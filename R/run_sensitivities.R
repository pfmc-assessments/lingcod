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
      paste0(., ".", sprintf("%03d", num), string)
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
            verbose = TRUE
          )
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
    for(isens in numbers) {
      newdir <- dirbase %>%
        sensitivity_path(num = isens, suffix = sens_table$suffix[isens])
      message("creating ", newdir)
      sensitivity_copy(dirbase, newdir)

      ## if (sens_table$parlabel != "") {
      ##   r4ss::SS_changepars(newdir, 
      ##                       ctlfile = "ling_control.ss", newctlfile = "ling_control.ss",
      ##                       strings = "steep",
      ##                       INIT = ifelse(senstable$newvals = NULL, repeat.vals = FALSE,
      ##                                     ### continue here....
      ##      newlos = NULL, newhis = NULL, newprior = NULL, newprsd = NULL, newprtype = NULL,
      ##      estimate = NULL, verbose = TRUE,
      ##      newphs = NULL
      ##   }
    }
  }
}
