# Set the directories you care about
basemodelgrep <- "[ns].011.005"

# Set up the base model folder with figures, csv, and tables
# Write 00mod.Rdata for each model
for (ii in dir("models", pattern = basemodelgrep, full.names = TRUE)) {
  setwd(ii)
  # creates 00mod.Rdata
  sa4ss::read_model(
    mod_loc = getwd(),
    create_plots = FALSE,
    save_loc = file.path("tex_tables"),
    verbose = TRUE
    )
  # load model
  load("00mod.Rdata")
  # make plots using model object loaded above
  make_r4ss_plots_ling(model, verbose = FALSE)
  
  # get exec summary tables
  r4ss::SSexecutivesummary(replist = model, format = FALSE)
  sa4ss::es_table_tex(
    dir = mod_loc,
    save_loc = file.path(mod_loc, "tex_tables"),
    csv_name = "table_labels.csv"
  )
  setwd("../..")
}

# Set your working directory to the appropriate location to build
# the document, this will work on everyone's machine
indir <- getwd()
setwd(file.path(dirname(system.file(package = "lingcod")),"doc"))

# args(bookdown::render_book)
bookdown::render_book("00a.Rmd", output_dir = getwd(), clean = FALSE,
  config_file = "_bookdown_north.yml",
  params = list(
    run_data = FALSE,
    area = get_groups(info_groups)[1],
    model = dir("../models", pattern = gsub("[ns]", "n", basemodelgrep),
     full.names = TRUE)
  )
)
bookdown::render_book("00a.Rmd", output_dir = getwd(), clean = FALSE,
  config_file = "_bookdown_south.yml",
  params = list(
    area = get_groups(info_groups)[2],
    model = dir("../models", pattern = gsub("[ns]", "s", basemodelgrep),
     full.names = TRUE)
  )
)
setwd(indir)
rm(indir)
