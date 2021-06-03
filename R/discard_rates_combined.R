#' Combine discard rates from multiple sources
#'
#' Combines values from the tables provided by Chantel Wetzel to
#' get a single fleet-specific discard rate after aggregating
#' across gears and sectors/observation method. This function needs to be
#' run separately for each fleet to be used in the model.
#' 
#' @param info_ncs Table for non-catch-shares discard info
#' @param info_cs Table for catch-shares discard info
#' @param info_em Table for electronic monitoring discard info
#' @param Area Area label in tables provided by Chantel
#' @param gears Subset of gears to include in the calculations
#' @param fleet Name or number of the fleet to use in the "Flt" column
#' in the table for use in SS
#' @param min_cv Minimum CV to use for fleets with 100% monitoring and no bootstrap
#' uncertainty provided
#' @author Ian G. Taylor
#' @export
#' @return Table for input into SS data file for a specific fleet.

discard_rates_combined <- function(info_ncs,
                                 info_cs,
                                 info_em,
                                 Area = "North4010",
                                 gears = NULL,
                                 fleet = NA,
                                 min_cv = 0.05
                                 ){

  # fix typo in units for table provided in 2021
  names(info_ncs)[names(info_ncs) %in% "StdDev.Boot_DISCARD.LBS"] <-
    "StdDev.Boot_DISCARD.MTS"
  
  # filter by gears
  if (!is.null(gears)) {
    info_ncs <- info_ncs[info_ncs$gear2 %in% gears,]
    info_cs <- info_cs[info_cs$gear2 %in% gears,]
    info_em <- info_em[info_em$gear2 %in% gears,]
  }
  # filter by areas
  if (!is.null(Area)) {
    info_ncs <- info_ncs[info_ncs$Area %in% Area,]
    info_cs <- info_cs[info_cs$Area %in% Area,]
    info_em <- info_em[info_em$Area %in% Area,]
  }
  # get unique list of gears per input table
  gears_ncs <- unique(info_ncs$gear2)
  gears_cs <- unique(info_cs$gear2)
  gears_em <- unique(info_em$gear2)

  # column names for the tables used to calculate everything
  names <- c(paste0(gears_ncs, "_ncs"),
             paste0(gears_cs, "_cs"),
             paste0(gears_em, "_em"))

  # dimensions
  n <- length(names)
  yrs <- sort(unique(c(info_ncs$ryear,
                       info_cs$ryear,
                       info_em$ryear)))
  # empty table to hold total catches (dis + ret)
  tot_catch <- data.frame(matrix(0,
                                 nrow = length(yrs),
                                 ncol = n),
                          row.names = yrs)
  names(tot_catch) <- names
  
  # empty table to hold discards
  discards <- tot_catch
  # empty table to hold standard deviation of the discard amount
  discards_sd <- tot_catch

  for (type in c("ncs", "cs", "em")) {
    # get table with a name like info_ncs
    table <- get(paste0("info_", type))

    # loop over gear types within the table
    for (gear2 in unique(table$gear2)) {

      # assemble name
      name <- paste0(gear2, "_", type)

      # loop over years
      for (y in yrs){
        # figure out corresponding row
        row <- which(table$ryear == y &
                     table$gear2 == gear2)

        # check for repeats
        if(length(row) > 1) {
          stop("multiple rows matching year = ", y,
               " Area = ", Area, " gear2 = ", gear2)
        }

        # if one row found, fill in tables where the info is aggregated
        if(length(row) == 1) {
          tot_catch[paste(y), name] <-
            table[row, "Observed_DISCARD.MTS"] +
            table[row, "Observed_RETAINED.MTS"]
          
          discards[paste(y), name] <-
            table[row, "Observed_DISCARD.MTS"]

          # fill in StdDev from the ncs table
          if (type == "ncs") {
            discards_sd[paste(y), name] <-
              table[row, "StdDev.Boot_DISCARD.MTS"]
          } else {
            discards_sd[paste(y), name] <-
              min_cv * table[row, "Observed_DISCARD.MTS"]
          }
        } # end check for 1 row
      } # end loop over years
    } # end loop over gears within the table
  } # end loop over types

  # add up total catch across gears/types
  total_tot_catch <- apply(tot_catch, MARGIN = 1, FUN = sum)
  
  # add up discards across gears/types
  total_discards <- apply(discards, MARGIN = 1, FUN = sum)

  # get SD of discards added up across gears/types
  # assume the values are independent so variance of total is sum of variances
  total_discards_sd <- sqrt(apply(discards_sd^2, MARGIN = 1, FUN = sum))

  # total rate is ratio of discards to total catch 
  total_rate <- total_discards / total_tot_catch

  # sd of the rate (fraction)
  total_rate_sd <- total_discards_sd / total_tot_catch

  # data.frame for input to SS
  data.frame(Yr = yrs,
             Seas = 7, # column label should really be "Month"
             Flt = fleet,
             Discard = round(total_rate, 3),
             Std_in = round(total_rate_sd, 3),
             CV = paste("#", round(total_rate_sd/total_rate, 3)))
}
