### notes on splitting historical California catch at 40°10'

# ESTIMATED THOUSANDS OF FISH CAUGHT (CATCH TYPE A + B)
# BY GROUP AND COASTAL COUNTY DISTRICT, JAN 1981---DEC 1981.

# define directory on a specific computer
if (Sys.info()["user"] == "Ian.Taylor") {
  dir.ling <- 'c:/SS/Lingcod/Lingcod_2021/'
}

# read raw data from Albin et al. 1993, subset for group = "35. LINGCOD"
albin_raw <- read.csv(file.path(dir.ling,
                                'data/CA/Albin_et_al_1993_Lingcod_rows.csv'),
                      skip = 1, header = FALSE)
# get unique area names
areas <- unique(as.character(albin_raw[1, -1]))
years <- as.numeric(albin_raw[-(1:2), 1])
# make data frame
albin_df <- data.frame(expand.grid(Year = years,
                                   Area = areas,
                                   Est = NA,
                                   SE = NA,
                                   CV = NA),
                       stringsAsFactors = FALSE)
# fix factor (for some reason, stringsAsFactors = FALSE didn't work above)
aalbin_df <- as.character(albin_df$Area)

# fill in values in data frame format
for (area in areas) {
  for (y in years) {
    vals <- as.numeric(albin_raw[albin_raw[,1] == y,
                                 albin_raw[1,] == area])
    row <- albin_df$Year == y & albin_df$Area == area
    albin_df$Est[row] <- vals[1]
    albin_df$SE[row] <- vals[2]
    albin_df$CV[row] <- vals[3]
  }
}

# confirm that total looks OK sum matches for Total = TRUE/FALSE
aggregate(albin_df$Est, by = list(albin_df$Area=="Total", albin_df$Year), FUN = sum)
##    Group.1 Group.2   x
## 1    FALSE    1981 118
## 2     TRUE    1981 118
## 3    FALSE    1982 111
## 4     TRUE    1982 111
## 5    FALSE    1983 108
## 6     TRUE    1983 108
## 7    FALSE    1984 134
## 8     TRUE    1984 134
## 9    FALSE    1985 168
## 10    TRUE    1985 168
## 11   FALSE    1986 219
## 12    TRUE    1986 219

ratios <- data.frame(Year = years,
                     DNH_over_total = NA,
                     SLO_over_total = NA)
for (y in years) {
  ratios$DNH_over_total[ratios$Year == y] <-
    albin_df$Est[albin_df$Area == "Del Norte / Humboldt" &
                 albin_df$Year == y] /
    albin_df$Est[albin_df$Area == "Total" &
                 albin_df$Year == y]
  ratios$SLO_over_total[ratios$Year == y] <-
    albin_df$Est[albin_df$Area == "San Luis Obispo" &
                 albin_df$Year == y] /
    albin_df$Est[albin_df$Area == "Total" &
                 albin_df$Year == y]
}
(round(average_DNH_over_total <- mean(ratios$DNH_over_total), 3))
# [1] 0.178
(round(catch_weighted_average_DNH_over_total <-
         weighted.mean(ratios$DNH_over_total,
                       w = albin_df$Est[albin_df$Area=="Total"]), 3))
# [1] 0.181

(round(average_SLO_over_total <- mean(ratios$SLO_over_total), 3))
# [1] 0.124
(round(catch_weighted_average_SLO_over_total <-
         weighted.mean(ratios$SLO_over_total,
                       w = albin_df$Est[albin_df$Area=="Total"]), 3))
# [1] 0.127
