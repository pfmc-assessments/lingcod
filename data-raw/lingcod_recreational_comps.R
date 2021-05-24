############################################################################################
#	Recreational data-processing for lingcod
#
#	Based on data moderate scripts, created by Chantel Wetzel, Brian Langseth
############################################################################################

#Questions:
#1. Do we need CAAL? Previous assessment did not do it. [NO]
#2. What to do with recfin data? Right now, only applying for CA 2004-2020, and 2020 for OR. [That is fine]
#3. Include WA research and unknown origin data? [No longer relevant]
4. What is the difference with 2003 type 3d CA data and mrfss type 3 data. 
#5. For CA use T_LEN or LNGTH? [LNGTH appears to be fork length]
#6. What to do with released fish? Set partition to be separate for each? [Exclude released. SS3 assumes partition 0 even if use partition 2 because dont have separate comps]
#7. What are "P" and "S" in WA bio files. Are these shore? [No longer relevant]
#8. What about the 0.2 cm fish in CA 2003? [Exclude]
#9. Something is wrong with Weight. [Its a conversion. Since we dont use it here, ignore.]
10. Fleet timings, numbers, age error
#11. Keeping all of Humboldt county right now for CA mrfss
12. Loading dataModerate_2021 from the github quillback branch doesnt include rename_mrfss
#13. Not switching to fork length from total length. Can for WA sport. Others? [Just do for WA]

#devtools::load_all("U:/Stock assessments/nwfscSurvey")
devtools::load_all("U:/Stock assessments/dataModerate_2021") 
library(nwfscSurvey)
library(dataModerate2021)
library(ggplot2)
library(readxl)

#Folder where the lingcod git repository is on computer
dir = "C:/Users/Brian.Langseth/Desktop/lingcod_2021"

#Length bins for north and south
len_bin = seq(10, 130, 2)
age_bin = seq(0, 20, 1)

############################################################################################
#	Load Data
############################################################################################

###############
#General Recfin
###############
#Zip "pulled_4_19_21" folder from Lingcod_2021>data-raw>recfin into data-raw folder in repository
recfin_bio = read.csv(file.path(dir,"Lingcod_2021","data-raw","pulled_4_19_21","SD501--2001---2020_rec_bio_lingcod_pulled_4_19_21.csv"))
#Exclude fish from Mexico
table(recfin_bio$AGENCY_WATER_AREA_NAME)
recfin_bio = recfin_bio[!recfin_bio$AGENCY_WATER_AREA_NAME %in% c("MEXICO (AREAB AND P1B IMPORT, CPFV)"),]
#Add area splits at 40`10`
recfin_bio$Areas = "north"
recfin_bio[recfin_bio$STATE_NAME=="CALIFORNIA" & !recfin_bio$COUNTY_NUMBER %in% c(15,23),"Areas"] = "south"

recfin_age = read.csv(file.path(dir,"Lingcod_2021","data-raw","pulled_4_19_21","SD506--1984---2020_rec_ageing_lincod_pulled_4_19_21.csv"))
recfin_age$Areas = "north"

#These functions do not keep weight right. However, we dont need weight to be right for comps. Continue on. 
recfin_len_data = rename_recfin(data = recfin_bio,
                               area_grouping = list(c("south"),c("north")),
                               area_names = c("south", "north"),
                               area_column_name = "Areas",
                               mode_grouping = list(c("BEACH/BANK", "MAN-MADE/JETTY"), c("PARTY/CHARTER BOATS"), c("PRIVATE/RENTAL BOATS"), c("NOT KNOWN")),
                               mode_names = c("rec_shore", "rec_boat_charter", "rec_boat_private", "rec_unk"),
                               mode_column_name = "RECFIN_MODE_NAME" )

recfin_age_data = rename_recfin(data = recfin_age,
                               area_grouping = list(c("south"), c("north")),
                               area_names = c("south", "north"),
                               area_column_name = "Areas",
                               mode_grouping = list(c("BEACH/BANK", "MAN-MADE/JETTY"), c("PARTY/CHARTER BOATS"), c("PRIVATE/RENTAL BOATS"), c("NOT KNOWN","^$")), #"^$" matches to ""
                               mode_names = c("rec_shore", "rec_boat_charter", "rec_boat_private", "rec_unk"),
                               mode_column_name = "RECFIN_MODE_NAME" )


