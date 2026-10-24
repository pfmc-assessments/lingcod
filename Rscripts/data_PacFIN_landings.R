
library(pacfintools)
library(dplyr)

catch.pacfin <- file.path("PacFIN.LCOD.CompFT.01.Sep.2026.RData")

table(catch.pacfin$INPFC_AREA_TYPE_CODE)

#Remove XX INPFC area (as was done in 2021)
#Add column "fleet", according to the following 
# HKL	FG
# MSC	FG
# POT	FG
# TLS	FG
# DRG	TW
# NET	FG
# TWL	TW
# TWS	TW

catch.pacfin <- catch.pacfin %>%
  filter(INPFC_AREA_TYPE_CODE != "XX") %>%
  mutate(fleet = if_else(PACFIN_GROUP_GEAR_CODE %in% c("DRG", "TWL", "TWS"), "TW", "FG"))

table(catch.pacfin$INPFC_AREA_TYPE_CODE)

table(catch.pacfin$PACFIN_GROUP_GEAR_CODE, catch.pacfin$fleet)
table(catch.pacfin$fleet)

# Add "port_latitude" column based on pacfintools

catch <- catch.pacfin |>
  dplyr::mutate(
    AGENCY_PORT_CODE = NA
  )
catch_with_lat <- pacfintools::get_latitude(Pdata = catch)

# Define boundary to split catches between N and S

lat_threshold <- 40.166667 

# Assign area using mutate() and ifelse()
catch.pacfin.split <- catch_with_lat %>%
  mutate(
    area = ifelse(port_latitude >= lat_threshold, "North", "South")
  )

# check the results
head(catch.pacfin.split)

# port_latitude was not available in pacfintools for the following PACFIN_PORT_CODE: 
#ARE (2202), Southern CA 
#SIM (114), Southern CA
#TML (30), Southern CA 
#LAC (14), WA
#NA (0).

#Assign "North" for area NA if it is in WA, otherwise "South" (all CA ports with no latitude are in on the south of 40.10)

catch.pacfin.split$area <- ifelse(is.na(catch.pacfin.split$area), 
                  ifelse(catch.pacfin.split$AGENCY_CODE == "W", "North", "South"), 
                  catch.pacfin.split$area)


save(catch.pacfin.split, file = "catch.pacfin.split.RData")

write.csv(catch.pacfin.split, "catch.pacfin.split.csv")

