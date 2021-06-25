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
#' run_sensitivities(get_dir_ling("n", 17), type = "sens", numbers = c(102, 104))
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
  if ("sens_create" %in% type) {
    # read table of info on sensitivities
    sens_table <- read.csv(system.file("extdata", "sensitivities.csv",
                                       package = "lingcod"),
                           comment.char = "#",
                           blank.lines.skip = TRUE)
    # add column to store directories that got created for the model in question
    sens_table$dir <- NA
    for(isens in intersect(sens_table$num, numbers)) {
      sens <- sens_table %>% dplyr::filter(num == isens)

      newdir <- dirbase %>% sensitivity_path(num = isens, suffix = sens$suffix)
      sens_table$dir[sens_table$num == isens] <- newdir
      message("creating ", newdir)
      sensitivity_copy(dirbase, newdir)

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
    # read table of info on sensitivities
    sens_table <- read.csv(system.file("extdata", "sensitivities.csv",
                                       package = "lingcod"),
                           comment.char = "#",
                           blank.lines.skip = TRUE)
    # add column to store directories that got created for the model in question
    sens_table$dir <- NA
    for(isens in intersect(sens_table$num, numbers)) {
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
