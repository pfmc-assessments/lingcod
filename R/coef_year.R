#' Get model coefficients for year
#'
#' Call [stats::coef] to get model coefficients from a model fit
#' in R. Year will be a factor term, and thus, the coefficients with
#' year in their name will be returned. No interactions with year are
#' included.
#'
#' @param results A model object output from a statistical model
#' such as [stats::glm].
#' @author Kelli F. Johnson
#' @return A vector of parameter values for all parameters pertaining
#' to year in the model.
#'
coef_year <- function(results) {
  if (!any(class(results) %in% "stanreg")) {
    xx <- stats::coef(results)
    xx <- as.data.frame(t(xx))
  } else {
    xx <- as.data.frame(results)
  }
  interceptlocation <- grep("Intercept", ignore.case = TRUE, names(xx))
  yearlocations <- grep("^Year[0-9]+$", ignore.case = TRUE, names(xx))
  out <- data.frame(xx[, interceptlocation], xx[, interceptlocation] + xx[, yearlocations])
  names(out) <- c(
    as.numeric(gsub("[yY][eE][aA][rR]", "", names(xx[yearlocations]))[1]) - 1,
    as.numeric(gsub("[yY][eE][aA][rR]", "", names(xx[yearlocations])))
  )
  if (NROW(out) == 1) {
    naming <- names(out)
    out <- as.numeric(out)
    names(out) <- naming
  }
  return(out)
}
