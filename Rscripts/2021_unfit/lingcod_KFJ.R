library(devtools)
setwd("c:/stockassessment/lingcod_2021")

# Install sa4ss from a local directory
install_clone("../ss/sa4ss")
# Load local species package
load_all()

# get files from sa4ss for the doc template into doc/draft
write_draft(
  authors = info_authors,
  dir = file.path("doc", "draft"),
  grepcopy = "00opts|^01a|^[i-s]"
)
