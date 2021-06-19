#Create table 3 from model output
#Sample sizes of comp data

##############################LenComps North###################################

###
#Recreational samps
###

#Function for getting recreational comps into desired format
table3_rec = function(comp){
  
  #Sex = 3 comps first
  sex <- comp$comps[,c("year","fleet", "sex", "Nsamp")]
  
  male_rows = grep("M", names(comp$comps))
  female_rows = grep("F", names(comp$comps))
  
  sex$Nmale <- rowSums(comp$comps[,male_rows])
  sex$Nfemale <- rowSums(comp$comps[,female_rows])
  sex$Gender <- "Sexed"
  sex$Units <- "Nfish"
  sex$Ntows <- ""
  sex$Fleet <- get_fleet(sex$fleet)$label_short
  
  #Sex = 0 comps next 
  unsex <- comp$comps_u[,c("year","fleet", "sex", "Nsamp")]
  
  unsex$Gender <- "Unsexed"
  unsex$Units <- "Nfish"
  unsex$Ntows <- ""
  unsex$Nmale <- ""
  unsex$Nfemale <- ""
  unsex$Fleet <- get_fleet(unsex$fleet)$label_short
  
  
  return(rbind(sex,unsex))
}

ca_rec <- table3_rec(lenCompN_CA_Rec)
or_rec <- table3_rec(lenCompN_OR_Rec)
wa_rec <- table3_rec(lenCompN_WA_Rec)

colnames_ordered <- c("year","Fleet","Gender","Units","Ntows","Nsamp","Nmale","Nfemale")
rec_samples <- data.frame(rbind(ca_rec,or_rec,wa_rec))[,colnames_ordered]

colnames <- c("Year","Fleet","Gender","Units","Ntows","Nfish","Nmale","Nfemale")

t = table_format(x = rec_samples,
                 caption = 'Length sample sizes for the north model.',
                 label = 'length_samps_N',
                 longtable = TRUE,
                 font_size = 9,
                 digits = 2,
                 landscape = FALSE,
                 col_names = colnames,
                 row.names = FALSE)

kableExtra::save_kable(t, file = file.path(getwd(),"doc","length_samps_N.tex"))


