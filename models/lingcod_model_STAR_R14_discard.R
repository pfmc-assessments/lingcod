#Script to explore discard rates for fleet 1 in the northern model 
#STAR Panel Request 14 (on day 3)

#14. Investigate the discrepancies in catches between the 
#GEMM reports and the northern model estimates. Explore 
#modeling methods to attempt to improve the fit to the dead
#discard rates in the model to produce dead discard estimates 
#that are more in line with the GEMM values. This adjustment 
#would consider these earlier years (1998-2001) as well. 
#This investigation should focus on the trawl fleet.

#Only apply for trawl in north from 2002 to 2010 (which
#is where the misfitting is occurring)

basedir <- get_dir_ling(area = "n", num = 23, sens = 1)
get_mod(area = "n", num = 23)


##
#Copy input files for each run
##
r4ss::copy_SS_inputs(dir.old = basedir,
         dir.new =  get_dir_ling(area = "n", num = 23, sens = 901),
                    #get_dir_ling(area = "n", num = 23, sens = 902),
                    #get_dir_ling(area = "n", num = 23, sens = 903),
                    #get_dir_ling(area = "n", num = 23, sens = 904),
        use_ss_new = FALSE,
        copy_par = FALSE,
        copy_exe = TRUE, 
        dir.exe = get_dir_exe(),
        overwrite = TRUE,
        verbose = TRUE)


###
#Update discard rates - sens 901
###
inputs901 <- get_inputs_ling(id = "2021.n.023.901") 

gearrates <- read.csv(file.path(getwd(), "data-raw",
  "CONFIDENTIAL_DATA_lingcod_OB_DisRatios_boot_ncs_All_Gears_4010__2021-03-08.csv"),header=TRUE)

#Median discard rates are very similar to what is used already

png(file.path(dir.ling, "figures/NorthDiscardRates_vs_boot_ncs_Bottomtrawl.png"),
    res = 300, units = 'in', width = 9, height = 9)
plot(unlist(gearrates %>% 
  dplyr::filter(gear2 == "BottomTrawl" & 
                  Area == "North4010" & 
                  ryear %in% c(2002:2010)) %>% 
  dplyr::select(Median.Boot_Ratio)),
inputs901$dat$discard_data$Discard[1:9], 
xlab = "Base model discard rates for fleet1", 
ylab = "Bootstrapped bottomtrawl discard rates")
abline(0,1)
dev.off()

#Stdev are different though - possibly use
plot(unlist(gearrates %>% 
              dplyr::filter(gear2 == "BottomTrawl" & 
                              Area == "North4010" & 
                              ryear %in% c(2002:2010)) %>% 
              dplyr::select(StdDev.Boot_Ratio)),
     inputs901$dat$discard_data$Std_in[1:9])

##
#Explore combining 902 and 904 - use this as 901
##
inputs901 <- get_inputs_ling(id = "2021.n.023.901") 

#Set discard se to zero. Input variance adj adds 0.05, so effectively its 0.05
inputs901$dat$discard_data$Std_in[1:9] <- 0

#Downweight sample size number

samp_size_adj <- 
  r4ss::SSMethod.TA1.8(mod.2021.n.023.001, type="len", fleet=1, part=1)[1] / 
  r4ss::SSMethod.TA1.8(mod.2021.n.023.001, type="len", fleet=1, part=2)[1]

#Adjust sample size - Do so for all trawl length comps
discard_samp_size <- inputs901$dat$lencomp[inputs901$dat$lencomp$Part == 1 &
                                             inputs901$dat$lencomp$FltSvy == 1, "Nsamp"] 
inputs901$dat$lencomp[inputs901$dat$lencomp$Part == 1 &
                        inputs901$dat$lencomp$FltSvy == 1, "Nsamp"] <- discard_samp_size * samp_size_adj

#Add comments
inputs901$dat$Comments <- c(inputs901$dat$Comments,
                            "#C STAR Panel Request 14: Reduce std around discard rates to 0 for 2002-2010 and downweight discard length sample size for 2004-2019")

#Write new input files
write_inputs_ling(inputs901,
                  # directory is same as source directory for inputs in this case
                  dir = inputs901$dir,
                  verbose = FALSE,
                  overwrite = TRUE)

#Run model, include hessian
r4ss::run_SS_models(dirvec = inputs901$dir,
                    skipfinished = FALSE)

get_mod(area = "n", num = 23, sens = 901, plot = TRUE)


###
#Update discard rates se - sens 902
###
inputs902 <- get_inputs_ling(id = "2021.n.023.902")

#Set to zero. Input variance adj adds 0.05, so effectively its 0.05
inputs902$dat$discard_data$Std_in[1:9] <- 0

#Add comments
inputs902$dat$Comments <- c(inputs902$dat$Comments,
                         "#C STAR Panel Request 14: Reduce std around discard rates")

#Write new input files
write_inputs_ling(inputs902,
                  # directory is same as source directory for inputs in this case
                  dir = inputs902$dir,
                  verbose = FALSE,
                  overwrite = TRUE)

