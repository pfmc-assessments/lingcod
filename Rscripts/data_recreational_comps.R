############################################################################################
#	Recreational data-processing for lingcod 2027
#
#	Based on using recfintools package, so much simpler than 2021 cycle
#
# Created by Brian Langseth
############################################################################################
#Questions:
#1. Do we need CAAL? Previous assessment did not do it. [Not at this time - From 2021]
#2. What to do with released fish? Set partition to be separate for each? [Exclude released. SS3 assumes partition 0 even if use partition 2 because dont have separate comps]
#May need to revisit this with how we model discards
#3. What about the 0.2 cm fish in CA 2003? [Exclude]
#4. Fleet timings (7), numbers (WA = 3, OR = 4, CA = 5), age error (1) DONE

#Notable changes from last assessment
#1. Using PORT GROUP to splint N/S of 40'10 where previously was COUNTY NUMBER.
#Assigns some Humboldt county records to South area now. About 20% of north records
#now assigned to south.

#TODOs:
#Will fill in later


#Install the recfintools package from github
remotes::install_github("pfmc-assessments/recfintools")
library(recfintools)

#Load all lingcod package files
devtools::load_all()

#Folder where the lingcod git repository is on computer
dir = getwd()

#Length bins for north and south
len_bin = info_bins[["length"]]
age_bin = info_bins[["age"]]

############################################################################################
#	Load Data
############################################################################################

#Load all rec catch and comp data. This script uses only comps, so focus on files 
# with BDS in them: 
# bds_recent_len - SD501 (recent years of recfin lengths), 
# bds_recent_age - SD506 (recent years of recfin ages), and
# bds_mrfss - SD517 (mrfss type 3 bds data).
recfintools::readData(path = file.path(dir, "data-raw", "Recreational"), species = "LINGCOD", verbose = TRUE)
rm(list = c("catch_hist", "catch_mrfss", "catch_recent"))

#TODO: add in standardized sex column

#Clean each file - but keep in records flagged for removal (using clean = FALSE)
#so can see what records clean_bds suggests should be removed. 
bds_recent_len <- recfintools::clean_bds(data = bds_recent_len, clean = FALSE, verbose = TRUE)
bds_recent_age <- recfintools::clean_bds(data = bds_recent_age, clean = FALSE, verbose = TRUE)
bds_mrfss <- recfintools::clean_bds(data = bds_mrfss, clean = FALSE, verbose = TRUE)

#Explorations throughout this script were done with the code above, where clean = FALSE. 
#but could also run with clean = TRUE (like below) to remove all the riffraff. 
# bds_recent_len <- recfintools::clean_bds(data = bds_recent_len, clean = TRUE, verbose = TRUE)
# bds_recent_age <- recfintools::clean_bds(data = bds_recent_age, clean = TRUE, verbose = TRUE)
# bds_mrfss <- recfintools::clean_bds(data = bds_mrfss, clean = TRUE, verbose = TRUE)


#TODO: add in historical access files to our google drive. These are files used in the setup
#script. Wait for MOA before doing. 

#Reuse the historial CA rec datasets from 2021 model
#Add file outputted from "lingcod_recreational_CA_historical_len_setup" which I
#renamed "data_recreational_CA_historical_len_setup.R"
cahist = read.csv(file.path(dir, "data-raw", "Recreational", "CA_rec_historical_length.csv"), header = TRUE)
#Add in CalPoly data
calpoly = data.frame(readxl::read_excel(file.path(dir,"data-raw", "Recreational", "Cal Poly LCOD lengths.xlsx"), sheet = "cal poly lingcod lengths", na = "NULL"))


############################################################################################
#	Data Processing
############################################################################################

###############
#General Recfin Processing
###############

##
#Lengths
##

