#' Make tables for the cpue indices

unlink(file.path(dirname(system.file(package=utils_name())),
  "tables", "tables_cpue.csv")
)
unlink(file.path(dirname(system.file(package=utils_name())),
  "figures", "figures_cpue.csv")
)
cpue_output(
  grep = "OR_COMM_NSLOG_CPUE", fleet = "Fix"
)
cpue_output(
  grep = "OR_ORBS_CPUE", fleet = "OR"
)