###############
#California
###############
#Zip "california_sharedwithJohnB" folder from Lingcod_2021>data-raw> into data-raw folder in repository
#THESE ARE NOT VIABLE - THEY ARE A SINGLE COMP SUMMARIZING THE DATA, NOT THE DATA THEMSELVES
#ca_recfin = read.csv(file.path(dir,"Lingcod_2021","data-raw","california_sharedwithJohnB","CRFS Lingcod Lengths 2004-2019.csv"))
#Couldn't read in the excel so saved the relevant sheet as a csv
#ca_mrfss_full = data.frame(read_excel(file.path(dir,"Lingcod_2021","data-raw","california_sharedwithJohnB","mrfss_type_3_1980_2003_lingcod.xlsx"), sheet = "mrfss_type_3_1980_2003", na = "NA"))
ca_mrfss_full = read.csv(file.path(dir,"Lingcod_2021","data-raw","california_sharedwithJohnB","mrfss_type_3_1980_2003_lingcod.csv"))
ca_mrfss = ca_mrfss_full[ca_mrfss_full$ST == 6 & ca_mrfss_full$SP_CODE == 8827010201,]
# #Checked the 2003_... file and see it has the same number of records. Not sure what the difference is. Dont use
# ca_mrfss_2003_full = data.frame(read_excel(file.path(dir,"Lingcod_2021","data-raw","california_sharedwithJohnB","2003_type_3d_Lingcod.xlsx"), sheet = "2003_type_3d_records_budrick", na = "NA"))
# ca_mrfss_2003 = ca_mrfss_2003_full[ca_mrfss_2003_full$SP_CODE == 8827010201,]

ca_mrfss = ca_mrfss[!is.na(ca_mrfss$CNTY), ] # remove records without a county
ncm = c(15, 23)
scm = unique(ca_mrfss[!ca_mrfss$CNTY %in% ncm, "CNTY"]) 
ca_mrfss$STATE_NAME = "CA"
ca_mrfss_data = rename_mrfss(data = ca_mrfss,
                             len_col = "LNGTH",
                             area_grouping = list(scm, ncm), 
                             area_names = c("south", "north"), 
                             area_column_name = "CNTY", 
                             mode_grouping = list(c(1,2), c(6), c(7)),
                             mode_names = c("rec_shore", "rec_boat_charter", "rec_boat_private"),
                             mode_column_name = "MODE_FX" )
#Dont need to convert based on LEN_FLAG have both fork length (LNGTH) and total length (T_LEN) fields


###############
#Oregon
###############
#Zip "SPORT BIOLOGICAL" folder from Lingcod_2021>data-raw>oregon_sharedwithAliW>LINGCOD into data-raw folder in repository
or_recfin = read.csv(file.path(dir,"Lingcod_2021","data-raw","SPORT BIOLOGICAL","RecFIN_LINGCOD_BIO-LW_2001-2020.csv"))
or_mrfss = data.frame(read_excel(file.path(dir,"Lingcod_2021","data-raw","SPORT BIOLOGICAL","Lingcod_MRFSS BIO_1980 - 2003.xlsx"), sheet = "raw data", na = "NA"))
or_age = read.csv(file.path(dir,"Lingcod_2021","data-raw","SPORT BIOLOGICAL","Oregon_LINGCOD_RecFIN_ages_1999-2019_nonconfid.csv"))

or_recfin_len_data = rename_recfin(data = or_recfin, 
                                   area_column_name = "STATE_NAME",
                                   area_grouping = list("OREGON"), 
                                   area_names = "north",
                                   mode_grouping = list(c("PARTY/CHARTER BOATS"), c("PRIVATE/RENTAL BOATS"), c("NOT KNOWN")),
                                   mode_names = c("rec_boat_charter", "rec_boat_private", "rec_unk"),
                                   mode_column_name = "RECFIN_MODE_NAME" )

