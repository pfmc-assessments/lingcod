# input
dir_sa4ss <- "c:/stockassessment/ss/sa4ss"

# Install sa4ss
install_clone(dir_sa4ss)

# get files from sa4ss for the doc template
mapply(
  FUN = write_draft,
  authors = list(
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
),
  dir = file.path("doc", get_groups(info_groups))
)

# Update 00bibliography.Rmd with local files
ignore <- mapply(
  FUN = sa4ss::write_bibliography,
  basedir = file.path("doc", get_groups(info_groups)),
  fileout = file.path("doc", get_groups(info_groups), "00bibliography.Rmd"),
  MoreArgs = list(up = 1)
  )
