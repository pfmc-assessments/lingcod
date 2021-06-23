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


table3_exp = function(comp, region){
  
  #Region must be either "north" or "south" to obtain sample sizes
  
  #Expanded comps. Comps with sexed fish.

  sex <- comp[,c("year","fleet", "sex", "Nsamp")]
  
  sex$Nmale <- ""
  sex$Nfemale <- ""
  sex$Gender <- "Sexed"
  sex$Units <- "Nsamp"

  sex$Fleet <- get_fleet(sex$fleet)$label_short
  
  samps = read.csv(
    file.path(getwd(),"data-raw","lenComps",sex$Fleet[1],paste0(region,"_length_SampleSize.csv")),
    header = TRUE)
  
  sex$Nfish <- samps$All_Fish 
  sex$Ntows <- samps$Tows
  

  return(sex)
}

table3_exp_discard = function(comp){
  
  #Expanded comps from comm discards. Sex = 0 so only unsexed

  unsex <- comp[,c("year","fleet", "sex")]
  
  unsex$Gender <- "Unsexed"
  unsex$Units <- "Ntows"
  unsex$Ntows <- comp$nsamp
  unsex$Nmale <- ""
  unsex$Nfemale <- ""
  unsex$Nfish <- ""
  unsex$Nsamp <- ""
  unsex$Fleet <- get_fleet(unsex$fleet)$label_short
  
  
  return(unsex)
}

table3_exp_comm = function(comp){
  
  #Sex = 3 comps first
  sex <- comp$FthenM[,c("fishyr", "sex", "Ntows")]
  
  sex$Nmale <- ""
  sex$Nfemale <- ""
  sex$Gender <- "Sexed"
  sex$Units <- "Ntows"
  sex$Nfish <- ""
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
  unsex$Nfish <- ""
  unsex$Nsamp <- ""
  unsex$fleet = NA
  unsex$fleet[which(comp$Uout$fleet == "FG")] = 2
  unsex$fleet[which(comp$Uout$fleet == "TW")] = 1
  unsex$Fleet <- get_fleet(unsex$fleet)$label_short
  
  names(unsex)[which(names(unsex)=="fishyr")] <- "year"
  
  return(rbind(sex,unsex))
}

##################################End of functions##################################

####################
####North length samples
###################

t3_ca_rec <- table3_noexp(lenCompN_CA_Rec)
t3_or_rec <- table3_noexp(lenCompN_OR_Rec)
t3_wa_rec <- table3_noexp(lenCompN_WA_Rec)
t3_lam <- table3_noexp(lenCompN_LamThesis)

t3_wcgbts <- table3_exp(lenCompN_sex3_WCGBTS, region = "north")
t3_tri <- table3_exp(lenCompN_sex3_Triennial, region = "north")

t3_discards <-table3_exp_discard(lenCompN_comm_discards)
t3_com <-table3_exp_comm(lenCompN_comm)

colnames_ordered <- c("year","fleet","Fleet","Gender","Units","Nsamp","Ntows","Nfish","Nmale","Nfemale")
t3_samples <- data.frame(rbind
                         (t3_ca_rec, t3_or_rec, t3_wa_rec, 
                           t3_lam,
                           t3_wcgbts, t3_tri,
                           t3_discards, t3_com))[,colnames_ordered]
t3_samples = t3_samples[order(t3_samples$fleet, t3_samples$year),]

colnames <- c("Year","Fleet","Gender","Units","Nsamp","Ntows","Nfish","Nmale","Nfemale")

t = table_format(x = t3_samples[,-which(names(t3_samples)=="fleet")],
                 caption = 'Sample sizes of length composition data for the north model.',
                 label = 'length_samps_N',
                 longtable = TRUE,
                 font_size = 9,
                 digits = 2,
                 landscape = FALSE,
                 col_names = colnames,
                 row.names = FALSE)

kableExtra::save_kable(t, file = file.path(getwd(),"doc","length_samps_N.tex"))


####################
####South length samples
###################

t3_ca_rec <- table3_noexp(lenCompS_CA_Rec)
t3_lam <- table3_noexp(lenCompS_LamThesis)
t3_hkl <- table3_noexp(lenCompS_HKL)
t3_deb <- table3_deb(lenCompS_debHist)
  
t3_wcgbts <- table3_exp(lenCompS_sex3_WCGBTS, region = "south")
t3_tri <- table3_exp(lenCompS_sex3_Triennial, region = "south")

t3_discards <-table3_exp_discard(lenCompS_comm_discards)
t3_com <-table3_exp_comm(lenCompS_comm)

colnames_ordered <- c("year","fleet","Fleet","Gender","Units","Nsamp","Ntows","Nfish","Nmale","Nfemale")
t3_samples <- data.frame(rbind
                         (t3_ca_rec, 
                           t3_lam, t3_deb,
                           t3_hkl, t3_wcgbts, t3_tri,
                           t3_discards, t3_com))[,colnames_ordered]
t3_samples = t3_samples[order(t3_samples$fleet, t3_samples$year),] #Order by fleet and then year

colnames <- c("Year","Fleet","Gender","Units","Nsamp","Ntows","Nfish","Nmale","Nfemale")

t = table_format(x = t3_samples[,-which(names(t3_samples)=="fleet")],
                 caption = 'Sample sizes of length composition data for the south model.',
                 label = 'length_samps_S',
                 longtable = TRUE,
                 font_size = 9,
                 digits = 2,
                 landscape = FALSE,
                 col_names = colnames,
                 row.names = FALSE)

kableExtra::save_kable(t, file = file.path(getwd(),"doc","length_samps_S.tex"))

