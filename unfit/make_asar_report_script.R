# asar setup (it is recommended in the asar tutorial that we save this script somewhere, I picked unfit/ based on the README instructions)
library(stockplotr)
library(asar)


# There is one Report.sso file each for the final model for North and South
n_output_file <- here::here("models","2021.n.023.001_fixWAreccatchhistory","Report.sso")
s_output_file <- here::here("models","2021.s.018.001_fixTri3","Report.sso")

# Working on north first
lingcod_conout <- stockplotr::convert_output(
  file = n_output_file,
  fleet_names = c("TW","FG"), # got these from doc/catch-comm-fleetstructure.Rmd
  model = "SS3", # optional, function recognizes model
  save_dir = here::here("data","lingcod_output.rda")
)



