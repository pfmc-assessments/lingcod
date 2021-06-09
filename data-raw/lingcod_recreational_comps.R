############################################################################################
#	Recreational data-processing for lingcod
#
#	Based on data moderate scripts, created by Chantel Wetzel, Brian Langseth
############################################################################################
#Questions:
#4. What is the difference with 2003 type 3d CA data and mrfss type 3 data.
#1. Do we need CAAL? Previous assessment did not do it. [Not at this time]
#2. What to do with recfin data? Right now, only applying for CA 2004-2020, and 2020 for OR. [That is fine]
#3. Include WA research and unknown origin data? [No longer relevant]
#5. For CA use T_LEN or LNGTH? [LNGTH appears to be fork length]
#6. What to do with released fish? Set partition to be separate for each? [Exclude released. SS3 assumes partition 0 even if use partition 2 because dont have separate comps]
#7. What are "P" and "S" in WA bio files. Are these shore? [No longer relevant]
#8. What about the 0.2 cm fish in CA 2003? [Exclude]
#9. Something is wrong with Weight. [Its a conversion. Since we dont use it here, ignore.]
#10. Fleet timings (7), numbers (WA = 3, OR = 4, CA = 5), age error (1) DONE
#11. Keeping all of Humboldt county right now for CA mrfss
#12. Loading dataModerate_2021 from the github quillback branch doesnt include rename_mrfss. [RESOLVED]
#13. Not switching to fork length from total length. Can for WA sport. Others? [Just do for WA]

#devtools::load_all("U:/Stock assessments/nwfscSurvey")
#devtools::load_all("U:/Stock assessments/dataModerate_2021")
# non-standard practice, all packages should be installed via this package, not in .R scripts
if (!"dataModerate2021" %in% installed.packages()[, 1]) {
  devtools::install_github("brianlangseth-NOAA/dataModerate_2021@quillback")
}
# non-standard practice, should use :: instead of a call to library()
library(dataModerate2021)

#Folder where the lingcod git repository is on computer
dir = getwd()

#Length bins for north and south
len_bin = info_bins[["length"]]
age_bin = info_bins[["age"]]

############################################################################################
#	Load Data
############################################################################################

###############
#General Recfin
###############
#Zip "pulled_4_19_21" folder from Lingcod_2021>data-raw>recfin into data-raw folder in repository
# PLEASE get this file from google drive in the data-raw folder rather than saving it in a subdirectory
# people should only have to download files at the top level of data-raw
recfin_bio = read.csv(file.path(dir, "data-raw", "SD501--2001---2020_rec_bio_lingcod_pulled_4_19_21.csv"))
#Exclude fish from Mexico
table(recfin_bio$AGENCY_WATER_AREA_NAME)
recfin_bio = recfin_bio[!recfin_bio$AGENCY_WATER_AREA_NAME %in% c("MEXICO (AREAB AND P1B IMPORT, CPFV)"),]
#Add area splits at 40`10`
recfin_bio$Areas = "north"
recfin_bio[recfin_bio$STATE_NAME=="CALIFORNIA" & !recfin_bio$COUNTY_NUMBER %in% c(15,23),"Areas"] = "south"

recfin_age = read.csv(file.path(dir, "data-raw","SD506--1984---2020_rec_ageing_lincod_pulled_4_19_21.csv"))
recfin_age$Areas = "north"

#These functions do not keep weight right. However, we dont need weight to be right for comps. Continue on. 
recfin_len_data = dataModerate2021::rename_recfin(data = recfin_bio,
                               area_grouping = list(c("south"),c("north")),
                               area_names = c("south", "north"),
                               area_column_name = "Areas",
                               mode_grouping = list(c("BEACH/BANK", "MAN-MADE/JETTY"), c("PARTY/CHARTER BOATS"), c("PRIVATE/RENTAL BOATS"), c("NOT KNOWN")),
                               mode_names = c("rec_shore", "rec_boat_charter", "rec_boat_private", "rec_unk"),
                               mode_column_name = "RECFIN_MODE_NAME" )

