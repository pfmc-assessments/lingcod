#' Switch between conditional (CAAL) and marginal age for a given
#' model.
#'
#' Modifies the elements of the data file
#'
#' @param dat List created by [get_inputs_ling()] or `r4ss::SS_readdat()`
#' @template area
#' @param area Area associated with the model, either "n" or "s"
#' @param dat_type Character vector listing data types to add
#' NULL value will lead to all data types
#' @param part Partition to include (e.g. to include only retained
#' length comps instead of discarded length comps). Currently only filters
#' commercial data for which discards comps are available.
#' @param fleets Optional vector of fleet numbers for which to add data
#' NULL value will use all fleets from [get_fleet()]
#' @template verbose
#' @author Ian G. Taylor
#' @export
#' @seealso [get_dir_ling()], [get_inputs_ling()], [clean_comps()]

change_ages <- function(olddir,
                        newdir,
                        fleets_marginal = NULL,
                        fleets_conditional = NULL) {
  olddir <- get_dir_ling(area = area, num = 4, sens = 9)
  newdir <- get_dir_ling(area = area, num = 4, sens = 10)
  
  r4ss::copy_SS_inputs(dir.old = olddir,
                       dir.new = newdir, 
                       use_ss_new = FALSE,
                       copy_par = TRUE,
                       copy_exe = TRUE,
                       dir.exe = get_dir_exe(),
                       overwrite = TRUE,
                       verbose = TRUE)
  
  # read all input files
  inputs <- get_inputs_ling(id = get_id_ling(newdir))

  # remove all ages except for WCGBTS and ghost fleets
  agecomp <- inputs$dat$agecomp
  agecomp <- agecomp %>% dplyr::filter(Lbin_lo == -1 | FltSvy == 7)

  # add revised agecomps to data file
  inputs$dat$agecomp <- agecomp
  
  # remove unneeded tunings
  inputs$ctl$Variance_adjustment_list <-
    inputs$ctl$Variance_adjustment_list %>%
    dplyr::filter(Factor != 5 | Fleet == 7)

  # write new files
  write_inputs_ling(inputs,
                    # directory is same as source directory for inputs in this case
                    dir = newdir,
                    # don't overwrite dat file because it's unchanged and has good comments
                    files = c("dat"), 
                    verbose = FALSE,
                    overwrite = TRUE
                    )
}
