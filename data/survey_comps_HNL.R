#######################################
#
#Scripts to generate length and age comps for the lingcod_2021 stock assessment from 
#the hook and line survey.
#
#Generates two comps: 1) females then males, and 2) unsexed fish
#
#Author: Brian Langseth
#Created: March 2, 2021
#
#######################################

##There are a few remaining tasks
1. Need to define length bins (currently set to min/max of each dataset with bin size of 5)
2. Will need to specify survey timing, sex (currently 3), fleet number, partition, etc....

#devtools::install_github("nwfsc-assess/nwfscSurvey", build_vignettes = TRUE)
library(nwfscSurvey)
#vignette("nwfscSurvey")

##------------------------------------Scripts----------------------------------------##

#Working directory where files will be saved
setwd("U:/Stock assessments/lingcod_2021/surveys")

#John Harms provided data in email on Feb 9, 2021.
hnl_full = read.csv("qryGrandUnifiedThru2019_For2021Assessments_DWarehouse version_01072021.csv", header = TRUE)
hnl = hnl_full[hnl_full$common_name == "Lingcod",]

#No ages in this dataset
table(hnl$age_years, useNA = "always")

#Create subfolder in length directory
if(!dir.exists(file.path("lengths","HooknLine"))) dir.create(file.path("lengths","HooknLine"))


############################################################################################
#	Comps - all for southern model 
############################################################################################

lrange = range(hnl$length_cm, na.rm = TRUE)
lbins = seq(from = lrange[1], to = lrange[2], by = 5)

#Rename fields so they work with UnexpandedLFs.fn
hnl$Length_cm = hnl$length_cm
hnl$Sex = hnl$sex
hnl$Year = hnl$year

#Generate Comps
lfs = UnexpandedLFs.fn(dir = file.path("lengths"), #puts into "forSS" folder in this location
                       datL = hnl, lgthBins = lbins, printfolder = "HooknLine",
                       sex = 3,  partition = 0, fleet = 1, month = 1)
file.rename(from = file.path("lengths", "HooknLine", paste0("Survey_notExpanded_Length_comp_Sex_3_bin=", min(lbins), "-", max(lbins), ".csv")), 
            to = file.path("lengths", "HooknLine", paste0("HNL_notExpanded_Length_comp_Sex_3_bin=", min(lbins), "-", max(lbins), ".csv"))) 
file.rename(from = file.path("lengths", "HooknLine", paste0("Survey_notExpanded_Length_comp_Sex_0_bin=", min(lbins), "-", max(lbins), ".csv")), 
            to = file.path("lengths", "HooknLine", paste0("HNL_notExpanded_Length_comp_Sex_0_bin=", min(lbins), "-", max(lbins), ".csv"))) 

#Visualize
PlotFreqData.fn(dir = file.path("lengths", "HooknLine"), 
                dat = lfs$comps, ylim=c(0, max(lbins)+4),
                main = "HNL lengths Male-Female", yaxs="i", ylab="Length (cm)", dopng = TRUE)
PlotFreqData.fn(dir = file.path("lengths", "HooknLine"), 
                dat = lfs$comps_u, ylim=c(0, max(lbins)+4),
                main = "HNL lengths Unsexed", yaxs="i", ylab="Length (cm)", dopng = TRUE)
PlotSexRatio.fn(dir = file.path("lengths", "HooknLine"),
                dat = hnl, ylim = c(-0.1, 1.1), main = "HNL Sex Ratio", yaxs="i", dopng = TRUE)



