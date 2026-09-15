# define directory on a specific computer
# only useful if sub-directories don't match
if (Sys.info()["user"] == "Ian.Taylor"){
  dir.ling <- c('c:/SS/Lingcod/Lingcod_2021')
  dir.ling2017 <- c('c:/SS/Lingcod/Lingcod_2017')

  load(file.path(dir.ling,
                 'data/Lingcod_survey_extractions_15-July-2020.Rdata'))

}

require(r4ss)

ling2017.n <- SS_output(file.path(dir.ling2017, 'models/north_base'))
ling2017.s <- SS_output(file.path(dir.ling2017, 'models/south_base'))

# female growth comparison
SSplotBiology(ling2017N, subplot=1, colvec = c("red", NA, NA))
SSplotBiology(ling2017S, subplot=1, colvec = c("orange", NA, NA), add = TRUE)

SSplotBiology(ling2017N, subplot=6, colvec = c("red", NA, NA))
SSplotBiology(ling2017S, subplot=6, colvec = c("orange", NA, NA), add = TRUE)
SSplotBiology(ling2017N, subplot=12, colvec = c("red", NA, NA))
SSplotBiology(ling2017S, subplot=12, colvec = c("orange", NA, NA), add = TRUE)



png(file = file.path(dir.ling, 'figures/spawning_output_comparison_2017.png'),
    units = 'in', width = 6.5, height = 6.5, res = 300)
                     
SSplotBiology(ling2017.n, subplot=11, colvec = 4)
SSplotBiology(ling2017.s, subplot=11, colvec = 2, add = TRUE)
legend('topleft', col = c(4,2), legend = c("North", "South"), lty = 1)
title(main = paste("Spawning output at age from 2017 Lingcod assessments",
                   "\nbased on maturity at length and length at age"))

dev.off()


natage_in_1999.n <- ling2017.n$natage[ling2017.n$natage$Sex == 1 &
                                      ling2017.n$natage$Time == 1999.0,
                                      paste(0:25)]
natage_in_1999.s <- ling2017.s$natage[ling2017.s$natage$Sex == 1 &
                                      ling2017.s$natage$Time == 1999.0,
                                      paste(0:25)]
natage_in_1887.n <- ling2017.n$natage[ling2017.n$natage$Sex == 1 &
                                      ling2017.n$natage$Time == 1887.0,
                                      paste(0:25)]
natage_in_1887.s <- ling2017.s$natage[ling2017.s$natage$Sex == 1 &
                                      ling2017.s$natage$Time == 1887.0,
                                      paste(0:25)]
spawn_output.n <- ling2017.n$endgrowth$"Mat*Fecund"[ling2017.n$endgrowth$Sex == 1]
spawn_output.s <- ling2017.s$endgrowth$"Mat*Fecund"[ling2017.s$endgrowth$Sex == 1]

plot(0:25, spawn_output.n * natage_in_1999.n/max(natage_in_1999.n), col = 4, type = 'o')
points(0:25, spawn_output.s * natage_in_1999.s/max(natage_in_1999.s), col = 2, type = 'o')

plot(0:25, spawn_output.n * natage_in_1887.n/max(natage_in_1887.n), col = 4, type = 'o')
points(0:25, spawn_output.s * natage_in_1887.s/max(natage_in_1887.s), col = 2, type = 'o')



# getting ages from PacFIN into Melissa Head's spreadsheet

# read spreadsheet from Melissa Head sent 17 May 2021
maturity_samples <- read.csv('data-raw/2014_2018ODFWLingcod_maturityagefish.csv')
# load PacFIN BDS data
load('data-raw/PacFIN.LCOD.bds.30.Apr.2021.RData')

# slow, brute force way to merge info from the two data frames
for (irow in 1:nrow(maturity_samples)) {
  samp_num <- maturity_samples$OR_sample._WAFishticket[irow]
  sequ_num <- maturity_samples$FishInfoID.[irow]
  if (samp_num %in% bds.pacfin$AGENCY_SAMPLE_NUMBER) {
    age <- bds.pacfin$FINAL_FISH_AGE_IN_YEARS[bds.pacfin$AGENCY_SAMPLE_NUMBER == samp_num &
                                              bds.pacfin$FISH_SEQUENCE_NUMBER == sequ_num]
    maturity_samples$Age_yrs[irow] <- age
  }
}

write.csv(maturity_samples,
          file = 'data-raw/2014_2018ODFWLingcod_maturityagefish_with_PacFIN_ages.csv',
          row.names = FALSE)
