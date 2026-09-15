require(nwfscSurvey)
library(nwfscSurvey)


setwd("C:/Users/vladlena.gertseva/Desktop/Center gravity/maps/wcgbts/lingcod")

catch <- pull_catch(common_name = "lingcod")

bio <- pull_bio(common_name = "lingcod") 


p <- plot_cpue_map(
dir = getwd(),
data = catch
)

plot_cpue(catch, dir = getwd(), plot = 1:3, width = 7, height = 7)


plot_bio_patterns(
  bio,
  dir = getwd(),
  col_name = "Length_cm",
  plot = 1:3,
  width = 7,
  height = 7
)


plot_bio_patterns(
  bio,
  dir = getwd(),
  col_name = "Age",
  plot = 1:3,
  width = 7,
  height = 7
)


plot_bio_patterns(
  bio,
  dir = getwd(),
  col_name = "Width_cm",
  plot = 1:3,
  width = 7,
  height = 7
)

plot_sex_ratio(
  bio,
  dir = getwd(),
  comp_column_name = "length_cm",
  main = NULL,
#  bin_width = ifelse(comp_column_name == "length_cm", 2, 1),
  width = 7,
  height = 7
)


plot_weight_length(
  bio,
  dir = getwd(),
  estimates = NULL,
  col_length = "length_cm",
  col_weight = "weight_kg",
  two_sex = TRUE,
  add_save_name = NULL,
  height = 7,
  width = 7,
  dpi = 300
)








# need to define age bins
plot_var_length_at_age(
  bio,
  age_bins,
  dir = getwd(),
  main = NULL,
  two_sex = TRUE,
  height = 7,
  width = 7
)



# Save the data

write.csv(catch,"catch.csv")
write.csv(bio,"bio.csv")

### Design-based index


#strata <- create_strata(
#  names          = c("CA_south_shallow", "CA_south_middle", "CA_north_shallow", "CA_north_middle", "OR_shallow", "OR_middle", "WA_shallow", "WA_middle"),
#  depths_shallow = c(55, 		183, 		55, 	183, 	55, 	183, 	55, 	183),
#  depths_deep    = c(183, 	549, 		183, 	549, 	183, 	549, 	183, 	549),
#  lats_south     = c(32, 		32, 		34.5, 34.5, 42, 	42, 	46, 	46),
#  lats_north     = c(34.5, 	34.5, 	42, 	42, 	46, 	46, 	49, 	49)
#)

strata <- create_strata(
  names          = c("CA_south", "CA_north", "OR", "WA"),
  depths_shallow = c(55, 		55, 	55, 		55),
  depths_deep    = c(549, 	549, 	549, 	 	549),
  lats_south     = c(32, 		34.5,  42, 		46),
  lats_north     = c(34.5, 	42, 	46, 		49)
)



biomass <- get_design_based(
  dir = getwd(),
data = catch,
  strata = strata
)


plot_index(
   dir = getwd(),
 data = biomass,
  plot = 1
)

 plot_index(
  data = biomass,dir = getwd(),
  plot = 2)
  
  
  
#write.csv( biomass$biomass_by_strata,"vg.csv") 
write.csv( biomass$biomass_by_strata,"vg2.csv")

