# Source this file using the command line via
# Rscript --vanilla .\unfit\diags.R 1
# where the 1 at the end is the args you want,
# so here args could be 1:3

args <- commandArgs(trailingOnly=TRUE)

setwd("c:/stockassessment/lingcod_2021")
library(devtools)
load_all()

run_investigatemodel(
  "2021.n.018.001_refined",
  run = c("jitter", "profile", "retro")[as.numeric(args)]
)
