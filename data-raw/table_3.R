#Script to create tables 3 and 4 (table of samples sizes of length comps) from model output
#Functions are not pretty and brute force. Multiple are needed given slightly different
#formats for all of the data. This could be cleaned in future. 

###########################Functions for various data types#################################


table3_noexp = function(comp){
  
  #Non-expanded comps. With sexed, and unsexed if available 

  #Sex = 3 comps first
  sex <- comp$comps[,c("year","fleet", "sex")]
  
  male_cols <- grep("M", names(comp$comps))
  female_cols <- grep("F", names(comp$comps))
  
  sex$Nmale <- rowSums(comp$comps[,male_cols])
  sex$Nfemale <- rowSums(comp$comps[,female_cols])
  sex$Nfish <- comp$comps$Nsamp
  sex$Nsamp <- ""
  sex$Gender <- "Sexed"
  sex$Units <- "Nfish"
  sex$Ntows <- ""
  sex$Fleet <- get_fleet(sex$fleet)$label_short
  
  unsex = NULL
  
  if(any(names(comp) %in% "comps_u")){
    #Sex = 0 comps next 
    unsex <- comp$comps_u[,c("year","fleet", "sex")]
    
    unsex$Gender <- "Unsexed"
    unsex$Units <- "Nfish"
    unsex$Ntows <- ""
    unsex$Nmale <- ""
    unsex$Nfemale <- ""
    unsex$Nfish <- comp$comps_u$Nsamp
    unsex$Nsamp <- ""
    unsex$Fleet <- get_fleet(unsex$fleet)$label_short
  }

  return(rbind(sex,unsex))
}

#Function for getting debWV comps into desired format
table3_deb = function(comp){
  
  #Non-expanded comps but comps reflects unsexed fish
  
  #Sex = 0 only
  unsex <- comp$comps[,c("year","fleet", "sex")]
  
  unsex$Gender <- "Unsexed"
  unsex$Units <- "Nfish"
  unsex$Ntows <- ""
  unsex$Nmale <- ""
  unsex$Nfemale <- ""
  unsex$Nfish <- comp$comps$Nsamp
  unsex$Nsamp <- ""
  unsex$Fleet <- get_fleet(unsex$fleet)$label_short
  
  return(unsex)
}


table3_exp = function(comp, region, type){
  
  #Region must be either "north" or "south" to obtain sample sizes
  #Type must be either "length" or "age" to obtain sample sizes
  
  if(type == "length") abbr_type = "len"
  if(type == "age") abbr_type = type
  
  #Expanded comps. Comps with sexed fish.

  sex <- comp[,c("year","fleet", "sex", "Nsamp")]
  
  sex$Nmale <- ""
  sex$Nfemale <- ""
  sex$Gender <- "Sexed"
  sex$Units <- "Nsamp"

  sex$Fleet <- get_fleet(sex$fleet)$label_short
  
  samps = read.csv(
    file.path(getwd(),"data-raw",paste0(abbr_type,"Comps"),sex$Fleet[1],paste0(region,"_",type,"_SampleSize.csv")),
    header = TRUE)
  
  sex$Nfish <- samps$All_Fish 
  sex$Ntows <- samps$Tows
  

  return(sex)
}

table3_exp_discard = function(comp, region){
  
  #Expanded comps from comm discards. Sex = 0 so only unsexed
  
  #Region must be either "north" or "south" to obtain sample sizes
  
  
  samps = read.csv(file.path(getwd(),"data-raw",
            "Mendocino_Lincod_2021_WCGOP_Comps_LF_Sample_Sizes.csv"),
            header = T)
  samps$fleet <- 2
  samps[samps$Gear == "TRAWL","fleet"] <- 1
  nhauls = samps[tolower(samps$State) == tolower(region),]


  unsex <- comp[,c("year","fleet", "sex")]
  
  unsex$Gender <- "Unsexed"
  unsex$Units <- "Ntows"
  unsex$Ntows <- comp$nsamp
  unsex$Nmale <- ""
  unsex$Nfemale <- ""
  unsex$Nfish <- nhauls[order(nhauls$fleet,nhauls$Year),"N_Fish"]
  unsex$Nsamp <- ""
  unsex$Fleet <- paste(get_fleet(unsex$fleet)$label_short, "discards")

  
  return(unsex)
}