#Fish from Mexico are flagged for removal? Yes!
table(bds_recent_len$AGENCY_WATER_AREA_NAME, bds_recent_len$remove)
#Unknown "area" records in AGENCY_WATER_AREA_NAME are mostly WA Puget Sound/Canada Records, per AGENCY_FISHED_AREA_NAME
table(bds_recent_len$AGENCY_FISHED_AREA_NAME, bds_recent_len$remove, bds_recent_len$state)
#Records removed due to years are Oregon records in 1999-2000 (overlap with MRFSS)
table(bds_recent_len$year, bds_recent_len$remove, bds_recent_len$state)
#Also note that removing WA Puget Sound areas functionally removes 1982-1985 for WA

#Add area splits at 40`10`
bds_recent_len$stock <- "north"
#2021 report says shelter cove (humboldt county but wine port group) landings 
#assigned to wine only started in 2008. But data shows bds records before that
#because RecFIN automatically makes the correction for all years. 
table(bds_recent_len[bds_recent_len$state == "CA",]$COUNTY_NUMBER, 
      bds_recent_len[bds_recent_len$state == "CA",]$RECFIN_PORT_NAME, 
      bds_recent_len[bds_recent_len$state == "CA",]$year, useNA = "always")
#Rather than filter based on county (15 and 23 = north) go with port group. Confirmed
#with CDFW this is the way to go. See github issue #240
bds_recent_len[bds_recent_len$state %in% "CA" & 
                 !grepl("redwood", bds_recent_len$RECFIN_PORT_NAME, ignore.case = TRUE), "stock"] = "south"


#Convert Washington total lengths (only ones we know are total) to fork
#This was done in 2021 (for 591 records) so keeping the same approach. 
#With new data now have 616 records that will be used with total length 
#Conversions based on Laidig (see github issue: https://github.com/pfmc-assessments/lingcod/issues/26)
table(bds_recent_len$RECFIN_LENGTH_TYPE, bds_recent_len$state, bds_recent_len$remove)
# temp <- bds_recent_len[bds_recent_len$RECFIN_LENGTH_TYPE == "TOTAL",]
# plot(temp$length_cm, temp$length_cm*0.981-0.521)
# abline(0,1)
bds_recent_len[bds_recent_len$RECFIN_LENGTH_TYPE %in% c("TOTAL"), "length_cm"] <-
  bds_recent_len[bds_recent_len$RECFIN_LENGTH_TYPE %in% c("TOTAL"), "length_cm"]*0.981-0.521


#Add field for whether retained or released
table(bds_recent_len$IS_RETAINED, useNA="always")
bds_recent_len <- bds_recent_len |>
  dplyr::mutate(
    disp = dplyr::if_else(
      IS_RETAINED %in% "RELEASED", "released", "retained")
  )

#Add source field
bds_recent_len$source <- "recfin"

#Add sex field - set 'N' which is not measured to 'U' (unknown)
table(bds_recent_len$RECFIN_SEX_CODE, useNA="always")
bds_recent_len <- bds_recent_len |>
  dplyr::mutate(
    sex = dplyr::if_else(
      RECFIN_SEX_CODE %in% c("N", NA), "U", RECFIN_SEX_CODE)
  )

##
#Ages
##

#No Puget Sound? Correct!
table(bds_recent_age$year, bds_recent_age$remove, bds_recent_age$state)
table(bds_recent_age$SURVEY_PROGRAM_CATCH_AREA_NAME, bds_recent_age$remove)
table(bds_recent_age$RECFIN_CATCH_AREA_NAME, bds_recent_age$remove)

#Only records from Oregon and Washington so all north
bds_recent_age$stock <- "north"

#Fish with multiple reads are flagged for removal because otherwise each read
#would count as a separate fish. Currently, only the first read is duplicated. 
#This happens for 27 records (54 fish with multiple reads, all in OR), and of these
#5 fish have multiple reads with different ages. I am ok with this decision. 
temp = bds_recent_age[bds_recent_age$MULTIPLE_READS %in% "Y",]
table(temp$MULTIPLE_READS, temp$remove)
table(temp$SAMPLE_ID, temp$USE_THIS_AGE)

#Add field for whether retained or released
bds_recent_age$disp = "retained"

#Add source field
bds_recent_age$source <- "recfin"