or_mrfss$STATE_NAME = "OR"
or_mrfss_data = rename_mrfss(data = or_mrfss,
                             len_col = "Length",
                             area_grouping = list(484), 
                             area_names = c("north"),
                             area_column_name = "ORBS_SPP_Code", # This is essentially a cheat
                             mode_grouping = list(c(1,2), c(6), c(7)),
                             mode_names = c("rec_shore", "rec_boat_charter", "rec_boat_private"),
                             mode_column_name = "MRFSS_MODE_FX" )

or_recfin_age_data = rename_recfin(data = or_age, 
                                   area_grouping = list("ODFW"), 
                                   area_names = c("north"), 
                                   area_column_name = "SAMPLING_AGENCY_NAME",
                                   mode_grouping = list( c("PARTY/CHARTER BOATS"), c("PRIVATE/RENTAL BOATS")),
                                   mode_names = c("rec_boat_charter", "rec_boat_private"),
                                   mode_column_name = "RECFIN_MODE_NAME",
                                   or_ages = TRUE)
or_recfin_age_data$State_Areas="north"
or_recfin_age_data$State = "OR"
or_recfin_age_data$Source = "RecFIN"



###############
#Washington
###############
#Download "Lingcod_Coastal_Sport_05202021" file from Lingcod_2021>data-raw>washington_sharedwithTheresa>LINGCOD into data-raw folder in repository
#Theresa wishes us to use this data instead. There are more samples in most overlapping years in the recfin data
wa_recfin_sport = data.frame(read_excel(file.path(dir,"Lingcod_2021","data-raw","Lingcod_Coastal_Sport_05202021.xlsx"), sheet = "Coastal Sport"))
wa_recfin_sport$AGENCY_WEIGHT = NA #need this for rename_wa_recfin
wa_sport = rename_wa_recfin(wa_recfin_sport)

#Convert the 591 total length measurements to fork length based on Laidig (see github issue: https://github.com/iantaylor-NOAA/Lingcod_2021/issues/26)
wa_sport[which(wa_sport$length_type_name=="Total length"),"RECFIN_LENGTH_MM"] = wa_sport[which(wa_sport$length_type_name=="Total length"),"RECFIN_LENGTH_MM"]*0.981-0.521
               
wa_sport$STATE_NAME = "WA"
wa_sport_data =rename_recfin(data = wa_sport,
                              area_grouping = list(c("WA")),
                              area_names = c("north"),
                              area_column_name = "STATE_NAME")
                              #mode_grouping = list( c("C"), c("B"), c("\\?", "^$", "P", "S")), #\\? matches to "?" and "^$" matches to ""
                              #mode_names = c("rec_boat_charter", "rec_boat_private", "rec_unk"),
                              #mode_column_name = "boat_mode_code")

#There are three fish with no best age, but which have age 1 and 2. Without knowing best, exclude. 

############################################################################################
# Put all the data into one list
############################################################################################
#Dont read in the oregon and washington age data just the length (otherwise aged lengths would be double counted)
#Per email with Theresa Tsou on May20, use wa sport data for length and ages
#Per email with Ali Whitman on May21, use or datasets (BOTH age and length) for lengths in 1999-2019, recfin lengths in 2020, and mrfss lengths in 1980-1998
input_len = list()
input_len[[1]] = recfin_len_data[which(recfin_len_data$State=="CA"),] #Other states provided data for recfin years
input_len[[2]] = ca_mrfss_data
input_len[[3]] = or_recfin_len_data
input_len[[4]] = or_mrfss_data[which(or_mrfss_data$Year<1999),]
input_len[[5]] = or_recfin_age_data
input_len[[6]] = recfin_len_data[which(recfin_len_data$State=="OR" & recfin_len_data$Year == 2020),]
input_len[[7]] = wa_sport_data[which(wa_sport_data$Year<2021),]

#For age data, oregon age matches recfin_age so just use oregon
input_age = list()
input_age[[1]] = or_recfin_age_data
input_age[[2]] = wa_sport_data[which(wa_sport_data$Year<2021),] 


############################################################################################
#	Create data frame with all the input data
############################################################################################
out = create_data_frame(data_list = input_len)

out_age = create_data_frame(data_list = input_age)


############################################################################################
# Clean up the data - lengths
############################################################################################

#Remove any data without valid lengths
print(paste("Removed",sum(is.na(out$Length)), "records without any length"))
out = out[!is.na(out$Length),]

