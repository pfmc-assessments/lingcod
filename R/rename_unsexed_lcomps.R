#' Rename or copy unsexed length comp files to 2021 assessment naming conventions
#'
#' @param base_dir Base directory containing length comp subfolders (default: "data-raw/lenComps")
#' @param comp_type Which comp type to rename: "raw" (default) or "expanded"
#' @param copy Logical; if TRUE (default), copies the file to preserve the new
#'   nwfscSurvey output. If FALSE, renames/moves the file.
#' @param overwrite Logical; whether to overwrite existing target files (default: TRUE).
#'
#' @return A data.frame mapping original file paths to their new paths.
rename_unsexed_lcomps <- function(
  base_dir  = file.path("data-raw", "lenComps"),
  comp_type = c("raw", "expanded"),
  copy      = TRUE,
  overwrite = TRUE
) {
  comp_type <- match.arg(comp_type)
  
  # Regex pattern to match unsexed files and extract min/max bin numbers
  pattern <- sprintf("^length_cm_unsexed_%s_([0-9]+)_([0-9]+)_.*\\.csv$", comp_type)
  
  all_files <- list.files(base_dir, pattern = "\\.csv$", recursive = TRUE, full.names = TRUE)
  matched_files <- all_files[grepl(pattern, basename(all_files))]
  
  if (length(matched_files) == 0) {
    message("No matching unsexed ", comp_type, " files found under: ", base_dir)
    return(invisible(data.frame(original = character(), new = character())))
  }
  
  dest_files <- vapply(matched_files, function(f) {
    fname   <- basename(f)
    area    <- basename(dirname(f))         # e.g., "north" or "south"
    surv_dir <- dirname(dirname(f))         # e.g., "data-raw/lenComps/WCGBTS"
    min_bin <- sub(pattern, "\\1", fname)   # e.g., "10"
    max_bin <- sub(pattern, "\\2", fname)   # e.g., "130"
    
    old_name <- sprintf("%s_Survey_Sex3_Bins_%s_%s_LengthComps.csv", area, min_bin, max_bin)
    file.path(surv_dir, old_name)
  }, character(1), USE.NAMES = FALSE)
  
  # Perform copy or rename
  for (i in seq_along(matched_files)) {
    if (copy) {
      file.copy(from = matched_files[i], to = dest_files[i], overwrite = overwrite)
    } else {
      file.rename(from = matched_files[i], to = dest_files[i])
    }
  }
  
  action <- if (copy) "Copied" else "Renamed"
  message(sprintf("%s %d file(s) to 2021 naming convention.", action, length(matched_files)))
  
  invisible(data.frame(original = matched_files, target = dest_files))
}