#Script to create table of samples sizes of length and age comps by state
#for commercial data. Adopted from table_sampleSize.R
#Functions are not pretty and brute force. Multiple are needed given slightly different
#formats for all of the data. This could be cleaned in future. 

###########################Functions for various data types#################################

#Based off of table3 and 4 from previous (2017) stock assessment

#Function to pull commercial samples sizes by state
#Type is "length" or "age"
table3_commState = function(type){
  
  #Read in nfish
  samps_raw_nfish <- read.csv(file.path(getwd(), "data-raw", 
                                        paste0("pacfin_", type, "_nfish_state_North.csv")),
                              header=T)
  #combine all sex as one because ntows is calculated over all genders
  samps_raw_nfish[samps_raw_nfish$sex %in% c("F","M"),"Sex"] = 0 
  samps_raw_nfish[samps_raw_nfish$sex %in% c("U"),"Sex"] = 0
  
  samps = aggregate(samps_raw_nfish$nfish, 
                    by = list("year" = samps_raw_nfish$yr, 
                              "fleet" = samps_raw_nfish$fleet, 
                              "sex" = samps_raw_nfish$Sex, 
                              "state" = samps_raw_nfish$state), 
                    FUN = sum)
  names(samps)[ncol(samps)] = "Nfish"
  
  samps$fleet_name = samps$fleet
  samps[samps$fleet == "FG","fleet"] = 2
  samps[samps$fleet == "TW","fleet"] = 1
  samps$Fleet = NULL
  samps$Fleet = paste(get_fleet(as.numeric(samps$fleet))$label_short)#, samps$state)
  
  #Read in tows
  ntows <- read.csv(file.path(getwd(), "data-raw", 
                                        paste0("pacfin_", type, "_ntows_state_North.csv")),
                              header=T)

  if(type == "length"){
  out <- merge(samps, ntows, by.x = c("year", "fleet_name", "state"),
               by.y = c("yr", "fleet", "state"))
  }
  if(type == "age"){
    out <- merge(samps, ntows, by.x = c("year", "fleet_name", "state"),
                 by.y = c("fishyr", "fleet", "state"))
    names(out)[ncol(out)] <- "ntows"
  }

  return(out[,c("year","fleet","Fleet", "state", "ntows","Nfish")])
}

#Function to pull commercial discard samples sizes by state
#Only available for lengths
#Only used for "North"
table3_discardState = function(){
  
  samps = read.csv(file.path(getwd(),"data-raw",
                             "Lingcod_OBSVR_Sample_Sizes_By_STATE.csv"),
                   header = T)
  
  #remove south data, which we dont use (because its all california anyway)
  samps <- samps[samps$Fishery == "North",]
  
  samps$fleet <- 2
  samps[samps$Gear == "TRAWL","fleet"] <- 1
  samps$Fleet = paste(get_fleet(as.numeric(samps$fleet))$label_short,"discards")
  
  #rename for consistency with table3_commState output
  samps$year <- samps$Year
  samps$state <- samps$State
  samps$ntows <- samps$N_unique_Hauls
  samps$Nfish <- samps$N_Fish
  
  return(samps[,c("year","fleet","Fleet", "state", "ntows","Nfish")])
}

##################################End of functions##################################

####################
####North length samples
###################

t3_comState <- table3_commState(type = "length")
t3_discardState <-table3_discardState()

aggregate(Nfish~year + fleet + state, t3_comState, FUN=sum)

t3_comState <- rbind(t3_comState,t3_discardState)

#Widen the table to save space
t3_comState_wide <- data.frame(tidyr::pivot_wider(data = t3_comState, names_from = state, values_from = c("ntows","Nfish")))
t3_comState_wide = t3_comState_wide[order(t3_comState_wide$fleet, t3_comState_wide$Fleet, t3_comState_wide$year),c(1,2,3,4,7,6,9,5,8)]
t3_comState_wide[is.na(t3_comState_wide)] <- 0

#Can output csv's to test
#write.csv(t3_comState_wide, file.path(getwd(), "data-raw", "t3_north_comm_length_byState.csv"))

colnames <- c("Year","Fleet","WA Trips","WA Fish","OR Trips","OR Fish","CA Trips","CA Fish")

t = table_format(x = t3_comState_wide[,-which(names(t3_comState_wide) %in% c("fleet"))],
                 caption = 'Sample sizes of commercial and commercial discard length composition 
                 data by fleet and state for the north model combined across sexes.',
                 label = 'sample-size-length-byState',
                 longtable = TRUE,
                 font_size = 9,
                 digits = 2,
                 landscape = FALSE,
                 col_names = colnames,
                 row.names = FALSE,
                 custom_width = TRUE,
                 col_to_adjust = 2,
                 width = '3cm')

kableExtra::save_kable(t, file = file.path(getwd(),"tables","length_samps_comm_byState_North.tex"))


####################
####North age samples
###################

t4_comState <- table3_commState(type = "age")

#Widen the table to save sapce
t4_comState_wide <- data.frame(tidyr::pivot_wider(data = t4_comState, names_from = state, values_from = c("ntows","Nfish")))
t4_comState_wide = t4_comState_wide[order(t4_comState_wide$fleet, t4_comState_wide$year),c(1,2,3,4,7,5,8,6,9)]
t4_comState_wide[is.na(t4_comState_wide)] <- 0

#Can output csv's to test
#write.csv(t4_comState_wide, file.path(getwd(), "data-raw", "t4_north_comm_age_byState.csv"))

colnames <- c("Year","Fleet","CA Trips","CA Fish","OR Trips","OR Fish","WA Trips","WA Fish")

t = table_format(x = t4_comState_wide[,-which(names(t4_comState_wide) %in% c("fleet"))],
                 caption = 'Sample sizes of commercial age composition data by fleet and state for the north model
                 combined across sexes.',
                 label = 'sample-size-age-byState',
                 longtable = TRUE,
                 font_size = 9,
                 digits = 2,
                 landscape = FALSE,
                 col_names = colnames,
                 row.names = FALSE,
                 custom_width = TRUE,
                 col_to_adjust = 2,
                 width = '2cm')

kableExtra::save_kable(t, file = file.path(getwd(),"tables","age_samps_comm_byState_North.tex"))