# Now lets do a check to filter out any anomalous lengths
remove = which(out$Length > 200 | out$Length < 8) 
out[remove,]
#      Year Lat Lon State State_Areas Areas Depth Sex Length Weight Age            Fleet Data_Type       Source
#14914 2008  NA  NA    CA       south    NA    NA   U    6.3   2.84  NA rec_boat_private  RETAINED       RecFIN
#18880 2009  NA  NA    CA       south    NA    NA   U  678.6   3.95  NA rec_boat_private  RETAINED       RecFIN
#91443 2003  NA  NA    CA       south    NA    NA   U    0.2     NA  NA rec_boat_private      <NA> RecFIN_MRFSS
print(paste("Removed",length(remove)-1, "records with lengths > 200 cm and < 1 cm"))
out = out[-remove[-1], ]

#Compare retained and released fish
ggplot(out, aes(Length, fill = Data_Type, color = Data_Type)) + 
  facet_wrap(facets = c("Sex","State")) + 
  geom_density(alpha = 0.4, lwd = 0.8, adjust = 0.5)

#Compare across primary modes
ggplot(out[out$Fleet %in% c("rec_boat_charter", "rec_boat_private", "rec_shore"),], aes(Length, fill = Fleet, color = Fleet)) + 
  facet_wrap(facets = c("Sex","State")) + 
  geom_density(alpha = 0.4, lwd = 0.8, adjust = 0.5)

## Remove the released fish. (No need to do so for the age data since none were released)
print(paste("Removed",length(which(out$Data_Type=="RELEASED")), "released records"))
out = out[out$Data_Type %in% c("RETAINED", NA), ]

############################################################################################
# Clean up the data - ages
############################################################################################

#Remove any data without valid ages
print(paste("Removed",sum(is.na(out_age$Age)), "records without any ages"))
out_age = out_age[!is.na(out_age$Age),]

# Now lets do a check to filter out any anomalous ages
range(out_age$Age, na.rm=TRUE)
#Ages are reasonable


############################################################################################
#	Washington fleet recreational length and age comps
############################################################################################
lsubdir = file.path(dir, "Lingcod_2021", "data", "lenComps", "Rec")
if(!dir.exists(file.path(lsubdir))) dir.create(file.path(lsubdir))

wa = out[which(out$State == "WA"), ]
wa$Length_cm = wa$Length

# create a table of the samples available by year
wa$Trawl_id = 1:nrow(wa)
GetN.fn(dir = file.path(lsubdir), dat = wa, type = "length", species = 'others')
n = read.csv(file.path(lsubdir, "forSS", "length_SampleSize.csv"))
n = n[,c('Year', 'All_Fish', 'Sexed_Fish', 'Unsexed_Fish')]
write.csv(n, file = file.path(lsubdir, "wa_rec_samples.csv"), row.names = FALSE)

lfs = UnexpandedLFs.fn(dir = file.path(lsubdir), #puts into "forSS" folder in this location
                       datL = wa, lgthBins = len_bin,
                       sex = 3,  partition = 0, fleet = "Fleet", month = 1)
file.rename(from = file.path(lsubdir, "forSS", paste0("Survey_notExpanded_Length_comp_Sex_0_bin=", min(len_bin), "-", max(len_bin), ".csv")), 
            to = file.path(lsubdir, paste0("north_WA_notExpanded_Length_comp_Sex_0_bin=", min(len_bin), "-", max(len_bin), ".csv"))) 
file.rename(from = file.path(lsubdir, "forSS", paste0("Survey_notExpanded_Length_comp_Sex_3_bin=", min(len_bin), "-", max(len_bin), ".csv")), 
            to = file.path(lsubdir, paste0("north_WA_notExpanded_Length_comp_Sex_3_bin=", min(len_bin), "-", max(len_bin), ".csv"))) 
#Remove forSS file
unlink(file.path(lsubdir,"forSS"), recursive=TRUE)


PlotFreqData.fn(dir = file.path(lsubdir), 
                dat = lfs$comps, ylim=c(0, max(len_bin)+4), 
                main = "WA Recreational - Sexed", yaxs="i", ylab="Length (cm)", dopng = TRUE)
