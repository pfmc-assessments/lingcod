##########################################################################################-
#
# Model runs for 2027 lingcod assessment
#   By: All members of lingcod team
#
##########################################################################################-
#Alternative to devtools if it doesn't work on your machine
#pak::pkg_install("pfmc-assessments/PEPtools")
#pak::pkg_install("r4ss/r4ss")

#Load packages
library(r4ss)
library(PEPtools)
library(dplyr)

##########################################################################################-
#                                 ---- TEMPLATE ----
#                                 ---- COPY ONLY ---
##########################################################################################-

#Use this structure to set up model runs below

####------------------------------------------------#
# [model number_model name  ----]
####------------------------------------------------#

dir_new <- "models/2027.n.001.001_template_example"
# using get_dir_ling() saves you from looking up the full directory:
# dir_old <- "models/2021.n.023.001_fixWAreccatchhistory"
dir_old <- get_dir_ling(area = "n", num = 23, year = 2021)

##
#Read inputs from old model
##

inputs <- get_inputs_ling(dir = dir_old)


##
#Make Changes
##

# CODED CHAGES GO HERE

##
#Output files and run
##

SS_write(inputs, dir = dir_new, overwrite = TRUE)
# make sure ss3 is in the models folder
if (!file.exists("models/ss3.exe")) {
  r4ss::get_ss3_exe(dir = "models")
}
# run model
r4ss::run(
  dir = dir_new,
  exe = here::here("models/ss3.exe"),
  extras = "-nohess", # comment out if you want to run with Hessian
  # extras = "-nohess -stopph 0", # run without estimation from initial values
  show_in_console = TRUE, #comment out if you don't want to watch model iterations
  skipfinished = FALSE
)
# clear out unnecessary files
r4ss::clean_files(dir = dir_new)

# read output and make plots (if desired)
# TODO for Ian: fix broken plot = TRUE option
mod_new <- get_mod(dir = dir_new, plot = FALSE)


##
#Comparison plots
##

# get_mod() adds the model outputs to your workspace
mod_old <- get_mod(dir = dir_old)

# two-panel summary plot 
# (default is spawning output and fraction unfished)
r4ss::plot_twopanel_comparison(
  list(mod_old, mod_new),
  dir = dir_new
)

# larger set of plots (if desired)
SSsummarize(list(mod_old, mod_new)) |>
  SSplotComparisons(
    legendlabels = c('label for old model', 'label for new model'),
    plot = FALSE,
    print = TRUE,
    plotdir = dir_new
  )

##########################################################################################-
#                                 ---- END TEMPLATE ----
##########################################################################################-

##########################################################################################-
#                     ---- Set up from 2021 base to 2027 version ----
##########################################################################################-

# START HERE
