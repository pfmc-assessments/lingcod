# Source this file using the command line via
# Rscript --vanilla .\unfit\diags.R 1
# where the 1 at the end is the args you want,
# so here args could be 1:3

run_lorenzenm <- function(
  olddir,
  newdir,
  referenceage = 7
) {

  if (missing(newdir)) {
    newdir <- gsub("[0-9]{3}_.+$", "800_lorenzenm", olddir)
  }
  if (dir.exists(newdir)) {
    unlink(newdir, recursive = TRUE)
  }
  r4ss::copy_SS_inputs(
    dir.old = olddir,
    dir.new = newdir,
    use_ss_new = FALSE,
    copy_par = FALSE,
    copy_exe = TRUE,
    dir.exe = get_dir_exe(),
    overwrite = TRUE,
    verbose = FALSE
  )

  file.starter <- file.path(newdir, "starter.ss")
  starter <- r4ss::SS_readstarter(file.starter, verbose = FALSE)
  dat <- r4ss::SS_readdat(file.path(newdir, starter[["datfile"]]),
    verbose = FALSE)
  ctl <- r4ss::SS_readctl(file.path(newdir, starter[["ctlfile"]]),
    use_datlist = TRUE, datlist = dat, verbose = FALSE,
    version = type.convert(dat[["ReadVersion"]], as.is = TRUE))
  ctl[["natM_type"]] <- 2
  ctl[["Lorenzen_refage"]] <- referenceage ## Reference age for Lorenzen M
  r4ss::SS_writectl(ctl, ctl[["sourcefile"]], verbose = FALSE, overwrite = TRUE)

  r4ss::run_SS_models(dirvec = newdir,
    extras = "-cbs 1500000000"
  )

}

run_lorenzenm(file.path("models", info_basemodels[[1]]))
run_lorenzenm(
  olddir = file.path("models", info_basemodels[[1]]),
  newdir = gsub("[0-9]{3}_.+$", "801_lorenzenm", file.path("models", info_basemodels[[1]])),
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
run_lorenzenm(olddir = file.path("models", "2021.s.017.001_triextrasdreweight"))

get_mod("n", 23)
get_mod("s", 17)
get_mod("n", 23, 801, covar = FALSE)
get_mod("n", 23, 802, covar = FALSE)
get_mod("s", 17, 801, covar = FALSE)
get_mod("s", 17, 802, covar = FALSE)
get_mod("s", 17, 803, covar = FALSE)
compare <- r4ss::SSsummarize(lapply(ls(pattern = "\\.[ns]"), get))
labstoM <- c("North", "North Lorenzen M", "North Lorenzen M + slx offset", "South", "South Lorenzen M", "South Lorenzen M free Triennial slx", "South Lorenzen M free + offset")
dir.create("figures", "STAR_requests10")
plot_twopanel_comparison(
  legendlabels = labstoM,
  lapply(ls(pattern = "\\.[ns]"), get),
  print = TRUE,
  plot = FALSE,
  dir = file.path("figures", "STAR_requests10")
)

r4ss::SSplotComparisons(compare,
  plotdir = file.path("figures", "STAR_requests10"),
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
  plot_dir = file.path("figures", "STAR_requests10"),
  table_dir = file.path("figures", "STAR_requests10"),
  write = FALSE
)
colnames(compare_table) <- c("Label", grep("North", labstoM, value = TRUE))
utils::write.csv(compare_table,
  row.names = FALSE,
  file.path("figures", "STAR_requests10", "sens_table_n_star.csv")
)
compare_table <- sens_make_table(
  area = "s",
  sens_mods = lapply(ls(pattern = "mod\\.[0-9]{4}\\.[s]"), get),
  sens_type = "star",
  plot = FALSE,
  plot_dir = file.path("figures", "STAR_requests10"),
  table_dir = file.path("figures", "STAR_requests10"),
  write = FALSE
)
colnames(compare_table) <- c("Label", grep("South", labstoM, value = TRUE))
utils::write.csv(compare_table,
  row.names = FALSE,
  file.path("figures", "STAR_requests10", "sens_table_s_star.csv")
)

