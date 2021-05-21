############################################################################################
#	Recreational data-processing for lingcod
#
#	Based on data moderate scripts, created by Chantel Wetzel, Brian Langseth
############################################################################################

#Questions:
1. What to do with recfin data?
1. Include WA research and unknown origin data?
2. What is the difference with 2003 type 3d CA data and mrfss type 3 data. 
3. For CA use T_LEN or LNGTH?
4. What to do with released fish? Set partition to be separate for each? Right now Im keeping all together
5. What are "P" and "S" in WA bio files. Are these shore?
6. What about the 0.2 cm fish in CA 2003?
7. Something is wrong with Weight
8. Fleet timings, numbers, age error

#devtools::load_all("U:/Stock assessments/nwfscSurvey")
devtools::load_all("U:/Stock assessments/dataModerate_2021") #If dont do this then rename recfin doesn't have as many entries
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
#Zip "SPORT BIOLOGICAL" folder from Lingcod_2021>data-raw>recfin>pulled_4_19_21 into data-raw folder in repository
recfin_bio = read.csv(file.path(dir,"Lingcod_2021","data-raw","pulled_4_19_21","SD501--2001---2020_rec_bio_lingcod_pulled_4_19_21.csv"))
recfin_bio$Areas = "north"
recfin_bio[recfin_bio$STATE_NAME=="CALIFORNIA" & !recfin_bio$COUNTY_NUMBER %in% c(15,23),"Areas"] = "south"

recfin_age = read.csv(file.path(dir,"Lingcod_2021","data-raw","pulled_4_19_21","SD506--1984---2020_rec_ageing_lincod_pulled_4_19_21.csv"))
recfin_age$Areas = "north"


####NEED TO DO THESE TWO YET
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
# #Checked the 2003_... file and see it hass the same number of records. Not sure what the difference is. Dont use
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
or_recfin_age_data$State_Areas="northage"


###############
#Washington
###############
#Download "Lingcod Biodata as of 3_29_2021(More Ages Coming Daily)" file from Lingcod_2021>data-raw>washington_sharedwithTheresa>LINGCOD into data-raw folder in repository
wa_recfin_sport = data.frame(read_excel(file.path(dir,"Lingcod_2021","data-raw","Lingcod Biodata as of 3_29_2021(More Ages Coming Daily).xlsx"), sheet = "Sport", na = "NA"))
wa_recfin_research = data.frame(read_excel(file.path(dir,"Lingcod_2021","data-raw","Lingcod Biodata as of 3_29_2021(More Ages Coming Daily).xlsx"), sheet = "Research", na = "NA"))
wa_recfin_sportUnkOrigin = data.frame(read_excel(file.path(dir,"Lingcod_2021","data-raw","Lingcod Biodata as of 3_29_2021(More Ages Coming Daily).xlsx"), sheet = "SportUnknownOrigin", na = "NA"))
#Distinguish washington "types"
wa_recfin_sport$Origin = "S"
wa_recfin_research$Origin = "R"
wa_recfin_sportUnkOrigin$Origin = "U"
#Combined dataset
wa_bio = rename_wa_recfin(rbind(wa_recfin_sport,wa_recfin_research,wa_recfin_sportUnkOrigin))

wa_bio$STATE_NAME = "WA"
wa_recfin_data =rename_recfin(data = wa_bio,
                              area_grouping = list(c("WA")),
                              area_names = c("north"),
                              area_column_name = "STATE_NAME",
                              mode_grouping = list( c("C"), c("B"), c("\\?", "^$", "P", "S")), #\\? matches to "?" and "^$" matches to ""
                              mode_names = c("rec_boat_charter", "rec_boat_private", "rec_unk"),
                              mode_column_name = "boat_mode_code")


############################################################################################
# Put all the data into one list
############################################################################################
#Dont read in the oregon and washington age data just the length (otherwise aged lengths would be double counted)
input_len = list()
input_len[[1]] = recfin_len_data
input_len[[2]] = ca_mrfss_data
input_len[[3]] = or_recfin_len_data
input_len[[4]] = or_mrfss_data
input_len[[5]] = wa_recfin_data

input_age = list()
input_age[[1]] = recfin_age_data
input_age[[2]] = or_recfin_age_data
input_age[[2]] = wa_recfin_data


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
#Year Lat Lon State State_Areas Areas Depth Sex Length   Weight Age            Fleet Data_Type       Source
#54585  2007  NA  NA    WA       north    NA    NA   U  750.0 4600.000  NA rec_boat_private  RETAINED       RecFIN
#57763  2008  NA  NA    CA       south    NA    NA   U    6.3    2.840  NA rec_boat_private  RETAINED       RecFIN
#74238  2009  NA  NA    CA       south    NA    NA   U  678.6    3.950  NA rec_boat_private  RETAINED       RecFIN
#244631 2003  NA  NA    CA       south    NA    NA   U    0.2       NA  NA rec_boat_private      <NA> RecFIN_MRFSS
#384411 2007  NA  NA    WA       north    NA    NA   U  750.0    0.001  NA rec_boat_private  RETAINED       RecFIN
print(paste("Removed",length(remove), "records with lengths > 200 cm"))
out = out[-remove, ]

## Remove the released for the rest of the summaries for now:
#print(paste("Removed",length(which(out$Data_Type=="RELEASED")), "released records"))
#out = out[out$Data_Type %in% c("RETAINED", NA), ]


############################################################################################
# Clean up the data - ages
############################################################################################

#Remove any data without valid ages
print(paste("Removed",sum(is.na(out_age$Age)), "records without any length"))
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











