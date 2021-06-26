#' get prior values for prior types and parameterizations used in Stock Synthesis
#'
#' copied from r4ss::SSplotPars()
#' https://github.com/r4ss/r4ss/blob/main/R/SSplotPars.R
#' can be put into r4ss as an independent function in the future
#'
#' @param Ptype string explaining prior type (see code for options)
#' @param Pmin MIN
#' @param Pmax MAX
#' @param Pr PRIOR value (often the mean)
#' @param Psd PR_SD
#' @param Pval vector of values for which to calculate the prior
#' @export

get_SS_prior <- function(Ptype, Pmin, Pmax, Pr, Psd, Pval) {
  # function to calculate prior values is direct translation of code in SS
  Prior_Like <- NULL

  if (is.na(Ptype)) {
    warning("problem with prior type interpretation. Ptype:", Ptype)
  }

  Pconst <- 0.0001
  # no prior
  if (Ptype %in% c("No_prior", "")) {
    Prior_Like <- rep(0., length(Pval))
  }

  # normal
  if (Ptype == "Normal") {
    Prior_Like <- 0.5 * ((Pval - Pr) / Psd)^2
  }

  # symmetric beta    value of Psd must be >0.0
  if (Ptype == "Sym_Beta") {
    mu <- -(Psd * (log((Pmax + Pmin) * 0.5 - Pmin))) - (Psd * (log(0.5)))
    Prior_Like <- -(mu + (Psd * (log(Pval - Pmin + Pconst))) +
                    (Psd * (log(1. - ((Pval - Pmin - Pconst) / (Pmax - Pmin))))))
  }

  # CASAL's Beta;  check to be sure that Aprior and Bprior are OK before running SS2!
  if (Ptype == "Full_Beta") {
    mu <- (Pr - Pmin) / (Pmax - Pmin) # CASAL's v
    tau <- (Pr - Pmin) * (Pmax - Pr) / (Psd^2) - 1.0
    Bprior <- tau * mu
    Aprior <- tau * (1 - mu) # CASAL's m and n
    if (Bprior <= 1.0 | Aprior <= 1.0) {
      warning("bad Beta prior")
    }
    Prior_Like <- (1.0 - Bprior) * log(Pconst + Pval - Pmin) +
      (1.0 - Aprior) * log(Pconst + Pmax - Pval) -
      (1.0 - Bprior) * log(Pconst + Pr - Pmin) -
      (1.0 - Aprior) * log(Pconst + Pmax - Pr)
  }

  # lognormal
  if (Ptype == "Log_Norm") {
    Prior_Like <- 0.5 * ((log(Pval) - Pr) / Psd)^2
  }

  # lognormal with bias correction (from Larry Jacobson)
  if (Ptype == "Log_Norm_w/biasadj") {
    if (Pmin > 0.0) {
      Prior_Like <- 0.5 * ((log(Pval) - Pr + 0.5 * Psd^2) / Psd)^2
    } else {
      warning("cannot do prior in log space for parm with min <=0.0")
    }
  }

  # gamma  (from Larry Jacobson)
  if (Ptype == "Gamma") {
    scale <- (Psd^2) / Pr #  gamma parameters by method of moments
    shape <- Pr / scale
    Prior_Like <- -1 * (-shape * log(scale) - lgamma(shape) +
                        (shape - 1.0) * log(Pval) - Pval / scale)
  }

  # F parameters get listed as different type but have no prior
  if (Ptype == "F") {
    Prior_Like <- rep(0., length(Pval))
  }
  if (is.null(Prior_Like)) {
    warning(
      "Problem calculating prior. The prior type doesn't match ",
      "any of the options in the SSplotPars function.\n",
      "Ptype: ", Ptype
    )
  }
  return(Prior_Like)
} # end GetPrior function
