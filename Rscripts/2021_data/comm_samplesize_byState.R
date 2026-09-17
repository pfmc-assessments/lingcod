#Script to attempt to extract nfish and ntow by state
#from commercial comps
#Ultimately not done because of cannot reproduce Ntows 
#across states, and therefore values by states would be inaccurate. 

#<<<<<<<<<<<<<<<Replaced with table_sampeSize_comm_byState.R>>>>>>>>>>>>>>>#


#To start at line 198 in lingcod_PacFIN_BDS.R

###################################################################################
#Script to provide sample sizes (nfish) by state and gear. Used to generate table
#of sample sizes (table_sampleSize.R). Only needed for north
###Lengths
temp_dat.n = bds.pacfin.n[!is.na(bds.pacfin.n$lengthcm),]
nlen_state.n <- aggregate(temp_dat.n$lengthcm,
                          by = list(yr = temp_dat.n$SAMPLE_YEAR,
                                    sex = temp_dat.n$SEX,
                                    fleet = temp_dat.n$fleet,
                                    state = temp_dat.n$state),
                          FUN = length)
names(nlen_state.n)[ncol(nlen_state.n)] <- "nfish"
write.csv(nlen_state.n, 
          file.path(getwd(),"data-raw","pacfin_length_nfish_state_North.csv"), 
          row.names = FALSE)

# temp_dat.s = bds.pacfin.s[!is.na(bds.pacfin.s$lengthcm),]
# nlen_state.s <- aggregate(temp_dat.s$lengthcm,
#                           by = list(yr = temp_dat.s$SAMPLE_YEAR,
#                                     sex = temp_dat.s$SEX,
#                                     fleet = temp_dat.s$fleet,
#                                     state = temp_dat.s$state),
#                           FUN = length)
# names(nlen_state.s)[ncol(nlen_state.s)] <- "nfish"
# write.csv(nlen_state.s, 
#           file.path(getwd(),"data-raw","pacfin_length_nfish_state_South.csv"), 
#           row.names = FALSE)

###Age
temp_dat.n = bds.pacfin.n[!is.na(bds.pacfin.n$Age),]
nage_state.n <- aggregate(temp_dat.n$Age,
                          by = list(yr = temp_dat.n$SAMPLE_YEAR,
                                    sex = temp_dat.n$SEX,
                                    fleet = temp_dat.n$fleet,
                                    state = temp_dat.n$state),
                          FUN = length)
names(nage_state.n)[ncol(nage_state.n)] <- "nfish"
write.csv(nage_state.n, 
          file.path(getwd(),"data-raw","pacfin_age_nfish_state_North.csv"), 
          row.names = FALSE)

# temp_dat.s = bds.pacfin.s[!is.na(bds.pacfin.s$Age),]
# nage_state.s <- aggregate(temp_dat.s$Age,
#                           by = list(yr = temp_dat.s$SAMPLE_YEAR,
#                                     sex = temp_dat.s$SEX,
#                                     fleet = temp_dat.s$fleet,
#                                     state = temp_dat.s$state),
#                           FUN = length)
# names(nage_state.s)[ncol(nage_state.s)] <- "nfish"
# write.csv(nage_state.s, 
#           file.path(getwd(),"data-raw","pacfin_age_nfish_state_South.csv"), 
#           row.names = FALSE)




##Script to provide sample sizes (ntows) by state and gear. Used to generate table
#of sample sizes (table_sampleSize.R)

#Get ntows by state. 
#Issue 1: Doing by SEX did not work. It does not produce comparable 
#results to our comps in lenN_comm, so treat as all sexes together. 
#Issue 2: Need to keep NA lengths in. Results across states are comparable
#to standard approach using unsexed comps without state distinction. 

#North Lengths
temp <- bds.pacfin.n[!is.na(bds.pacfin.n$lengthcm), ]
temp <- bds.pacfin.n 

fish <- aggregate(SEX ~ fishyr + fleet + state, temp,
                  FUN = function(x) { length(x) } )

trips <- aggregate(SAMPLE_NO~fishyr + fleet + state, temp,
                   FUN = function(x) { length(unique(x)) } )

# #Getting 12 tows in 1987 for FG. Below I get 14 (if keep NA lengthcm then this resolves)
# aggregate(SAMPLE_NO ~ fishyr + fleet, trips, FUN = sum)

