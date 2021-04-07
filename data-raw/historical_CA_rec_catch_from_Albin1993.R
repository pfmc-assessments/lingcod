### notes on splitting historical California catch at 40°10'

if (!file.exists("data-raw")) {
  stop("You need to source this file from the lingcod_2021 directory.", call. = FALSE)
}

# read raw data from Albin et al. 1993, subset for group = "35. LINGCOD"
albin_raw <- read.csv(
  file = file.path("data-raw", "Albin_et_al_1993_Lingcod_rows.csv"),
  skip = 1, header = FALSE
)

# make data frame
albin_df <- expand.grid(
  Year = as.numeric(albin_raw[-(1:2), 1]),
  Area = unique(as.character(albin_raw[1, -1])), # get unique area names
  Est = NA, SE = NA, CV = NA,
  stringsAsFactors = FALSE)

# fill in values in data frame format
for (area in albin_df[["Area"]]) {
  for (y in albin_df[["Year"]]) {
    vals <- as.numeric(albin_raw[albin_raw[,1] == y,
                                 albin_raw[1,] == area])
    row <- albin_df$Year == y & albin_df$Area == area
    albin_df$Est[row] <- vals[1]
    albin_df$SE[row] <- vals[2]
    albin_df$CV[row] <- vals[3]
  }
}

# confirm that total looks OK sum matches for Total = TRUE/FALSE
testthat::expect_equal(
  stats::aggregate(albin_df$Est, by = list(albin_df$Area=="Total", albin_df$Year), FUN = sum),
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
  data.frame(
    Group.1 = rep(c(FALSE, TRUE), 6),
    Group.2 = rep(1981:1986, each = 2),
    x = rep(c(118, 111, 108, 134, 168, 219), each = 2)
  )
)

ratios <- data.frame(Year = unique(albin_df[["Year"]]),
                     DNH_over_total = NA,
                     SLO_over_total = NA)
for (y in ratios[["Year"]]) {
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
# Following does the same
# ratios <- albin_df[albin_df[["Area"]]!="Total",] %>% 
#   group_by(Year) %>% mutate(sum = sum(Est)) %>%
#   group_by(Area, Year) %>% summarize(sum = Est/sum, .groups = "keep") %>%
#   dplyr::filter(grepl("Hum|Luis", Area)) %>%
#   tidyr::spread(key = Area, value = sum) %>%
#   data.frame
# colnames(ratios) <- c("Year", "DNH_over_total", "SLO_over_total")

testthat::expect_equal(
  round(average_DNH_over_total <- mean(ratios$DNH_over_total), 3),
  0.178
)
testthat::expect_equal(
  round(catch_weighted_average_DNH_over_total <-
         stats::weighted.mean(ratios$DNH_over_total,
                       w = albin_df$Est[albin_df$Area=="Total"]), 3),
  0.181
)
testthat::expect_equal(
  round(average_SLO_over_total <- mean(ratios$SLO_over_total), 3),
  0.124
)
testthat::expect_equal(
  round(catch_weighted_average_SLO_over_total <-
         stats::weighted.mean(ratios$SLO_over_total,
                       w = albin_df$Est[albin_df$Area=="Total"]), 3),
  0.127
)

#### Assign data objects
# usethis::use_data(average_DNH_over_total, overwrite = TRUE)
# usethis::use_data(average_SLO_over_total, overwrite = TRUE)
# usethis::use_data(catch_weighted_average_DNH_over_total, overwrite = TRUE)
# usethis::use_data(catch_weighted_average_SLO_over_total, overwrite = TRUE)

#### Clean up
rm(albin_raw, albin_df, ratios)
rm(y, vals, row, area)
