#' Expand the length-composition data for a given survey
#'
#' Expand length-composition data, which REQUIRES there to be lengths.
#'
#' @param sname A character value giving the survey name.
#' @param doAgeRep A logical value.
#' @param dir The upper directory where you would like the directories with
#' the results returned from this function to be saved. The default is to
#' use `"data-raw". Survey-specific folders based on `dir` and `sname` will
#' be created.
#'
#' @author Brian J. Langseth
#' @export
#' @return
#' 1. csv files: the unsexed and sexed comps for north and south
#' 2. Figures: sex ratio and size frequency for north and south

survey_lcomps <- function(
  sname,
  doAgeRep = FALSE,
  dir = "data-raw"
){
  
  #Create lengths subfolder in current directory
  stopifnot(file.exists(dir))
  dir.create(file.path(dir, "lenComps"), showWarnings = FALSE)

  for(i in sname){
    
    if(i == "Triennial") ifleet = get_fleet("Tri")$num
    if(i == "WCGBTS") ifleet = get_fleet("WC")$num
    
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
  
    #------------------------------------------Lengths-----------------------------------------#
    
    #Create a survey subfolder in the lengths folder
    dir.create(file.path(dir, "lenComps",i), showWarnings = FALSE)
    
    #Split based on our designation between north and south at 40 degrees 10 minutes
    bio_north = bio[bio$Latitude_dd >= (40 + 10/60),]
    bio_south = bio[bio$Latitude_dd < (40 + 10/60),]
    catch_north = catch[catch$Latitude_dd >= (40 + 10/60),]
    catch_south = catch[catch$Latitude_dd < (40 + 10/60),]
    
    #Calculate the effN
    n_north = GetN.fn(dir = file.path(dir, "lenComps"), dat = bio_north, type = "length", 
                species = "others", printfolder = i)
    
    file.rename(file.path(dir, "lenComps", i, "length_SampleSize.csv"),
                file.path(dir, "lenComps", i, "north_length_SampleSize.csv"))
    
    n_south = GetN.fn(dir = file.path(dir, "lenComps"), dat = bio_south, type = "length", 
                      species = "others", printfolder = i)
    
    file.rename(file.path(dir, "lenComps", i, "length_SampleSize.csv"),
                file.path(dir, "lenComps", i, "south_length_SampleSize.csv"))
    
    #Output expanded lengths based on strata and rename. Plot summaries 
    lengths_north = SurveyLFs.fn(dir = file.path(dir, "lenComps"),
                           datL = bio_north, 
                           datTows = catch_north, 
                           strat.df = strata_north, 
                           lgthBins = info_bins[["length"]], 
                           sex = 3, 
                           month = 7, 
                           fleet = ifleet,
                           nSamps = n_north,
                           printfolder = i,
                           sexRatioUnsexed = 0.5,
                           maxSizeUnsexed = 40) #based on length-weight relationships (male female diverage around here)
    

    file.rename(file.path(dir, "lenComps", i, paste0("Survey_Sex3_Bins_",first(info_bins[["length"]]),"_",last(info_bins[["length"]]),"_LengthComps.csv")),
                file.path(dir, "lenComps", i, paste0("north_Survey_Sex3_Bins_",first(info_bins[["length"]]),"_",last(info_bins[["length"]]),"_LengthComps.csv")))
    #file.rename(file.path(dir, "lenComps", i, paste0("Survey_Sex_Unsexed_Bins_",first(info_bins[["length"]]),"_",last(info_bins[["length"]]),"_LengthComps.csv")),
    #            file.path(dir, "lenComps", i, paste0("north_Survey_Sex_Unsexed_Bins_",first(info_bins[["length"]]),"_",last(info_bins[["length"]]),"_LengthComps.csv")))
    file.remove(file.path(dir, "lenComps", i, paste0("Survey_Sex3_Bins_-999_",last(info_bins[["length"]]),"_LengthComps.csv")))
    #file.remove(file.path(dir, "lenComps", i, paste0("Survey_Sex_Unsexed_Bins_-999_",last(info_bins[["length"]]),"_LengthComps.csv")))
    
   
    PlotFreqData.fn(dir = file.path(dir, "lenComps", i), dat = lengths_north, ylim=c(0, max(info_bins[["length"]]) + 4), inch = 0.10, main = paste( i, "- North "), yaxs="i", ylab="Length (cm)", dopng = TRUE)
    PlotSexRatio.fn(dir = file.path(dir, "lenComps", i), dat = bio_north, data.type = "length", dopng = TRUE, main = paste( i, "- North "))
    
    #Save as .rdas. Have to read in unsexed comps because variable only keeps sex3 comps
    assign(paste0("lenCompN_sex3_",i), lengths_north)
    do.call(usethis::use_data, list(as.name(paste0("lenCompN_sex3_",i)), overwrite = TRUE))
    #assign(paste0("lenCompN_unsex_",i), read.csv(file.path(dir, "lenComps", i, paste0("north_Survey_Sex_Unsexed_Bins_",first(info_bins[["length"]]),"_",last(info_bins[["length"]]),"_LengthComps.csv"))))
    #do.call(usethis::use_data, list(as.name(paste0("lenCompN_unsex_",i)), overwrite = TRUE))
    
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
                                   lgthBins = info_bins[["length"]], 
                                   sex = 3, 
                                   month = "Month", 
                                   fleet = "Fleet",
                                   #nSamps = n_north,
                                   printfolder = i)
      age_representativeness_plot_expand(bio_north, file = paste0(i,"_north_len_agedlen_EXPAND.png"))
      age_representativeness_plot_expand(bio_south, file = paste0(i,"_south_len_agedlen_EXPAND.png"))
    }
      
    
    lengths_south = SurveyLFs.fn(dir = file.path(dir, "lenComps"),
                                 datL = bio_south, 
                                 datTows = catch_south, 
                                 strat.df = strata_south, 
                                 lgthBins = info_bins[["length"]], 
                                 sex = 3, 
                                 month = 7, 
                                 fleet = ifleet,
                                 nSamps = n_south,
                                 printfolder = i,
                                 sexRatioUnsexed = 0.5,
                                 maxSizeUnsexed = 40) #based on length-weight relationships (male female diverage around here)
    
    
    file.rename(file.path(dir, "lenComps", i, paste0("Survey_Sex3_Bins_",first(info_bins[["length"]]),"_",last(info_bins[["length"]]),"_LengthComps.csv")),
                file.path(dir, "lenComps", i, paste0("south_Survey_Sex3_Bins_",first(info_bins[["length"]]),"_",last(info_bins[["length"]]),"_LengthComps.csv")))
    #file.rename(file.path(dir, "lenComps", i, paste0("Survey_Sex_Unsexed_Bins_",first(info_bins[["length"]]),"_",last(info_bins[["length"]]),"_LengthComps.csv")),
    #            file.path(dir, "lenComps", i, paste0("south_Survey_Sex_Unsexed_Bins_",first(info_bins[["length"]]),"_",last(info_bins[["length"]]),"_LengthComps.csv")))
    file.remove(file.path(dir, "lenComps", i, paste0("Survey_Sex3_Bins_-999_",last(info_bins[["length"]]),"_LengthComps.csv")))
    #file.remove(file.path(dir, "lenComps", i, paste0("Survey_Sex_Unsexed_Bins_-999_",last(info_bins[["length"]]),"_LengthComps.csv")))
    
    PlotFreqData.fn(dir = file.path(dir, "lenComps", i), dat = lengths_south, ylim=c(0, max(info_bins[["length"]]) + 4), inch = 0.10, main = paste( i, "- South "), yaxs="i", ylab="Length (cm)", dopng = TRUE)
    PlotSexRatio.fn(dir = file.path(dir, "lenComps", i), dat = bio_south, data.type = "length", dopng = TRUE, main = paste( i, "- South "))
    
    #Save as .rdas. Have to read in unsexed comps because variable only keeps sex3 comps
    assign(paste0("lenCompS_sex3_",i), lengths_south)
    do.call(usethis::use_data, list(as.name(paste0("lenCompS_sex3_",i)), overwrite = TRUE))
    #assign(paste0("lenCompS_unsex_",i), read.csv(file.path(dir, "lenComps", i, paste0("south_Survey_Sex_Unsexed_Bins_",first(info_bins[["length"]]),"_",last(info_bins[["length"]]),"_LengthComps.csv"))))
    #do.call(usethis::use_data, list(as.name(paste0("lenCompS_unsex_",i)), overwrite = TRUE))
    
    print(paste("Lengths for",i,"done"))
    
  } #end survey loop
}
