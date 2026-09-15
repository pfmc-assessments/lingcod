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

get_mod(area = "s", num = 14)


#Do outputs
make_r4ss_plots_ling(mod.2021.s.014.806, plot = 1:26)
make_r4ss_plots_ling(mod.2021.s.014.806, plot = 31:50)
plot_twopanel_comparison(list(mod.2021.s.014.806, mod.2021.s.014.001), 
                         legendlabels = c("block CA rec 1972", "south base"), print = TRUE)



###
#Compare results with base
###
outs <- mapply(SIMPLIFY = FALSE, r4ss::SS_output,
               dir=file.path("models", 
                             c("2021.s.014.806_recBlock_1972",
                               "2021.s.014.001_esth")))
mid <- r4ss::SSsummarize(outs)
r4ss::SSplotComparisons(mid, print = TRUE, 
                        legendlabels = c("CA rec block 1972", 
                                         "Base model"), 
                        plotdir = file.path("figures", "STAR_Day2_request2"))



tab <- mod.2021.s.014.001$likelihoods_used[c("TOTAL", "Survey", "Length_comp", 
                                      "Age_comp", "Discard", "Parm_priors"),] -
  mod.2021.s.014.806$likelihoods_used[c("TOTAL", "Survey", "Length_comp", 
                                        "Age_comp", "Discard", "Parm_priors"),]
tab$lambdas <- 0

colnames <- c("base", "Block CA rec 1972")

t = sa4ss::table_format(x = tab[,c(2,1)],
                 caption = 'South sensitivity to adding block prior to 1973 to CA rec',
                 label = 's.014.806',
                 longtable = TRUE,
                 font_size = 9,
                 digits = 2,
                 landscape = FALSE,
                 col_names = colnames,
                 row.names = TRUE)

kableExtra::save_kable(t, file = file.path(getwd(),"figures","STAR_Day2_request2","like_table.tex"))

