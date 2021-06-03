#########
#For Lingcod 2021 assessment
#
#Script to read in all of the needed Access files for the historical CA lengths
#HAVE TO USE R-32BIT VERSION
#These files are confidential, so access is restricted.
#Link to "CA CPFV historical data" is in drive folder, for those with access. 
#
#Output of this script a single csv file with identifying information removed. 
#File is into data-raw and the google drive
#
#Author: Brian Langseth (brian.langseth@noaa.gov)
#########

library(RODBC)

#################
#DebWV files
#Onboard Party Boat > CPFV-Onboard Data-Central California_DebWV
#################
deb <- file.path(getwd(),"data-raw","CPFV-Onboard Data.mdb")
conDeb <- RODBC::odbcConnectAccess(deb)
RODBC::sqlTables(conDeb)
deb.trip <- RODBC::sqlFetch(conDeb, "AllTrp")
deb.len <- RODBC::sqlFetch(conDeb, "Length")
deb.loc <- RODBC::sqlFetch(conDeb, "CPFV_Party_LOCAS")
RODBC::odbcCloseAll()


#Take fishing locations below 40.10
north_areas = unique(deb.loc[which(deb.loc$Lat_DD>=(40+10/60)),"LOCA"])

#Keep lingcod, only in southern locations
deb.len <- deb.len[deb.len$SP == 2664 & !deb.len$NLOC %in% c(north_areas),]

deb.data <- merge(deb.len,deb.trip,by = "TRIPNOSAMP")
deb.data$Data_Type = "RELEASED"
deb.data$Data_Type[which(deb.data$FATE=="K")] = "RETAINED"
deb.data$data = "CPFV-Onboard Data"
deb.data$Length = deb.data$TL
deb.data$Sex = "U"

deb.out = deb.data[,c("YEAR", "Length", "Sex", "Data_Type", "data")]


#################
#Crooke and Ally
#Onboard Party Boat > CPFV-Southern California_Crooke+Ally (for 1970s data)
#Onboard Party Boat > CPFV-Southern California_Crooke+Ally > 
#HK_Archive 1985-1989 Southern California > 86-88 Data  (for 1980s data)
#################

#Data from 1970s
ca <- file.path(getwd(),"data-raw","CPFV.mdb")
conca <- RODBC::odbcConnectAccess(ca)
RODBC::sqlTables(conca)
ca.trip <- RODBC::sqlFetch(conca, "Tbl_70strip")
ca.len <- RODBC::sqlFetch(conca, "Tbl_70scatch")
RODBC::odbcCloseAll()

#Keep lingcod. Locations already in southern california
ca.len <- ca.len[ca.len$SpCode == 2664,]

ca.data <- merge(ca.len,ca.trip, by = "TripID")
ca.data$Data_Type = "RETAINED" #Dont actually know but assume so, thus add this
ca.data$YEAR = format(ca.data$date, format="%Y")
ca.data$data = "CPFV"
ca.data$Sex = "U"

ca.70.out <- ca.data[,c("YEAR", "Length", "Sex", "Data_Type", "data")]


#Data from 1980s
ca <- file.path(getwd(),"data-raw","86-88 Data.mdb")
conca <- RODBC::odbcConnectAccess(ca)
RODBC::sqlTables(conca)
ca.len <- RODBC::sqlFetch(conca, "Length_Tbl")
RODBC::odbcCloseAll()

ca.data <- ca.len[ca.len$L_SPECODE == 2664,]

ca.data$Data_Type = "RELEASED"
ca.data$Data_Type[which(ca.data$L_KEPTREL=="K")] = "RETAINED"

ca.data$YEAR = ca.data$L_DATE_YY + 1900
ca.data$Length = ca.data$L_LENGTH1
ca.data$data = "86-88 Data"
ca.data$Sex = "U"

ca.80.out = ca.data[,c("YEAR", "Length", "Sex", "Data_Type","data")]


#################
#Dockside sampling
#Northern California 59-72 Dockside > CCRS_LF_77-86
#Northern California 59-72 Dockside > FPB_LF_59-72 
#Northern California 59-72 Dockside > Skiff_LF_59-72
#################

#Data from 1977-1986 Party
dock1 <- file.path(getwd(),"data-raw","CCRS_LF_77-86.mdb")
cond1 <- RODBC::odbcConnectAccess(dock1)
RODBC::sqlTables(cond1)
dock1.len <- RODBC::sqlFetch(cond1, "CCRS7786")
RODBC::odbcCloseAll()

dock1.data <- dock1.len[dock1.len$Sp_Code == 2664,]

dock1.data$Data_Type = "RETAINED" #Dont actually know but assume so, thus add this

dock1.data$YEAR = dock1.data$Year + 1900
dock1.data$data = "CCRS_LF_77-86"

dock1.out = dock1.data[,c("YEAR","Length","Sex","Data_Type","data")] 


#Data from 1959-1972 Party
dock2 <- file.path(getwd(),"data-raw","FPB_LF_59-72.mdb")
cond2 <- RODBC::odbcConnectAccess(dock2)
RODBC::sqlTables(cond2)
dock2.len <- RODBC::sqlFetch(cond2, "PBLF_1959-1972")
RODBC::odbcCloseAll()

dock2.data <- dock2.len[dock2.len$Sp_Code == 2664,]

dock2.data$Data_Type = "RETAINED" #Dont actually know but assume so, thus add this

dock2.data$YEAR = dock2.data$Year + 1900
dock2.data$data = "FPB_LF_59-72"
dock2.data$Sex = factor(dock2.data$Sex, labels = c("U","M","F"))

dock2.out = dock2.data[,c("YEAR", "Length", "Sex", "Data_Type", "data")] 


#Data from 1959-1972 Skiff
dock3 <- file.path(getwd(),"data-raw","Skiff_LF_59-72.mdb")
cond3 <- RODBC::odbcConnectAccess(dock3)
RODBC::sqlTables(cond3)
dock3.len <- RODBC::sqlFetch(cond3, "SKF_LF_1957-1972")
RODBC::odbcCloseAll()

dock3.data <- dock3.len[dock3.len$Sp_Code == 2664,]

dock3.data$Data_Type = "RETAINED" #Dont actually know but assume so, thus add this

dock3.data$YEAR = dock3.data$Year + 1900
dock3.data$data = "Skiff_LF_59-72"
dock3.data$Sex = factor(dock3.data$Sex, labels = c("U","M","F"))

dock3.out = dock3.data[,c("YEAR", "Length", "Sex", "Data_Type", "data")] 



####
#Combine datasets and output into data-raw folder
####
ca.hist = rbind(deb.out, ca.70.out, ca.80.out, dock1.out, dock2.out, dock3.out)
write.csv(ca.hist, file = file.path(getwd(), "data-raw", "CA_rec_historical_length.csv"), row.names = FALSE)
          