#Add sex field 
table(bds_recent_age$RECFIN_SEX_CODE, useNA="always")
bds_recent_age <- bds_recent_age |>
  dplyr::mutate(
    sex = dplyr::if_else(
      RECFIN_SEX_CODE %in% c(NA), "U", RECFIN_SEX_CODE)
  )

#Add age column
bds_recent_age$age <- bds_recent_age$USE_THIS_AGE

#TODO: have recfintools::getAge() add this automatically

#Add standardized length column to ages for CAAL processing. As done for length
#dataset, convert Washington total lengths to fork lengths. In the age data
#LENGTH_TYPE is read in as TRUE when its total, and FALSE, when its fork.
bds_recent_age$length_cm <- bds_recent_age$RECFIN_LENGTH_MM/10
table(bds_recent_age$LENGTH_TYPE, bds_recent_age$state)
bds_recent_age[bds_recent_age$LENGTH_TYPE %in% c(TRUE), "length_cm"] <-
  bds_recent_age[bds_recent_age$LENGTH_TYPE %in% c(TRUE), "length_cm"]*0.981-0.521


###############
#General MRFSS Processing
###############

#Fish from mexico are flagged for removal
table(bds_mrfss$AREA_NAME, bds_mrfss$remove)
#Washington does not use mrfss data so all WA data also flagged for removal
table(bds_mrfss$AREA_NAME, bds_mrfss$remove, bds_mrfss$state)

#Add field for whether retained or released
table(bds_mrfss$DISP3_DESCRIPTION, bds_mrfss$DISP3, bds_mrfss$state, useNA="always")
bds_mrfss <- bds_mrfss |>
  dplyr::mutate(
    disp = dplyr::if_else(
      DISP3 %in% c(2, 6), "released", "retained")
  )
#TODO: Confirm with Budrick that 2 and 6 are the only releases. There are not many (only 20)

#Add source field
bds_mrfss$source <- "mrfss"

#Add sex field 
table(bds_mrfss$F_SEX, useNA="always")
bds_mrfss <- bds_mrfss |>
  dplyr::mutate(
    sex = dplyr::case_when(
      F_SEX %in% 1 ~ "M",
      F_SEX %in% 2 ~ "F",
      TRUE ~ "U")
  )

#TODO: Confirm with Budrick and F_Sex = 3, 4, and 8 are indeed unknown. 3 and 4  
#are from Oregon. 


##
#California MRFSS data
##

#Previous, all records in CA without a CNTY were removed. There are some INTSITE
#records among these but INTSITE is not unique to CNTY. Thus not usable.
#Subregion also not helpful because plenty of non N 40'10 are "Northern California"
table(bds_mrfss$CNTY, bds_mrfss$SUB_REG_NAME)
bds_mrfss <- bds_mrfss[!(bds_mrfss$state == "CA" & is.na(bds_mrfss$CNTY)), ]

#TODO: Confirm with Budrick that CNTY = NA records in CA should be removed because 
#cant distinguish N/S of 40'10

#Add area splits at 40`10`
bds_mrfss$stock <- "north"
bds_mrfss[bds_mrfss$state == "CA" & !bds_mrfss$CNTY %in% c(15,23), "stock"] <- "south"

#TODO: Resolve the issue with DebWV data possibly being in MRFSS data. Dont 
#want to use duplicative data. 


###############
#California Historical Processing 
###############

#Same as for 2021 assessment but with slight changes to variable names and 
#adding in mode. 

#Add variables to cahist needed to create common dataset
cahist$year <- cahist$YEAR
cahist$state <- "CA"
cahist$stock <- "south"
cahist$source <- paste("ca_hist", cahist$data)
cahist$sex <- cahist$Sex
cahist[which(cahist$Sex %in% c(NA, "unk")), "sex"] <- "U"
cahist$length_cm <- cahist$Length
cahist$disp <- tolower(cahist$Data_Type)
#Added for 2027 assessment based on looking at the access database files
cahist <- cahist |>
  dplyr::mutate(
    mode = dplyr::case_when(
      data %in% c("CPFV-Onboard Data", "CPFV", "86-88 Data", "CCRS_LF_77-86", "FPB_LF_59-72") ~ "PC",
      data %in% c("Skiff_LF_59-72") ~ "PR",
      TRUE ~ "Unk"
    )
  )

