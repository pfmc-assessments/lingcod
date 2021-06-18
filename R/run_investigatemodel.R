#' Run all model investigations for a base model
#'
#' @param basemodelname The name of the base model of interest in `modeldir`.
#' This can be a vector of names if you want to do the same thing for each
#' area.
#' @param pars A file path the csv with the parameter specifications.
#' The file has a column for area, with values matching what you use in your
#' model name for area, e.g., 2009.n.001.001_test, would be a northern model.
#' and the remaining columns are parameter inputs for
#' [nwfscDiag::get_settings_profile], and the column names must match the
#' formals exactly because they are used with [do.call].
#' You can pass any file you want, but the default is to use the one saved internal
#' to this package.
#' @param run A vector of options you want to run,
#' where the default is to run them all.
#' @param njitter An integer number of jitter runs you want to complete.
#'
#' @export
#' @author Chantel R. Wetzel from the example in \pkg{nwfscDiags}.
#'
#' @details notes:
#' * The whole process will fail if a single model doesn't converge in the retro.
#' * The process will in retro if no forecasts.
#' * Error from SS_doretro I think has file names pasted together without spaces.
#' `Error in r4ss::SS_doRetro(masterdir = retro_dir, overwrite = model_settings$overwrite,  :`
#' `error copying file(s): ss.exeforecast.ssling_control.ssling_data.ss`
#'
#' @examples
#' \dontrun{
#' # Just need to define xxx
#' setwd(dirname(system.file(package = "lingcod")))
#' run_investigatemodel(basemodelname = basemodelname)
#' }
run_investigatemodel <- function(basemodelname,
                                 pars = system.file("extdata", "diagpars.csv", package = "lingcod"),
                                 run = c("jitter", "profile", "retro"),
                                 njitter = 100
) {
#######################################################################################################
# Define the parameters to profile and the parameter ranges:
#------------------------------------------------------------------------------------------------------
# Can use the get_settings_profile function to specify which parameters to run a profile for and 
# the parameter ranges for each profile.  The low and high values can be specified in 3 ways:
# as a 'multiplier' where a percent where the low and high range will be specified as x% of the base 
# parameter (i.e., (base parameter - base parameter* x) - (base parameter + base parameter * x)),
# in 'real' space where the low and high values are in the parameter space, and finally as
# 'relative' where the low and high is a specified amount relative to the base model parameter 
# (i.e., (base parameter - x) - (base parameter + x).
# Here is an example call to the get_settings_profile function:
  
  stopifnot(dir.exists("models"))
  stopifnot(file.exists(pars))
  parsettings <- utils::read.csv(pars)
  out <- as.list(basemodelname)
  names(out) <- basemodelname

  for (iimname in basemodelname) {
    # Get settings that are area specific and global based on
    # what is in the csv and the model name that will have the
    # area embedded in it
    iiarea <- gsub("[0-9]{4}\\.([a-z]+)\\.[0-9]+\\.[a-z0-9._]+", "\\1", iimname)
    iipars <- parsettings %>%
      dplyr::filter(area %in% c("", iiarea)) %>%
      dplyr::select(names(formals(nwfscDiag::get_settings_profile)))

    # Create a list of settings to run the profiles, jitters, and retrospectives:
    model_settings <- nwfscDiag::get_settings(
      settings = list(
        base_name = iimname,
        run = run,
        profile_details = do.call(nwfscDiag::get_settings_profile, iipars)
      )
    )
    # For testing purposes I was looking at smaller run times here
    model_settings[["Njitter"]] <- njitter
    # model_settings[["retro_yrs"]] <- c(-1, -2)
    # model_settings$extras <- "-nohess -maxI 1"

    # to do - change the Windows64 to be workable on any machine
    check <- file.copy(
      overwrite = TRUE,
      dir(system.file("bin", "Windows64", package = "lingcod"), pattern = "ss", full.names = TRUE),
      file.path("models", iimname, dir(system.file("bin", "Windows64", package = "lingcod"), pattern = "ss"))
    )
    stopifnot(check)

    nwfscDiag::run_diagnostics(
      mydir = normalizePath("models"),
      model_settings = model_settings
    )
  }

}
