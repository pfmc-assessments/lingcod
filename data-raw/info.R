#' ---
#' title: "Info"
#' author: "Kelli F. Johnson"
#' date: "`r format(Sys.time(), '%B %d, %Y')`"
#' ---
#'
#' Create data structures that are useful to many functions throughout
#' the package and useful for writing the document.
#'

#+ info_bins
info_bins <- mapply(
  SIMPLIFY = FALSE,
  FUN = seq,
  from = list(age = 0, length = 10),
  to = list(age = 20, length = 130),
  by = c(age = 1, length = 2)
)

#+ info-surveynames
info_surveynames <- c("WCGBTS", "Triennial")

#+ end_makedata
usethis::use_data(info_bins, overwrite = TRUE)
usethis::use_data(info_surveynames, overwrite = TRUE)

#+ end_cleanup