#Add variables to calPoly dataset to create common dataset
calpoly$year <- calpoly$year
calpoly$state <- "CA"
calpoly$stock <- "south"
calpoly$source <- "calPoly"
calpoly$sex <- calpoly$Sex
calpoly[which(calpoly$Sex %in% "m"), "sex"] <- "M"
calpoly[which(calpoly$Sex %in% "f"), "sex"] <- "F"
calpoly[is.na(calpoly$Sex), "sex"] <- "U"
calpoly$disp = "retained"
calpoly[which(calpoly$Fate %in% c("ra","RA","RD","RU")), "disp"] = "released"
calpoly$mode <- "PC" #TODO: Need to confirm this.
calpoly$length_cm <- calpoly$Length 

#TODO: Need to add mode to calPoly. Confirm with Melissa which it is.


###############
# Put all the data into one list
###############

#Here are the years of the data available

#Washington lengths and ages: 1985-current (recent) 
#Oregon lengths: 1980-2000 (mrfss), 2001-current (recent)
#Oregon ages: 1999-current (recent)
#California lengths: 1980-2003 (mrfss), 2003-current (recent), the 2003 overlap in recent
#is because there were type 3d records of released CPFV for 2003 and they are in 
#recent data 
table(bds_recent_len$year, bds_recent_len$state, bds_recent_len$remove)
table(bds_recent_age$year, bds_recent_age$state, bds_recent_age$remove)
table(bds_mrfss$year, bds_mrfss$state, bds_mrfss$remove)

len_fields <- c("year", "state", "stock", "mode", "sex", "length_cm", "disp", "source")
age_fields <- c("year", "state", "stock", "mode", "sex", "age", "length_cm", "disp", "source")

####
#Remove records that recfintools flags for removal (i.e. remove != no) 
####
out <- rbind(bds_recent_len[bds_recent_len$remove %in% "no", len_fields],
             bds_mrfss[bds_mrfss$remove %in% "no", len_fields],
             cahist[, len_fields],
             calpoly[, len_fields])

out_age = bds_recent_age[bds_recent_age$remove %in% "no", age_fields]


############################################################################################
# Clean up the data
############################################################################################

###############
# Clean up lengths
###############

#Remove any data without valid lengths - only occurs from cahist datasets
print(paste("Removed",sum(is.na(out$length_cm)), "records without any length"))
out = out[!is.na(out$length_cm),]

# Now lets do a check to filter out any anomalous lengths
remove = which(out$length_cm > 200 | out$length_cm < 8) 
out[remove,]
#         year state stock mode sex  length_cm     disp source
# 74853   2008    CA south   PR   U   6.300000 retained recfin
# 87250   2009    CA south   PR   U 678.600000 retained recfin
# 1596810 2003    CA south   PR   U   0.200000 retained  mrfss
# 1772010 1980    CA south   PR   U   6.308885 retained  mrfss
print(paste("Removed",length(remove)-2, "records with lengths > 200 cm and < 1 cm"))
out = out[-remove[c(2,3)], ]

#-------Exploratory length figures

#Compare retained and released fish
ggplot(out, aes(length_cm, fill = disp, color = disp)) + 
  facet_wrap(facets = c("sex","state")) + 
  geom_density(alpha = 0.4, lwd = 0.8, adjust = 0.5)

#Samples sizes show releases are either recfin or historical california, and PC
table(out$source, out$disp)
table(out$source, out$disp, out$mode)
ggplot(out, aes(length_cm, fill = disp, color = disp)) + 
  facet_wrap(facets = c("sex","mode")) + 
  geom_density(alpha = 0.4, lwd = 0.8, adjust = 0.5)
table(out$year, out$disp) #releases since 2003 but pretty consistent over time

#Compare across primary modes
ggplot(out[out$mode %in% c("PR", "PC", "Other"),], aes(length_cm, fill = mode, color = mode)) + 
  facet_wrap(facets = c("sex","state")) + 
  geom_density(alpha = 0.4, lwd = 0.8, adjust = 0.5)
