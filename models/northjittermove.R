# Move the 90th iteration of 2021.n.016.001_tune to 2021.n.016.002_jitter_sample
# Files are copied along with input files but the control file still has the original
# values, but THE PAR FILE has the jitter values. AGAIN PAR FILE HAS VALUES.
# All I did was copy the files.

jitteriter <- 90

jitterdir <- paste0(info_basemodels[["North"]], "_jitter_0.05")
newdir <- gsub("\\.001", ".002", paste0(info_basemodels[["North"]], "_sample"))
dir.create(file.path("models", newdir), showWarnings = FALSE)

files <- dir(
  file.path("models", jitterdir),
  pattern = as.character(jitteriter)
)
newfiles <- gsub("_\\.sso", "", gsub(as.character(jitteriter), "", files))

file.copy(
  file.path("models", jitterdir, files),
  file.path("models", newdir, newfiles)
)

r4ss::copy_SS_inputs(
  dir.old = file.path("models", jitterdir),
  dir.new = file.path("models", newdir),
  overwrite = TRUE, recursive = TRUE,
  use_ss_new = FALSE,
  copy_par = FALSE,
  verbose = TRUE
)
