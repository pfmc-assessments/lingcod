# asar setup (it is recommended in the asar tutorial that we save this script somewhere, I picked unfit/ based on the README instructions)
library(stockplotr)
library(asar)

# There is one Report.sso file each for the final model for North and South
n_output_file <- here::here(
  "models",
  "2021.n.023.001_fixWAreccatchhistory",
  "Report.sso"
)
s_output_file <- here::here("models", "2021.s.018.001_fixTri3", "Report.sso")

########### Lingcod - north ##########################################
lingcod_conout <- stockplotr::convert_output(
  file = n_output_file,
  fleet_names = c("TW", "FG"), # got these from doc/catch-comm-fleetstructure.Rmd
  model = "SS3", # optional, function recognizes model
  save_dir = here::here("doc", "report_north", "lingcod_output.rda")
)

# Read in converted output file
load(here::here("doc", "report_north", "lingcod_output.rda"))

# Run function
# The two functions below use the current wd to save plots, so it is set here. 
# I don't love that but it works.
setwd(here::here("doc","report_north"))
stockplotr::save_all_plots(dat = out_new) 

# Create asar template
asar::create_template(
  format = "pdf",
  office = "NWFSC",
  region = "U.S. West Coast",
  species = "Lingcod",
  spp_latin = "Ophiodon elongatus",
  year = 2027,
  author = c(
    "Brian Langseth" = "NWFSC",
    "Vladlena Gertseva" = "NWFSC",
    "Margaret Siple" = "NWFSC",
    "Megan Feddern" = "NWFSC"
  ),
  param_names = c("TW", "FG"),
  param_values = c("Trawl", "Fixed gear"),
  model_results = "../doc/report_north/lingcod_output.rda" # converted model output
)

########### Lingcod - south ##########################################
lingcod_conout <- stockplotr::convert_output(
  file = s_output_file,
  fleet_names = c("TW", "FG"), # got these from doc/catch-comm-fleetstructure.Rmd
  model = "SS3", # optional, function recognizes model
  save_dir = here::here("doc", "report_south", "lingcod_output.rda")
)

# Read in converted output file
load(here::here("doc", "report_south", "lingcod_output.rda"))

# Run function
# The two functions below use the current wd to save plots, so it is set here.
# I don't love that but it works.
setwd(here::here("doc", "report_south"))
stockplotr::save_all_plots(dat = out_new)

# Create asar template
# Note:
asar::create_template(
  format = "pdf",
  office = "NWFSC",
  region = "U.S. West Coast",
  species = "Lingcod (South)",
  spp_latin = "Ophiodon elongatus",
  year = 2027,
  author = c(
    "Ian Taylor" = "NWFSC",
    "Sabrina Beyer" = "NWFSC",
    "Chantel Wetzel" = "NWFSC",
    "Megan Feddern" = "NWFSC",
    "Melissa Monk" = "NWFSC"
  ),
  param_names = c("TW", "FG"),
  param_values = c("Trawl", "Fixed gear"),
  model_results = "../doc/report_south/lingcod_output.rda" # converted model output
)