#The slight differences between charter and private are mostly with released fish
temp = out[out$disp=="retained",]
ggplot(temp[temp$mode %in% c("PR", "PC", "Other"),], aes(length_cm, fill = mode, color = mode)) + 
  facet_wrap(facets = c("sex","state")) + 
  geom_density(alpha = 0.4, lwd = 0.8, adjust = 0.5)
#Very few "other" gear so can just remove that and replot - Shows PC and PR are similar
table(out$source, out$mode) 
ggplot(out[out$mode %in% c("PR", "PC"),], aes(length_cm, fill = mode, color = mode)) + 
  facet_wrap(facets = c("sex","state")) + 
  geom_density(alpha = 0.4, lwd = 0.8, adjust = 0.5)
ggplot(out[out$mode %in% c("PR", "PC"),], aes(length_cm, fill = mode, color = mode)) + 
  facet_wrap(facets = c("state", "stock")) + 
  geom_density(alpha = 0.4, lwd = 0.8, adjust = 0.5)
#If show only retained fish then difference between PC and PR even less
ggplot(temp[temp$mode %in% c("PR", "PC"),], aes(length_cm, fill = mode, color = mode)) + 
  facet_wrap(facets = c("state", "stock")) + 
  geom_density(alpha = 0.4, lwd = 0.8, adjust = 0.5)

#Sample sizes between PR and PC
table(out$mode, out$state, out$stock)

#Compare lengths by state - Pretty similar based on state
ggplot(out[out$mode %in% c("PR", "PC"),], aes(length_cm, fill = state, color = state)) + 
  facet_wrap(facets = c("mode", "stock")) + 
  geom_density(alpha = 0.4, lwd = 0.8, adjust = 0.5)

#Compare across primary modes in CA (for CA hist)
ggplot(out[grepl("ca_hist", out$source),], aes(length_cm, fill = mode, color = mode)) + 
  #facet_wrap(facets = c("sex","state")) + 
  geom_density(alpha = 0.4, lwd = 0.8, adjust = 0.5)

#Compare across Sex in CA (for CA hist) by retained vs released fish
#Given that released is only for unknown sex, comparison by sex is not worthwhile
ggplot(out[grepl("ca_hist", out$source),], aes(length_cm, fill = disp, color = disp)) + 
  facet_wrap(facets = c("sex")) + 
  geom_density(alpha = 0.4, lwd = 0.8, adjust = 0.5)

#Compare across Sex in CA (for CalPoly) by retained vs released fish
ggplot(out[grepl("calPoly", out$source),], aes(length_cm, fill = disp, color = disp)) + 
  facet_wrap(facets = c("sex")) + 
  geom_density(alpha = 0.4, lwd = 0.8, adjust = 0.5)

#Compare across Source by retained vs released fish
#out[out$Source == "RecFIN_MRFSS", "Data_Type"] = "RETAINED"
# grDevices::png(
#   filename = file.path(getwd(), "data_output", "Recreational", 
#                        "CA_Lengths_Retained-ReleasedxSource.png"),
#   width = 8, height = 6, units = "in", res = 300)
ggplot(out[out$state=="CA",], aes(length_cm, fill = source, color = source)) + 
  facet_wrap(facets = c("disp", "sex")) + 
  geom_density(alpha = 0.4, lwd = 0.8, adjust = 0.5)
# grDevices::dev.off()

#--------- exploratory figures done. Add more later as needed.

# Remove released fish
print(paste("Removed",length(which(out$disp == "released")), "released records"))
out = out[out$disp %in% c("retained"), ]

#Remove CalPoly data for lengths comps - TODO: Confirm with Melissa
out = out[-grep("calPoly", out$source),]

#Set aside data from DebWV because it uses both retained and released fish
#and has its own fleet. Then remove Deb data from the main dataset
out_deb = out[which(out$source %in% "ca_hist CPFV-Onboard Data"),] 
out = out[-which(out$source %in% "ca_hist CPFV-Onboard Data"),] 

#TO DO: figure out wehther deb data is within mrfss


