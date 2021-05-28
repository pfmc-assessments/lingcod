#' Expand the age-composition data for a given survey
#'
#' Expand age-composition data, which REQUIRES there to be ages.
#' Default is marginal compositions but can do CAAL.
#'
#' @param sname A character value giving the survey name.
#' @param CAAL A logical if conditional-age-at-length compositions should
#' be returned. The default is to return marginal age compositions instead.
#' @param dir The upper directory where you would like the directories with
#' the results returned from this function to be saved. The default is to
#' use `"data-raw". Survey-specific folders based on `dir` and `sname` will
#' be created.
#'
#' @author Brian J. Langseth
#' @export
#' @return
#' *   Ages
#'       1. csv files: unsexed and sexed comps for north and south
#'       2. Figures: sex ratio and size frequency for north and south
#' *   Ages CAAL
#'       1. csv files: sex-specific comps for north and south
#'       2. Figures: NA
#'
survey_acomps <- function(
  sname,
  CAAL = FALSE,
  dir = "data-raw"
) {

  #Create age subfolders in current directory
  stopifnot(file.exists(dir))
  dir.create(file.path(dir, "ageComps"), showWarnings = FALSE)
  dir.create(file.path(dir, "ageCAAL"), showWarnings = FALSE)
  
  for(i in sname){
    
    if(i == "Triennial") ifleet = 6
    if(i == "WCGBTS") ifleet = 7
    
    #Read biological data and catch data generated from read_surveys()
    bio_ages = eval(parse(text = paste0("bio.",i)))
    if ("Ages" %in% names(bio_ages)) {
      bio_ages = bio_ages[["Ages"]] #Adjust for format differences for some surveys
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
      #Previous depth choices were (55, 183, 450)
      strata_north = CreateStrataDF.fn(names = c("north shallow", "north mid"), #need to NA if have only 1 strata
                                       depths.shallow = c(55, 183), 
                                       depths.deep = c(183, 350), 
                                       lats.south = c(40.166667),
                                       lats.north = c(49))
      
      strata_south = CreateStrataDF.fn(names = c("south Pt C shallow", "Pt C to Cape M shallow", "south Pt C mid", "Pt C to Cape M mid"),
                                       depths.shallow = c(55, 55, 183, 183), 
                                       depths.deep = c(183, 183, 350, 350), 
                                       lats.south = c(32, 34.5, 32, 34.5),
                                       lats.north = c(34.5, 40.166667, 34.5, 40.166667))
    }
    
    
    #------------------------------------------Ages-----------------------------------------#
      
    #Create a survey subfolder in the ages folder
    dir.create(file.path(dir, "ageComps", i), showWarnings = FALSE)
    
    bioages_north = bio_ages[bio_ages$Latitude_dd >= (40 + 10/60),]
    bioages_south = bio_ages[bio_ages$Latitude_dd < (40 + 10/60),]
    catch_north = catch[catch$Latitude_dd >= (40 + 10/60),]
    catch_south = catch[catch$Latitude_dd < (40 + 10/60),]
    
    ############################
    #Marginals
    ############################
    
    #Calculate the effN
    n_north_age = GetN.fn(dir = file.path(dir, "ageComps"), dat = bioages_north, type = "age", 
                          species = "others", printfolder = i)
    
    file.rename(file.path(dir, "ageComps", i, "age_SampleSize.csv"),
                file.path(dir, "ageComps", i, "north_age_SampleSize.csv"))
    
    n_south_age = GetN.fn(dir = file.path(dir, "ageComps"), dat = bioages_south, type = "age", 
                          species = "others", printfolder = i)
    
    file.rename(file.path(dir, "ageComps", i, "age_SampleSize.csv"),
                file.path(dir, "ageComps", i, "south_age_SampleSize.csv"))
    
    #Create age bins - RIGHT NOW THE MIN/MAX OF THE FULL DATASET
    arange = c(0,20)
    abin = seq(from = arange[1], to = arange[2], by = 1)
    
    
    #Output expanded ages based on strata and rename. Plot summaries 
    ages_north = SurveyAFs.fn(dir = file.path(dir, "ageComps"),
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
                              printfolder = i,
                              sexRatioUnsexed = 0.5,
                              maxSizeUnsexed = 2) #based on length-age relationship for combo and combined (male female diverage around here)
    
    
    file.rename(file.path(dir, "ageComps", i, paste0("Survey_Sex3_Bins_",first(abin),"_",last(abin),"_AgeComps.csv")),
                file.path(dir, "ageComps", i, paste0("north_Survey_Sex3_Bins_",first(abin),"_",last(abin),"_AgeComps.csv")))
    #file.rename(file.path(dir, "ageComps", i, paste0("Survey_Sex_Unsexed_Bins_",first(abin),"_",last(abin),"_AgeComps.csv")),
    #            file.path(dir, "ageComps", i, paste0("north_Survey_Sex_Unsexed_Bins_",first(abin),"_",last(abin),"_AgeComps.csv")))
    file.remove(file.path(dir, "ageComps", i, paste0("Survey_Sex3_Bins_-999_",last(abin),"_AgeComps.csv")))
    #file.remove(file.path(dir, "ageComps", i, paste0("Survey_Sex_Unsexed_Bins_-999_",last(abin),"_AgeComps.csv")))
    
    PlotFreqData.fn(dir = file.path(dir, "ageComps", i), dat = ages_north, ylim=c(0, max(abin) + 1), inch = 0.10, main = paste( i, "- North "), yaxs="i", ylab="Age", dopng = TRUE)
    PlotSexRatio.fn(dir = file.path(dir, "ageComps", i), dat = bioages_north, data.type = "age", dopng = TRUE, main = paste( i, "- North "))
    
    #Save as .rdas. Have to read in unsexed comps because variable only keeps sex3 comps
    assign(paste0("ageCompN_sex3_",i), ages_north)
    do.call(usethis::use_data, list(as.name(paste0("ageCompN_sex3_",i)), overwrite = TRUE))
    #assign(paste0("ageCompN_unsex_",i), read.csv(file.path(dir, "ageComps", i, paste0("north_Survey_Sex_Unsexed_Bins_",first(abin),"_",last(abin),"_AgeComps.csv"))))
    #do.call(usethis::use_data, list(as.name(paste0("ageCompN_unsex_",i)), overwrite = TRUE))
    
    ages_south = SurveyAFs.fn(dir = file.path(dir, "ageComps"),
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
                              printfolder = i,
                              sexRatioUnsexed = 0.5,
                              maxSizeUnsexed = 1) #based on length-age relationship for combo and combined (male female diverage around here)
    
    
    file.rename(file.path(dir, "ageComps", i, paste0("Survey_Sex3_Bins_",first(abin),"_",last(abin),"_AgeComps.csv")),
                file.path(dir, "ageComps", i, paste0("south_Survey_Sex3_Bins_",first(abin),"_",last(abin),"_AgeComps.csv")))
    #file.rename(file.path(dir, "ageComps", i, paste0("Survey_Sex_Unsexed_Bins_",first(abin),"_",last(abin),"_AgeComps.csv")),
    #            file.path(dir, "ageComps", i, paste0("south_Survey_Sex_Unsexed_Bins_",first(abin),"_",last(abin),"_AgeComps.csv")))
    file.remove(file.path(dir, "ageComps", i, paste0("Survey_Sex3_Bins_-999_",last(abin),"_AgeComps.csv")))
    #file.remove(file.path(dir, "ageComps", i, paste0("Survey_Sex_Unsexed_Bins_-999_",last(abin),"_AgeComps.csv")))
    
    PlotFreqData.fn(dir = file.path(dir, "ageComps", i), dat = ages_south, ylim=c(0, max(abin) + 1), inch = 0.10, main = paste( i, "- South "), yaxs="i", ylab="Age", dopng = TRUE)
    PlotSexRatio.fn(dir = file.path(dir, "ageComps", i), dat = bioages_south, data.type = "age", dopng = TRUE, main = paste( i, "- South "))
    
    #Save as .rdas. Have to read in unsexed comps because variable only keeps sex3 comps
    assign(paste0("ageCompS_sex3_",i), ages_south)
    do.call(usethis::use_data, list(as.name(paste0("ageCompS_sex3_",i)), overwrite = TRUE))
    #assign(paste0("ageCompS_unsex_",i), read.csv(file.path(dir, "ageComps", i, paste0("south_Survey_Sex_Unsexed_Bins_",first(abin),"_",last(abin),"_AgeComps.csv"))))
    #do.call(usethis::use_data, list(as.name(paste0("ageCompS_unsex_",i)), overwrite = TRUE))
    
    print(paste("Ages for",i,"done")) #For checking purposes
    
    
    ############################
    #Conditional age at length
    ############################
    
    if(CAAL){
      
      #For surveys with separated length and age datasets (e.g. Triennial), using just the age dataset
      
      #Create a survey subfolder in the ages_CAAL folder
      dir.create(file.path("data", "ageCAAL",i), showWarnings = FALSE)
      
      #Create length bins - RIGHT NOW THE MIN/MAX OF THE USED DATASET
      lrange = c(10,130)
      lbin = seq(from = lrange[1], to = lrange[2], by = 2)
      
      #Output conditional length at age comps 
      agesCAAL_north = SurveyAgeAtLen.fn(dir = file.path(dir, "ageCAAL"),
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
        
      file.rename(file.path(dir, "ageCAAL", i, paste0("Survey_CAAL_Male_Bins_",first(lbin),"_",last(lbin),"_",first(abin),"_", last(abin),".csv")),
                  file.path(dir, "ageCAAL", i, paste0("north_Survey_CAAL_Male_Bins_",first(lbin),"_",last(lbin),"_",first(abin),"_", last(abin),".csv")))
      file.rename(file.path(dir, "ageCAAL", i, paste0("Survey_CAAL_Female_Bins_",first(lbin),"_",last(lbin),"_",first(abin),"_", last(abin),".csv")),
                  file.path(dir, "ageCAAL", i, paste0("north_Survey_CAAL_Female_Bins_",first(lbin),"_",last(lbin),"_",first(abin),"_", last(abin),".csv")))
      
      #Save as .rdas. Combined for female (first element) and male (second element)
      assign(paste0("ageCAAL_N_",i), agesCAAL_north)
      do.call(usethis::use_data, list(as.name(paste0("ageCAAL_N_",i)), overwrite = TRUE))
      
      agesCAAL_south = SurveyAgeAtLen.fn(dir = file.path(dir, "ageCAAL"),
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
      
      file.rename(file.path(dir, "ageCAAL", i, paste0("Survey_CAAL_Male_Bins_",first(lbin),"_",last(lbin),"_",first(abin),"_", last(abin),".csv")),
                  file.path(dir, "ageCAAL", i, paste0("south_Survey_CAAL_Male_Bins_",first(lbin),"_",last(lbin),"_",first(abin),"_", last(abin),".csv")))
      file.rename(file.path(dir, "ageCAAL", i, paste0("Survey_CAAL_Female_Bins_",first(lbin),"_",last(lbin),"_",first(abin),"_", last(abin),".csv")),
                  file.path(dir, "ageCAAL", i, paste0("south_Survey_CAAL_Female_Bins_",first(lbin),"_",last(lbin),"_",first(abin),"_", last(abin),".csv")))
      
      #Save as .rdas. Combined for female (first element) and male (second element)
      assign(paste0("ageCAAL_S_",i), agesCAAL_south)
      do.call(usethis::use_data, list(as.name(paste0("ageCAAL_S_",i)), overwrite = TRUE))
      
      print(paste("CAAL Ages for",i,"done")) #For checking purposes
      
    } #end CAAL if statement
    
  } #end survey loop
} 
