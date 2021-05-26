#' renumber fleets in lingcod data file
#'
#' function hopefully only to be used once for each model
#'
#' @param area area, initially either "n" or "s" for 2021 models
#' @param fleets table of info on old and new fleets created by get_fleets()
#' @param dat data file object created by [get_inputs_ling()] or
#' [r4ss::SS_readdat()]
#' @author Ian G. Taylor
#' @export
#' @seealso [change_control_fleets()], [get_fleet()], [get_inputs_ling()]

change_data_fleets <- function(area, fleets, dat) {
  
  # update years and number of fleets
  dat$endyr <- 2020
  dat$Nfleets <- max(fleets$num)
  dat$Comments <- "2021 Lingcod data based on 2019 model with renumbered fleets"
  
  # update table of info on each fleet
  dat$fleetinfo <- data.frame(type = c(rep(1, 5), rep(3, 4)),
                              surveytiming = c(rep(-1, 5), rep(1, 4)),
                              area = 1,
                              units = 1,
                              need_catch_mult = 0,
                              fleetname = fleets$fleet)
  # I think these are legacies from 3.24 models and not used by SS_writedat()
  dat$surveytiming <- NULL
  dat$units_of_catch <- NULL

  # update 
  dat$catch$fleet <- get_fleet(value = dat$catch$fleet,
                               yr = 2019,
                               area = area)$num

  # update numbers and rownames in table of CPUE info
  dat$CPUEinfo <- data.frame(Fleet = fleets$num,
                             Units = 1, # will change later for some
                             Errtype = 0,
                             SD_Report = 0,
                             row.names = fleets$fleet)
  # change rec fleet units from biomass to numbers
  dat$CPUEinfo[grep("Rec", fleets$fleet), "Units"] <- 0
  # change H&L fleet units from biomass to numbers
  dat$CPUEinfo[grep("HookLine", fleets$fleet), "Units"] <- 0

  # update fleet number in CPUE data
  dat$CPUE$index <- get_fleet(value = dat$CPUE$index,
                              yr = 2019,
                              area = area)$num

  # update table of discard fleet info
  dat$discard_fleet_info$Fleet <- get_fleet(value = dat$discard_fleet_info$Fleet,
                                            yr = 2019,
                                            area = area)$num
  rownames(dat$discard_fleet_info) <- get_fleet(value = dat$discard_fleet_info$Fleet,
                                                yr = 2019,
                                                area = area)$fleet
  # update table of discard data
  dat$discard_data$Flt <- get_fleet(value = dat$discard_data$Flt,
                                    yr = 2019,
                                    area = area)$num
  # update bins
  dat$minimum_size <- 10
  dat$maximum_size <- 140
  # 2019 south model had bins starting at 4
  dat$lbin_vector <- seq(10, 130, 2)
  dat$N_lbins <- length(dat$lbin_vector)
  
  # table of length comp info
  dat$len_info <- data.frame(mintailcomp = rep(-1, dat$Nfleets),
                             addtocomp = 0.001,
                             combine_M_F = 0,
                             CompressBins = 0,
                             CompError = 0,
                             ParmSelect = 0,
                             minsamplesize = 0.001,
                             row.names = fleets$fleet)

  # update length comps
  dat$lencomp$FltSvy <- get_fleet(value = dat$lencomp$FltSvy,
                                  yr = 2019,
                                  area = area)$num
  if(area == "s"){
    # compression of small length bins
    dat$lencomp$f10 <- apply(X = dat$lencomp[names(dat$lencomp) %in%
                                             paste0("f", seq(4,10,2))],
                             MARGIN = 1,
                             FUN = sum)
    dat$lencomp$m10 <- apply(X = dat$lencomp[names(dat$lencomp) %in%
                                             paste0("m", seq(4,10,2))],
                             MARGIN = 1,
                             FUN = sum)
    # remove columns for small bins that got compressed
    dat$lencomp <- dat$lencomp[,!substring(names(dat$lencomp), 2) %in% c(4,6,8)]
  }

  # update age comps
  dat$age_info <- data.frame(mintailcomp = rep(-1, dat$Nfleets),
                             addtocomp = 0.001,
                             combine_M_F = 0,
                             CompressBins = 0,
                             CompError = 0,
                             ParmSelect = 0,
                             minsamplesize = 0.001,
                             row.names = fleets$fleet)
  # update age comps (keeping any negative fleet numbers negative)
  dat$agecomp$FltSvy <- sign(dat$agecomp$FltSvy) *
    get_fleet(value = abs(dat$agecomp$FltSvy),
              yr = 2019,
              area = area)$num

  # return the modified data file
  return(dat)
}