###############
# Clean up ages
###############

#Remove any data without valid ages
print(paste("Removed",sum(is.na(out_age$age)), "records without any ages"))
out_age = out_age[!is.na(out_age$age),]

# Now lets do a check to filter out any anomalous ages
range(out_age$age, na.rm=TRUE)
#Have a very old fish (111 years!)
remove = which(out_age$age > 50 | out_age$age < 1) 
out_age[remove,]
#       year state stock mode sex age     disp source
# 52999 2023    WA north   PC   F 111 retained recfin
#Find out more details. 
bds_recent_age[which(bds_recent_age$USE_THIS_AGE > 50),]
print(paste("Removed",length(remove), "records with age > 50"))
out_age = out_age[-remove, ]
#I let Fabio know about this, and it may be corrected in the future. 

#Any odd lengths for CAAL processing using the same ranges as for length data? Nope
remove = which(out_age$length_cm > 200 | out_age$length_cm < 8) 
out_age[remove,]


############################################################################################
#------------------------------------------------------------------------------------------#
#
# Generate compositions for lengths and ages and caal for each rec fleet
#
#------------------------------------------------------------------------------------------#
############################################################################################

# Set up directories of where to save

subdirl = file.path(getwd(), "data_output", "Recreational", "lenComps")
if(!dir.exists(subdirl)){
  dir.create(file.path(subdirl), showWarnings = FALSE, recursive = TRUE)
}
subdira = file.path(getwd(), "data_output", "Recreational", "ageComps")
if(!dir.exists(subdira)){
  dir.create(file.path(subdira), showWarnings = FALSE, recursive = TRUE)
}

#########
#Length comps
#########

# Assign to month 7 since this is an annual model where expected size 
# distributions will only be calculated at beginning and middle of the year

##
#Washington
##
lfs_wa <- nwfscSurvey::get_raw_comps(
  data = out |> dplyr::filter(state %in% "WA"),
  comp_bins = len_bin,
  comp_column_name = "length_cm",
  input_n_method = "total_samples",
  month = 7,
  fleet = get_fleet("Rec_WA")$num,
  dir = subdirl
)

#Add plots
nwfscSurvey::plot_comps(data = lfs_wa$sexed, dir = subdirl)
nwfscSurvey::plot_comps(data = lfs_wa$unsexed, dir = subdirl)
nwfscSurvey::plot_sex_ratio(
  data = out |> dplyr::filter(state %in% "WA"), 
  dir = subdirl
)

#Rename files to make clear these are WA by adding WA_rec at end, but make 
#sure files already with a prefix aren't changed.
f <- list.files(subdirl, pattern = "length_", full.names = TRUE)
f <- grep(pattern = "Deb_rec|CA_S_rec|CA_N_rec|OR_rec|WA_rec", x = f, invert = TRUE, value = TRUE)
file.rename(
  f,
  file.path(subdirl, sub("\\.", "_WA_rec.", basename(f)))
)

lenCompN_WA_Rec = lfs_wa
usethis::use_data(lenCompN_WA_Rec, overwrite = TRUE)


##
#Oregon
##
lfs_or <- nwfscSurvey::get_raw_comps(
  data = out |> dplyr::filter(state %in% "OR"),
  comp_bins = len_bin,
  comp_column_name = "length_cm",
  input_n_method = "total_samples",
  month = 7,
  fleet = get_fleet("Rec_OR")$num,
  dir = subdirl
)

#Add plots
nwfscSurvey::plot_comps(data = lfs_or$sexed, dir = subdirl)
nwfscSurvey::plot_comps(data = lfs_or$unsexed, dir = subdirl)
nwfscSurvey::plot_sex_ratio(
  data = out |> dplyr::filter(state %in% "OR"), 
  dir = subdirl
)

#Rename files to make clear these are OR by adding OR_rec at end
f <- list.files(subdirl, pattern = "length_", full.names = TRUE)
f <- grep(pattern = "Deb_rec|CA_S_rec|CA_N_rec|OR_rec|WA_rec", x = f, invert = TRUE, value = TRUE)
file.rename(
  f,
  file.path(subdirl, sub("\\.", "_OR_rec.", basename(f)))
)

