#

# This script is to calculate amount of historical discard for the period before GEMM estimates. Dead discard is calculated based on landings, discard rates and discard mortality rates.

library(dplyr)

# read index output
dir <- "data-raw/discard/historical_discard"

#Load the CSV file 
historical_discard_table_North <- read.csv("historical_discard_table_North.csv")

# View the data frame
historical_discard_table_North

#calculate dead discard based on values in the data frame

historical_discard_table_North <- historical_discard_table_North %>%
  mutate(dead_discard = (pacfin_landings * discard_rate) / (1 - discard_rate) * mortality_rate)

# view results
 print(historical_discard_table_North) 
 
#save results 
 save(historical_discard_table_North, file = "historical_discard_table_North_processed.rda")
 write.csv(historical_discard_table_North, "historical_discard_table_North_processed.csv")
 