#' Switch between conditional (CAAL) and marginal age for a given
#' model.
#'
#' Modifies the elements of the data file
#'
#' @param dat List created by [get_inputs_ling()] or `r4ss::SS_readdat()`
#' @template area
#' @param area Area associated with the model, either "n" or "s"
#' @param fleets_marginal which fleets to have marginal ages
#' @param fleets_conditional which fleets to have CAAL ages
#' @template verbose
#' @author Ian G. Taylor
#' @export
#' @seealso [get_dir_ling()], [get_inputs_ling()], [add_data()]

change_ages <- function(dat,
                        area,
                        fleets_marginal = NULL,
                        fleets_conditional = NULL) {

  # get agecomps from data file
  agecomp <- dat$agecomp
  # turn off all ages
  agecomp$FltSvy <- -1 * abs(agecomp$FltSvy)
  # turn on marginal ages for the chosen fleets
  for(f in fleets_marginal) {
    sub <- abs(agecomp$FltSvy) %in% f & agecomp$Lbin_lo == -1
    agecomp$FltSvy[sub] <- abs(agecomp$FltSvy[sub])
  }
  
  # turn on CAAL ages for the chosen fleets
  for(f in fleets_conditional) {
    sub <- abs(agecomp$FltSvy) %in% f & agecomp$Lbin_lo > 0
    agecomp$FltSvy[sub] <- abs(agecomp$FltSvy[sub])
  }

  # remove CAAL with negative fleets to speed up the model
  agecomp <- agecomp[agecomp$FltSvy > 0 | agecomp$Lbin_lo == -1,]
  
  # add revised agecomps to data file
  dat$agecomp <- agecomp

  # return dat list
  dat
}
