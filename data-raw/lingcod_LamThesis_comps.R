####
# Create age and length comps from data collected for Laurel Lam's thesis
# These data are the same used in the 2017 assessment, but adjusted to accommodate the 
# new area separation at 40`10, and removing all samples before 1/20/2016, which 
# were on CCFRP boats
#
####

##A few things to do
#1. Update length bins, fleets, and timing
#2. 

#Read in data
data <- read.csv("L:/Assessments/Archives/Lingcod/Lingcod_2017/Data/MLMLResearchSamples/SA_Lam_MergedAges.csv", header = TRUE)

#Rename fields so they work with UnexpandedLFs.fn and SurveyAgeAtLen.fn
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

#Age Bins
#arange = range(data$Ages, na.rm = TRUE)
#abins = seq(from = floor(arange[1]), to = floor(arange[2]), by = 1)

#data_n$Trawl_id = 1:nrow(data_n) 
#data_s$Trawl_id = 1:nrow(data_s)

###############################
# Length comps - North and South
###############################

#Generate Comps - North
lfs_n = UnexpandedLFs.fn(dir = file.path("data", "lenComps"),
                       datL = data_n, lgthBins = lbins, printfolder = "LamThesis",
                       sex = 3,  partition = 0, fleet = 1, month = 1)
lfs_n = list("comps" = lfs_n$comps[1,]) #Remove dummy year comp
write.csv(lfs_n, file.path("data", "lenComps", "LamThesis", paste0("north_LamThesis_notExpanded_Length_comp_Sex_3_bin=", min(lbins), "-", max(lbins), ".csv")))
file.remove(file.path("data", "lenComps", "LamThesis", paste0("Survey_notExpanded_Length_comp_Sex_3_bin=", min(lbins), "-", max(lbins), ".csv"))) 

#Visualize
PlotFreqData.fn(dir = file.path("data", "lenComps", "LamThesis"), 
                dat = lfs_n$comps, ylim=c(0, max(lbins)+4),
                main = "Lam Thesis lengths Male-Female North", yaxs="i", ylab="Length (cm)", dopng = TRUE)
PlotSexRatio.fn(dir = file.path("data", "lenComps", "LamThesis"),
                dat = data_n[!data_n$Year == 9999,], ylim = c(-0.1, 1.1), main = "LamThesis Sex Ratio North", yaxs="i", dopng = TRUE)


#Generate Comps - South
lfs_s = UnexpandedLFs.fn(dir = file.path("data", "lenComps"),
                       datL = data_s, lgthBins = lbins, printfolder = "LamThesis",
                       sex = 3,  partition = 0, fleet = 1, month = 1)
file.rename(from = file.path("data", "lenComps", "LamThesis", paste0("Survey_notExpanded_Length_comp_Sex_3_bin=", min(lbins), "-", max(lbins), ".csv")), 
            to = file.path("data", "lenComps", "LamThesis", paste0("south_LamThesis_notExpanded_Length_comp_Sex_3_bin=", min(lbins), "-", max(lbins), ".csv"))) 

#Visualize
PlotFreqData.fn(dir = file.path("data", "lenComps", "LamThesis"), 
                dat = lfs_s$comps, ylim=c(0, max(lbins)+4),
                main = "Lam Thesis lengths Male-Female South", yaxs="i", ylab="Length (cm)", dopng = TRUE)
PlotSexRatio.fn(dir = file.path("data", "lenComps", "LamThesis"),
                dat = data_s, ylim = c(-0.1, 1.1), main = "LamThesis Sex Ratio South", yaxs="i", dopng = TRUE)


###############################
# CAAL comps - North and South
###############################

### Need to update this...not sure how within the current framework
# strata_north = CreateStrataDF.fn(names = NA,
#                                  depths.shallow = c(55), 
#                                  depths.deep = c(350), 
#                                  lats.south = c(40.166667),
#                                  lats.north = c(49))
# 
# caal_n = SurveyAgeAtLen.fn(dir = file.path("data", "LamThesis"),
#                            datAL = data_n, 
#                            datTows = data_n, 
#                            strat.df = strata_north, 
#                            lgthBins = lbin, 
#                            ageBins = abin, 
#                            sex = 3,
#                            raw = TRUE, #Not standard to set to FALSE (expanded)
#                            month = "Month", 
#                            fleet = "Fleet",
#                            ageErr = "Enter")


#### Make the .rda file for the package
# Uncomment the following line to actually make the data set for the package
lenCompN_Lam = lfs_n
lenCompS_Lam = lfs_s
usethis::use_data(lenCompN_Lam, overwrite = TRUE)
usethis::use_data(lenCompS_Lam, overwrite = TRUE)

#### Remove objects
# rm()