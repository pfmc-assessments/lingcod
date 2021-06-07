#' renumber fleets in lingcod control file
#'
#' function hopefully only to be used once for each model
#'
#' @param area area, initially either "n" or "s" for 2021 models
#' @param fleets table of info on old and new fleets created by get_fleets()
#' @param ctl control file object created by [get_inputs_ling()] or
#' [r4ss::SS_readctl()]
#' @author Ian G. Taylor
#' @export
#' @seealso [change_data_fleets()], [get_fleet()], [get_inputs_ling()]

change_control_fleets <- function(area, fleets, ctl) {

  Nfleets <- max(fleets$num)

  # change to simpler recruitment distribution for models with 1 area/season/etc.
  ctl$recr_dist_method <- 4
  ctl$MG_parms <- ctl$MG_parms[-grep("RecrDist", rownames(ctl$MG_parms)),]

  # renumber fleets for catchability parameters
  ctl$Q_options <- data.frame(fleet = 1:Nfleets,
                              link = 1,
                              link_info = 0,
                              extra_se = 0, # to be changed below
                              biasadj = 0,
                              float = 1,
                              row.names = fleets$fleet)

  # extra_se was turned on for fishery dependent CPUE
  ctl$Q_options$extra_se[grep("Comm", fleets$fleet)] <- 1
  ctl$Q_options$extra_se[grep("Rec", fleets$fleet)] <- 1
 
  # remove rows for those fleets not used or with no index in each area
  if(area == "n"){
    ctl$Q_options <- ctl$Q_options[!grepl("Rec_CA", fleets$fleet) &
                                   !grepl("Surv_HookLine", fleets$fleet) &
                                   !grepl("Research_Lam", fleets$fleet) &
                                   !grepl("CPFV_DebWV", fleets$fleet),]
  }
  if(area == "s"){
    ctl$Q_options <- ctl$Q_options[!grepl("Comm_Fix", fleets$fleet) &
                                   !grepl("Rec_WA", fleets$fleet) &
                                   !grepl("Rec_OR", fleets$fleet) &
                                   !grepl("Rec_CA", fleets$fleet) &
                                   !grepl("Research_Lam", fleets$fleet) &
                                   !grepl("CPFV_DebWV", fleets$fleet),]
  }

  # create base Q parameters for each fleet (none estimated because float = 1 above)
  base_Q_parms <-
    data.frame(LO = rep(-15, nrow(ctl$Q_options)),
               HI = 15,
               INIT = 0,
               PRIOR = 0,
               PR_SD = 0,
               PR_type = 0,
               PHASE = -1,
               env_var = 0,
               dev_link = 0,
               dev_minyr = 0,
               dev_maxyr = 0,
               dev_PH = 0,
               Block = 0,
               Block_Fxn = 0,
               row.names = paste0(rownames(ctl$Q_options),
                                  "_LnQ_base"))

  # create extraSD parameters for the fishery dependent CPUE
  extraSD_Q_parms <-
    data.frame(LO = rep(0, sum(ctl$Q_options$extra_se)),
               HI = 2,
               INIT = 0.05,
               PRIOR = 0,
               PR_SD = 0,
               PR_type = 0,
               PHASE = 2,
               env_var = 0,
               dev_link = 0,
               dev_minyr = 0,
               dev_maxyr = 0,
               dev_PH = 0,
               Block = 0,
               Block_Fxn = 0,
               row.names =
                 paste0(rownames(ctl$Q_options)[ctl$Q_options$extra_se == 1],
                        "_Q_extraSD"))
  # stich the two types of parameters together and sort as expected by SS
  Q_parms <- rbind(base_Q_parms, extraSD_Q_parms)
  # get fleet number
  Q_parms <- Q_parms[order(rownames(Q_parms)),]

  # add time block to Triennial to match separate early and late indices in 2017/2019 models
  # add an extra block design
  ctl$N_Block_Designs <- ctl$N_Block_Designs + 1
  # single block for the new design
  ctl$blocks_per_pattern <- c(ctl$blocks_per_pattern, 1)
  # set range of years for block
  ctl$Block_Design[[ctl$N_Block_Designs]] <- c(1995, 2004)

  # add block to Q for triennial
  tripar <- grep("TRI", rownames(Q_parms))
  Q_parms$Block[tripar] <- ctl$N_Block_Designs
  Q_parms$Block_Fxn[tripar] <- 2

  # create time-varying replacement Q_parm 
  ctl$Q_parms_tv <- Q_parms[tripar, 1:7]

  # update the list with the revised Q_parms table 
  ctl$Q_parms <- Q_parms

  ######## selectivity
  # make table of types full of NA values to replace
  size_selex_types <- data.frame(Pattern = rep(NA, Nfleets),
                                 Discard = NA,
                                 Male = NA,
                                 Special = NA,
                                 row.names = fleets$fleet)
  # copy corresponding selex types from previous assessment
  for(irow in 1:Nfleets){
    oldrow <- which(rownames(ctl$size_selex_types) %in%
                    get_fleet(irow)[[paste0("fleets_2019.", area)]])
    if (length(oldrow) > 0) {
      size_selex_types[irow, ] <- ctl$size_selex_types[oldrow, ]
    } else {
      size_selex_types[irow, ] <- rep(0, 4)
    }
  }
  ctl$size_selex_types <- size_selex_types

  # fleets are in the same order so selectivity parameters should all work as before
  # with the exception of the triennial survey, where the parameters for the 1995-2004
  # period are now block replacement parameters rather than base parameters
  TRI_Late_rows <- grep("TRI_Late", rownames(ctl$size_selex_parms))
  # map first first 7 columns of TRI_Late into time-varying selectivity section
  ctl$size_selex_parms_tv <- rbind(ctl$size_selex_parms_tv,
                                   ctl$size_selex_parms[TRI_Late_rows, 1:7])
  # remove the rows from the base selectivity parameter section
  ctl$size_selex_parms <- ctl$size_selex_parms[-TRI_Late_rows,]

  # add block to Q for triennial (formerly TRI_Early)
  tripar <- grep("TRI", rownames(ctl$size_selex_parms))
  ctl$size_selex_parms$Block[tripar] <- ctl$N_Block_Designs
  ctl$size_selex_parms$Block_Fxn[tripar] <- 2
  
  # previous model used age selex = 11 (selex=1.0  for specified min-max age)
  # with the range specified as all ages: 0 to 25.
  # changing to age selex = 0 has same result with no parameter lines required
  ctl$age_selex_types <- data.frame(Pattern = rep(0, Nfleets),
                                    Discard = 0,
                                    Male = 0,
                                    Special = 0,
                                    row.names = fleets$fleet)
  ctl$age_selex_parms <- NULL

  # update data weighting
  ctl$Variance_adjustment_list$Fleet <-
    get_fleet(value = ctl$Variance_adjustment_list$Fleet,
              yr=2019,
              area = area)$num

  # TRI_Early and TRI_Late had separate weights for their length comps 
  tri_length_weights <-
    ctl$Variance_adjustment_list$Value[ctl$Variance_adjustment_list$Factor == 4 &
                                       ctl$Variance_adjustment_list$Fleet ==
                                       get_fleet(value = "Tri")$num]
  tri_length_weights
  # [1] 1.506500 0.172543 # 2019 north model
  # [1] 0.985006 2.702180 # 2019 south model

  # set weight equal to the mean of the two time periods
  ctl$Variance_adjustment_list$Value[ctl$Variance_adjustment_list$Factor == 4 &
                                     ctl$Variance_adjustment_list$Fleet ==
                                     get_fleet(value = "Tri")$num] <-
    mean(tri_length_weights)

  # remove extra row previously associated with TRI_Late 
  ctl$Variance_adjustment_list <-
    ctl$Variance_adjustment_list[!duplicated(ctl$Variance_adjustment_list),]

  # return the modified control file
  return(ctl)
}
