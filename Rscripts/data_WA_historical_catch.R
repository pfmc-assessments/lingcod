# Washington commercial data


library(dplyr)

setwd
catch_comm_WA_yearstartpacfin <- 1996

catch_comm_WA  <- read.csv("WA_historical_lingcod_2027.csv") %>%
 dplyr::filter(Year < catch_comm_WA_yearstartpacfin) %>%
  dplyr::mutate(
    LINE = ifelse(LINE == 0, NA_real_, LINE),
    LINE = stats::approx(Year, LINE, n = length(LINE))$y,
    FG = LINE + NET, TW = TRAWL
  ) %>%
  dplyr::select(-Total, -LINE, -NET, -TRAWL) %>%
  tidyr::gather(key = "fleet", value = "mt", -Year) %>%
  dplyr::mutate(area = "North", state = "WA")


save(catch_comm_WA, file = "catch_comm_WA.rda")
write.csv(catch_comm_WA, "catch_comm_WA.csv")
