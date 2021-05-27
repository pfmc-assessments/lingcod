#' ---
#' title: "Info"
#' author: "Kelli F. Johnson"
#' date: "`r format(Sys.time(), '%B %d, %Y')`"
#' ---
#'
#' Create data structures that are useful to many functions throughout
#' the package and useful for writing the document.
#'
#+ info-surveynames
info_surveynames <- c("WCGBTS", "Triennial")

#+ end_makedata
usethis::use_data(info_surveynames, overwrite = TRUE)

#+ end_cleanup
