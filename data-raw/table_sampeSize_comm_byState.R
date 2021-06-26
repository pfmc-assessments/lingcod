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
  samps$Fleet = paste(get_fleet(as.numeric(samps$fleet))$label_short, samps$state)
  
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

  return(out[,c("year","fleet","Fleet","ntows","Nfish")])
}

##################################End of functions##################################

####################
####North length samples
###################

t3_comState <- table3_commState(type = "length")

t3_comState = t3_comState[order(t3_comState$fleet, t3_comState$Fleet, t3_comState$year),]

#Can output csv's to test
#write.csv(t3_comState, file.path(getwd(), "data-raw", "t3_north_comm_length_byState.csv"))

aggregate(Nfish~year + fleet, t3_comState, FUN=sum)

colnames <- c("Year","Fleet","Ntows","Nfish")

t = table_format(x = t3_comState[,-which(names(t3_comState) %in% c("fleet"))],
                 caption = 'Sample sizes of commercial length composition data by state for the north model
                 combined across sexes.',
                 label = 'sample-size-length-byState',
                 longtable = TRUE,
                 font_size = 9,
                 digits = 2,
                 landscape = FALSE,
                 col_names = colnames,
                 row.names = FALSE)

kableExtra::save_kable(t, file = file.path(getwd(),"tables","length_samps_comm_byState_North.tex"))


####################
####North age samples
###################

t4_comState <- table3_commState(type = "age")

t4_comState = t4_comState[order(t4_comState$fleet, t4_comState$Fleet, t4_comState$year),]

#Can output csv's to test
#write.csv(t4_comState, file.path(getwd(), "data-raw", "t4_north_comm_age_byState.csv"))

colnames <- c("Year","Fleet","Ntows","Nfish")

t = table_format(x = t4_comState[,-which(names(t4_comState) %in% c("fleet"))],
                 caption = 'Sample sizes of commercial age composition data by state for the north model
                 combined across sexes.',
                 label = 'sample-size-age-byState',
                 longtable = TRUE,
                 font_size = 9,
                 digits = 2,
                 landscape = FALSE,
                 col_names = colnames,
                 row.names = FALSE)

kableExtra::save_kable(t, file = file.path(getwd(),"tables","age_samps_comm_byState_North.tex"))
