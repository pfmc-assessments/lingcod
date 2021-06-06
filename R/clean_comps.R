#' change the column names in the data.frame of length or age comps
#'
#' aligns the  names from the various software tools and combines
#' data frames with sexed and unsexed comps into one
#'
#' @param comp data object in the lingcod package
#' @template verbose
#' @author Ian G. Taylor
#' @export
#' @seealso [add_data()]

clean_comps <- function(comp, type = "len"){
  if (is.null(comp)) {
    return()
  }

  # internal function to pad unsexed comps with zeros for the male columns
  add_zeros <- function(df){
    df.zeros <- data.frame(matrix(0,
                                  nrow = nrow(df),
                                  ncol = length(info_bins$length)))
    names(df)[-(1:6)] <- paste0("F-", info_bins$length)
    names(df.zeros) <- paste0("M-", info_bins$length)
    cbind(df, df.zeros)
  }

  len_bin_names <- c(paste0("f", info_bins$length),
                     paste0("m", info_bins$length))

  ##########################################################################
  # format used by PacFIN.Utilities
  if("FthenM" %in% names(comp)){
    newcomp <- rbind(comp$FthenM,
                     comp$Uout)

    # low-tech 2021 scheme to convert "TW" to 1 and "FG" to 2
    newcomp$fleet[newcomp$fleet == "TW"] <- 1
    newcomp$fleet[newcomp$fleet == "FG"] <- 2

    # fix duplicate column names
    names(newcomp) <- vctrs::vec_as_names(names(newcomp),
                                          repair = "unique",
                                          quiet = TRUE)
    newcomp <- newcomp %>%
      dplyr::rename(year    = "fishyr"   , # use naming convention from add_data()
                    part    = "partition",
                    nsamp   = "Ntows"  # could also be Nsamps or InputN or something new
                    ) %>%
      dplyr::select(-c("Nsamps", "InputN"))
    # replace names for data columns
    names(newcomp)[-(1:6)] <- len_bin_names
  }

  ##########################################################################
  # format used for recreational comps
  if("comps" %in% names(comp)){
    newcomp <- comp$comps
    # add zeros to main comps (needed for lenCompS_CA_debHist)
    if ("U-10" %in% names(newcomp)) {
      newcomp <- add_zeros(newcomp)
    }
    if ("comps_u" %in% names(comp)) {
      newcomp <- rbind(newcomp,
                       add_zeros(comp$comps_u))
    }
    newcomp <- newcomp %>%
      dplyr::rename(year    = "year"   ,
                    part    = "partition",
                    nsamp   = "Nsamp")
    
    # replace names for data columns
    names(newcomp)[-(1:6)] <- len_bin_names
  }

  ##########################################################################
  # format used by data processed using nwfscSurvey package (a single table)

  if(is.data.frame(comp) && "F10" %in% names(comp)) {
    newcomp <- comp %>%
      dplyr::rename(part = "partition") %>%
      dplyr::rename_with(.fn = tolower) # change Nsamp to nsamp and F10 to f10
  }

  # return cleaned comps
  newcomp
}