lenCompN_OR_Rec = lfs_or
usethis::use_data(lenCompN_OR_Rec, overwrite = TRUE)


##
#California North
##
lfs_caN <- nwfscSurvey::get_raw_comps(
  data = out |> dplyr::filter(state %in% "CA", stock %in% "north"),
  comp_bins = len_bin,
  comp_column_name = "length_cm",
  input_n_method = "total_samples",
  month = 7,
  fleet = get_fleet("Rec_CA")$num,
  dir = subdirl
)

#Add plots
nwfscSurvey::plot_comps(data = lfs_caN$sexed, dir = subdirl)
nwfscSurvey::plot_comps(data = lfs_caN$unsexed, dir = subdirl)
nwfscSurvey::plot_sex_ratio(
  data = out |> dplyr::filter(state %in% "CA", stock %in% "north"), 
  dir = subdirl
)

#Rename files to make clear these are CA by adding CA_N_rec at end
f <- list.files(subdirl, pattern = "length_", full.names = TRUE)
f <- grep(pattern = "Deb_rec|CA_S_rec|CA_N_rec|OR_rec|WA_rec", x = f, invert = TRUE, value = TRUE)
file.rename(
  f,
  file.path(subdirl, sub("\\.", "_CA_N_rec.", basename(f)))
)

lenCompN_CA_Rec = lfs_caN
usethis::use_data(lenCompN_CA_Rec, overwrite = TRUE)


##
#California South
##
lfs_caS <- nwfscSurvey::get_raw_comps(
  data = out |> dplyr::filter(state %in% "CA", stock %in% "south"),
  comp_bins = len_bin,
  comp_column_name = "length_cm",
  input_n_method = "total_samples",
  month = 7,
  fleet = get_fleet("Rec_CA")$num,
  dir = subdirl
)

#Add plots
nwfscSurvey::plot_comps(data = lfs_caS$sexed, dir = subdirl)
nwfscSurvey::plot_comps(data = lfs_caS$unsexed, dir = subdirl)
nwfscSurvey::plot_sex_ratio(
  data = out |> dplyr::filter(state %in% "CA", stock %in% "south"), 
  dir = subdirl
)

#Rename files to make clear these are CA by adding CA_S_rec at end
f <- list.files(subdirl, pattern = "length_", full.names = TRUE)
f <- grep(pattern = "Deb_rec|CA_S_rec|CA_N_rec|OR_rec|WA_rec", x = f, invert = TRUE, value = TRUE)
file.rename(
  f,
  file.path(subdirl, sub("\\.", "_CA_S_rec.", basename(f)))
)

lenCompS_CA_Rec = lfs_caS
usethis::use_data(lenCompS_CA_Rec, overwrite = TRUE)


##
#Deb WV
##
lfs_deb <- nwfscSurvey::get_raw_comps(
  data = out_deb,
  comp_bins = len_bin,
  comp_column_name = "length_cm",
  input_n_method = "total_samples",
  month = 7,
  fleet = get_fleet("DebWV")$num,
  dir = subdirl
)

#Add plots - only unsexed for this dataset
nwfscSurvey::plot_comps(data = lfs_deb$unsexed, dir = subdirl)

#Rename files to make clear these are Deb by adding Deb at end
f <- list.files(subdirl, pattern = "length_", full.names = TRUE)
f <- grep(pattern = "Deb_rec|CA_S_rec|CA_N_rec|OR_rec|WA_rec", x = f, invert = TRUE, value = TRUE)
file.rename(
  f,
  file.path(subdirl, sub("\\.", "_Deb_rec.", basename(f)))
)

lenCompS_Deb = lfs_deb
usethis::use_data(lenCompS_Deb, overwrite = TRUE)




#########
#Age comps
#########


##
#Washington
##

afs_wa <- nwfscSurvey::get_raw_comps(
  data = out_age |> dplyr::filter(state %in% "WA"),
  comp_bins = age_bin,
  comp_column_name = "age",
  input_n_method = "total_samples",
  month = 7,
  fleet = get_fleet("Rec_WA")$num,
  dir = subdira,
  ageerr = 1
)