names(trips) <- c("yr","fleet","state","ntows")
write.csv(trips, 
          file.path(getwd(),"data-raw","pacfin_length_ntows_state_North.csv"), 
          row.names = FALSE)
# #Testing to ensure results over all states are comparable
# 
# bds.pacfin.n.exp$SEX = "U"
# comps.n <- PacFIN.Utilities::getComps(Pdata = bds.pacfin.n.exp,
#                                       Comps = "LEN")
# 
# lenCompN_comm <- PacFIN.Utilities::writeComps(inComps = comps.n,
#                                               fname = "data/lenCompN_comm_all_unesexed.csv",
#                                               lbins = info_bins$length,
#                                               sum1 = TRUE,
#                                               partition = 2,
#                                               digits = 3,
#                                               dummybins = FALSE)

#North ages
#Need to keep NA age in. In this case results across states are comparable
#to standard approach using unsexed comps without state distinction
#provided years without valid ages are removed after the fact. 
#This results in the same number of tows as for length

temp <- bds.pacfin.n[!is.na(bds.pacfin.n$Age), ]
temp <- bds.pacfin.n 

fish <- aggregate(SEX ~ fishyr + fleet + state, temp,
                  FUN = function(x) { length(x) } )

trips <- aggregate(SAMPLE_NO~fishyr + fleet + state, temp,
                   FUN = function(x) { length(unique(x)) } )

aggregate(SAMPLE_NO ~ fishyr + fleet, trips, FUN = sum)

noages = table(temp$fishyr,is.na(temp$Age),temp$fleet)
noages_yrFG <- names(which(noages[,"FALSE","FG"]==0))
noages_yrTW <- names(which(noages[,"FALSE","TW"]==0))

trips_rec <- rbind(trips[which(trips$fleet == "FG" & !trips$fishyr %in% noages_yrFG),],
                   trips[trips$fleet == "TW" & !trips$fishyr %in% noages_yrTW,])

names(trips) <- c("yr","fleet","state","ntows")
write.csv(trips_rec, 
          file.path(getwd(),"data-raw","pacfin_age_ntows_state_North.csv"), 
          row.names = FALSE)

# #Testing to ensure results over all states are comparable
# bds.pacfin.n.exp$SEX = "U"
# comps.n <- PacFIN.Utilities::getComps(Pdata = bds.pacfin.n.exp,
#                                       Comps = "AGE")
# 
# tempAgeN <- PacFIN.Utilities::writeComps(inComps = comps.n,
#                                               fname = "data/ageCompN_comm_all_unesexed.csv",
#                                               lbins = info_bins$age,
#                                               sum1 = TRUE,
#                                               partition = 2,
#                                               digits = 3,
#                                               dummybins = FALSE)


# #South Lengths
# #Not needed since all one state (CA) but tested anyway
#
# temp <- bds.pacfin.s[!is.na(bds.pacfin.s$lengthcm), ]
# temp <- bds.pacfin.s
# 
# fish <- aggregate(SEX ~ fishyr + fleet + state, temp,
#                  FUN = function(x) { length(x) } )
# 
# trips <- aggregate(SAMPLE_NO~fishyr + fleet + state, temp,
#                   FUN = function(x) { length(unique(x)) } )
# 
# #Years added where the following shows only NAs for a fleet (1979,1980 for FG). These
# #must be removed.
# table(bds.pacfin.s$fishyr,is.na(bds.pacfin.s$lengthcm),bds.pacfin.s$fleet)
# 
# trips2 <- trips[!(trips$fishyr %in% c(1979,1980) & trips$fleet=="FG"),]
# 
# write.csv(trips2, 
#           file.path(getwd(),"data-raw","pacfin_length_ntows_state_South.csv"), 
#           row.names = FALSE)

# #Testing to ensure results over all states are comparable
# aggregate(SAMPLE_NO ~ fishyr + fleet, trips, FUN = sum)
# 
# bds.pacfin.s.exp$SEX = "U"
# comps.s <- PacFIN.Utilities::getComps(Pdata = bds.pacfin.s.exp,
#                                       Comps = "LEN")
# 
# lenCompS_comm <- PacFIN.Utilities::writeComps(inComps = comps.s,
#                                               fname = "data/lenCompS_comm_all_unesexed.csv",
#                                               lbins = info_bins$length,
#                                               sum1 = TRUE,
#                                               partition = 2,
#                                               digits = 3,
#                                               dummybins = FALSE)

