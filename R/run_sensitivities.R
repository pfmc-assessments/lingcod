#' Run sensitivities for a base model
#'
#' @template dirbase
#' @param type The type of sensitivity you want to run.
#' See the formals for options.
#' @examples
#' \dontrun{
#' dirbase <- get_dir_ling(area = area, num = 14, sens = 1)
#' run_sensitivities(dirbase, c("profile", "retro", "regularization"))
#' }
run_sensitivities <- function(dirbase,
                              type = c("profile", "retro", "regularization", "jitter")
                              ) {

  # Retros, Profile, Jitter
  if (any(grepl("retro|profile|jitter", type))) {
    run_investigatemodel(
      basename(dirbase),
      run = grep(value = TRUE, "retro|profile|jitter", type)
    )
  }
  # 
  if ("regularization" %in% type) {
    run_regularization(
      basename(dirbase),
      interactive = FALSE,
      verbose = FALSE
    )
  }

}
