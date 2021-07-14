#' Run sensitivities for a base model
#'
#' @template dirbase
#' @param type The type of sensitivity you want to run.
#' Options are
#' "profile", "retro", "regularization", "sens_create", and "sens_run".
#' @param numbers Numbers of specific sensitivities to create or run.
#' @param extras additional arguments after the "ss" command passed to
#' `r4ss::run_SS_
#' @param skipfinished skip directories with existing Report.sso files
#' (passed to `r4ss::SS_changepars()`). Doesn't apply to profiles,
#' retros, or regularization.
#' 
#' @author Kelli Faye Johnson, Ian G. Taylor
#' @examples
#' \dontrun{
#' dirbase <- get_dir_ling(area = area, num = 14, sens = 1)
#' run_sensitivities(dirbase, c("profile", "retro", "regularization"))
#' run_sensitivities(get_dir_ling("n", 22),
#'                   type = "sens_create",
#'                   numbers = c(102, 104))
#' run_sensitivities(get_dir_ling("s", 14),
#'                   type = c("sens_run", "sens_create"),
#'                   numbers = c(303:320))
#' }
run_sensitivities <- function(dirbase,
                              type = c("profile", "retro", "regularization",
                                       #"sens_create",
                                       #"sens_run"
                                       ),
                              numbers = 1:999,
                              extras = "-nox -nohess -cbs 1500000000",
                              skipfinished = TRUE
                              ) {

  #' create a path associated with a particular sensitivity
  #' by converting a source directory, like
  #' "2021.n.016.001_tune" to a sensitivity path like
  #' "2021.n.016.101_shareM".
  #'
  #' @param dir the source model directory
  #' @param num the senstiviity number as represented in sensitivity.csv
  #' @param suffix a string to append to the new path
  #' 
  sensitivity_path <- function(dir, num, suffix = "") {
    dir %>%
      substring(first = 1,
                last = nchar("models/2021.n.001")) %>%
      paste0(., ".", sprintf("%03d", num), suffix)
  }

  #' wrapper for r4ss::copy_SS_inputs() with defaults for run_sensitivies()
  sensitivity_copy <- function(olddir, newdir) {
    r4ss::copy_SS_inputs(
            dir.old = olddir,
            dir.new = newdir,
            use_ss_new = FALSE,
            copy_par = FALSE,
            copy_exe = TRUE,
            dir.exe = get_dir_exe(),
            overwrite = TRUE,
            verbose = FALSE
          )
  }

  #' convert values from the CSV file into format required by
  #' r4ss::SS_changepars(), including splitting multiple entries
  fix_val <- function(x) {
    # split multiple values if present
    if (grepl('\"', x)) {
      return(eval(parse(text=gsub('\"', "", x))))
    }
    # clean up blank values
    if (x == "") {
      x <- NULL
    }
    x
  }
  
  # Retros, Profile, Jitter
  if (any(grepl("retro|profile|jitter", type))) {
    run_investigatemodel(
      basename(dirbase),
      run = grep(value = TRUE, "retro|profile|jitter", type)
    )
  }
  # 
  if ("regularization" %in% type) {
    run_regularization(
      basename(dirbase),
      interactive = FALSE,
      verbose = FALSE
    )
  }

  # create additional sensitivitities
  if ("sens_create" %in% type | "sens_run" %in% type) {
    # read table of info on sensitivities
    sens_table <- read.csv(system.file("extdata", "sensitivities.csv",
                                       package = "lingcod"),
                           comment.char = "#",
                           blank.lines.skip = TRUE)
    # there's a better way to get the area
    area <- strsplit(dirbase, split = ".", fixed = TRUE)[[1]][2]

    # remove rows that don't apply to this model
    if (area == "n") {
      sens_table <- sens_table[sens_table$north,]
    }
    if (area == "s") {
      sens_table <- sens_table[sens_table$south,]
    }
    
    # add column to store directories that got created for the model in question
    sens_table$dir <- NA

    numbers_filtered <- intersect(sens_table$num, numbers)
    message("requested sensitivities filtered for area = '", area, "':",
            paste(numbers_filtered, collapse = ", "))
  }

  if ("sens_create" %in% type) {
    # loop over sensititivy numbers
    for(isens in numbers_filtered) {
      sens <- sens_table %>% dplyr::filter(num == isens)

      newdir <- dirbase %>% sensitivity_path(num = isens, suffix = sens$suffix)
      sens_table$dir[sens_table$num == isens] <- newdir
      message("creating ", newdir)
      sensitivity_copy(dirbase, newdir)

      #####################################################################
      # sensitivities that involve changing parameter lines
      if (sens$parlabel != "") {
        r4ss::SS_changepars(dir = newdir, 
                            ctlfile = "ling_control.ss",
                            newctlfile = "ling_control.ss",
                            strings = fix_val(sens$parlabel),
                            newvals = fix_val(sens$INIT),
                            newphs = fix_val(sens$PHASE),
                            newprior = fix_val(sens$PRIOR),
                            newprsd = fix_val(sens$PR_SD),
                            newlos = fix_val(sens$LO),
                            verbose = FALSE
                            )
      } # end test for non-empty parlabel

      #####################################################################
      # sensitivities that involve changing age data
      datdir <- NULL
      if (sens$suffix == "_all_CAAL_ages") { # 201
        datdir <- get_dir_ling(area = area, num = 4, sens = 9)
      }
      if (sens$suffix == "_all_marg_ages") { # 202
        datdir <- get_dir_ling(area = area, num = 4, sens = 12)
      }
      ## if (sens$suffix == "_some_CAAL_ages" & area == "a") {
      ##   datdir <- file.path(olddir = get_dir_ling(area = area, num = 4, sens = 13))
      ## }
      if (sens$suffix == "_no_fishery_ages") { #204
        datdir <- get_dir_ling(area = area, num = 4, sens = 14)
      }
      if (!is.null(datdir)) {
        file.copy(from = file.path(datdir, "ling_data.ss"),
                  to = file.path(newdir, "ling_data.ss"),
                  overwrite = TRUE)
      }

      # STAR request 8
      if (grepl("no_fixed-gear_ages", sens$suffix)) {
        inputs <- get_inputs_ling(dir = newdir)
        if (grepl("no_fixed-gear_ages$", sens$suffix)) {
          inputs$dat$agecomp$Yr[inputs$dat$agecomp$FltSvy == 2] <-
            -1 * inputs$dat$agecomp$Yr[inputs$dat$agecomp$FltSvy == 2]
        }
        if (grepl("no_fixed-gear_ages_1999-2011", sens$suffix)) {
          inputs$dat$agecomp$Yr[inputs$dat$agecomp$FltSvy == 2 &
                                inputs$dat$agecomp$Yr %in% 1999:2011] <-
            -1 * inputs$dat$agecomp$Yr[inputs$dat$agecomp$FltSvy == 2 &
                                inputs$dat$agecomp$Yr %in% 1999:2011]
        }
        write_inputs_ling(inputs, dir = newdir, files = "dat")
      }
      
      #####################################################################
      # other sensitivities
      if (substring(sens$suffix, 1, 3) == "_DM") { #205 or 208
        # copy report because Ian is paranoid about accidentally overwriting the base model
        file.copy(from = file.path(dirbase, "Report.sso"),
                  to = file.path(newdir, "Report.sso"))
        mod.tuning <- r4ss::SS_output(newdir, covar =FALSE, NoCompOK = TRUE, forecast = FALSE,
                                      verbose = FALSE, printstats = FALSE)
        r4ss::SS_tune_comps(mod.tuning, dir = newdir, option = "DM", niters_tuning = 0)
        # requires manual delete of Report
      }

      # combine males and females for small size bins
      if (sens$suffix == "_combMF") { #206
        inputs <- get_inputs_ling(dir = newdir)
        inputs$dat$len_info$combine_M_F <- which(info_bins$length == 40)
        inputs$dat$Comments <- c(inputs$dat$Comments,
                                 "#C males and females < 40cm combined")
        write_inputs_ling(inputs, dir = newdir, files = "dat")
      }

      # remove unsexed fish
      if (sens$suffix == "_no_unsexed") { # 207
        inputs <- get_inputs_ling(dir = newdir)
        inputs$dat$lencomp <- inputs$dat$lencomp %>% dplyr::filter(Gender != 0)
        inputs$dat$agecomp <- inputs$dat$agecomp %>% dplyr::filter(Gender != 0)
        inputs$dat$Comments <- c(inputs$dat$Comments,
                                 "#C all unsexed lengths and ages removed")
        write_inputs_ling(inputs, dir = newdir, files = "dat")
      }
      
      if (substring(sens$suffix, 1, 6) == "_tuned") { #211 to 217
        olddir <- newdir %>%
          get_id_ling() %>%
          gsub(pattern = "\\.21", # depends on having fewer than 200 model numbesr
               replacement = "\\.20") %>%
          get_dir_ling(id = .)
        sensitivity_copy(olddir, newdir)
        # strugglingwith SS_tune_comps(), adding brute force mess of file copying
        file.copy(file.path(olddir, "Report.sso"),
                  file.path(newdir, "Report.sso"))
        mod.tuning <- r4ss::SS_output(olddir, verbose = FALSE, printstats = FALSE)
        r4ss::SS_tune_comps(replist = mod.tuning,
                            dir = newdir, option = "Francis", niters_tuning = 1)
        # requires manual delete of Report
      }

      #####################################################################
      # selectivity sensitivities

      # force fixed-gear fishery to be asymptotic
      if (grepl("_asymptotic_FG", sens$suffix)) {
        inputs <- get_inputs_ling(dir = newdir)
        inputs$ctl[["size_selex_parms"]] <-
          change_pars(
            pars = inputs$ctl[["size_selex_parms"]],
            string = "SizeSel_P_4_2_Comm_Fix",
            LO = -1, HI = 15, INIT = 15, PHASE = -3
          )
        write_inputs_ling(inputs, dir = newdir, files = "ctl")
      }

      if (grepl("_male_sel_offset", sens$suffix) |
          grepl("_female_sel_offset", sens$suffix)) { #402 - 406
        inputs <- get_inputs_ling(dir = newdir)
        # add male offset to selectivity
        if (grepl("_male_sel_offset", sens$suffix)) { #402
          inputs$ctl$size_selex_types$Male <-
            ifelse(inputs$ctl$size_selex_types$Pattern == 24, 3, 0)
        }
        # add female offset to selectivity
        if (grepl("_female_sel_offset", sens$suffix)) { #403 - 405
          inputs$ctl$size_selex_types$Male <-
            ifelse(inputs$ctl$size_selex_types$Pattern == 24, 4, 0)
        }
        # make a table of male offset parameters to insert below 
        # the other parameters for each fleet
        tab <- data.frame(matrix(0, nrow = 5, ncol = 14))
        names(tab) <- names(inputs$ctl$size_selex_parms)
        tab$LO <- c(-30, -15, -15, -15, 0.1)
        tab$HI <- c(30, 10, 10, 10, 5.0)
        tab$INIT <- c(0, 0, 0, 0, 0.9)
        tab$PHASE <- c(-5, -5, -5, -5, 3)
        # insert table for each fleet
        old_parms <- inputs$ctl$size_selex_parms
        new_parms <- NULL
        for (fleet in get_fleet()$fleet) {
          if (any (grepl(fleet, rownames(old_parms)))) {
            tab_fleet <- tab
            rownames(tab_fleet) <- paste0("SizeSel_PMalOff_", 1:5, "_", fleet)
            new_parms <- rbind(new_parms,
                               old_parms[grep(fleet, rownames(old_parms)),],
                               tab_fleet)
          }
        } # end loop over fleets
        inputs$ctl$size_selex_parms <- new_parms
        inputs$ctl$Comments <- c(inputs$ctl$Comments,
                                 "#C male or female selectivity offsets added")
        write_inputs_ling(inputs, dir = newdir, files = "ctl")
      } # end modification of male offset sensitivity
      
      #####################################################################
      # sensitivities that involve changing lambdas
      if (sens$lambda_comp != "") {
        inputs <- get_inputs_ling(dir = newdir)
        lambda_comp <- fix_val(sens$lambda_comp)
        lambda_fleet <- fix_val(sens$lambda_fleet)
        inputs$ctl$N_lambdas <- length(lambda_fleet)
        inputs$ctl$lambdas <- data.frame(like_comp = fix_val(sens$lambda_comp),
                                         fleet = fix_val(sens$lambda_fleet),
                                         phase = 1, # starting in phase 1
                                         value = 0, # only option now is to fix at 0
                                         sizefreq_method = 999) # unused value
        # had issue with get_fleet(1) matching fleets 1 and 10
        rownames(inputs$ctl$lambdas) <-
          paste0("#_turn_off_", ifelse(lambda_comp == 1, "index", "something"),
                 "_for_", get_fleet()$fleet[get_fleet()$num %in% lambda_fleet]) 
        write_inputs_ling(inputs, dir = newdir, files = "ctl")
      }

    } # end loop over sensitivity numbers
    
    filename <- paste0("sensitivities_",
                       format(Sys.time(), "%d-%m-%Y_%H.%M.%OS4"),
                       ".csv")
    message("writing ", file.path(dirbase, filename))
    write.csv(x = sens_table,
              file = file.path(dirbase, filename),
              row.names = FALSE)
  } # end check for "sens_create" in type

  # run additional sensitivitites
  if ("sens_run" %in% type) {
    # loop over sensititivy numbers
    for(isens in numbers_filtered) {
      sens <- sens_table %>% dplyr::filter(num == isens)

      newdir <- dirbase %>% sensitivity_path(num = isens, suffix = sens$suffix)

      message("running model in ", newdir)
      r4ss::run_SS_models(dirvec = newdir,
                          extras = extras,
                          skipfinished = skipfinished,
                          intern = TRUE,
                          verbose = TRUE,
                          exe_in_path = FALSE
                          )
    } # end loop over sensitivity numbers
  } # end check for "sens_run" in type
}
