####
# Create age and length comps from data collected for Laurel Lam's thesis
# These data are the same used in the 2017 assessment, but adjusted to accommodate the 
# new area separation at 40`10, and removing all samples before 1/20/2016, which 
# were on CCFRP boats
#
#
####

##A few things to do
#1. Update length bins, fleets, and timing
#2. 

library(nwfscSurvey)

#Working directory where files will be saved
dir = "U:/Stock assessments/lingcod_2021/surveys"

#Read in data
data <- read.csv("L:/Assessments/Archives/Lingcod/Lingcod_2017/Data/MLMLResearchSamples/SA_Lam_MergedAges.csv", header = TRUE)

#Rename fields so they work with UnexpandedLFs.fn
data$Length_cm = data$TL.cm
data$Year = as.numeric(substr(data$Date..yymmdd.,1,4))
#data$Age = data$Ages
#data$Depth_m = data$Depth.ft*0.3048
#data$Latitude_dd = data$Lat
#data$Weight = data$Wt.kg

#Remove CCRFP fish (sampled before 1/20/2016, which all occurred in 2015)
#Also reoves the four fish with no year
data <- subset(data,data$Year > 2015) 

#Set one record with sex = "M " to "M"
data[which(data$Sex == "M "), "Sex"] = "M"

#Separate north and south of 40`10
data_n = subset(data,data$Lat > (40+10/60))
data_s = subset(data,data$Lat <= (40+10/60))

#UnexpandedLFs.fn doesn't work for just one year. 
#Copy a dummy variable for year 9999 so function works for data_n
dummy = data_n[1,]
dummy$Year = 9999
data_n = rbind(dummy,data_n)

#Length Bins
lrange = range(data$TL.cm, na.rm = TRUE)
lbins = seq(from = floor(lrange[1]), to = floor(lrange[2]), by = 2)

##Age Bins
#arange = range(data$Ages, na.rm = TRUE)
#abins = seq(from = floor(arange[1]), to = floor(arange[2]), by = 1)

#data_n$Trawl_id = 1:nrow(data_n) 
#data_s$Trawl_id = 1:nrow(data_s)

###############################
# Length comps - North and South
###############################

#Generate Comps - North
lfs_n = UnexpandedLFs.fn(dir = file.path(dir, "lengths"), #puts into "forSS" folder in this location
                       datL = data_n, lgthBins = lbins, printfolder = "LamThesis",
                       sex = 3,  partition = 0, fleet = 1, month = 1)
lfs_n = list("comps" = lfs_n$comps[1,]) #Remove dummy year comp
write.csv(lfs_n, file = file.path(dir, "lengths", "LamThesis", paste0("LamThesis_north_notExpanded_Length_comp_Sex_3_bin=", min(lbins), "-", max(lbins), ".csv")))
file.remove(file.path(dir, "lengths", "LamThesis", paste0("Survey_notExpanded_Length_comp_Sex_3_bin=", min(lbins), "-", max(lbins), ".csv"))) 

#Visualize
PlotFreqData.fn(dir = file.path(dir, "lengths", "LamThesis"), 
                dat = lfs_n$comps, ylim=c(0, max(lbins)+4),
                main = "Lam Thesis lengths Male-Female North", yaxs="i", ylab="Length (cm)", dopng = TRUE)
PlotSexRatio.fn(dir = file.path(dir, "lengths", "LamThesis"),
                dat = data_n[!data_n$Year == 9999,], ylim = c(-0.1, 1.1), main = "LamThesis Sex Ratio North", yaxs="i", dopng = TRUE)


#Generate Comps - South
lfs_s = UnexpandedLFs.fn(dir = file.path(dir, "lengths"), #puts into "forSS" folder in this location
                       datL = data_s, lgthBins = lbins, printfolder = "LamThesis",
                       sex = 3,  partition = 0, fleet = 1, month = 1)
file.rename(from = file.path(dir, "lengths", "LamThesis", paste0("Survey_notExpanded_Length_comp_Sex_3_bin=", min(lbins), "-", max(lbins), ".csv")), 
            to = file.path(dir, "lengths", "LamThesis", paste0("LamThesis_south_notExpanded_Length_comp_Sex_3_bin=", min(lbins), "-", max(lbins), ".csv"))) 

#Visualize
PlotFreqData.fn(dir = file.path(dir, "lengths", "LamThesis"), 
                dat = lfs_s$comps, ylim=c(0, max(lbins)+4),
                main = "Lam Thesis lengths Male-Female South", yaxs="i", ylab="Length (cm)", dopng = TRUE)
PlotSexRatio.fn(dir = file.path(dir, "lengths", "LamThesis"),
                dat = data_s, ylim = c(-0.1, 1.1), main = "LamThesis Sex Ratio South", yaxs="i", dopng = TRUE)


###############################
# CAAL comps - North and South
###############################


### Need to update this...not sure how within the current framework


#### Make the .rda file for the package
# Uncomment the following line to actually make the data set for the package
lenCompN_Lam = lfs_n
lenCompS_Lam = lfs_s
LamThesis = data
usethis::use_data(lfs_n, overwrite = TRUE)
usethis::use_data(lfs_s, overwrite = TRUE)
usethis::use_data(LamThesis, overwrite = TRUE)

#### Remove objects
# Remove processing objects to clean up your workspace
#rm(testdata)
