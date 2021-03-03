#######################################
#
#Scripts to pull length and age data for the lingcod_2021 stock assessment from surveys
#and create expanded length, age, and CAAL comps. 
#
#Lingcod only present in the combo, triennial, and slope surveys so only use these surveys
#Ages only available in combo and triennial. 
#
#Author: Brian Langseth
#Created: February 9, 2021
#
#######################################

##There are a few remaining tasks
1. Need to redefine depth strata and latitude strata (right now WCGBTS specific)
2. Need to define length bins (currently set to min/max of each dataset)
3. Will need to specify survey timing, sex (currently 3), fleet number, etc....
4. For CAAL, nwfscSurvey functions dont do unsexed. Do we ignore unsexed? 
5. For CAAL can do expanded comps, but Im not doing (not standard to do so). Do we want to use expanded CAAL?

#devtools::install_github("nwfsc-assess/nwfscSurvey", build_vignettes = TRUE)
library(nwfscSurvey)
#vignette("nwfscSurvey")

##------------------------------------Scripts----------------------------------------##


#Working directory where files will be saved
setwd("U:/Stock assessments/lingcod_2021/surveys")

#Surveys to use 
surveys = c("NWFSC.Combo", "Triennial", "AFSC.Slope", "NWFSC.Slope")

#Read in data from the data warehouse using function below
#Saves .rda files for each specified survey
read_surveys(surveys) #Dont need to do this again unless need new data

#Generate length comps using function below
#Saves comps and plots for each specified survey 
survey_lcomps(surveys)


#Generate age comps using function below. Option for CAAL
#Saves comps and plots for surveys with age data 
survey_acomps(surveys[1:2], CAAL = TRUE)



##------------------------------------Functions----------------------------------------##

#####################################################################################
#Function to read in the biological and catch data from the data warehouse
#Saves .rda files to the working directory
#####################################################################################

read_surveys <- function(sname){
  
  for(i in sname){
    bio <- PullBio.fn(Name = "lingcod", SurveyName = i, SaveFile = TRUE, Dir = getwd())
    catch <- PullCatch.fn(Name = "lingcod", SurveyName = i, SaveFile = TRUE, Dir = getwd())
    print(paste("Done reading in bio and catch for", i))
  }
}


######################################################################################
#Function to expand the length comps for each survey
#Saves to survey specific subfolder within length folders
#1. the unsexed and sexed comps for north and south
#2. Plots: sex ratio and size frequency for north and south
######################################################################################

