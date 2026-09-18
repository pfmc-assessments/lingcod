# Source this file using the command line via
# Rscript --vanilla .\unfit\diags.R 1
# where the 1 at the end is the args you want,
# so here args could be 1:3

args <- commandArgs(trailingOnly=TRUE)

setwd("c:/stockassessment/lingcod_2021")
library(devtools)
load_all()

run_investigatemodel(
  "2021.n.023.001_fixWAreccatchhistory",
  # "2021.s.018.001_fixTri3",
  run = c("profile", "retro", "jitter")[as.numeric(args)]
)
