#Explore why combo survey from the data warehouse using PullBio.fn differs from what Patrick is provided (the api)

setwd("C:/Users/Brian.Langseth/Desktop/lingcod_2021")
devtools::load_all("Lingcod_2021")
library(lingcod)
library(nwfscSurvey)

#From data warehouse
bio <- PullBio.fn(Name = "lingcod", SurveyName = "NWFSC.Combo", SaveFile = FALSE)

#From api 
api = read.csv("TrawlSpecimens.csv", header = TRUE)

#Years
cbind(table(bio$Year),table(api$date_dim.year)[4:20])

#Restrict api to only 2003 and onward
api = api[api$date_dim.year>=2003,]

#Years
cbind(table(bio$Year),table(api$date_dim.year))

#Ages
table(bio$Age,useNA="always")
table(api$ï..age_years,useNA="always")

#What are the projects for the api
table(api$project) #...includes some triennial samples

#Api has triennial samples. Restrict to only combo
api = api[api$project %in% c("Groundfish Slope and Shelf Combination Survey"),]

#Years
cbind(table(bio$Year),table(api$date_dim.year))
table(bio$Year)-table(api$date_dim.year)

#PullBio.fn excludes weights with non-standard weight
table(api$standard_survey_age_indicator, useNA = "always")
table(api$standard_survey_length_or_width_indicator, useNA = "always")
table(api$standard_survey_maturity_indicator, useNA = "always") #ignore
table(api$standard_survey_weight_indicator, useNA = "always")
#Non of these would be removed

table(bio$Year,bio$Vessel)-table(api$date_dim.year,api$vessel)

#Lets pull just Blue Horizon data (different of 45 samples)
api_blue = api[api$vessel == "Blue Horizon",]
bio_blue = bio[bio$Vessel == "Blue Horizon",]
table(api_blue$length_cm,useNA="always")
table(bio_blue$Length_cm,useNA="always")
table(api_blue$station_code)
table(bio_blue$Tow)
table(bio_blue$Trawl_id)
table(api_blue$trawl_id)

bio_notin_api_blue = which(!bio_blue$Trawl_id %in% api_blue$trawl_id)
api_notin_bio_blue = which(!api_blue$trawl_id %in% bio_blue$Trawl_id) #these records are not in the bio

api_blue[api_notin_bio_blue,]
table(api_blue$target_station_design_dim.stn_invalid_for_trawl_date_whid)
#So values with an entry for this designation "target_station_design_dim....." are not included. But 5 stations without with designation are also not included

#Try trawl id. These appear unique
bio_notin_api = which(!bio$Trawl_id %in% api$trawl_id)
api_notin_bio = which(!api$trawl_id %in% bio$Trawl_id) #510 samples, which is the different

rowSums(table(api[api_notin_bio,]$target_station_design_dim.stn_invalid_for_trawl_date_whid, api[api_notin_bio,]$ï..age_years))







