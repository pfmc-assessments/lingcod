
outputdir <- file.path("figures", "STAR_requests10")
dir.create(outputdir, showWarnings = FALSE)

run_lorenzenm(
  olddir = file.path("models", "2021.n.023.001_fixWAreccatchhistory"),
  newdir = "2021.n.023.800_lorenzenm",
  referenceage = 7
)
run_lorenzenm(
  olddir = file.path("models", "2021.n.023.001_fixWAreccatchhistory"),
  newdir = file.path("models", "2021.n.023.801_lorenzenm"),
  referenceage = 8
)
run_lorenzenm(
  olddir = file.path("models", "2021.n.023.411_female_sel_offset_fisheries"),
  newdir = file.path("models", "2021.n.023.802_offsetLM"),
  referenceage = 8
)
run_lorenzenm(
  olddir = file.path("models", "2021.s.017.001_triextrasdreweight"),
  newdir = file.path("models", "2021.s.017.801_lorenzenm"),
  referenceage = 8
)
run_lorenzenm(
  olddir = file.path("models", "2021.s.017.412_female_sel_offset_fisheriesFixTriSlx"),
  newdir = file.path("models", "2021.s.017.803_lorenzenm"),
  referenceage = 8
)
run_lorenzenm(
  olddir = file.path("models", "2021.s.017.001_triextrasdreweight"),
  newdir = "2021.s.017.801_lorenzenm",
  referenceage = 7
)

get_mod("n", 23)
get_mod("s", 17)
get_mod("n", 23, 801, covar = FALSE)
get_mod("n", 23, 802, covar = FALSE)
get_mod("s", 17, 801, covar = FALSE)
get_mod("s", 17, 802, covar = FALSE)
get_mod("s", 17, 803, covar = FALSE)
compare <- r4ss::SSsummarize(lapply(ls(pattern = "\\.[ns]"), get))
labstoM <- c("North", "North Lorenzen M", "North Lorenzen M + slx offset", "South", "South Lorenzen M", "South Lorenzen M free Triennial slx", "South Lorenzen M free + offset")

r4ss::SSplotComparisons(compare,
  plotdir = outputdir,
  print = TRUE,
  plot = FALSE,
  legendlabels = labstoM,
  densitynames = c("NatM")
)

compare_table <- sens_make_table(
  area = "n",
  sens_mods = lapply(ls(pattern = "mod\\.[0-9]{4}\\.[n]"), get),
  sens_type = "star",
  plot = FALSE,
  plot_dir = outputdir,
  table_dir = outputdir,
  write = FALSE
)
colnames(compare_table) <- c("Label", grep("North", labstoM, value = TRUE))
utils::write.csv(
  compare_table,
  row.names = FALSE,
  file.path("figures", "STAR_requests10", "sens_table_n_star.csv")
)
compare_table <- sens_make_table(
  area = "s",
  sens_mods = lapply(ls(pattern = "mod\\.[0-9]{4}\\.[s]"), get),
  sens_type = "star",
  plot = FALSE,
  plot_dir = outputdir,
  table_dir = outputdir,
  write = FALSE
)
colnames(compare_table) <- c("Label", grep("South", labstoM, value = TRUE))
utils::write.csv(
  compare_table,
  row.names = FALSE,
  file.path(outputdir, "sens_table_s_star.csv")
)

