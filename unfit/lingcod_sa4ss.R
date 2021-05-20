# get files from sa4ss for the doc template
dir_draft <- file.path("doc", "draft")
dir_north <- file.path("doc", "north")
dir_south <- file.path("doc", "south")
unlink(dir_draft, recursive = TRUE)
dir.create(dir_draft, showWarnings = FALSE)
dir.create(dir_north, showWarnings = FALSE)
dir.create(dir_south, showWarnings = FALSE)
listdir <- dir()
sa4ss::draft(
  authors = c(
    "Ian G. Taylor",
    "Kelli F. Johnson",
    "Brian J. Langseth",
    "Andi Stephens",
    "Laurel S. Lam",
    "Melissa H. Monk",
    "Alison D. Whitman",
    # "John E. Budrick",
    "Melissa A. Haltuch"
  ),
  species = "lingcod",
  latin = "Ophiodon elongatus",
  create_dir = FALSE
)
listmv <- dir()[!dir() %in% listdir]
mvfiles <- file.rename(
  listmv,
  file.path(dir_draft, listmv)
)
stopifnot(all(mvfiles))
