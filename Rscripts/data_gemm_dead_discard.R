#gemm

library(nwfscSurvey)
library(dplyr)
library(tidyr)
# Pull most recent gemm 
lingcod_gemm <- pull_gemm(common_name = "lingcod")

# load file with secot vs fleet
load("gemm_fleets.RData")

# Add fleet field to gemm
gemm_by_fleet <- left_join(gemm_fleets,lingcod_gemm,  by = "sector")

save(gemm_by_fleet, file = "gemm_by_fleet.RData")

#remove other groupings
gemm_by_fleet_area <- gemm_by_fleet %>%
  filter(!gemm_by_fleet$grouping %in% c("Lingcod (Coast)", "Lingcod (North of 42° N. lat.)", "Lingcod (South of 42° N. lat.)"))

#Make a table for dead discard by year by fleet and area (grouping)

discard_table <- gemm_by_fleet_area %>%
  # 1. Group by the key categories
  group_by(year, fleet, grouping) %>%
  
  # 2. Sum up the discards for each group
  summarize(dead_discard = sum(discard_mortality, na.rm = TRUE), .groups = "drop") %>%
  
  # 3. Pivot wide by sector to make it easier to read side-by-side
  pivot_wider(names_from = grouping, values_from = dead_discard, values_fill = 0)

# View the final table
print(discard_table)

# Save a Rdata file
save(discard_table, file = "dead_discard_table.RData")

write.csv(discard_table,"dead_discard_table.csv")
