#Script to run block for early CA rec data
#STAR panel on day 2, Request 2
#This updates STAR panel Request 3 from Day 1

#2. Add time varying selectivity for the CA rec 
#fishery in the South model. Add a block that would 
#encompass from 1959 to 1972. Provide the model 
#results (biomass, recruitments, and recdevs) and 
#the estimated selectivity curves. Provide information 
#on how the fit to the data improved. 


#Copy from s.014.001 and update block manually

#Set number of blocks from 6 to 7 in the 8th block pattern
#Add new block from 1973 to 1982

# look at model output and check bias adj
output <- get_mod(area = "s", num = 14, sens = 806)
biasadj <- r4ss::SS_fitbiasramp(output, verbose = TRUE) #keep same

get_mod(area = "s", num = 1)


#Do outputs
make_r4ss_plots_ling(mod.2021.s.014.806, plot = 1:26)
make_r4ss_plots_ling(mod.2021.s.014.806, plot = 31:50)
plot_twopanel_comparison(list(mod.2021.s.014.806, mod.2021.s.014.001), print = FALSE)



###
#Compare results with base
###
outs <- mapply(SIMPLIFY = FALSE, r4ss::SS_output,
               dir=file.path("models", 
                             c("2021.s.014.804_no_earlyDevs_biasAdj",
                               "2021.s.014.803_no_earlyDevs", 
                               "2021.s.014.001_esth")))
mid <- r4ss::SSsummarize(outs)
r4ss::SSplotComparisons(mid, print = TRUE, 
                        legendlabels = c("No early devs w/ bias adj", 
                                         "No early devs", "Base model"), 
                        plotdir = file.path("figures", "STAR_Day1_request3"))


