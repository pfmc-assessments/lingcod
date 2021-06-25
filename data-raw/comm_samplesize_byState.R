#Script to attempt to extract nfish and ntow by state
#from commercial comps
#Ultimately not done because of cannot reproduce Ntows 
#across states, and therefore values by states would be inaccurate. 


#To start at line 198 in lingcod_PacFIN_BDS.R

###################################################################################
#Script to provide sample sizes (nfish) by state and gear. Used to generate table
#of sample sizes (table_3.R)
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
          file.path(getwd(),"data-raw","pacfin_length_state_gear_sample_size_North.csv"), 
          row.names = FALSE)

temp_dat.s = bds.pacfin.s[!is.na(bds.pacfin.s$lengthcm),]
nlen_state.s <- aggregate(temp_dat.s$lengthcm,
                          by = list(yr = temp_dat.s$SAMPLE_YEAR,
                                    sex = temp_dat.s$SEX,
                                    fleet = temp_dat.s$fleet,
                                    state = temp_dat.s$state),
                          FUN = length)
names(nlen_state.s)[ncol(nlen_state.s)] <- "nfish"
write.csv(nlen_state.s, 
          file.path(getwd(),"data-raw","pacfin_length_state_gear_sample_size_South.csv"), 
          row.names = FALSE)

################################
#Get ntrip by state
temp = bds.pacfin.n[!is.na(bds.pacfin.n$lengthcm), ]
temp = bds.pacfin.n

temp$gend <- 0
temp[temp$SEX %in% c("F","M"), "gend"] <- 3

fish = aggregate(SEX ~ fishyr + fleet + state, temp,
                 FUN = function(x) { length(x) } )

trips = aggregate(SAMPLE_NO~fishyr + fleet + state, temp,
                  FUN = function(x) { length(unique(x)) } )

#Getting 12 tows in 1987 for FG. Below I get 14 (if keep NA lengthcm then this resolves)
aggregate(SAMPLE_NO ~ fishyr + fleet, trips, FUN = sum)

#Before doing this Im running the code below down to 266
bds.pacfin.n.exp$SEX = "U"
comps.n <- PacFIN.Utilities::getComps(Pdata = bds.pacfin.n.exp,
                                      Comps = "LEN")

lenCompN_comm <- PacFIN.Utilities::writeComps(inComps = comps.n,
                                              fname = "data/lenCompN_comm_all_unesexed.csv",
                                              lbins = info_bins$length,
                                              sum1 = TRUE,
                                              partition = 2,
                                              digits = 3,
                                              dummybins = FALSE)


#For south
#If dont exclude NA lengthcm then get many extra years (where all lengthcms are NA)
#If exclude NA lengthcm then do not reproduce expansion script
temp = bds.pacfin.s[!is.na(bds.pacfin.s$lengthcm), ]
temp = bds.pacfin.s

temp$gend <- 0
temp[temp$SEX %in% c("F","M"), "gend"] <- 3

fish = aggregate(SEX ~ fishyr + fleet + state, temp,
                 FUN = function(x) { length(x) } )

trips = aggregate(SAMPLE_NO~fishyr + fleet + state, temp,
                  FUN = function(x) { length(unique(x)) } )

#Getting 12 tows in 1987 for FG. Below I get 14
aggregate(SAMPLE_NO ~ fishyr + fleet, trips, FUN = sum)

#Before doing this Im running the code below down to 266
bds.pacfin.s.exp$SEX = "U"
comps.s <- PacFIN.Utilities::getComps(Pdata = bds.pacfin.s.exp,
                                      Comps = "LEN")

lenCompS_comm <- PacFIN.Utilities::writeComps(inComps = comps.s,
                                              fname = "data/lenCompS_comm_all_unesexed.csv",
                                              lbins = info_bins$length,
                                              sum1 = TRUE,
                                              partition = 2,
                                              digits = 3,
                                              dummybins = FALSE)
###################################


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
          file.path(getwd(),"data-raw","pacfin_age_state_gear_sample_size_North.csv"), 
          row.names = FALSE)

temp_dat.s = bds.pacfin.s[!is.na(bds.pacfin.s$Age),]
nage_state.s <- aggregate(temp_dat.s$Age,
                          by = list(yr = temp_dat.s$SAMPLE_YEAR,
                                    sex = temp_dat.s$SEX,
                                    fleet = temp_dat.s$fleet,
                                    state = temp_dat.s$state),
                          FUN = length)
names(nage_state.s)[ncol(nage_state.s)] <- "nfish"
write.csv(nage_state.s, 
          file.path(getwd(),"data-raw","pacfin_age_state_gear_sample_size_South.csv"), 
          row.names = FALSE)
####################################################################################