#Add plots
nwfscSurvey::plot_comps(data = afs_wa$sexed, dir = subdira)
nwfscSurvey::plot_comps(data = afs_wa$unsexed, dir = subdira)
nwfscSurvey::plot_sex_ratio(
  data = out_age |> dplyr::filter(state %in% "WA"), 
  comp_column_name = "age",
  dir = subdira
)

#Rename files to make clear these are WA by adding WA_rec at end
f <- list.files(subdira, pattern = "age_", full.names = TRUE)
f <- grep(pattern = "OR_rec|WA_rec", x = f, invert = TRUE, value = TRUE)
file.rename(
  f,
  file.path(subdira, sub("\\.", "_WA_rec.", basename(f)))
)

ageCompN_WA_Rec = afs_wa
usethis::use_data(ageCompN_WA_Rec, overwrite = TRUE)


##
#Oregon
##

afs_or <- nwfscSurvey::get_raw_comps(
  data = out_age |> dplyr::filter(state %in% "OR"),
  comp_bins = age_bin,
  comp_column_name = "age",
  input_n_method = "total_samples",
  month = 7,
  fleet = get_fleet("Rec_OR")$num,
  dir = subdira,
  ageerr = 1
)

#Add plots
nwfscSurvey::plot_comps(data = afs_or$sexed, dir = subdira)
nwfscSurvey::plot_comps(data = afs_or$unsexed, dir = subdira)
nwfscSurvey::plot_sex_ratio(
  data = out_age |> dplyr::filter(state %in% "OR"), 
  comp_column_name = "age",
  dir = subdira
)

#Rename files to make clear these are OR by adding OR_rec at end
f <- list.files(subdira, pattern = "age_", full.names = TRUE)
f <- grep(pattern = "OR_rec|WA_rec", x = f, invert = TRUE, value = TRUE)
file.rename(
  f,
  file.path(subdira, sub("\\.", "_OR_rec.", basename(f)))
)

ageCompN_OR_Rec = afs_or
usethis::use_data(ageCompN_OR_Rec, overwrite = TRUE)


#########
#CAAL comps
#########

##
#Washington
##

ageCAAL_wa <- nwfscSurvey::get_raw_caal(
  data = out_age |> dplyr::filter(state %in% "WA"),
  len_bins = len_bin,
  age_bins = age_bin,
  length_column_name = "length_cm",
  age_column_name = "age",
  month = 7,
  fleet = get_fleet("Rec_WA")$num,
  partition = 0,
  ageerr = 1,
  dir = subdira
)

#Rename files to make clear these are WA by adding WA_rec at end
f <- list.files(subdira, pattern = "caal_", full.names = TRUE)
f <- grep(pattern = "OR_rec|WA_rec", x = f, invert = TRUE, value = TRUE)
file.rename(
  f,
  file.path(subdira, sub("\\.", "_WA_rec.", basename(f)))
)

ageCAAL_N_WA_Rec = ageCAAL_wa
usethis::use_data(ageCAAL_N_WA_Rec, overwrite = TRUE)


##
#Oregon
##

ageCAAL_or <- nwfscSurvey::get_raw_caal(
  data = out_age |> dplyr::filter(state %in% "OR"),
  len_bins = len_bins,
  age_bins = age_bins,
  length_column_name = "length_cm",
  age_column_name = "age",
  month = 7,
  fleet = get_fleet("Rec_OR")$num,
  partition = 0,
  ageerr = 1,
  dir = subdira
)

#Rename files to make clear these are OR by adding OR_rec at end
f <- list.files(subdira, pattern = "caal_", full.names = TRUE)
f <- grep(pattern = "OR_rec|WA_rec", x = f, invert = TRUE, value = TRUE)
file.rename(
  f,
  file.path(subdira, sub("\\.", "_OR_rec.", basename(f)))
)

ageCAAL_N_OR_Rec = ageCAAL_or
usethis::use_data(ageCAAL_N_OR_Rec, overwrite = TRUE)







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

