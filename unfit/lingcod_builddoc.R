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
    model = dir("../models", pattern = "2021.n.004.001_new_data_test", full.names = TRUE)
  )
)
bookdown::render_book("00a.Rmd", output_dir = getwd(), clean = FALSE,
  config_file = "_bookdown_south.yml",
  params = list(
    area = get_groups(info_groups)[2],
    model = dir("../models", pattern = "s.005.001_initial_ctl", full.names = TRUE)
  )
)
setwd(indir)
rm(indir)
