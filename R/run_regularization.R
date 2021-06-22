#' Example script to run MCMC using R package adnuts for SS
#'
#' Started Feb 2021 by Cole Monnahan (cole.monnahan@noaa.gov | AFSC)
#' Note I am using SS version 3.30.16, which is freely available
#' from: https://vlab.ncep.noaa.gov/web/stock-synthesis/home
#' Non-windows users will need to download and put that
#' executable in the hake folder.
#'
#' @template dirbase
#' @param interaction A logical value specifying if you want to run the
#' [shinystan::launch_shinyadmb].
#' @param verbose A logical value specifying if information should be printed
#' to the screen or not.
#'
#' @export
#' @author Cole M. Monnahan, augmented by Kelli F. Johnson
#'
run_regularization <- function(dirbase,
                               interactive = FALSE,
                               verbose = FALSE
                               ) {
## Define the path and model name (without .exe extension)
m <- 'ss'                               # model name

### ------------------------------------------------------------
### Task 0: Set up and test model for running. This requires
### pointing to a folder and executable. The folder needs to
### contain all sufficient input files and assumes optimization
### has occurred and produced all necessary outputs. Temporary
### copies will be made in the working directory during execution
wd <- getwd()
on.exit(setwd(wd), add = TRUE)

  # Run the model if need be
  if (!file.exists(file.path(dirbase, "Report.sso"))) {
    setwd(dirbase)
    file.copy(
      system.file("bin", "Windows64", "ss.exe", package = "lingcod"),
      file.path("ss.exe")
    )
    system(paste(m, "-nohess"))
    setwd(file.path("..", ".."))
  }

  # Regularization
  p <- paste0(dirbase, "_mcmc")
  dir.create(p, showWarnings = FALSE)
  dir.create(file.path(p, "fits"))
  r4ss::copy_SS_inputs(
    dir.old = dirbase,
    dir.new = p,
    overwrite = TRUE
  )
  file.copy(
    system.file("bin", "Windows64", "ss.exe", package = "lingcod"),
    file.path(p, "ss.exe")
  )
  ## optimize w/ -mcmc flag b/c of bias adjustment.
  setwd(p);
  system("ss -nox -mcmc 100");
  setwd(wd)

  ## Now test it works in parallel
  fit <- adnuts::sample_rwm(model=m, path=p, iter=2000, chains=2)
  ## This thin rate will lead to run time of ~60 mins below
  thin60min <- floor((60*60)/mean(fit$time.total))

  ## ------------------------------------------------------------
  ## Task 1: Run and demonstrate MCMC convergence diagnostics.
  chains <- parallel::detectCores() -1

## I recommend using 1000-2000 iterations, with first 10-25%
## warmup. Start with thin=1, then increase thin rate until
## convergence diagnostics passed (ESS>200 & Rhat<1.1).
## printed to screen live!!
thin <- thin60min # change this as needed
iter <- 2000*thin
## Duration argument will stop after 40 minutes, only used
## for the workshop to keep things organized
fit <- adnuts::sample_rwm(model=m, path=p, iter=iter, warmup=iter*0.25,
  chains=chains, thin=thin, duration=60)
## Good idea to save the output, I recommend RDS format.
saveRDS(fit, file=file.path(p, "fits", "mcmc.RDS"))
## Marginal comparisons as multipage PDF for easy scrolling
grDevices::pdf(file.path(p, "fits", 'marginals.pdf'), onefile=TRUE, width=7,height=5)
plot_marginals(fit)
grDevices::dev.off()
# fit <- readRDS(file=file.path(p, "fits", "mcmc.RDS"))

## Key information from run. Including the two recommended
## convergence diagnostics:
if (verbose) summary(fit)

## Interactive tools (must close out browser to regain console)
if (interactive) shinystan::launch_shinyadmb(fit)

## Extract posterior samples as a data.frame
# ?extract_samples
post <- adnuts::extract_samples(fit)

## If more thinning is needed, increase and rerun, repeating.

### ------------------------------------------------------------
### Task 2: Model diagnostics using failed convergence
### diagnostics. When the MLE and MCMC estimate completely
### different things that is usually a parameterization issue.

## Read in a longer previous run or use yours
ssoutput<-r4ss::SS_output(p,covar=F)
gnames <- cbind(fit$par_names[-NROW(fit$par_names)],
  ssoutput$parameters$Label[ssoutput$parameters$Phase>=0])
## The 6 slowest/fastest mixing parameters
grDevices::png(file.path(p, "fits", "regularization-pairschains-slow6.png"))
pairs_admb(fit, pars=1:6, order='slow')
grDevices::dev.off()
grDevices::png(file.path(p, "fits", "regularization-pairshists-slow6.png"))
adnuts::pairs_admb(fit, pars=1:6, order='slow', diag='hist')
grDevices::dev.off()
# pairs_admb(fit, pars=1:6, order='fast')
## Can also specify names or use grep
# pairs_admb(fit, pars=c('recdev_early[21]','recdev_early[22]',
#                        'recdev_early[23]'))
# pairs_admb(fit, pars=grep('_parm', fit$par_names))

## Marginal MLE vs posterior
# adnuts::plot_marginals(fit, pars=1:15)
grDevices::png(file.path(p, "fits", "regularization-uncertaintymlevmcmc.png"))
x <- adnuts::plot_uncertainties(fit)
grDevices::dev.off()
# head(x)
grDevices::png(file.path(p, "fits", "regularization-marginals-worstsd.png"))
adnuts::plot_marginals(fit, pars=which.max(x$sd.post))
grDevices::dev.off()

### ------------------------------------------------------------
### Task 3: Posterior extraction for inference. mceval can be run
### from command line b/c post-warmup samples from all chains
### were merged into main folder, so any mceval output files
### contain all this information

}
