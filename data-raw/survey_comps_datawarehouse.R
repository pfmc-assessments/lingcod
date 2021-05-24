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
#1. Need to redefine depth strata and latitude strata (right now WCGBTS and Triennial specific). DONE
#2. Need to define length bins (currently set to min/max of each dataset with binsize of 2). DONE
#3. Will need to specify survey timing (month 7), sex (currently 3 and 0), fleet number (triennial = 6, WCGBTS = 7) DONE
#4. For CAAL, nwfscSurvey functions dont do unsexed. Do we ignore unsexed? Yes DONE
#5. For CAAL can do expanded comps, but Im not doing (not standard to do so). Do we want to use expanded CAAL? No DONE


##------------------------------------Scripts----------------------------------------##

#Surveys to use 
#surveys = c("NWFSC.Combo", "Triennial", "AFSC.Slope", "NWFSC.Slope")
surveys = c("WCGBTS", "Triennial") #names of existing data 

#Read in data from the data warehouse using function below
#Saves .rda files for each specified survey
#No longer needed due to new repository structure
#readin_survey_data(surveys)   #########Dont need to do this again unless need new data##########

#Generate length comps using function below
#Saves comps and plots for each specified survey 
survey_lcomps(surveys)


#Generate age comps using function below. Option for CAAL in addition to conditional age comps
#Saves comps and plots for surveys with age data (only WCGBTS and Triennial)
survey_acomps(surveys[1:2], CAAL = TRUE)



##------------------------------------Functions----------------------------------------##

#####################################################################################
#Function to read in the biological and catch data from the data warehouse
#Saves .rda files to the working directory
#No longer needed due to new repository structure
#####################################################################################

# readin_survey_data <- function(sname){
#   
#   for(i in sname){
#     bio <- PullBio.fn(Name = "lingcod", SurveyName = i, SaveFile = TRUE, Dir = getwd())
#     catch <- PullCatch.fn(Name = "lingcod", SurveyName = i, SaveFile = TRUE, Dir = getwd())
#     print(paste("Done reading in bio and catch for", i))
#   }
# }


######################################################################################
#Function to expand the length comps for each survey
#Saves to survey specific subfolder within length folders
#1. the unsexed and sexed comps for north and south
#2. Plots: sex ratio and size frequency for north and south
######################################################################################

