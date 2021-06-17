#' ---
#' title: "Last"
#' author: "Kelli F. Johnson"
#' date: "`r format(Sys.time(), '%B %d, %Y')`"
#' ---
#'
#' Create data structures that are useful to many functions throughout
#' the package and useful for writing the document of objects
#' that pertain to the last assessment for this species.
#'

#+ last_ssdir
last_ssdir <- dir(
  path = "models",
  pattern = "2019.[nNsS].001.001.cou"
)

#+ last_ssdat
last_ssdat <- lingcod::SS_readdat.list(
  dir = file.path("models"),
  pattern = last_ssdir
)


#+ last_makedata
usethis::use_data(last_ssdir, overwrite = TRUE)
usethis::use_data(last_ssdat, overwrite = TRUE)

#+ last_cleanup
# rm(list = ls())