recfin_age_data = dataModerate2021::rename_recfin(data = recfin_age,
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
#Couldn't read in the excel so saved the relevant sheet as a csv and uploaded to google drive
# so others could use it as well!
#ca_mrfss_full = data.frame(readxl::read_excel(file.path(dir,"data-raw","mrfss_type_3_1980_2003_lingcod.xlsx"), sheet = "mrfss_type_3_1980_2003", na = "NA"))
ca_mrfss_full = read.csv(file.path(dir,"data-raw", "mrfss_type_3_1980_2003_lingcod.csv"))
ca_mrfss = ca_mrfss_full[ca_mrfss_full$ST == 6 & ca_mrfss_full$SP_CODE == 8827010201,]
# #Checked the 2003_... file and see it is only for 2003. These data are in the recfin pull so dont use
#ca_mrfss_2003_full = data.frame(readxl::read_excel(file.path(dir,"data-raw","2003_type_3d_Lingcod.xlsx"), sheet = "2003_type_3d_records_budrick", na = "NA"))
#ca_mrfss_2003 = ca_mrfss_2003_full[ca_mrfss_2003_full$SP_CODE == 8827010201,]
#Add in file outputted from "lingcod_recreational_CA_historical_len_setup.R"
cahist = read.csv(file.path(dir, "data-raw", "CA_rec_historical_length.csv"), header = TRUE)
cahist[which(cahist$Sex=="unk"),"Sex"] = "U"
#Add in CalPoly data
calpoly = data.frame(readxl::read_excel(file.path(dir,"data-raw","Cal Poly LCOD lengths.xlsx"), sheet = "cal poly lingcod lengths", na = "NULL"))
calpoly[which(calpoly$Sex=="m"),"Sex"] = "M"
calpoly[which(calpoly$Sex=="f"),"Sex"] = "F"
calpoly[is.na(calpoly$Sex),"Sex"] = "U"
calpoly$Data_Type = "RETAINED"
calpoly[which(calpoly$Fate %in% c("ra","RA","RD","RU")), "Data_Type"] = "RELEASED"


ca_mrfss = ca_mrfss[!is.na(ca_mrfss$CNTY), ] # remove records without a county
ncm = c(15, 23)
scm = unique(ca_mrfss[!ca_mrfss$CNTY %in% ncm, "CNTY"]) 
ca_mrfss$STATE_NAME = "CA"
ca_mrfss_data = dataModerate2021::rename_mrfss(data = ca_mrfss,
                             len_col = "LNGTH",
                             area_grouping = list(scm, ncm), 
                             area_names = c("south", "north"), 
                             area_column_name = "CNTY", 
                             mode_grouping = list(c(1,2), c(6), c(7)),
                             mode_names = c("rec_shore", "rec_boat_charter", "rec_boat_private"),
                             mode_column_name = "MODE_FX" )
#Dont need to convert based on LEN_FLAG have both fork length (LNGTH) and total length (T_LEN) fields


#Add variables to cahist needed to create common dataset in create_data_frame()
cahist$Year = cahist$YEAR
cahist$Lat = cahist$Lon = cahist$Areas = cahist$Depth = cahist$Age = cahist$Weight = NA
cahist$State = "CA"
cahist$State_Areas = "south"
cahist$Fleet = cahist$data
cahist$Source = "CA_Hist"

#Add variables to calPoly dataset to create common dataset in create_data_frame()
calpoly$Year = calpoly$year
calpoly$Lat = calpoly$Lon = calpoly$Areas = calpoly$Depth = calpoly$Age = calpoly$Weight = NA
calpoly$State = "CA"
calpoly$State_Areas = "south"
calpoly$Fleet = NA
calpoly$Source = "CalPoly"


###############
#Oregon
###############
#Zip "SPORT BIOLOGICAL" folder from Lingcod_2021>data-raw>oregon_sharedwithAliW>LINGCOD into data-raw folder in repository
or_recfin = read.csv(file.path(dir,"data-raw","RecFIN_LINGCOD_BIO-LW_2001-2020.csv"))
or_mrfss = data.frame(readxl::read_excel(file.path(dir,"data-raw","Lingcod_MRFSS BIO_1980 - 2003.xlsx"), sheet = "raw data", na = "NA"))
or_age = read.csv(file.path(dir,"data-raw","Oregon_LINGCOD_RecFIN_ages_1999-2019_nonconfid.csv"))

or_recfin_len_data = dataModerate2021::rename_recfin(data = or_recfin, 
                                   area_column_name = "STATE_NAME",
                                   area_grouping = list("OREGON"), 
                                   area_names = "north",
                                   mode_grouping = list(c("PARTY/CHARTER BOATS"), c("PRIVATE/RENTAL BOATS"), c("NOT KNOWN")),
                                   mode_names = c("rec_boat_charter", "rec_boat_private", "rec_unk"),
                                   mode_column_name = "RECFIN_MODE_NAME" )

or_mrfss$STATE_NAME = "OR"
or_mrfss_data = dataModerate2021::rename_mrfss(data = or_mrfss,
                             len_col = "Length",
                             area_grouping = list(484), 
                             area_names = c("north"),
                             area_column_name = "ORBS_SPP_Code", # This is essentially a cheat
                             mode_grouping = list(c(1,2), c(6), c(7)),
                             mode_names = c("rec_shore", "rec_boat_charter", "rec_boat_private"),
                             mode_column_name = "MRFSS_MODE_FX" )

or_recfin_age_data = dataModerate2021::rename_recfin(data = or_age, 
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
wa_recfin_sport = data.frame(readxl::read_excel(file.path(dir,"data-raw", "Lingcod_Coastal_Sport_05202021.xlsx"), sheet = "Coastal Sport"))
wa_recfin_sport$AGENCY_WEIGHT = NA #need this for rename_wa_recfin
wa_sport = dataModerate2021::rename_wa_recfin(wa_recfin_sport)

#Convert the 591 total length measurements to fork length based on Laidig (see github issue: https://github.com/iantaylor-NOAA/Lingcod_2021/issues/26)
wa_sport[which(wa_sport$length_type_name=="Total length"),"RECFIN_LENGTH_MM"] = wa_sport[which(wa_sport$length_type_name=="Total length"),"RECFIN_LENGTH_MM"]*0.981-0.521
               
wa_sport$STATE_NAME = "WA"
wa_sport_data = dataModerate2021::rename_recfin(data = wa_sport,
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
input_len[[8]] = cahist
input_len[[9]] = calpoly


#For age data, oregon age matches recfin_age so just use oregon
input_age = list()
input_age[[1]] = or_recfin_age_data
input_age[[2]] = wa_sport_data[which(wa_sport_data$Year<2021),]

############################################################################################
#	Create data frame with all the input data
############################################################################################
out = dataModerate2021::create_data_frame(data_list = input_len)

out_age = dataModerate2021::create_data_frame(data_list = input_age)


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

#Compare across non primary nodes in CA (for CA hist)
ggplot(out[out$Source == "CA_Hist",], aes(Length, fill = Fleet, color = Fleet)) + 
  facet_wrap(facets = c("Sex","State")) + 
  geom_density(alpha = 0.4, lwd = 0.8, adjust = 0.5)

#Compare across Sex in CA (for CA hist) by retained vs released fish
ggplot(out[out$Source == "CA_Hist",], aes(Length, fill = Data_Type, color = Data_Type)) + 
  facet_wrap(facets = c("Sex")) + 
  geom_density(alpha = 0.4, lwd = 0.8, adjust = 0.5)

#Compare across Sex in CA (for CalPoly) by retained vs released fish
ggplot(out[out$Source == "CalPoly",], aes(Length, fill = Data_Type, color = Data_Type)) + 
  facet_wrap(facets = c("Sex")) + 
  geom_density(alpha = 0.4, lwd = 0.8, adjust = 0.5)

#Compare across Source by retained vs released fish
#out[out$Source == "RecFIN_MRFSS", "Data_Type"] = "RETAINED"
grDevices::png(
  filename = file.path("figures", "CA_Lengths_Retained-ReleasedxSource.png"),
  width = 8, height = 6, units = "in", res = 300)
ggplot(out[out$State=="CA",], aes(Length, fill = Source, color = Source)) + 
  facet_wrap(facets = c("Data_Type", "Sex")) + 
  geom_density(alpha = 0.4, lwd = 0.8, adjust = 0.5)
grDevices::dev.off()

#Remove CalPoly data for lengths comps
out = out[which(out$Source != "CalPoly"),]

#Set aside data from DebWV because it uses both retained and released fish
#and has its own fleet. Then remove Deb data from the main dataset
out_deb = out[which(out$Fleet == "CPFV-Onboard Data"),] 
out = out[-which(out$Fleet == "CPFV-Onboard Data"),] 

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
lsubdir = file.path(dir, "data-raw", "lenComps", "Rec")
dir.create(file.path(lsubdir), showWarnings = FALSE, recursive = TRUE)

wa = out[which(out$State == "WA"), ]
wa$Length_cm = wa$Length

# create a table of the samples available by year
wa$Trawl_id = 1:nrow(wa)
nwfscSurvey::GetN.fn(dir = file.path(lsubdir), dat = wa, type = "length", species = 'others')
n = read.csv(file.path(lsubdir, "forSS", "length_SampleSize.csv"))
n = n[,c('Year', 'All_Fish', 'Sexed_Fish', 'Unsexed_Fish')]
write.csv(n, file = file.path(lsubdir, "wa_rec_samples.csv"), row.names = FALSE)

lfs = nwfscSurvey::UnexpandedLFs.fn(dir = file.path(lsubdir), #puts into "forSS" folder in this location
                       datL = wa, lgthBins = len_bin,
                       sex = 3,  partition = 0, fleet = get_fleet("Rec_WA")$num, month = 7)
file.rename(from = file.path(lsubdir, "forSS", paste0("Survey_notExpanded_Length_comp_Sex_0_bin=", min(len_bin), "-", max(len_bin), ".csv")), 
            to = file.path(lsubdir, paste0("north_WA_notExpanded_Length_comp_Sex_0_bin=", min(len_bin), "-", max(len_bin), ".csv"))) 
file.rename(from = file.path(lsubdir, "forSS", paste0("Survey_notExpanded_Length_comp_Sex_3_bin=", min(len_bin), "-", max(len_bin), ".csv")), 
            to = file.path(lsubdir, paste0("north_WA_notExpanded_Length_comp_Sex_3_bin=", min(len_bin), "-", max(len_bin), ".csv"))) 
#Remove forSS file
unlink(file.path(lsubdir,"forSS"), recursive=TRUE)

nwfscSurvey::PlotFreqData.fn(dir = file.path(lsubdir), 
                dat = lfs$comps, ylim=c(0, max(len_bin)+4), 
                main = "WA Recreational - Sexed", yaxs="i", ylab="Length (cm)", dopng = TRUE)
nwfscSurvey::PlotFreqData.fn(dir = file.path(lsubdir), 
                dat = lfs$comps_u, ylim=c(0, max(len_bin)+4), 
                main = "WA Recreational - Unsexed", yaxs="i", ylab="Length (cm)", dopng = TRUE)
nwfscSurvey::PlotSexRatio.fn(dir = file.path(lsubdir), dat = wa, data.type = "length", dopng = TRUE, main = paste( "WA North "))

#Save as .rdas. Combined for sex3 (first element) and unsexed (second element)
lenCompN_WA_Rec = lfs
usethis::use_data(lenCompN_WA_Rec, overwrite = TRUE)

#######
#Washington age comps
#######
asubdir = file.path(dir, "data-raw", "ageComps", "Rec")
dir.create(file.path(asubdir), showWarnings = FALSE, recursive = TRUE)

wa_age = out_age[which(out_age$State == "WA"), ]
wa_age$Trawl_id = 1:nrow(wa_age)

nwfscSurvey::GetN.fn(dir = file.path(asubdir), dat = wa_age, type = "age", species = 'others')
n = read.csv(file.path(asubdir, "forSS", "age_SampleSize.csv"))
n = n[,c('Year', 'All_Fish', 'Sexed_Fish', 'Unsexed_Fish')]
write.csv(n, file = file.path(asubdir, "wa_rec_age_samples.csv"), row.names = FALSE)

afs = nwfscSurvey::UnexpandedAFs.fn(dir = file.path(asubdir), #puts into "forSS" folder in this location
                       datA = wa_age, ageBins = age_bin,
                       sex = 3,  partition = 0, fleet = get_fleet("Rec_WA")$num, month = 7, ageErr = 1) #Fleet is 1 for WA
file.rename(from = file.path(asubdir, "forSS", paste0("Survey_notExpanded_Age_comp_Sex_0_bin=", min(age_bin), "-", max(age_bin), ".csv")), 
            to = file.path(asubdir, paste0("north_WA_notExpanded_Age_comp_Sex_0_bin=", min(age_bin), "-", max(age_bin), ".csv"))) 
file.rename(from = file.path(asubdir, "forSS", paste0("Survey_notExpanded_Age_comp_Sex_3_bin=", min(age_bin), "-", max(age_bin), ".csv")), 
            to = file.path(asubdir, paste0("north_WA_notExpanded_Age_comp_Sex_3_bin=", min(age_bin), "-", max(age_bin), ".csv"))) 
#Remove forSS file
unlink(file.path(asubdir,"forSS"), recursive=TRUE)

nwfscSurvey::PlotFreqData.fn(dir = file.path(asubdir), 
                dat = afs$comps, ylim=c(0, max(age_bin)+1), 
                main = "WA Recreational - Sexed", yaxs="i", ylab="Age", dopng = TRUE)
nwfscSurvey::PlotFreqData.fn(dir = file.path(asubdir), 
                dat = afs$comps_u, ylim=c(0, max(age_bin)+1), 
                main = "WA Recreational - Unsexed", yaxs="i", ylab="Age", dopng = TRUE)
nwfscSurvey::PlotSexRatio.fn(dir = file.path(asubdir), dat = wa_age, data.type = "age", dopng = TRUE, main = paste( "WA North "))

#Save as .rdas. Combined for sex3 (first element) and unsexed (second element)
ageCompN_WA_Rec = afs
usethis::use_data(ageCompN_WA_Rec, overwrite = TRUE)


#######
#Washington CAAL comps
#######
dir.create(file.path(getwd(),"data-raw","ageCAAL","Rec"), showWarnings = FALSE, recursive = TRUE)
#Exclude NA lengths
wa_CAAL = wa_age[!is.na(wa_age$Length),]
wa_CAAL$Len_Bin_FL = 2*floor(wa_CAAL$Length/2)
wa_CAAL$Ages = wa_CAAL$Age
ageCAAL_N_WA_Rec = create_caal_nonsurvey(Data = wa_CAAL, agebin = range(info_bins[["age"]]), lenbin = range(info_bins[["length"]]), wd = "data-raw/ageCAAL/Rec" ,
                                            append = "north_WA_Rec", seas = 7, fleet = get_fleet("Rec_WA")$num, partition = 0, ageEr = 1)
#Save as .rdas.
usethis::use_data(ageCAAL_N_WA_Rec, overwrite = TRUE)


############################################################################################
#	Oregon fleet recreational length and age comps
############################################################################################
or = out[which(out$State == "OR"), ]
or$Length_cm = or$Length

# create a table of the samples available by year
or$Trawl_id = 1:nrow(or)
nwfscSurvey::GetN.fn(dir = file.path(lsubdir), dat = or, type = "length", species = 'others')
n = read.csv(file.path(lsubdir, "forSS", "length_SampleSize.csv"))
n = n[,c('Year', 'All_Fish', 'Sexed_Fish', 'Unsexed_Fish')]
write.csv(n, file = file.path(lsubdir, "or_rec_samples.csv"), row.names = FALSE)

lfs = nwfscSurvey::UnexpandedLFs.fn(dir = file.path(lsubdir), #puts into "forSS" folder in this location
                       datL = or, lgthBins = len_bin,
                       sex = 3,  partition = 0, fleet = get_fleet("Rec_OR")$num, month = 7)
file.rename(from = file.path(lsubdir, "forSS", paste0("Survey_notExpanded_Length_comp_Sex_0_bin=", min(len_bin), "-", max(len_bin), ".csv")), 
            to = file.path(lsubdir, paste0("north_OR_notExpanded_Length_comp_Sex_0_bin=", min(len_bin), "-", max(len_bin), ".csv"))) 
file.rename(from = file.path(lsubdir, "forSS", paste0("Survey_notExpanded_Length_comp_Sex_3_bin=", min(len_bin), "-", max(len_bin), ".csv")), 
            to = file.path(lsubdir, paste0("north_OR_notExpanded_Length_comp_Sex_3_bin=", min(len_bin), "-", max(len_bin), ".csv"))) 
#Remove forSS file
unlink(file.path(lsubdir,"forSS"), recursive=TRUE)

nwfscSurvey::PlotFreqData.fn(dir = file.path(lsubdir), 
                dat = lfs$comps, ylim=c(0, max(len_bin)+4), 
                main = "OR Recreational - Sexed", yaxs="i", ylab="Length (cm)", dopng = TRUE)
nwfscSurvey::PlotFreqData.fn(dir = file.path(lsubdir), 
                dat = lfs$comps_u, ylim=c(0, max(len_bin)+4), 
                main = "OR Recreational - Unsexed", yaxs="i", ylab="Length (cm)", dopng = TRUE)
nwfscSurvey::PlotSexRatio.fn(dir = file.path(lsubdir), dat = or, data.type = "length", dopng = TRUE, main = paste( "OR North "))

#Save as .rdas. Combined for sex3 (first element) and unsexed (second element)
lenCompN_OR_Rec = lfs
usethis::use_data(lenCompN_OR_Rec, overwrite = TRUE)

#######
#Oregon age comps
#######
or_age = out_age[which(out_age$State == "OR"), ]
or_age$Trawl_id = 1:nrow(or_age)

nwfscSurvey::GetN.fn(dir = file.path(asubdir), dat = or_age, type = "age", species = 'others')
n = read.csv(file.path(asubdir, "forSS", "age_SampleSize.csv"))
n = n[,c('Year', 'All_Fish', 'Sexed_Fish', 'Unsexed_Fish')]
write.csv(n, file = file.path(asubdir, "or_rec_age_samples.csv"), row.names = FALSE)

afs = nwfscSurvey::UnexpandedAFs.fn(dir = file.path(asubdir), #puts into "forSS" folder in this location
                       datA = or_age, ageBins = age_bin,
                       sex = 3,  partition = 0, fleet = get_fleet("Rec_OR")$num, month = 7, ageErr = 1) #Fleet is 1 for WA
file.rename(from = file.path(asubdir, "forSS", paste0("Survey_notExpanded_Age_comp_Sex_0_bin=", min(age_bin), "-", max(age_bin), ".csv")), 
            to = file.path(asubdir, paste0("north_OR_notExpanded_Age_comp_Sex_0_bin=", min(age_bin), "-", max(age_bin), ".csv"))) 
file.rename(from = file.path(asubdir, "forSS", paste0("Survey_notExpanded_Age_comp_Sex_3_bin=", min(age_bin), "-", max(age_bin), ".csv")), 
            to = file.path(asubdir, paste0("north_OR_notExpanded_Age_comp_Sex_3_bin=", min(age_bin), "-", max(age_bin), ".csv"))) 
#Remove forSS file
unlink(file.path(asubdir,"forSS"), recursive=TRUE)

nwfscSurvey::PlotFreqData.fn(dir = file.path(asubdir), 
                dat = afs$comps, ylim=c(0, max(age_bin)+1), 
                main = "OR Recreational - Sexed", yaxs="i", ylab="Age", dopng = TRUE)
nwfscSurvey::PlotFreqData.fn(dir = file.path(asubdir), 
                dat = afs$comps_u, ylim=c(0, max(age_bin)+1), 
                main = "OR Recreational - Unsexed", yaxs="i", ylab="Age", dopng = TRUE)
nwfscSurvey::PlotSexRatio.fn(dir = file.path(asubdir), dat = or_age, data.type = "age", dopng = TRUE, main = paste( "OR North "))

#Save as .rdas. Combined for sex3 (first element) and unsexed (second element)
ageCompN_OR_Rec = afs
usethis::use_data(ageCompN_OR_Rec, overwrite = TRUE)


#######
#Oregon CAAL comps
#######
#Exclude NA lengths
or_CAAL = or_age[!is.na(or_age$Length),]
or_CAAL$Len_Bin_FL = 2*floor(or_CAAL$Length/2)
or_CAAL$Ages = or_CAAL$Age
ageCAAL_N_OR_Rec = create_caal_nonsurvey(Data = or_CAAL, agebin = range(info_bins[["age"]]), lenbin = range(info_bins[["length"]]), wd = "data-raw/ageCAAL/Rec" ,
                                         append = "north_OR_Rec", seas = 7, fleet = get_fleet("Rec_OR")$num, partition = 0, ageEr = 1)
#Save as .rdas.
usethis::use_data(ageCAAL_N_OR_Rec, overwrite = TRUE)

############################################################################################
#	California north fleet recreational length comps (there are no ages)
############################################################################################
ca = out[which(out$State == "CA" & out$State_Areas == "north"), ]
ca$Length_cm = ca$Length

# create a table of the samples available by year
ca$Trawl_id = 1:nrow(ca)
nwfscSurvey::GetN.fn(dir = file.path(lsubdir), dat = ca, type = "length", species = 'others')
n = read.csv(file.path(lsubdir, "forSS", "length_SampleSize.csv"))
n = n[,c('Year', 'All_Fish', 'Sexed_Fish', 'Unsexed_Fish')]
write.csv(n, file = file.path(lsubdir, "ca_north_rec_samples.csv"), row.names = FALSE)

lfs = nwfscSurvey::UnexpandedLFs.fn(dir = file.path(lsubdir), #puts into "forSS" folder in this location
                       datL = ca, lgthBins = len_bin,
                       sex = 3,  partition = 0, fleet = get_fleet("Rec_CA")$num, month = 7)
file.rename(from = file.path(lsubdir, "forSS", paste0("Survey_notExpanded_Length_comp_Sex_0_bin=", min(len_bin), "-", max(len_bin), ".csv")), 
            to = file.path(lsubdir, paste0("north_CA_notExpanded_Length_comp_Sex_0_bin=", min(len_bin), "-", max(len_bin), ".csv"))) 
file.rename(from = file.path(lsubdir, "forSS", paste0("Survey_notExpanded_Length_comp_Sex_3_bin=", min(len_bin), "-", max(len_bin), ".csv")), 
            to = file.path(lsubdir, paste0("north_CA_notExpanded_Length_comp_Sex_3_bin=", min(len_bin), "-", max(len_bin), ".csv"))) 
#Remove forSS file
unlink(file.path(lsubdir,"forSS"), recursive=TRUE)

nwfscSurvey::PlotFreqData.fn(dir = file.path(lsubdir), 
                dat = lfs$comps, ylim=c(0, max(len_bin)+4), 
                main = "CA North Recreational - Sexed", yaxs="i", ylab="Length (cm)", dopng = TRUE)
nwfscSurvey::PlotFreqData.fn(dir = file.path(lsubdir), 
                dat = lfs$comps_u, ylim=c(0, max(len_bin)+4), 
                main = "CA North Recreational - Unsexed", yaxs="i", ylab="Length (cm)", dopng = TRUE)
nwfscSurvey::PlotSexRatio.fn(dir = file.path(lsubdir), dat = ca, data.type = "length", dopng = TRUE, main = paste( "CA North "))

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
nwfscSurvey::GetN.fn(dir = file.path(lsubdir), dat = ca, type = "length", species = 'others')
n = read.csv(file.path(lsubdir, "forSS", "length_SampleSize.csv"))
n = n[,c('Year', 'All_Fish', 'Sexed_Fish', 'Unsexed_Fish')]
write.csv(n, file = file.path(lsubdir, "ca_south_rec_samples.csv"), row.names = FALSE)

lfs = nwfscSurvey::UnexpandedLFs.fn(dir = file.path(lsubdir), #puts into "forSS" folder in this location
                       datL = ca, lgthBins = len_bin,
                       sex = 3,  partition = 0, fleet = get_fleet("Rec_CA")$num, month = 7)
file.rename(from = file.path(lsubdir, "forSS", paste0("Survey_notExpanded_Length_comp_Sex_0_bin=", min(len_bin), "-", max(len_bin), ".csv")), 
            to = file.path(lsubdir, paste0("south_CA_notExpanded_Length_comp_Sex_0_bin=", min(len_bin), "-", max(len_bin), ".csv"))) 
file.rename(from = file.path(lsubdir, "forSS", paste0("Survey_notExpanded_Length_comp_Sex_3_bin=", min(len_bin), "-", max(len_bin), ".csv")), 
            to = file.path(lsubdir, paste0("south_CA_notExpanded_Length_comp_Sex_3_bin=", min(len_bin), "-", max(len_bin), ".csv"))) 
#Remove forSS file
unlink(file.path(lsubdir,"forSS"), recursive=TRUE)

nwfscSurvey::PlotFreqData.fn(dir = file.path(lsubdir), 
                dat = lfs$comps, ylim=c(0, max(len_bin)+4), 
                main = "CA South Recreational - Sexed", yaxs="i", ylab="Length (cm)", dopng = TRUE)
nwfscSurvey::PlotFreqData.fn(dir = file.path(lsubdir), 
                dat = lfs$comps_u, ylim=c(0, max(len_bin)+4), 
                main = "CA South Recreational - Unsexed", yaxs="i", ylab="Length (cm)", dopng = TRUE)
nwfscSurvey::PlotSexRatio.fn(dir = file.path(lsubdir), dat = ca, data.type = "length", dopng = TRUE, main = paste( "CA South "))

#Save as .rdas. Combined for sex3 (first element) and unsexed (second element)
lenCompS_CA_Rec = lfs
usethis::use_data(lenCompS_CA_Rec, overwrite = TRUE)


############################################################################################
#	DebWV recreational length comps (Southern California)
############################################################################################
out_deb$Length_cm = out_deb$Length

# create a table of the samples available by year
out_deb$Trawl_id = 1:nrow(out_deb)
nwfscSurvey::GetN.fn(dir = file.path(lsubdir), dat = out_deb, type = "length", species = 'others')
n = read.csv(file.path(lsubdir, "forSS", "length_SampleSize.csv"))
n = n[,c('Year', 'All_Fish', 'Sexed_Fish', 'Unsexed_Fish')]
write.csv(n, file = file.path(lsubdir, "debHist_samples.csv"), row.names = FALSE)

lfs = nwfscSurvey::UnexpandedLFs.fn(dir = file.path(lsubdir), #puts into "forSS" folder in this location
                                    datL = out_deb, lgthBins = len_bin,
                                    sex = 0,  partition = 0, fleet = get_fleet("CPFV_DebWV")$num, month = 7)
file.rename(from = file.path(lsubdir, "forSS", paste0("Survey_notExpanded_Length_comp_Sex_0_bin=", min(len_bin), "-", max(len_bin), ".csv")), 
            to = file.path(lsubdir, paste0("debHist_notExpanded_Length_comp_Sex_0_bin=", min(len_bin), "-", max(len_bin), ".csv"))) 
#Remove forSS file
unlink(file.path(lsubdir,"forSS"), recursive=TRUE)

nwfscSurvey::PlotFreqData.fn(dir = file.path(lsubdir), 
                             dat = lfs$comps, ylim=c(0, max(len_bin)+4), 
                             main = "debHist - Unsexed", yaxs="i", ylab="Length (cm)", dopng = TRUE)

#Save as .rdas. Combined for sex3 (first element) and unsexed (second element)
lenCompS_debHist = lfs
usethis::use_data(lenCompS_debHist, overwrite = TRUE)


ignore <- file.copy(
  dir(dir("data-raw", pattern = "lenComps", full.names = TRUE),
      pattern = c("Rec.+\\.png"), recursive = TRUE, full.names = TRUE
  ),
  "figures"
)