PlotFreqData.fn(dir = file.path(lsubdir), 
                dat = lfs$comps_u, ylim=c(0, max(len_bin)+4), 
                main = "WA Recreational - Unsexed", yaxs="i", ylab="Length (cm)", dopng = TRUE)

#Save as .rdas. Combined for sex3 (first element) and unsexed (second element)
lenCompN_WA_Rec = lfs
usethis::use_data(lenCompN_WA_Rec, overwrite = TRUE)


#######
#Washington age comps
#######
asubdir = file.path(dir, "Lingcod_2021", "data", "ageComps", "Rec")
if(!dir.exists(file.path(asubdir))) dir.create(file.path(asubdir))

wa_age = out_age[which(out_age$State == "WA"), ]
wa_age$Trawl_id = 1:nrow(wa_age)

GetN.fn(dir = file.path(asubdir), dat = wa_age, type = "age", species = 'others')
n = read.csv(file.path(asubdir, "forSS", "age_SampleSize.csv"))
n = n[,c('Year', 'All_Fish', 'Sexed_Fish', 'Unsexed_Fish')]
write.csv(n, file = file.path(asubdir, "wa_rec_age_samples.csv"), row.names = FALSE)

afs = UnexpandedAFs.fn(dir = file.path(asubdir), #puts into "forSS" folder in this location
                       datA = wa_age, ageBins = age_bin,
                       sex = 3,  partition = 0, fleet = "Fleet", month = 1, ageErr = 1) #Fleet is 1 for WA
file.rename(from = file.path(asubdir, "forSS", paste0("Survey_notExpanded_Age_comp_Sex_0_bin=", min(age_bin), "-", max(age_bin), ".csv")), 
            to = file.path(asubdir, paste0("north_WA_notExpanded_Age_comp_Sex_0_bin=", min(age_bin), "-", max(age_bin), ".csv"))) 
file.rename(from = file.path(asubdir, "forSS", paste0("Survey_notExpanded_Age_comp_Sex_3_bin=", min(age_bin), "-", max(age_bin), ".csv")), 
            to = file.path(asubdir, paste0("north_WA_notExpanded_Age_comp_Sex_3_bin=", min(age_bin), "-", max(age_bin), ".csv"))) 
#Remove forSS file
unlink(file.path(asubdir,"forSS"), recursive=TRUE)

PlotFreqData.fn(dir = file.path(asubdir), 
                dat = afs$comps, ylim=c(0, max(age_bin)+1), 
                main = "WA Recreational - Sexed", yaxs="i", ylab="Age", dopng = TRUE)
PlotFreqData.fn(dir = file.path(asubdir), 
                dat = afs$comps_u, ylim=c(0, max(age_bin)+1), 
                main = "WA Recreational - Unsexed", yaxs="i", ylab="Age", dopng = TRUE)

#Save as .rdas. Combined for sex3 (first element) and unsexed (second element)
ageCompN_WA_Rec = afs
usethis::use_data(ageCompN_WA_Rec, overwrite = TRUE)


############################################################################################
#	Oregon fleet recreational length and age comps
############################################################################################
or = out[which(out$State == "OR"), ]
or$Length_cm = or$Length

# create a table of the samples available by year
or$Trawl_id = 1:nrow(or)
GetN.fn(dir = file.path(lsubdir), dat = or, type = "length", species = 'others')
n = read.csv(file.path(lsubdir, "forSS", "length_SampleSize.csv"))
n = n[,c('Year', 'All_Fish', 'Sexed_Fish', 'Unsexed_Fish')]
write.csv(n, file = file.path(lsubdir, "or_rec_samples.csv"), row.names = FALSE)

lfs = UnexpandedLFs.fn(dir = file.path(lsubdir), #puts into "forSS" folder in this location
                       datL = or, lgthBins = len_bin,
                       sex = 3,  partition = 0, fleet = "Fleet", month = 1)
file.rename(from = file.path(lsubdir, "forSS", paste0("Survey_notExpanded_Length_comp_Sex_0_bin=", min(len_bin), "-", max(len_bin), ".csv")), 
            to = file.path(lsubdir, paste0("north_OR_notExpanded_Length_comp_Sex_0_bin=", min(len_bin), "-", max(len_bin), ".csv"))) 
