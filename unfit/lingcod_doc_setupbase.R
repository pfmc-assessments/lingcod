# Write 00mod.Rdata for each model
for (ii in dir("models", pattern = "2021.+data", full.names = TRUE)) {
  setwd(ii)
  sa4ss::read_model(
    mod_loc = getwd(),
    create_plots = FALSE,
    save_loc = file.path("tex_tables"),
    verbose = TRUE
  )
  load("00mod.Rdata")
  r4ss::SSexecutivesummary(replist = model, format = FALSE)
  sa4ss::es_table_tex(
    dir = mod_loc,
    save_loc = file.path(mod_loc, "tex_tables"),
    csv_name = "table_labels.csv"
  )
  setwd("../..")
}