survey_lcomps <- function(sname){
  
  #Create lengths subfolder in current directory
  if(!dir.exists("lengths")) dir.create("lengths")

  for(i in sname){
    
    #Read biological data and catch data generated from read_surveys()
    load(paste0("Bio_All_", i, "_2021-02-08.rda"))
    bio =  Data
    if(i %in% c("Triennial", "AFSC.Slope")) {
      bio = Data[[1]] #Adjust for format differences for some surveys
    }
    load(paste0("Catch__", i, "_2021-02-08.rda"))
    catch = Out
    
    #Create strata - right now basing off stratification of WCBGT survey at 55, 183, and 549 depths
    #and Cape Mendocino (APPROXIMATE) and pt conception latitudes
    strata_north = CreateStrataDF.fn(names = c("north shallow", "north mid"),
                               depths.shallow = c(55, 183), 
                               depths.deep = c(183, 549), 
                               lats.south = c(40),
                               lats.north = c(49))
    
    strata_south = CreateStrataDF.fn(names = c("south Pt C shallow", "Pt C to Cape M shallow", "south Pt C mid", "Pt C to Cape M mid"),
                                     depths.shallow = c(55, 55, 183, 183), 
                                     depths.deep = c(183, 183, 549, 549), 
                                     lats.south = c(32, 34.5, 32, 34.5),
                                     lats.north = c(34.5, 40, 34.5, 40))
  
    #------------------------------------------Lengths-----------------------------------------#
    
    #Create a survey subfolder in the lengths folder
    dir.create(file.path("lengths",i))
    
    #Split based on our designation between north and south at 40 degrees 10 minutes
    bio_north = bio[bio$Latitude_dd >= (40 + 10/60),]
    bio_south = bio[bio$Latitude_dd < (40 + 10/60),]
    catch_north = catch[catch$Latitude_dd >= (40 + 10/60),]
    catch_south = catch[catch$Latitude_dd < (40 + 10/60),]
    
    #Calculate the effN
    n_north = GetN.fn(dir = file.path(getwd(), "lengths"), dat = bio_north, type = "length", 
                species = "others", printfolder = i)
    
    file.rename(file.path(getwd(), "lengths", i, "length_SampleSize.csv"),
                file.path(getwd(), "lengths", i, "north_length_SampleSize.csv"))
    
    n_south = GetN.fn(dir = file.path(getwd(), "lengths"), dat = bio_south, type = "length", 
                      species = "others", printfolder = i)
    
    file.rename(file.path(getwd(), "lengths", i, "length_SampleSize.csv"),
                file.path(getwd(), "lengths", i, "south_length_SampleSize.csv"))
    
    
    #Create length bins - RIGHT NOW THE MIN/MAX OF THE FULL DATASET
    lrange = range(bio$Length_cm, na.rm = TRUE, finite = TRUE)
    lbin = seq(from = floor(lrange[1]), to = ceiling(lrange[2]), by = 2)
    
    
    #Output expanded lengths based on strata and rename. Plot summaries 
    lengths_north = SurveyLFs.fn(dir = file.path(getwd(), "lengths"),
                           datL = bio_north, 
                           datTows = catch_north, 
                           strat.df = strata_north, 
                           lgthBins = lbin, 
                           sex = 3, 
                           month = "Month", 
                           fleet = "Fleet",
                           nSamps = n_north,
                           printfolder = i)
    
    file.rename(file.path(getwd(), "lengths", i, paste0("Survey_Sex3_Bins_",first(lbin),"_",last(lbin),"_LengthComps.csv")),
                file.path(getwd(), "lengths", i, paste0("north_Survey_Sex3_Bins_",first(lbin),"_",last(lbin),"_LengthComps.csv")))
    file.rename(file.path(getwd(), "lengths", i, paste0("Survey_Sex_Unsexed_Bins_",first(lbin),"_",last(lbin),"_LengthComps.csv")),
                file.path(getwd(), "lengths", i, paste0("north_Survey_Sex_Unsexed_Bins_",first(lbin),"_",last(lbin),"_LengthComps.csv")))
    file.rename(file.path(getwd(), "lengths", i, paste0("Survey_Sex3_Bins_-999_",last(lbin),"_LengthComps.csv")),
                file.path(getwd(), "lengths", i, paste0("north_Survey_Sex3_Bins_-999_",last(lbin),"_LengthComps.csv")))
    file.rename(file.path(getwd(), "lengths", i, paste0("Survey_Sex_Unsexed_Bins_-999_",last(lbin),"_LengthComps.csv")),
                file.path(getwd(), "lengths", i, paste0("north_Survey_Sex_Unsexed_Bins_-999_",last(lbin),"_LengthComps.csv")))
    
    PlotFreqData.fn(dir = file.path(getwd(), "lengths", i), dat = lengths_north, ylim=c(0, max(lbin) + 4), inch = 0.10, main = paste( i, "- North "), yaxs="i", ylab="Length (cm)", dopng = TRUE)
    PlotSexRatio.fn(dir = file.path(getwd(), "lengths", i), dat = bio_north, data.type = "length", dopng = TRUE, main = paste( i, "- North "))
    
    
    lengths_south = SurveyLFs.fn(dir = file.path(getwd(), "lengths"),
                                 datL = bio_south, 
                                 datTows = catch_south, 
                                 strat.df = strata_south, 
                                 lgthBins = lbin, 
                                 sex = 3, 
                                 month = "Month", 
                                 fleet = "Fleet",
                                 nSamps = n_south,
                                 printfolder = i)
    
    file.rename(file.path(getwd(), "lengths", i, paste0("Survey_Sex3_Bins_",first(lbin),"_",last(lbin),"_LengthComps.csv")),
                file.path(getwd(), "lengths", i, paste0("south_Survey_Sex3_Bins_",first(lbin),"_",last(lbin),"_LengthComps.csv")))
    file.rename(file.path(getwd(), "lengths", i, paste0("Survey_Sex_Unsexed_Bins_",first(lbin),"_",last(lbin),"_LengthComps.csv")),
                file.path(getwd(), "lengths", i, paste0("south_Survey_Sex_Unsexed_Bins_",first(lbin),"_",last(lbin),"_LengthComps.csv")))
    file.rename(file.path(getwd(), "lengths", i, paste0("Survey_Sex3_Bins_-999_",last(lbin),"_LengthComps.csv")),
                file.path(getwd(), "lengths", i, paste0("south_Survey_Sex3_Bins_-999_",last(lbin),"_LengthComps.csv")))
    file.rename(file.path(getwd(), "lengths", i, paste0("Survey_Sex_Unsexed_Bins_-999_",last(lbin),"_LengthComps.csv")),
                file.path(getwd(), "lengths", i, paste0("south_Survey_Sex_Unsexed_Bins_-999_",last(lbin),"_LengthComps.csv")))
    
    PlotFreqData.fn(dir = file.path(getwd(), "lengths", i), dat = lengths_south, ylim=c(0, max(lbin) + 4), inch = 0.10, main = paste( i, "- South "), yaxs="i", ylab="Length (cm)", dopng = TRUE)
    PlotSexRatio.fn(dir = file.path(getwd(), "lengths", i), dat = bio_south, data.type = "length", dopng = TRUE, main = paste( i, "- South "))
    
    print(paste("Lengths for",i,"done"))
    
  } #end survey loop
} 


