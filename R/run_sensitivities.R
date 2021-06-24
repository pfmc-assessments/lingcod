#' Run sensitivities for a base model
#'
#' @template dirbase
#' @param type The type of sensitivity you want to run.
#' See the formals for options.
#' @param numbers Numbers of specific sensitivities to run.
#' @examples
#' \dontrun{
#' dirbase <- get_dir_ling(area = area, num = 14, sens = 1)
#' run_sensitivities(dirbase, c("profile", "retro", "regularization"))
#' run_sensitivities(get_dir_ling("n", 17), type = "sens", numbers = c(102, 104))
#' }
run_sensitivities <- function(dirbase,
                              type = c("profile", "retro", "regularization",
                                       #"sens"
                                       ),
                              numbers = 1:999
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

  #' convert values from the CSV file into numeric or NULL
  fix_val <- function(x) {
    if (is.na(x) || x == "") {
      NULL
    } else {
      as.numeric(x)
    }
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

  if ("sens" %in% type) {
    # read table of info on sensitivities
    sens_table <- read.csv(system.file("extdata", "sensitivities.csv",
                                       package = "lingcod"),
                           comment.char = "#",
                           blank.lines.skip = TRUE)
    for(isens in intersect(sens_table$num, numbers)) {
      sens <- sens_table %>% dplyr::filter(num == isens)

      newdir <- dirbase %>% sensitivity_path(num = isens, suffix = sens$suffix)
      message("creating ", newdir)
      sensitivity_copy(dirbase, newdir)
      if (sens$parlabel != "") {
        r4ss::SS_changepars(dir = newdir, 
                            ctlfile = "ling_control.ss",
                            newctlfile = "ling_control.ss",
                            strings = sens$parlabel,
                            newvals = fix_val(sens$INIT),
                            newphs = fix_val(sens$PHASE),
                            newprior = fix_val(sens$PRIOR),
                            newprsd = fix_val(sens$PR_SD),
                            verbose = FALSE
                            )
      } # end test for non-empty parlabel
    } # end loop over sensitivity numbers in the table
  } # end check for "sens" in type
}