#Run model, include hessian
r4ss::run_SS_models(dirvec = inputs902$dir,
                    skipfinished = FALSE)

get_mod(area = "n", num = 23, sens = 902, plot = TRUE)


###
#Update discard rates and se - sens 903
###

#Because sens 901 wasnt done because trawl rates are very similar to those used
#dont do this run either

##
#Because there is some gradient flags for the width in the 1998-2011 retention block
#Retain_L_width_1_Comm_Trawl(1)_BLK3repl_1998 is reaching a bound, 
#set to se from the bootstrapping. Do here for sens 903
##

inputs903 <- get_inputs_ling(id = "2021.n.023.903")

inputs903$dat$discard_data$Std_in[1:9] <- 
  unlist(gearrates %>% 
           dplyr::filter(gear2 == "BottomTrawl" & 
                           Area == "North4010" & 
                           ryear %in% c(2002:2010)) %>% 
           dplyr::select(StdDev.Boot_Ratio))

#Add comments
inputs903$dat$Comments <- c(inputs903$dat$Comments,
                            "#C STAR Panel Request 14: Reduce std around discard rates to bootstrap se values")

#Write new input files
write_inputs_ling(inputs903,
                  # directory is same as source directory for inputs in this case
                  dir = inputs903$dir,
                  verbose = FALSE,
                  overwrite = TRUE)

#Run model, include hessian
r4ss::run_SS_models(dirvec = inputs903$dir,
                    skipfinished = FALSE)

get_mod(area = "n", num = 23, sens = 903, plot = TRUE)



###
#Adjust sample size of input length comps for discards - sens 904
###
inputs904 <- get_inputs_ling(id = "2021.n.023.904") 

samp_size_adj <- 
  r4ss::SSMethod.TA1.8(mod.2021.n.023.001, type="len", fleet=1, part=1)[1] / 
  r4ss::SSMethod.TA1.8(mod.2021.n.023.001, type="len", fleet=1, part=2)[1]

#Adjust sample size - Do so for all trawl length comps
discard_samp_size <- inputs904$dat$lencomp[inputs904$dat$lencomp$Part == 1 &
                        inputs904$dat$lencomp$FltSvy == 1, "Nsamp"] 
inputs904$dat$lencomp[inputs904$dat$lencomp$Part == 1 &
                        inputs904$dat$lencomp$FltSvy == 1, "Nsamp"] <- discard_samp_size * samp_size_adj

#Add comments
inputs904$dat$Comments <- c(inputs904$dat$Comments,
                            "#C STAR Panel Request 14: Reduce sample size of discard length comps")

#Write new input files
write_inputs_ling(inputs904,
                  # directory is same as source directory for inputs in this case
                  dir = inputs904$dir,
                  verbose = FALSE,
                  overwrite = TRUE)

#Run model, include hessian
r4ss::run_SS_models(dirvec = inputs904$dir,
                    skipfinished = FALSE)

get_mod(area = "n", num = 23, sens = 904, plot = TRUE)



<------------continue here


##
#Brian Comparison
###

get_mod(area = "n", num = 23, sens = 902)
get_mod(area = "n", num = 23, sens = 903)
get_mod(area = "n", num = 23, sens = 904)
get_mod(area = "n", num = 23, sens = 901)

outs <- mapply(SIMPLIFY = FALSE, r4ss::SS_output,
               dir=file.path("models", 
                             c("2021.n.023.001_fixWAreccatchhistory",
                               "2021.n.023.902_discard_se",
                               "2021.n.023.903_trawl_rates_discard_se",
                               "2021.n.023.904_sample_size")))#,
#                               "2021.n.023.901_trawl_discard_rates")))

labmod <- c("north new base",
             "1-Very low discard rate se",
             "2-Low discard rate se",
             "3-Reduce sample size of discard lengths")#,
#             "4-Combine 1 and 3")

mid <- r4ss::SSsummarize(outs)
r4ss::SSplotComparisons(
  mid, print = TRUE, 
  legendlabels = labmod,
  plotdir = file.path("figures", "STAR_request14"))

outmod <- list(
  mod.2021.n.023.001,
  mod.2021.n.023.902,
  mod.2021.n.023.903,
  mod.2021.n.023.904#,
#  mod.2021.n.023.901,
)

plot_twopanel_comparison(
  outmod,
  print = TRUE,
  legendlabels = labmod,
  dir = file.path("figures", "STAR_request14")
)

compare_table <- sens_make_table(
  area = "n",
  # num,
  # sens_base = 1,
  # yr = 2021,
  # sens_nums,
  sens_mods = setNames(outmod, gsub("\\n", "_", labmod)),
  sens_type = "star",
  plot = FALSE,
  plot_dir = file.path("figures", "STAR_request14"),
  table_dir = file.path("figures", "STAR_request14"),
  write = FALSE)

colnames(compare_table) <- c("Label", labmod)
utils::write.csv(compare_table,
  row.names = FALSE,
  file.path("figures", "STAR_request14", "sens_table_n_star14.csv")
  )