file.rename(from = file.path(lsubdir, "forSS", paste0("Survey_notExpanded_Length_comp_Sex_3_bin=", min(len_bin), "-", max(len_bin), ".csv")), 
            to = file.path(lsubdir, paste0("north_OR_notExpanded_Length_comp_Sex_3_bin=", min(len_bin), "-", max(len_bin), ".csv"))) 
#Remove forSS file
unlink(file.path(lsubdir,"forSS"), recursive=TRUE)

PlotFreqData.fn(dir = file.path(lsubdir), 
                dat = lfs$comps, ylim=c(0, max(len_bin)+4), 
                main = "OR Recreational - Sexed", yaxs="i", ylab="Length (cm)", dopng = TRUE)
PlotFreqData.fn(dir = file.path(lsubdir), 
                dat = lfs$comps_u, ylim=c(0, max(len_bin)+4), 
                main = "OR Recreational - Unsexed", yaxs="i", ylab="Length (cm)", dopng = TRUE)

#Save as .rdas. Combined for sex3 (first element) and unsexed (second element)
lenCompN_OR_Rec = lfs
usethis::use_data(lenCompN_OR_Rec, overwrite = TRUE)



#######
#Oregon age comps
#######
or_age = out_age[which(out_age$State == "OR"), ]
or_age$Trawl_id = 1:nrow(or_age)

GetN.fn(dir = file.path(asubdir), dat = or_age, type = "age", species = 'others')
n = read.csv(file.path(asubdir, "forSS", "age_SampleSize.csv"))
n = n[,c('Year', 'All_Fish', 'Sexed_Fish', 'Unsexed_Fish')]
write.csv(n, file = file.path(asubdir, "or_rec_age_samples.csv"), row.names = FALSE)

afs = UnexpandedAFs.fn(dir = file.path(asubdir), #puts into "forSS" folder in this location
                       datA = or_age, ageBins = age_bin,
                       sex = 3,  partition = 0, fleet = "Fleet", month = 1, ageErr = 1) #Fleet is 1 for WA
file.rename(from = file.path(asubdir, "forSS", paste0("Survey_notExpanded_Age_comp_Sex_0_bin=", min(age_bin), "-", max(age_bin), ".csv")), 
            to = file.path(asubdir, paste0("north_OR_notExpanded_Age_comp_Sex_0_bin=", min(age_bin), "-", max(age_bin), ".csv"))) 
file.rename(from = file.path(asubdir, "forSS", paste0("Survey_notExpanded_Age_comp_Sex_3_bin=", min(age_bin), "-", max(age_bin), ".csv")), 
            to = file.path(asubdir, paste0("north_OR_notExpanded_Age_comp_Sex_3_bin=", min(age_bin), "-", max(age_bin), ".csv"))) 
#Remove forSS file
unlink(file.path(asubdir,"forSS"), recursive=TRUE)

PlotFreqData.fn(dir = file.path(asubdir), 
                dat = afs$comps, ylim=c(0, max(age_bin)+1), 
                main = "OR Recreational - Sexed", yaxs="i", ylab="Age", dopng = TRUE)
PlotFreqData.fn(dir = file.path(asubdir), 
                dat = afs$comps_u, ylim=c(0, max(age_bin)+1), 
                main = "OR Recreational - Unsexed", yaxs="i", ylab="Age", dopng = TRUE)

#Save as .rdas. Combined for sex3 (first element) and unsexed (second element)
ageCompN_OR_Rec = afs
usethis::use_data(ageCompN_OR_Rec, overwrite = TRUE)


############################################################################################
#	California north fleet recreational length comps (there are no ages)
############################################################################################
ca = out[which(out$State == "CA" & out$State_Areas == "north"), ]
ca$Length_cm = ca$Length

# create a table of the samples available by year
ca$Trawl_id = 1:nrow(ca)
GetN.fn(dir = file.path(lsubdir), dat = ca, type = "length", species = 'others')
n = read.csv(file.path(lsubdir, "forSS", "length_SampleSize.csv"))
n = n[,c('Year', 'All_Fish', 'Sexed_Fish', 'Unsexed_Fish')]
write.csv(n, file = file.path(lsubdir, "ca_north_rec_samples.csv"), row.names = FALSE)