table3_exp_comm = function(comp){
  
  #Sex = 3 comps first
  sex <- comp$FthenM[,c("fishyr", "sex", "Ntows")]
  
  sex$Nmale <- ""
  sex$Nfemale <- ""
  sex$Gender <- "Sexed"
  sex$Units <- "Ntows"
  sex$Nfish <- comp$FthenM$Nsamps
  sex$Nsamp <- ""
  sex$fleet = NA
  sex$fleet[which(comp$FthenM$fleet == "FG")] = 2
  sex$fleet[which(comp$FthenM$fleet == "TW")] = 1
  sex$Fleet <- get_fleet(sex$fleet)$label_short
  
  names(sex)[which(names(sex)=="fishyr")] <- "year"
  
  #Sex = 0 comps next
  unsex <- comp$Uout[,c("fishyr", "sex", "Ntows")]
  
  unsex$Nmale <- ""
  unsex$Nfemale <- ""
  unsex$Gender <- "Unsexed"
  unsex$Units <- "Ntows"
  unsex$Nfish <- comp$Uout$Nsamps
  unsex$Nsamp <- ""
  unsex$fleet = NA
  unsex$fleet[which(comp$Uout$fleet == "FG")] = 2
  unsex$fleet[which(comp$Uout$fleet == "TW")] = 1
  unsex$Fleet <- get_fleet(unsex$fleet)$label_short
  
  names(unsex)[which(names(unsex)=="fishyr")] <- "year"
  
  return(rbind(sex,unsex))
}

#Age comp function to get marginal from CAAL
table4_fromCAAL = function(comp){
  
  #female first
  fem <- comp$female[,c("Year", "Fleet", "Gender", "nSamps")]
  
  #male next
  mal <- comp$male[,c("Year", "Fleet", "Gender", "nSamps")]
  
  comb = data.frame("year" = unique(c(fem$Year, mal$Year)))
  comb$Nmale <- (dplyr::group_by(mal, Year) %>% dplyr::summarise(sum = sum(nSamps)))$sum
  comb$Nfemale <- (dplyr::group_by(fem, Year) %>% dplyr::summarise(sum = sum(nSamps)))$sum
  comb$sex = 3
  comb$Gender <- "Sexed"
  comb$Units <- "Nfish"
  comb$Nfish <- comb$Nmale + comb$Nfemale
  comb$Nsamp <- ""
  comb$fleet <- unique(c(fem$Fleet,mal$Fleet))
  comb$Fleet <- get_fleet(unique(comb$fleet))$label_short
  comb$Ntows <- ""
  
  return(comb)
}

#Function to pull commercial samples sizes by state
#Gear is entered as "FG" or "TW"
#Region is "North" or "South"
#Type is "length" or "age"
table3_commState = function(region, type){
  
  samps_raw = read.csv(file.path(getwd(), "data-raw", 
                   paste0("pacfin_", type, "_state_gear_sample_size_", region, ".csv")),
                   header=T)
  samps_raw[samps_raw$sex %in% c("F","M"),"Sex"] = 3
  samps_raw[samps_raw$sex %in% c("U"),"Sex"] = 0
  
  samps = aggregate(samps_raw$nfish, 
                        by = list("year" = samps_raw$yr, "fleet" = samps_raw$fleet, "sex" = samps_raw$Sex, 
                                  "state" = samps_raw$state), 
                        FUN = sum)
  names(samps)[ncol(samps)] = "Nfish"
  
  samps$fleet_name = samps$fleet
  samps[samps$fleet == "FG","fleet"] = 2
  samps[samps$fleet == "TW","fleet"] = 1
  samps$Fleet = NULL
  samps$Fleet = paste(get_fleet(as.numeric(samps$fleet))$label_short, samps$state)
  samps$Gender <- NULL
  samps[samps$sex == 3, "Gender"] <- "Sexed"
  samps[samps$sex == 0, "Gender"] <- "Unsexed"
  
  samps$Nmale <- ""
  samps$Nfemale <- ""
  samps$Units <- "Ntows"
  samps$Nsamp <- ""
  samps$Ntows <- ""
  
  return(samps[,c("year","fleet","sex","Nfish","Fleet","Gender", "Nmale","Nfemale","Units","Ntows","Nsamp")])
}

