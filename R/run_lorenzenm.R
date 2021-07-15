#' Run a model using Lorenzen natural mortality
#'
#' Copy model files and choose a reference age for the
#' Lorenzen natural mortality curve.
#'
#' @param olddir The directory you want to copy input files from.
#' @param newdir The new directory name for the Lorenzen natural mortality run.
#' If this directory already exists, it will be wiped clean prior to copying files.
#' @param referenceage The age at which defines, or grounds, the curve.
#' If there is a prior on natural mortality, the prior will apply to this age.

run_lorenzenm <- function(
  olddir,
  newdir,
  referenceage
) {

  if (dir.exists(newdir)) {
    unlink(newdir, recursive = TRUE)
  }
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

  #todo: change this to use Ian's function that reads all inputs
  file.starter <- file.path(newdir, "starter.ss")
  starter <- r4ss::SS_readstarter(file.starter, verbose = FALSE)
  dat <- r4ss::SS_readdat(
    file.path(newdir, starter[["datfile"]]),
    verbose = FALSE
  )
  ctl <- r4ss::SS_readctl(
    file.path(newdir, starter[["ctlfile"]]),
    use_datlist = TRUE, datlist = dat,
    verbose = FALSE,
    version = type.convert(dat[["ReadVersion"]], as.is = TRUE)
  )
  ctl[["natM_type"]] <- 2
  # Reference age for Lorenzen M
  ctl[["Lorenzen_refage"]] <- referenceage
  r4ss::SS_writectl(ctl, ctl[["sourcefile"]], verbose = FALSE, overwrite = TRUE)

  r4ss::run_SS_models(
    dirvec = newdir,
    extras = "-cbs 1500000000"
  )

}