lfs = UnexpandedLFs.fn(dir = file.path(lsubdir), #puts into "forSS" folder in this location
                       datL = ca, lgthBins = len_bin,
                       sex = 3,  partition = 0, fleet = "Fleet", month = 1)
file.rename(from = file.path(lsubdir, "forSS", paste0("Survey_notExpanded_Length_comp_Sex_0_bin=", min(len_bin), "-", max(len_bin), ".csv")), 
            to = file.path(lsubdir, paste0("north_CA_notExpanded_Length_comp_Sex_0_bin=", min(len_bin), "-", max(len_bin), ".csv"))) 
file.rename(from = file.path(lsubdir, "forSS", paste0("Survey_notExpanded_Length_comp_Sex_3_bin=", min(len_bin), "-", max(len_bin), ".csv")), 
            to = file.path(lsubdir, paste0("north_CA_notExpanded_Length_comp_Sex_3_bin=", min(len_bin), "-", max(len_bin), ".csv"))) 
#Remove forSS file
unlink(file.path(lsubdir,"forSS"), recursive=TRUE)


PlotFreqData.fn(dir = file.path(lsubdir), 
                dat = lfs$comps, ylim=c(0, max(len_bin)+4), 
                main = "CA North Recreational - Sexed", yaxs="i", ylab="Length (cm)", dopng = TRUE)
PlotFreqData.fn(dir = file.path(lsubdir), 
                dat = lfs$comps_u, ylim=c(0, max(len_bin)+4), 
                main = "CA North Recreational - Unsexed", yaxs="i", ylab="Length (cm)", dopng = TRUE)


#Save as .rdas. Combined for sex3 (first element) and unsexed (second element)
lenCompN_CA_Rec = lfs
usethis::use_data(lenCompN_CA_Rec, overwrite = TRUE)




############################################################################################
#	California south fleet recreational length comps (there are no ages)
############################################################################################
ca = out[which(out$State == "CA" & out$State_Areas == "south"), ]
ca$Length_cm = ca$Length

# create a table of the samples available by year
ca$Trawl_id = 1:nrow(ca)
GetN.fn(dir = file.path(lsubdir), dat = ca, type = "length", species = 'others')
n = read.csv(file.path(lsubdir, "forSS", "length_SampleSize.csv"))
n = n[,c('Year', 'All_Fish', 'Sexed_Fish', 'Unsexed_Fish')]
write.csv(n, file = file.path(lsubdir, "ca_south_rec_samples.csv"), row.names = FALSE)

lfs = UnexpandedLFs.fn(dir = file.path(lsubdir), #puts into "forSS" folder in this location
                       datL = ca, lgthBins = len_bin,
                       sex = 3,  partition = 0, fleet = "Fleet", month = 1)
file.rename(from = file.path(lsubdir, "forSS", paste0("Survey_notExpanded_Length_comp_Sex_0_bin=", min(len_bin), "-", max(len_bin), ".csv")), 
            to = file.path(lsubdir, paste0("south_CA_notExpanded_Length_comp_Sex_0_bin=", min(len_bin), "-", max(len_bin), ".csv"))) 
file.rename(from = file.path(lsubdir, "forSS", paste0("Survey_notExpanded_Length_comp_Sex_3_bin=", min(len_bin), "-", max(len_bin), ".csv")), 
            to = file.path(lsubdir, paste0("south_CA_notExpanded_Length_comp_Sex_3_bin=", min(len_bin), "-", max(len_bin), ".csv"))) 
#Remove forSS file
unlink(file.path(lsubdir,"forSS"), recursive=TRUE)


PlotFreqData.fn(dir = file.path(lsubdir), 
                dat = lfs$comps, ylim=c(0, max(len_bin)+4), 
                main = "CA South Recreational - Sexed", yaxs="i", ylab="Length (cm)", dopng = TRUE)
PlotFreqData.fn(dir = file.path(lsubdir), 
                dat = lfs$comps_u, ylim=c(0, max(len_bin)+4), 
                main = "CA South Recreational - Unsexed", yaxs="i", ylab="Length (cm)", dopng = TRUE)

#Save as .rdas. Combined for sex3 (first element) and unsexed (second element)
lenCompS_CA_Rec = lfs
usethis::use_data(lenCompS_CA_Rec, overwrite = TRUE)











