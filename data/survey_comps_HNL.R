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
1. Need to define length bins (currently set to min/max of each dataset with bin size of 2)
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

#Laurel Lam provided ages on March 22, 2021 from 2017-2019 for hook and line survey
hnl_ages = read.csv("H&L_Lingcod_ages.csv", header = TRUE)

#Create subfolder in length and age directory
if(!dir.exists(file.path("lengths","HooknLine"))) dir.create(file.path("lengths","HooknLine"))
if(!dir.exists(file.path("ages","HooknLine"))) dir.create(file.path("ages","HooknLine"))



############################################################################################
#	Comps - all for southern model 
############################################################################################

#------------------------Length-----------------------------#

lrange = range(hnl$length_cm, na.rm = TRUE)
lbins = seq(from = lrange[1], to = lrange[2], by = 2)

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

age_representativeness_plot(hnl)



#------------------------Age-----------------------------#

#Marginal comps
arange = range(hnl_ages$Final.Age, na.rm = TRUE)
abins = seq(from = arange[1], to = arange[2], by = 1)

#Set up required variable names
hnl_ages$Age = hnl_ages$Final.Age
hnl_ages$Length_cm = hnl_ages$FishLength
hnl_ages$Sex = hnl_ages$FishGenderCode
hnl_ages$Year = hnl_ages$SurveyYear

afs = UnexpandedAFs.fn(dir = file.path("ages"),  #Somehow stills prints to "forSS"
                       datA = hnl_ages, ageBins = abins, printfolder = "HooknLine",
                       sex = 3, partition = 0, fleet = 1, month = 1, ageErr = 1)
file.rename(from = file.path("ages", "forSS", "Survey_notExpanded_Age_comp_Sex_3_bin=1-12.csv"), 
            to= file.path("ages", "HooknLine", "south_Survey_Sex3_Bins_1_12_AgeComps.csv")) 
if(dir.exists(file.path("ages","forSS"))) unlink(file.path("ages","forSS"),recursive = TRUE) #remove forSS file


#Currently not doing CAAL