survey_lcomps <- function(sname, doAgeRep = FALSE){
  
  #Create lengths subfolder in current directory
  if(!dir.exists(file.path("data", "lenComps"))) dir.create(file.path("data", "lenComps"))

  for(i in sname){
    
    if(i == "Triennial") ifleet = 6
    if(i == "WCGBTS") ifleet = 7
    
    #Read biological data and catch data generated from read_surveys()
    bio = eval(parse(text = paste0("bio.",i)))
    if(i %in% c("Triennial", "AFSC.Slope")) {
      bio = bio[[1]] #Adjust for format differences for some surveys
    }
    catch = eval(parse(text = paste0("catch.",i)))
    
    #Create strata - right now basing off stratification of WCBGT survey at 55, 183, 549, and 1280 depths,
    #but cutting at 400 because that is basically depth limitation of lingcod. 
    #Using Cape Mendocino and pt conception latitudes
    #Depth choices based on page 13 of survey report (https://www.webapps.nwfsc.noaa.gov/assets/25/8655_02272017_093722_TechMemo136.pdf)
    #and coversation with Chantel Wetzel about capping at species depth (issue #21)
    #Previous depth choices were at 55, 183, 400, 1280
    strata_north = CreateStrataDF.fn(names = c("north shallow", "north mid"),
                               depths.shallow = c(55, 183),
                               depths.deep = c(183, 400),
                               lats.south = c(40.166667),
                               lats.north = c(49))

    strata_south = CreateStrataDF.fn(names = c("south Pt C shallow", "Pt C to Cape M shallow", "south Pt C mid", "Pt C to Cape M mid"),
                                     depths.shallow = c(55, 55, 183, 183),
                                     depths.deep = c(183, 183, 400, 400),
                                     lats.south = c(32, 34.5, 32, 34.5),
                                     lats.north = c(34.5, 40.166667, 34.5, 40.166667))
    
    if(i == "Triennial") {
      
      
      
      #For triennial, strata is 55, 350 (because 366 not available), and 500 depths and Cape Mendocino and pt conception latitudes
      #However, Im cutting at 350 because that is basically depth limitation of lingcod.
      #Depth choices based on page 24-25 of survey report (https://www.webapps.nwfsc.noaa.gov/assets/25/8655_02272017_093722_TechMemo136.pdf)
      #and coversation with Chantel Wetzel about capping at species depth (issue #21)
      #Previous depth choices were (I believe) the same as the WCGBTS (55, 183, 400, 1280)
      strata_north = CreateStrataDF.fn(names = NA, #need to NA if have only 1 strata
                                       depths.shallow = c(55), 
                                       depths.deep = c(350), 
                                       lats.south = c(40.166667),
                                       lats.north = c(49))
      
      strata_south = CreateStrataDF.fn(names = c("south Pt C shallow", "Pt C to Cape M shallow"),
                                       depths.shallow = c(55, 55), 
                                       depths.deep = c(350, 350), 
                                       lats.south = c(32, 34.5),
                                       lats.north = c(34.5, 40.166667))
    }
  
    #------------------------------------------Lengths-----------------------------------------#
    
    #Create a survey subfolder in the lengths folder
    dir.create(file.path("data", "lenComps",i))
    
    #Split based on our designation between north and south at 40 degrees 10 minutes
    bio_north = bio[bio$Latitude_dd >= (40 + 10/60),]
    bio_south = bio[bio$Latitude_dd < (40 + 10/60),]
    catch_north = catch[catch$Latitude_dd >= (40 + 10/60),]
    catch_south = catch[catch$Latitude_dd < (40 + 10/60),]
    
    #Calculate the effN
    n_north = GetN.fn(dir = file.path(getwd(), "data", "lenComps"), dat = bio_north, type = "length", 
                species = "others", printfolder = i)
    
    file.rename(file.path(getwd(), "data", "lenComps", i, "length_SampleSize.csv"),
                file.path(getwd(), "data", "lenComps", i, "north_length_SampleSize.csv"))
    
    n_south = GetN.fn(dir = file.path(getwd(), "data", "lenComps"), dat = bio_south, type = "length", 
                      species = "others", printfolder = i)
    
    file.rename(file.path(getwd(), "data", "lenComps", i, "length_SampleSize.csv"),
                file.path(getwd(), "data", "lenComps", i, "south_length_SampleSize.csv"))
    
    
    #Create length bins - RIGHT NOW THE MIN/MAX OF THE FULL DATASET
    lrange = c(10,130)
    lbin = seq(from = lrange[1], to = lrange[2], by = 2)
    
    #Output expanded lengths based on strata and rename. Plot summaries 
    lengths_north = SurveyLFs.fn(dir = file.path(getwd(), "data", "lenComps"),
                           datL = bio_north, 
                           datTows = catch_north, 
                           strat.df = strata_north, 
                           lgthBins = lbin, 
                           sex = 3, 
                           month = 7, 
                           fleet = ifleet,
                           nSamps = n_north,
                           printfolder = i)
    

    file.rename(file.path(getwd(), "data", "lenComps", i, paste0("Survey_Sex3_Bins_",first(lbin),"_",last(lbin),"_LengthComps.csv")),
                file.path(getwd(), "data", "lenComps", i, paste0("north_Survey_Sex3_Bins_",first(lbin),"_",last(lbin),"_LengthComps.csv")))
    file.rename(file.path(getwd(), "data", "lenComps", i, paste0("Survey_Sex_Unsexed_Bins_",first(lbin),"_",last(lbin),"_LengthComps.csv")),
                file.path(getwd(), "data", "lenComps", i, paste0("north_Survey_Sex_Unsexed_Bins_",first(lbin),"_",last(lbin),"_LengthComps.csv")))
    file.remove(file.path(getwd(), "data", "lenComps", i, paste0("Survey_Sex3_Bins_-999_",last(lbin),"_LengthComps.csv")))
    file.remove(file.path(getwd(), "data", "lenComps", i, paste0("Survey_Sex_Unsexed_Bins_-999_",last(lbin),"_LengthComps.csv")))
    
   
    PlotFreqData.fn(dir = file.path(getwd(), "data", "lenComps", i), dat = lengths_north, ylim=c(0, max(lbin) + 4), inch = 0.10, main = paste( i, "- North "), yaxs="i", ylab="Length (cm)", dopng = TRUE)
    PlotSexRatio.fn(dir = file.path(getwd(), "data", "lenComps", i), dat = bio_north, data.type = "length", dopng = TRUE, main = paste( i, "- North "))
    
    #Save as .rdas. Have to read in unsexed comps because variable only keeps sex3 comps
    assign(paste0("lenCompN_sex3_",i), lengths_north)
    do.call(usethis::use_data, list(as.name(paste0("lenCompN_sex3_",i)), overwrite = TRUE))
    assign(paste0("lenCompN_unsex_",i), read.csv(file.path(getwd(), "data", "lenComps", i, paste0("north_Survey_Sex_Unsexed_Bins_",first(lbin),"_",last(lbin),"_LengthComps.csv"))))
    do.call(usethis::use_data, list(as.name(paste0("lenCompN_unsex_",i)), overwrite = TRUE))
    
    if(doAgeRep) {
      #Non expanded
      age_representativeness_plot(bio_north, file = paste0(i,"_north_len_agedlen.png"))
      age_representativeness_plot(bio_south, file = paste0(i,"_south_len_agedlen.png"))
      
      #Expanded - reducing lengths to those in tows with ages, reducing catches to those of tows with aged fish
      #Unsure whether to: 
      #1) keep all lengths from tows with ages or just lengths from aged fish
      #2) keep all catches
      tows_with_ages = bio_north[!is.na(bio_north$Age),]
      aged_bio_north = bio_north[bio_north$Trawl_id %in% tows_with_ages$Trawl_id,]
      aged_catch_north = catch_north[catch_north$Trawl_id %in% aged_bio_north$Trawl_id,]
      aged_lengths_north = SurveyLFs.fn(dir = NULL,
                                   datL = aged_bio_north, 
                                   datTows = aged_catch_north, 
                                   strat.df = strata_north, 
                                   lgthBins = lbin, 
                                   sex = 3, 
                                   month = "Month", 
                                   fleet = "Fleet",
                                   #nSamps = n_north,
                                   printfolder = i)
      age_representativeness_plot_expand(bio_north, file = paste0(i,"_north_len_agedlen_EXPAND.png"))
      age_representativeness_plot_expand(bio_south, file = paste0(i,"_south_len_agedlen_EXPAND.png"))
    }
      
    
    lengths_south = SurveyLFs.fn(dir = file.path(getwd(), "data", "lenComps"),
                                 datL = bio_south, 
                                 datTows = catch_south, 
                                 strat.df = strata_south, 
                                 lgthBins = lbin, 
                                 sex = 3, 
                                 month = 7, 
                                 fleet = ifleet,
                                 nSamps = n_south,
                                 printfolder = i)
    
    file.rename(file.path(getwd(), "data", "lenComps", i, paste0("Survey_Sex3_Bins_",first(lbin),"_",last(lbin),"_LengthComps.csv")),
                file.path(getwd(), "data", "lenComps", i, paste0("south_Survey_Sex3_Bins_",first(lbin),"_",last(lbin),"_LengthComps.csv")))
    file.rename(file.path(getwd(), "data", "lenComps", i, paste0("Survey_Sex_Unsexed_Bins_",first(lbin),"_",last(lbin),"_LengthComps.csv")),
                file.path(getwd(), "data", "lenComps", i, paste0("south_Survey_Sex_Unsexed_Bins_",first(lbin),"_",last(lbin),"_LengthComps.csv")))
    file.remove(file.path(getwd(), "data", "lenComps", i, paste0("Survey_Sex3_Bins_-999_",last(lbin),"_LengthComps.csv")))
    file.remove(file.path(getwd(), "data", "lenComps", i, paste0("Survey_Sex_Unsexed_Bins_-999_",last(lbin),"_LengthComps.csv")))
    
    PlotFreqData.fn(dir = file.path(getwd(), "data", "lenComps", i), dat = lengths_south, ylim=c(0, max(lbin) + 4), inch = 0.10, main = paste( i, "- South "), yaxs="i", ylab="Length (cm)", dopng = TRUE)
    PlotSexRatio.fn(dir = file.path(getwd(), "data", "lenComps", i), dat = bio_south, data.type = "length", dopng = TRUE, main = paste( i, "- South "))
    
    #Save as .rdas. Have to read in unsexed comps because variable only keeps sex3 comps
    assign(paste0("lenCompS_sex3_",i), lengths_south)
    do.call(usethis::use_data, list(as.name(paste0("lenCompS_sex3_",i)), overwrite = TRUE))
    assign(paste0("lenCompS_unsex_",i), read.csv(file.path(getwd(), "data", "lenComps", i, paste0("south_Survey_Sex_Unsexed_Bins_",first(lbin),"_",last(lbin),"_LengthComps.csv"))))
    do.call(usethis::use_data, list(as.name(paste0("lenCompS_unsex_",i)), overwrite = TRUE))
    
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
  if(!dir.exists(file.path("data", "ageComps"))) dir.create(file.path("data", "ageComps"))
  if(!dir.exists(file.path("data", "ageCAAL")) & CAAL) dir.create(file.path("data", "ageCAAL"))
  
  for(i in sname){
    
    if(i == "Triennial") ifleet = 6
    if(i == "WCGBTS") ifleet = 7
    
    #Read biological data and catch data generated from read_surveys()
    bio_ages = eval(parse(text = paste0("bio.",i)))
    if(i %in% c("Triennial", "AFSC.Slope")) {
      bio_ages = bio_ages[[2]] #Adjust for format differences for some surveys
    }
    catch = eval(parse(text = paste0("catch.",i)))
    
    #Create strata - right now basing off stratification of WCBGT survey at 55, 183, 549, and 1280 depths,
    #but cutting at 400 because that is basically depth limitation of lingcod. 
    #Using Cape Mendocino and pt conception latitudes
    #Depth choices based on page 13 of survey report (https://www.webapps.nwfsc.noaa.gov/assets/25/8655_02272017_093722_TechMemo136.pdf)
    #and coversation with Chantel Wetzel about capping at species depth (issue #21)
    #Previous depth choices were at 55, 183, 400, 1280
    strata_north = CreateStrataDF.fn(names = c("north shallow", "north mid"),
                                     depths.shallow = c(55, 183),
                                     depths.deep = c(183, 400),
                                     lats.south = c(40.166667),
                                     lats.north = c(49))
    
    strata_south = CreateStrataDF.fn(names = c("south Pt C shallow", "Pt C to Cape M shallow", "south Pt C mid", "Pt C to Cape M mid"),
                                     depths.shallow = c(55, 55, 183, 183),
                                     depths.deep = c(183, 183, 400, 400),
                                     lats.south = c(32, 34.5, 32, 34.5),
                                     lats.north = c(34.5, 40.166667, 34.5, 40.166667))
    
    if(i == "Triennial") {
      #For triennial, strata is 55, 350 (because 366 not available), and 500 depths and Cape Mendocino and pt conception latitudes
      #However, Im cutting at 350 because that is basically depth limitation of lingcod.
      #Depth choices based on page 24-25 of survey report (https://www.webapps.nwfsc.noaa.gov/assets/25/8655_02272017_093722_TechMemo136.pdf)
      #and coversation with Chantel Wetzel about capping at species depth (issue #21)
      #Previous depth choices were (I believe) the same as the WCGBTS (55, 183, 400, 1280)
      strata_north = CreateStrataDF.fn(names = NA, #need to NA if have only 1 strata
                                       depths.shallow = c(55), 
                                       depths.deep = c(350), 
                                       lats.south = c(40.166667),
                                       lats.north = c(49))
      
      strata_south = CreateStrataDF.fn(names = c("south Pt C shallow", "Pt C to Cape M shallow"),
                                       depths.shallow = c(55, 55), 
                                       depths.deep = c(350, 350), 
                                       lats.south = c(32, 34.5),
                                       lats.north = c(34.5, 40.166667))
    }
    
    
    #------------------------------------------Ages-----------------------------------------#
      
    #Create a survey subfolder in the ages folder
    dir.create(file.path("data", "ageComps", i))
    
    bioages_north = bio_ages[bio_ages$Latitude_dd >= (40 + 10/60),]
    bioages_south = bio_ages[bio_ages$Latitude_dd < (40 + 10/60),]
    catch_north = catch[catch$Latitude_dd >= (40 + 10/60),]
    catch_south = catch[catch$Latitude_dd < (40 + 10/60),]
    
    ############################
    #Marginals
    ############################
    
    #Calculate the effN
    n_north_age = GetN.fn(dir = file.path(getwd(),"data", "ageComps"), dat = bioages_north, type = "age", 
                          species = "others", printfolder = i)
    
    file.rename(file.path(getwd(), "data", "ageComps", i, "age_SampleSize.csv"),
                file.path(getwd(), "data", "ageComps", i, "north_age_SampleSize.csv"))
    
    n_south_age = GetN.fn(dir = file.path(getwd(), "data", "ageComps"), dat = bioages_south, type = "age", 
                          species = "others", printfolder = i)
    
    file.rename(file.path(getwd(), "data", "ageComps", i, "age_SampleSize.csv"),
                file.path(getwd(), "data", "ageComps", i, "south_age_SampleSize.csv"))
    
    
    #Create age bins - RIGHT NOW THE MIN/MAX OF THE FULL DATASET
    arange = c(0,20)
    abin = seq(from = arange[1], to = arange[2], by = 1)
    
    
    #Output expanded ages based on strata and rename. Plot summaries 
    ages_north = SurveyAFs.fn(dir = file.path(getwd(), "data", "ageComps"),
                              datA = bioages_north, 
                              datTows = catch_north, 
                              strat.df = strata_north, 
                              ageBins = abin, 
                              sex = 3, 
                              month = 7, 
                              fleet = ifleet,
                              agelow = -1,
                              agehigh = -1,
                              ageErr = 1,
                              nSamps = n_north_age,
                              printfolder = i)
    
    file.rename(file.path(getwd(), "data", "ageComps", i, paste0("Survey_Sex3_Bins_",first(abin),"_",last(abin),"_AgeComps.csv")),
                file.path(getwd(), "data", "ageComps", i, paste0("north_Survey_Sex3_Bins_",first(abin),"_",last(abin),"_AgeComps.csv")))
    file.rename(file.path(getwd(), "data", "ageComps", i, paste0("Survey_Sex_Unsexed_Bins_",first(abin),"_",last(abin),"_AgeComps.csv")),
                file.path(getwd(), "data", "ageComps", i, paste0("north_Survey_Sex_Unsexed_Bins_",first(abin),"_",last(abin),"_AgeComps.csv")))
    file.remove(file.path(getwd(), "data", "ageComps", i, paste0("Survey_Sex3_Bins_-999_",last(abin),"_AgeComps.csv")))
    file.remove(file.path(getwd(), "data", "ageComps", i, paste0("Survey_Sex_Unsexed_Bins_-999_",last(abin),"_AgeComps.csv")))
    
    PlotFreqData.fn(dir = file.path(getwd(), "data", "ageComps", i), dat = ages_north, ylim=c(0, max(abin) + 1), inch = 0.10, main = paste( i, "- North "), yaxs="i", ylab="Age", dopng = TRUE)
    PlotSexRatio.fn(dir = file.path(getwd(), "data", "ageComps", i), dat = bioages_north, data.type = "age", dopng = TRUE, main = paste( i, "- North "))
    
    #Save as .rdas. Have to read in unsexed comps because variable only keeps sex3 comps
    assign(paste0("ageCompN_sex3_",i), ages_north)
    do.call(usethis::use_data, list(as.name(paste0("ageCompN_sex3_",i)), overwrite = TRUE))
    assign(paste0("ageCompN_unsex_",i), read.csv(file.path(getwd(), "data", "ageComps", i, paste0("north_Survey_Sex_Unsexed_Bins_",first(abin),"_",last(abin),"_AgeComps.csv"))))
    do.call(usethis::use_data, list(as.name(paste0("ageCompN_unsex_",i)), overwrite = TRUE))
    
    ages_south = SurveyAFs.fn(dir = file.path(getwd(), "data", "ageComps"),
                              datA = bioages_south, 
                              datTows = catch_south, 
                              strat.df = strata_south, 
                              ageBins = abin, 
                              sex = 3, 
                              month = 7, 
                              fleet = ifleet,
                              agelow = -1,
                              agehigh = -1,
                              ageErr = 1,
                              nSamps = n_south_age,
                              printfolder = i)
    
    file.rename(file.path(getwd(), "data", "ageComps", i, paste0("Survey_Sex3_Bins_",first(abin),"_",last(abin),"_AgeComps.csv")),
                file.path(getwd(), "data", "ageComps", i, paste0("south_Survey_Sex3_Bins_",first(abin),"_",last(abin),"_AgeComps.csv")))
    file.rename(file.path(getwd(), "data", "ageComps", i, paste0("Survey_Sex_Unsexed_Bins_",first(abin),"_",last(abin),"_AgeComps.csv")),
                file.path(getwd(), "data", "ageComps", i, paste0("south_Survey_Sex_Unsexed_Bins_",first(abin),"_",last(abin),"_AgeComps.csv")))
    file.remove(file.path(getwd(), "data", "ageComps", i, paste0("Survey_Sex3_Bins_-999_",last(abin),"_AgeComps.csv")))
    file.remove(file.path(getwd(), "data", "ageComps", i, paste0("Survey_Sex_Unsexed_Bins_-999_",last(abin),"_AgeComps.csv")))
    
    PlotFreqData.fn(dir = file.path(getwd(), "data", "ageComps", i), dat = ages_south, ylim=c(0, max(abin) + 1), inch = 0.10, main = paste( i, "- South "), yaxs="i", ylab="Age", dopng = TRUE)
    PlotSexRatio.fn(dir = file.path(getwd(), "data", "ageComps", i), dat = bioages_south, data.type = "age", dopng = TRUE, main = paste( i, "- South "))
    
    #Save as .rdas. Have to read in unsexed comps because variable only keeps sex3 comps
    assign(paste0("ageCompS_sex3_",i), ages_south)
    do.call(usethis::use_data, list(as.name(paste0("ageCompS_sex3_",i)), overwrite = TRUE))
    assign(paste0("ageCompS_unsex_",i), read.csv(file.path(getwd(), "data", "ageComps", i, paste0("south_Survey_Sex_Unsexed_Bins_",first(abin),"_",last(abin),"_AgeComps.csv"))))
    do.call(usethis::use_data, list(as.name(paste0("ageCompS_unsex_",i)), overwrite = TRUE))
    
    print(paste("Ages for",i,"done")) #For checking purposes
    
    
    ############################
    #Conditional age at length
    ############################
    
    if(CAAL){
      
      #For surveys with separated length and age datasets (e.g. Triennial), using just the age dataset
      
      #Create a survey subfolder in the ages_CAAL folder
      dir.create(file.path("data", "ageCAAL",i))
      
      #Create length bins - RIGHT NOW THE MIN/MAX OF THE USED DATASET
      lrange = c(10,130)
      lbin = seq(from = lrange[1], to = lrange[2], by = 2)
      
      #Output conditional length at age comps 
      agesCAAL_north = SurveyAgeAtLen.fn(dir = file.path(getwd(), "data", "ageCAAL"),
                                datAL = bioages_north, 
                                datTows = catch_north, 
                                strat.df = strata_north, 
                                lgthBins = lbin, 
                                ageBins = abin, 
                                sex = 3,
                                raw = TRUE, #Not standard to set to FALSE (expanded)
                                month = 7, 
                                fleet = ifleet,
                                ageErr = 1,
                                printfolder = i)
        
      file.rename(file.path(getwd(), "data", "ageCAAL", i, paste0("Survey_CAAL_Male_Bins_",first(lbin),"_",last(lbin),"_",first(abin),"_", last(abin),".csv")),
                  file.path(getwd(), "data", "ageCAAL", i, paste0("north_Survey_CAAL_Male_Bins_",first(lbin),"_",last(lbin),"_",first(abin),"_", last(abin),".csv")))
      file.rename(file.path(getwd(), "data", "ageCAAL", i, paste0("Survey_CAAL_Female_Bins_",first(lbin),"_",last(lbin),"_",first(abin),"_", last(abin),".csv")),
                  file.path(getwd(), "data", "ageCAAL", i, paste0("north_Survey_CAAL_Female_Bins_",first(lbin),"_",last(lbin),"_",first(abin),"_", last(abin),".csv")))
      
      #Save as .rdas. Combined for female (first element) and male (second element)
      assign(paste0("ageCAAL_N_",i), agesCAAL_north)
      do.call(usethis::use_data, list(as.name(paste0("ageCAAL_N_",i)), overwrite = TRUE))
      
      agesCAAL_south = SurveyAgeAtLen.fn(dir = file.path(getwd(), "data", "ageCAAL"),
                                     datAL = bioages_south, 
                                     datTows = catch_south, 
                                     strat.df = strata_south, 
                                     lgthBins = lbin, 
                                     ageBins = abin, 
                                     sex = 3,
                                     raw = TRUE, #Not standard to set to FALSE (expanded)
                                     month = 7, 
                                     fleet = ifleet,
                                     ageErr = 1,
                                     printfolder = i)
      
      file.rename(file.path(getwd(), "data", "ageCAAL", i, paste0("Survey_CAAL_Male_Bins_",first(lbin),"_",last(lbin),"_",first(abin),"_", last(abin),".csv")),
                  file.path(getwd(), "data", "ageCAAL", i, paste0("south_Survey_CAAL_Male_Bins_",first(lbin),"_",last(lbin),"_",first(abin),"_", last(abin),".csv")))
      file.rename(file.path(getwd(), "data", "ageCAAL", i, paste0("Survey_CAAL_Female_Bins_",first(lbin),"_",last(lbin),"_",first(abin),"_", last(abin),".csv")),
                  file.path(getwd(), "data", "ageCAAL", i, paste0("south_Survey_CAAL_Female_Bins_",first(lbin),"_",last(lbin),"_",first(abin),"_", last(abin),".csv")))
      
      #Save as .rdas. Combined for female (first element) and male (second element)
      assign(paste0("ageCAAL_S_",i), agesCAAL_south)
      do.call(usethis::use_data, list(as.name(paste0("ageCAAL_S_",i)), overwrite = TRUE))
      
      print(paste("CAAL Ages for",i,"done")) #For checking purposes
      
    } #end CAAL if statement
    
  } #end survey loop
} 


