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

new_name <- "model number_model name"
old_name <- "model Number_model name"


##
#Copy inputs
##

copy_SS_inputs(dir.old = file.path('models', old_name), 
               dir.new = file.path('models', new_name),
               overwrite = TRUE)

mod <- SS_read(file.path('models', new_name))


##
#Make Changes
##

Coded changes go here


##
#Output files and run
##

SS_write(mod,
         dir = file.path('models', new_name),
         overwrite = TRUE)

r4ss::run(dir = file.path('models', new_name), 
          exe = file.path('models/ss3_win.exe'), 
          extras = '-nohess',
          show_in_console = TRUE, #comment out if you dont want to watch model iterations
          skipfinished = FALSE)

pp <- SS_output(file.path('models', new_name))
SS_plots(pp, plot = c(1:26)) # <- maybe add more plots 


##
#Comparison plots
##

xx <- SSgetoutput(dirvec = glue::glue("{models}/{subdir}", models = file.path('models'),
                                      subdir = c('name1',
                                                 'name2',
                                                 new_name)))
SSsummarize(xx) |>
  SSplotComparisons(legendlabels = c('label for model 1',
                                     'label for model 2',
                                     'label for new model'),
                    subplots = c(1,3), print = TRUE, plotdir = file.path('models', new_name))

dev.off()

##########################################################################################-
#                                 ---- END TEMPLATE ---- 
##########################################################################################-



##########################################################################################-
#                     ---- Set up from 2021 base to 2027 version ----
##########################################################################################-

START HERE
