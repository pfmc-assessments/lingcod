####
# Create age and length comps from data collected for Laurel Lam's thesis
# These data are the same used in the 2017 assessment, but adjusted to accommodate the 
# new area separation at 40`10, and removing all samples before 1/20/2016, which 
# were on CCFRP boats
#
####

# Make dir
dir <- file.path("data-raw", "lenComps", "LamThesis")
dir.create(dir, showWarnings = FALSE, recursive = TRUE)
dir.create(gsub("lenComps", "ageCAAL", dir), showWarnings = FALSE, recursive = TRUE)
stopifnot(file.exists(dir))

#Read in data - copied file from L:/Assessments/Archives/Lingcod/Lingcod_2017/Data/MLMLResearchSamples
data <- read.csv(file.path("data-raw", "SA_Lam_MergedAges.csv"), header = TRUE)

#Rename fields so they work with UnexpandedLFs.fn and SurveyAgeAtLen.fn
#Convert length to fork length following Laidig (see github issue: https://github.com/iantaylor-NOAA/Lingcod_2021/issues/26)
data$Length_cm = data$TL.cm*0.981-0.521
data$Year = as.numeric(substr(data$Date..yymmdd.,1,4))

#Convert the info_bins[["length"]] in the file which are based on total length bins to fork length bins
data$Len_Bin_FL = 2*floor(data$Length_cm/2)

#Remove CCRFP fish (sampled before 1/20/2016, which all occurred in 2015)
#Also removes the four fish with no year
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

###############################
# Length comps - North and South
###############################

#Generate Comps - North
lfs_n = nwfscSurvey::UnexpandedLFs.fn(dir = dirname(dir),
                       datL = data_n, lgthBins = info_bins[["length"]], printfolder = basename(dir),
                       sex = 3,  partition = 0, fleet = get_fleet("Lam")$num, month = 7)
lfs_n = list("comps" = lfs_n$comps[1,]) #Remove dummy year comp
#Output removal direction within write.csv or else column headers are weird
write.csv(lfs_n$comps[1,], file.path(dir, paste0("north_LamThesis_notExpanded_Length_comp_Sex_3_bin=", min(info_bins[["length"]]), "-", max(info_bins[["length"]]), ".csv")), row.names = FALSE)
file.remove(file.path(dir, paste0("Survey_notExpanded_Length_comp_Sex_3_bin=", min(info_bins[["length"]]), "-", max(info_bins[["length"]]), ".csv"))) 

#Visualize
nwfscSurvey::PlotFreqData.fn(dir = dir,
                dat = lfs_n$comps, ylim=c(0, max(info_bins[["length"]])+4), xlim = c(2015,2017),
                main = "Lam Thesis lengths Male-Female North", yaxs="i", ylab="Length (cm)", dopng = TRUE)
nwfscSurvey::PlotSexRatio.fn(dir = dir,
                dat = data_n[!data_n$Year == 9999,], ylim = c(-0.1, 1.1), main = "LamThesis Sex Ratio North", yaxs="i", dopng = TRUE)


#Generate Comps - South
lfs_s = nwfscSurvey::UnexpandedLFs.fn(dir = dirname(dir),
                       datL = data_s, lgthBins = info_bins[["length"]], printfolder = basename(dir),
                       sex = 3,  partition = 0, fleet = get_fleet("Lam")$num, month = 7)
file.rename(from = file.path(dir, paste0("Survey_notExpanded_Length_comp_Sex_3_bin=", min(info_bins[["length"]]), "-", max(info_bins[["length"]]), ".csv")), 
            to = file.path(dir, paste0("south_LamThesis_notExpanded_Length_comp_Sex_3_bin=", min(info_bins[["length"]]), "-", max(info_bins[["length"]]), ".csv"))) 

#Visualize
nwfscSurvey::PlotFreqData.fn(dir = dir,
                dat = lfs_s$comps, ylim=c(0, max(info_bins[["length"]])+4), xlim = c(2015,2018),
                main = "Lam Thesis lengths Male-Female South", yaxs="i", ylab="Length (cm)", dopng = TRUE)
nwfscSurvey::PlotSexRatio.fn(dir = dir,
                dat = data_s, ylim = c(-0.1, 1.1), main = "LamThesis Sex Ratio South", yaxs="i", dopng = TRUE)

#############
# Marginal Age Comps - just for visualization figures
#############

#Generate Comps - North
afs_n = nwfscSurvey::UnexpandedAFs.fn(dir = dir,
                                      datA = data_n, ageBins = info_bins[["age"]], printfolder = "forSS",
                                      sex = 3,  partition = 0, fleet = get_fleet("Lam")$num, month = 7)
afs_n = list("comps" = afs_n$comps[1,]) #Remove dummy year comp
#Output removal direction within write.csv or else column headers are weird
unlink(file.path(dir,"forSS"), recursive=TRUE)

#Visualize
nwfscSurvey::PlotFreqData.fn(dir = dir,
                             dat = afs_n$comps, ylim=c(0, max(info_bins[["age"]])+4), xlim = c(2015,2017),
                             main = "Lam Thesis ages Male-Female North", yaxs="i", ylab="Age", dopng = TRUE)

#Generate Comps - South
afs_s = nwfscSurvey::UnexpandedAFs.fn(dir = dir,
                                      datA = data_s, ageBins = info_bins[["age"]], printfolder = "forSS",
                                      sex = 3,  partition = 0, fleet = get_fleet("Lam")$num, month = 7)
#Output removal direction within write.csv or else column headers are weird
unlink(file.path(dir,"forSS"), recursive=TRUE)

#Visualize
nwfscSurvey::PlotFreqData.fn(dir = dir,
                             dat = afs_s$comps, ylim=c(0, max(info_bins[["age"]])+4), xlim = c(2015,2018),
                             main = "Lam Thesis ages Male-Female South", yaxs="i", ylab="Age", dopng = TRUE)


###############################
# CAAL comps - North and South
###############################

#Generate Comps - North
ageCAAL_N_LamThesis = create_caal_nonsurvey(Data = data_n, agebin = range(info_bins[["age"]]), lenbin = range(info_bins[["length"]]), wd = gsub("lenComps", "ageCAAL", dir),
                                            append = "north_LamThesis", seas = 7, fleet = get_fleet("Lam")$num, partition = 0, ageEr = 1)

#Generate Comps - South
ageCAAL_S_LamThesis = create_caal_nonsurvey(Data = data_s, agebin = range(info_bins[["age"]]), lenbin = range(info_bins[["length"]]), wd = gsub("lenComps", "ageCAAL", dir),
                                            append = "south_LamThesis", seas = 7, fleet = get_fleet("Lam")$num, partition = 0, ageEr = 1)


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

# Move png files to "figures"
ignore <- file.copy(
  recursive = TRUE,
  dir(dir, pattern = "png", recursive = TRUE, full.names = TRUE),
  "figures"
)

#### Remove objects
# rm()