##################################End of functions##################################

####################
####North length samples
###################

t3_ca_rec <- table3_noexp(lenCompN_CA_Rec)
t3_or_rec <- table3_noexp(lenCompN_OR_Rec)
t3_wa_rec <- table3_noexp(lenCompN_WA_Rec)
t3_lam <- table3_noexp(lenCompN_LamThesis)

t3_wcgbts <- table3_exp(lenCompN_sex3_WCGBTS, region = "north", type = "length")
t3_tri <- table3_exp(lenCompN_sex3_Triennial, region = "north", type = "length")

t3_discards <-table3_exp_discard(lenCompN_comm_discards, region = "North")
t3_com <-table3_exp_comm(lenCompN_comm)
t3_comState <- table3_commState(region = "North", type = "length")

colnames_ordered <- c("year","fleet","Fleet","Gender","Units","Nsamp","Ntows","Nfish","Nmale","Nfemale")
t3_samples <- data.frame(rbind
                         (t3_ca_rec, t3_or_rec, t3_wa_rec, 
                           t3_lam,
                           t3_wcgbts, t3_tri,
                           #t3_comState,
                           t3_discards, t3_com))[,colnames_ordered]
t3_samples = t3_samples[order(t3_samples$fleet, t3_samples$Fleet, t3_samples$Gender, t3_samples$year),]

#Can output csv's to test
#write.csv(t3_samples, file.path(getwd(), "data-raw", "t3_north_length.csv"))

colnames <- c("Year","Fleet","Gender","Units","Nsamp","Ntows","Nfish","Nmale","Nfemale")

t = table_format(x = t3_samples[,-which(names(t3_samples)=="fleet")],
                 caption = 'Sample sizes of length composition data for the north model.',
                 label = 'sample-size-length',
                 longtable = TRUE,
                 font_size = 9,
                 digits = 2,
                 landscape = FALSE,
                 col_names = colnames,
                 row.names = FALSE)

kableExtra::save_kable(t, file = file.path(getwd(),"doc","length_samps_North.tex"))


####################
####South length samples
###################

t3_ca_rec <- table3_noexp(lenCompS_CA_Rec)
t3_lam <- table3_noexp(lenCompS_LamThesis)
t3_hkl <- table3_noexp(lenCompS_HKL)
t3_deb <- table3_deb(lenCompS_debHist)
  
t3_wcgbts <- table3_exp(lenCompS_sex3_WCGBTS, region = "south", type = "length")
t3_tri <- table3_exp(lenCompS_sex3_Triennial, region = "south", type = "length")

t3_discards <-table3_exp_discard(lenCompS_comm_discards, region = "south")
t3_com <-table3_exp_comm(lenCompS_comm)
t3_comState <- table3_commState(region = "South", type = "length")

colnames_ordered <- c("year","fleet","Fleet","Gender","Units","Nsamp","Ntows","Nfish","Nmale","Nfemale")
t3_samples <- data.frame(rbind
                         (t3_ca_rec, 
                           t3_lam, t3_deb,
                           t3_hkl, t3_wcgbts, t3_tri,
                           #t3_comState,
                           t3_discards, t3_com))[,colnames_ordered]
t3_samples = t3_samples[order(t3_samples$fleet, t3_samples$Fleet, t3_samples$Gender, t3_samples$year),] #Order by fleet and then year

#Can output csv's to test
#write.csv(t3_samples, file.path(getwd(), "data-raw", "t3_south_length.csv"))

colnames <- c("Year","Fleet","Gender","Units","Nsamp","Ntows","Nfish","Nmale","Nfemale")