######################################################################################
#Function to expand the age comps for each survey. REQUIRES there to be ages
#Default is marginal comps but can do CAAL
#Saves to survey specific subfolders within age or age_CAAL folder
#Ages
#1. the unsexed and sexed comps for north and south
#2. Plots: sex ratio and size frequency for north and south

#Ages CAAL
#1. Sex-specific comps for north and south
#2. No plots currently available
######################################################################################


survey_acomps <- function(sname, CAAL = FALSE){
  
  #Create age subfolders in current directory
  if(!dir.exists("ages")) dir.create("ages")
  if(!dir.exists("ages_CAAL") & CAAL) dir.create("ages_CAAL")
  
  for(i in sname){
    
    #Read biological data and catch data generated from read_surveys()
    load(paste0("Bio_All_", i, "_2021-02-08.rda"))
    bio_ages = Data
    if(i %in% c("Triennial", "AFSC.Slope")) {
      bio_ages = Data[[2]] #Adjust for format differences for some surveys
    }
    load(paste0("Catch__", i, "_2021-02-08.rda"))
    catch = Out
    
    #Create strata - right now basing off stratification of WCBGT survey at 55, 183, and 549 depths
    #and Cape Mendocino (APPROXIMATE) and pt conception latitudes
    strata_north = CreateStrataDF.fn(names = c("north shallow", "north mid"),
                                     depths.shallow = c(55, 183), 
                                     depths.deep = c(183, 549), 
                                     lats.south = c(40),
                                     lats.north = c(49))
    
    strata_south = CreateStrataDF.fn(names = c("south Pt C shallow", "Pt C to Cape M shallow", "south Pt C mid", "Pt C to Cape M mid"),
                                     depths.shallow = c(55, 55, 183, 183), 
                                     depths.deep = c(183, 183, 549, 549), 
                                     lats.south = c(32, 34.5, 32, 34.5),
                                     lats.north = c(34.5, 40, 34.5, 40))
    
    #------------------------------------------Ages-----------------------------------------#
      
    #Create a survey subfolder in the ages folder
    dir.create(file.path("ages",i))
    
    bioages_north = bio_ages[bio_ages$Latitude_dd >= (40 + 10/60),]
    bioages_south = bio_ages[bio_ages$Latitude_dd < (40 + 10/60),]
    catch_north = catch[catch$Latitude_dd >= (40 + 10/60),]
    catch_south = catch[catch$Latitude_dd < (40 + 10/60),]
    
    ############################
    #Marginals
    ############################
    
    #Calculate the effN
    n_north_age = GetN.fn(dir = file.path(getwd(), "ages"), dat = bioages_north, type = "age", 
                          species = "others", printfolder = i)
    
    file.rename(file.path(getwd(), "ages", i, "age_SampleSize.csv"),
                file.path(getwd(), "ages", i, "north_age_SampleSize.csv"))
    
    n_south_age = GetN.fn(dir = file.path(getwd(), "ages"), dat = bioages_south, type = "age", 
                          species = "others", printfolder = i)
    
    file.rename(file.path(getwd(), "ages", i, "age_SampleSize.csv"),
                file.path(getwd(), "ages", i, "south_age_SampleSize.csv"))
    
    
    #Create age bins - RIGHT NOW THE MIN/MAX OF THE FULL DATASET
    arange = range(bio_ages$Age, na.rm = TRUE, finite = TRUE)
    abin = seq(from = arange[1], to = arange[2], by = 1)
    
    
    #Output expanded ages based on strata and rename. Plot summaries 
    ages_north = SurveyAFs.fn(dir = file.path(getwd(), "ages"),
                              datA = bioages_north, 
                              datTows = catch_north, 
                              strat.df = strata_north, 
                              ageBins = abin, 
                              sex = 3, 
                              month = "Month", 
                              fleet = "Fleet",
                              agelow = "Enter",
                              agehigh = "Enter",
                              ageErr = "Enter",
                              nSamps = n_north_age,
                              printfolder = i)
    
    file.rename(file.path(getwd(), "ages", i, paste0("Survey_Sex3_Bins_",first(abin),"_",last(abin),"_AgeComps.csv")),
                file.path(getwd(), "ages", i, paste0("north_Survey_Sex3_Bins_",first(abin),"_",last(abin),"_AgeComps.csv")))
    file.rename(file.path(getwd(), "ages", i, paste0("Survey_Sex_Unsexed_Bins_",first(abin),"_",last(abin),"_AgeComps.csv")),
                file.path(getwd(), "ages", i, paste0("north_Survey_Sex_Unsexed_Bins_",first(abin),"_",last(abin),"_AgeComps.csv")))
    file.rename(file.path(getwd(), "ages", i, paste0("Survey_Sex3_Bins_-999_",last(abin),"_AgeComps.csv")),
                file.path(getwd(), "ages", i, paste0("north_Survey_Sex3_Bins_-999_",last(abin),"_AgeComps.csv")))
    file.rename(file.path(getwd(), "ages", i, paste0("Survey_Sex_Unsexed_Bins_-999_",last(abin),"_AgeComps.csv")),
                file.path(getwd(), "ages", i, paste0("north_Survey_Sex_Unsexed_Bins_-999_",last(abin),"_AgeComps.csv")))
    
    PlotFreqData.fn(dir = file.path(getwd(), "ages", i), dat = ages_north, ylim=c(0, max(abin) + 1), inch = 0.10, main = paste( i, "- North "), yaxs="i", ylab="Age", dopng = TRUE)
    PlotSexRatio.fn(dir = file.path(getwd(), "ages", i), dat = bioages_north, data.type = "age", dopng = TRUE, main = paste( i, "- North "))
    
    
    ages_south = SurveyAFs.fn(dir = file.path(getwd(), "ages"),
                              datA = bioages_south, 
                              datTows = catch_south, 
                              strat.df = strata_south, 
                              ageBins = abin, 
                              sex = 3, 
                              month = "Month", 
                              fleet = "Fleet",
                              agelow = "Enter",
                              agehigh = "Enter",
                              ageErr = "Enter",
                              nSamps = n_south_age,
                              printfolder = i)
    
    file.rename(file.path(getwd(), "ages", i, paste0("Survey_Sex3_Bins_",first(abin),"_",last(abin),"_AgeComps.csv")),
                file.path(getwd(), "ages", i, paste0("south_Survey_Sex3_Bins_",first(abin),"_",last(abin),"_AgeComps.csv")))
    file.rename(file.path(getwd(), "ages", i, paste0("Survey_Sex_Unsexed_Bins_",first(abin),"_",last(abin),"_AgeComps.csv")),
                file.path(getwd(), "ages", i, paste0("south_Survey_Sex_Unsexed_Bins_",first(abin),"_",last(abin),"_AgeComps.csv")))
    file.rename(file.path(getwd(), "ages", i, paste0("Survey_Sex3_Bins_-999_",last(abin),"_AgeComps.csv")),
                file.path(getwd(), "ages", i, paste0("south_Survey_Sex3_Bins_-999_",last(abin),"_AgeComps.csv")))
    file.rename(file.path(getwd(), "ages", i, paste0("Survey_Sex_Unsexed_Bins_-999_",last(abin),"_AgeComps.csv")),
                file.path(getwd(), "ages", i, paste0("south_Survey_Sex_Unsexed_Bins_-999_",last(abin),"_AgeComps.csv")))
    
    PlotFreqData.fn(dir = file.path(getwd(), "ages", i), dat = ages_south, ylim=c(0, max(abin) + 1), inch = 0.10, main = paste( i, "- South "), yaxs="i", ylab="Age", dopng = TRUE)
    PlotSexRatio.fn(dir = file.path(getwd(), "ages", i), dat = bioages_south, data.type = "age", dopng = TRUE, main = paste( i, "- South "))
    
    print(paste("Ages for",i,"done")) #For checking purposes
    
    
    ############################
    #Conditional age at length
    ############################
    
    if(CAAL){
      
      #For surveys with separated length and age datasets (e.g. Triennial), using just the age dataset
      
      #Create a survey subfolder in the ages_CAAL folder
      dir.create(file.path("ages_CAAL",i))
      
      #Create length bins - RIGHT NOW THE MIN/MAX OF THE USED DATASET
      lrange = range(bio_ages$Length_cm, na.rm = TRUE, finite = TRUE)
      lbin = seq(from = floor(lrange[1]), to = ceiling(lrange[2]), by = 2)
      
      #Output conditional length at age comps 
      agesCAAL_north = SurveyAgeAtLen.fn(dir = file.path(getwd(), "ages_CAAL"),
                                datAL = bioages_north, 
                                datTows = catch_north, 
                                strat.df = strata_north, 
                                lgthBins = lbin, 
                                ageBins = abin, 
                                sex = 3,
                                raw = TRUE, #Not standard to set to FALSE (expanded)
                                month = "Month", 
                                fleet = "Fleet",
                                ageErr = "Enter",
                                printfolder = i)
        
      file.rename(file.path(getwd(), "ages_CAAL", i, paste0("Survey_CAAL_Male_Bins_",first(lbin),"_",last(lbin),"_",first(abin),"_", last(abin),".csv")),
                  file.path(getwd(), "ages_CAAL", i, paste0("north_Survey_CAAL_Male_Bins_",first(lbin),"_",last(lbin),"_",first(abin),"_", last(abin),".csv")))
      file.rename(file.path(getwd(), "ages_CAAL", i, paste0("Survey_CAAL_Female_Bins_",first(lbin),"_",last(lbin),"_",first(abin),"_", last(abin),".csv")),
                  file.path(getwd(), "ages_CAAL", i, paste0("north_Survey_CAAL_Female_Bins_",first(lbin),"_",last(lbin),"_",first(abin),"_", last(abin),".csv")))
      
      
      agesCAAL_south = SurveyAgeAtLen.fn(dir = file.path(getwd(), "ages_CAAL"),
                                     datAL = bioages_south, 
                                     datTows = catch_south, 
                                     strat.df = strata_south, 
                                     lgthBins = lbin, 
                                     ageBins = abin, 
                                     sex = 3,
                                     raw = TRUE, #Not standard to set to FALSE (expanded)
                                     month = "Month", 
                                     fleet = "Fleet",
                                     ageErr = "Enter",
                                     printfolder = i)
      
      file.rename(file.path(getwd(), "ages_CAAL", i, paste0("Survey_CAAL_Male_Bins_",first(lbin),"_",last(lbin),"_",first(abin),"_", last(abin),".csv")),
                  file.path(getwd(), "ages_CAAL", i, paste0("south_Survey_CAAL_Male_Bins_",first(lbin),"_",last(lbin),"_",first(abin),"_", last(abin),".csv")))
      file.rename(file.path(getwd(), "ages_CAAL", i, paste0("Survey_CAAL_Female_Bins_",first(lbin),"_",last(lbin),"_",first(abin),"_", last(abin),".csv")),
                  file.path(getwd(), "ages_CAAL", i, paste0("south_Survey_CAAL_Female_Bins_",first(lbin),"_",last(lbin),"_",first(abin),"_", last(abin),".csv")))
      
      print(paste("CAAL Ages for",i,"done")) #For checking purposes
      
    } #end CAAL if statement
    
  } #end survey loop
} 


