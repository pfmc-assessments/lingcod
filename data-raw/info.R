#' ---
#' title: "Info"
#' author: "Kelli F. Johnson"
#' date: "`r format(Sys.time(), '%B %d, %Y')`"
#' ---
#'
#' Create data structures that are useful to many functions throughout
#' the package and useful for writing the document.
#'

#+ info_authors
info_authors <- list(
  c("Ian G. Taylor", "Kelli F. Johnson",
    "Brian J. Langseth", "Andi Stephens",
    "Laurel S. Lam", "Melissa H. Monk",
    "Alison D. Whitman",
    "Melissa A. Haltuch"
  ),
  c("Ian G. Taylor", "Kelli F. Johnson",
    "Brian J. Langseth", "Andi Stephens",
    "Laurel S. Lam", "Melissa H. Monk",
    "John E. Budrick",
    "Melissa A. Haltuch"
  )
)

#+ info_bins
info_bins <- mapply(
  SIMPLIFY = FALSE,
  FUN = seq,
  from = list(age = 0, length = 10),
  to = list(age = 20, length = 130),
  by = c(age = 1, length = 2)
)

#+ info-groups
info_groups <- data.frame(
  area = c("North", "South")
)

#+ info-surveynames
info_surveynames <- c("WCGBTS", "Triennial")

#+ info_basemodels
info_basemodels <- structure(
  c("2021.n.023.001_fixWAreccatchhistory", "2021.s.014.001_esth"),
  names = get_groups(info_groups)
  )

#+ info_areacolors
# 
info_areacolors <- structure(
  unikn::usecol(pal_unikn_pair, 16L)[c(2,10)], 
  names = get_groups(info_groups)
  )



#+ info_makedata
usethis::use_data(info_areacolors, overwrite = TRUE)
usethis::use_data(info_authors, overwrite = TRUE)
usethis::use_data(info_basemodels, overwrite = TRUE)
usethis::use_data(info_bins, overwrite = TRUE)
usethis::use_data(info_groups, overwrite = TRUE)
usethis::use_data(info_surveynames, overwrite = TRUE)

#+ info_cleanup
rm(list = ls(pattern = "info_"))