t = table_format(x = t3_samples[,-which(names(t3_samples)=="fleet")],
                 caption = 'Sample sizes of length composition data for the south model.',
                 label = 'sample-size-length',
                 longtable = TRUE,
                 font_size = 9,
                 digits = 2,
                 landscape = FALSE,
                 col_names = colnames,
                 row.names = FALSE)

kableExtra::save_kable(t, file = file.path(getwd(),"doc","length_samps_South.tex"))


####################
####North age samples
###################

t4_or_rec <- table3_noexp(ageCompN_OR_Rec)
t4_wa_rec <- table3_noexp(ageCompN_WA_Rec)
t4_lam <- table4_fromCAAL(ageCAAL_N_LamThesis) #<- calculate from CAAL

t4_wcgbts <- table3_exp(ageCompN_sex3_WCGBTS, region = "north", type = "age")
t4_tri <- table3_exp(ageCompN_sex3_Triennial, region = "north", type = "age")

t4_com <-table3_exp_comm(ageCompN_comm)
t4_comState <- table3_commState(region = "North", type = "age")

colnames_ordered <- c("year","fleet","Fleet","Gender","Units","Nsamp","Ntows","Nfish","Nmale","Nfemale")
t4_samples <- data.frame(rbind
                         (t4_or_rec, t4_wa_rec, 
                           t4_lam,
                           t4_wcgbts, t4_tri,
                           #t4_comState,
                           t4_com))[,colnames_ordered]
t4_samples = t4_samples[order(t4_samples$fleet, t4_samples$Fleet, t4_samples$Gender, t4_samples$year),]

#Can output csv's to test
#write.csv(t4_samples, file.path(getwd(), "data-raw", "t4_north_age.csv"))

colnames <- c("Year","Fleet","Gender","Units","Nsamp","Ntows","Nfish","Nmale","Nfemale")

t = table_format(x = t4_samples[,-which(names(t4_samples)=="fleet")],
                 caption = 'Sample sizes of age composition data for the north model.',
                 label = 'sample-size-age',
                 longtable = TRUE,
                 font_size = 9,
                 digits = 2,
                 landscape = FALSE,
                 col_names = colnames,
                 row.names = FALSE)

kableExtra::save_kable(t, file = file.path(getwd(),"doc","age_samps_North.tex"))


####################
####South age samples
###################

t4_lam <- table4_fromCAAL(ageCAAL_S_LamThesis) #<- calculate from CAAL
t4_hkl <- table3_noexp(ageCompS_HKL)

t4_wcgbts <- table3_exp(ageCompS_sex3_WCGBTS, region = "south", type = "age")
t4_tri <- table3_exp(ageCompS_sex3_Triennial, region = "south", type = "age")

t4_com <-table3_exp_comm(ageCompS_comm)
t4_comState <- table3_commState(region = "South", type = "age")

colnames_ordered <- c("year","fleet","Fleet","Gender","Units","Nsamp","Ntows","Nfish","Nmale","Nfemale")
t4_samples <- data.frame(rbind
                         (t4_lam,
                           t4_hkl, t4_wcgbts, t4_tri,
                           t4_comState,
                           t4_com))[,colnames_ordered]
t4_samples = t4_samples[order(t4_samples$fleet, t4_samples$Fleet, t4_samples$Gender, t4_samples$year),]

#Can output csv's to test
#write.csv(t4_samples, file.path(getwd(), "data-raw", "t4_south_age.csv"))

colnames <- c("Year","Fleet","Gender","Units","Nsamp","Ntows","Nfish","Nmale","Nfemale")

t = table_format(x = t4_samples[,-which(names(t4_samples)=="fleet")],
                 caption = 'Sample sizes of age composition data for the south model.',
                 label = 'sample-size-age',
                 longtable = TRUE,
                 font_size = 9,
                 digits = 2,
                 landscape = FALSE,
                 col_names = colnames,
                 row.names = FALSE)

kableExtra::save_kable(t, file = file.path(getwd(),"doc","age_samps_South.tex"))
  
