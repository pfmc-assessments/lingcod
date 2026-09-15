#' ---
#' title: "Lingcod <>"
#' author: "First MI. Last"
#' date: "`r format(Sys.time(), '%B %d, %Y')`"
#' output:
#'   bookdown::html_document2:
#'     keep_md: true
#' ---
#'
#+ setup_knitr
utils_knit_opts(type = "data-raw")
#'
#' ## Section
#'
#' Text goes here.
#'
#+ nameyourrchunkhere
# Coding comment
testdata <- "This is a test"
DATASET <- testdata

#' ## Make the .rda file for the package
#'
#+ end_makedata
# Uncomment the following line to actually make the data set for the package
# usethis::use_data(DATASET, overwrite = TRUE)

#+ end_cleanup
rm(testdata)
