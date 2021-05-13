####
# Create age and length comps from data collected for Laurel Lam's thesis
# These data are the same used in the 2017 assessment, but adjusted to accommodate the 
# new area separation at 40`10, and removing all samples before 1/20/2016, which 
# were on CCFRP boats
#
####

#Read in data
data <- read.csv("L:/Assessments/Archives/Lingcod/Lingcod_2017/Data/MLMLResearchSamples/SA_Lam_MergedAges.csv", header = TRUE)

#Rename fields so they work with UnexpandedLFs.fn and SurveyAgeAtLen.fn
#Convert length to fork length following Laidig (see github issue: https://github.com/iantaylor-NOAA/Lingcod_2021/issues/26)
data$Length_cm = data$TL.cm*0.981-0.521
data$Year = as.numeric(substr(data$Date..yymmdd.,1,4))

#Convert the Lbins in the file which are based on total length bins to fork length bins
data$Len_Bin_FL = 2*floor(data$Length_cm/2)

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
lrange = c(10,130)
lbins = seq(from = lrange[1], to = lrange[2], by = 2)

#Age Bins
arange = c(0,20)
abins = seq(from = arange[1], to = arange[2], by = 1)

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

#Generate Comps - North
ageCAAL_N_LamThesis = create_caal_nonsurvey(data_n, arange, lrange, "data/ageCAAL/LamThesis", "north_LamThesis")

#Generate Comps - South
ageCAAL_S_LamThesis = create_caal_nonsurvey(data_s, arange, lrange, "data/ageCAAL/LamThesis", "south_LamThesis")


###############################
# Make the .rda file for the package
############################### 
#Not adding Laurels Thesis data at this time.
lenCompN_LamThesis = lfs_n
lenCompS_LamThesis = lfs_s
usethis::use_data(lenCompN_LamThesis, overwrite = TRUE)
usethis::use_data(lenCompS_LamThesis, overwrite = TRUE)
usethis::use_data(ageCAAL_N_LamThesis, overwrite = TRUE)
usethis::use_data(ageCAAL_S_LamThesis, overwrite = TRUE)

#### Remove objects
# rm()