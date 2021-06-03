#' add data to lingcod model
#'
#' adds data a model with 
#'
#' @param id model id (like "2021.s.002.001") for the original model
#' to which data will be added (replacing what's currently there for each
#' specified combination of data type and fleet
#' @param dat_type character vector listing data types to add
#' @param fleets optional vector of fleet numbers for which to add data
#' NULL value will use all fleets from [get_fleet()]
#' @param ss_new use data.ss_new instead of ling_data.ss
#' @param verbose logical controlling feedback about internal results
#' @author Ian G. Taylor
#' @export

add_data <- function(id = "2021.s.002.001",
                     dat_type = c("catch",
                                  "index",
                                  "discard",
                                  "lencomp",
                                  "ageerror",
                                  "agecomp"),
                     fleets = NULL,
                     ss_new = TRUE,
                     verbose = TRUE){

  # vector of fleets to fill in data
  if (is.null(fleets)) {
    fleets <- get_fleet()$num
  }
  # messages about what's happening
  if (verbose) {
    message("adding data types: ", paste(dat_type, collapse = ", "))
    message("       for fleets: ", paste(fleets, collapse = ", "))
  }

  # get area of old model
  Area <- ifelse(substring(id, first = 6, last = 6) == "n",
                 yes = "North",
                 no = "South")
  area <- towlower(Area)
  
  # read data files for old model
  inputs <- get_inputs_ling(id = id, ss_new = ss_new)
  dat <- inputs$dat

  # add catch data
  if ("catch" %in% dat_type) {
    # copy table of catch
    newcatch <- dat$catch
    # loop over fleets
    for (f in fleets) {
      # remove existing values for this fleet
      newcatch <- newcatch[newcatch$fleet != f,]
      # figure out the subset of the catch table to include
      data_catch.f <- data_catch[data_catch$Year >= dat$styr &
                                 data_catch$fleet == get_fleet(f)$label_twoletter &
                                                                 data_catch$area == Area,]
      if (nrow(data_catch.f) > 0) {
        # add new catch for this fleet
        newcatch <- rbind(newcatch,
                          data.frame(year = data_catch.f$Year,
                                     seas = 1,
                                     fleet = f,
                                     catch = data_catch.f$mt,
                                     catch_se = ifelse(data_catch.f$mt > 0,
                                                       yes = 0.01,
                                                       no = 0)))
      }
    } # end loop over fleets within adding catch

    # put newcatch into list after sorting by fleet then year
    dat$catch <- newcatch[order(newcatch$fleet, newcatch$year),]
  } # end adding catch data

  # add index data
  if ("index" %in% dat_type) {
    # TODO: fill in this section
  }

  # add discard data
  if ("discard" %in% dat_type) {
    # TODO: fill in this section
  }

  # add lencomp data
  if ("lencomp" %in% dat_type) {
    # TODO: fill in this section
  }

  # add ageerror data
  if ("ageerror" %in% dat_type) {
    # TODO: fill in this section
  }

  # add agecomp data
  if ("agecomp" %in% dat_type) {
    # TODO: fill in this section
  }

  # return list with new data
  dat
}
