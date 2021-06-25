# functions related to senstivitiy output processing ported from
# https://github.com/iantaylor-NOAA/BigSkate_Doc/blob/master/R/BigSkate_sensitivity_results.R

#' create a nicer label for model output tables
#'
#' adds a new column of english language labels
#' for parameters and quantities of interest
#' @param tab a table with a `Label` column containing parameter labels
#' @author Ian G. Taylor
#' @export
sens_clean_labels <- function(tab){
  newlabel <- tab$Label
  newlabel <- gsub("like", "likelihood (diff from base)", newlabel)
  newlabel <- gsub("Ret", "Retained", newlabel)
  newlabel <- gsub("p_1_", "", newlabel)
  newlabel <- gsub("GP_1", "", newlabel)
  newlabel <- gsub("SR_LN", "log", newlabel)
  newlabel <- gsub("LnQ_base", "WCGBTS catchability", newlabel)
  newlabel <- gsub("NatM_uniform", "M", newlabel)
  newlabel <- gsub("Fem", "Female", newlabel)
  newlabel <- gsub("Mal", "Male", newlabel)
  newlabel <- gsub("Bratio", "Fraction unfished", newlabel)
  newlabel <- gsub("OFLCatch", "OFL mt", newlabel)
  newlabel <- gsub("MSY", "MSY mt", newlabel)
  newlabel <- gsub("SPRratio", "Fishing intensity", newlabel)
  newlabel <- gsub("_", " ", newlabel)
  # not generalized
  newlabel <- gsub("SmryBio unfished", "Virgin age 3+ bio 1000 mt", newlabel) 
  newlabel <- gsub("thousand", "1000", newlabel)
  tab$Label <- newlabel
  return(tab)
}

#' Convert offset parameters
#'
#' Convert log Q to standard space
#' and summary biomass into 1000s of mt
#' @param tab a table with a `Label` column containing parameter labels
sens_convert_vals <- function(tab){
  tab[grep("LnQ", tab$Label), -1] <-
    exp(tab[grep("LnQ", tab$Label), -1])
  tab[grep("SmryBio_unfished", tab$Label), -1] <-
    tab[grep("SmryBio_unfished", tab$Label), -1]/1e3
  return(tab)
  
}  

#' convert parameter offsets to standard space
#'
#' (not needed for lingcod since our male growth is modeled
#' as independent parameters)
#' @param tab a table with a `Label` column containing parameter labels
sens_convert_offsets <- function(tab){
  # male M offset
  tab[grep("NatM_p_1_Mal", tab$Label), -1] <-
    tab[grep("NatM_p_1_Fem", tab$Label), -1] *
    exp(tab[grep("NatM_p_1_Mal", tab$Label), -1])
  # male Linf offset
  # subset models for those that use male offset
  mods <- which(tab[grep("Linf_Mal", tab$Label), -1] < 0)
  tab[grep("Linf_Mal", tab$Label), 1 + mods] <-
    tab[grep("Linf_Fem", tab$Label), 1 + mods] *
    exp(tab[grep("Linf_Mal", tab$Label), 1 + mods])
  return(tab)
}  

#' Make a table of senstivity results
#'
#' Works with [run_sensitivities()] and the info in
#' /inst/extdata/sensitivities.csv to make a table of results
#' 
#' @param area which area "n" or "s"
#' @param sens_nums a vector of values from /inst/extdata/sensitivities.csv
#' @param sens_type a string indicating the type which is appended to the csv
#' file containing the sensitivity results
#' @param write logical to write csv file to doc or not
#'
#' @author Ian G. Taylor
#' @export

sens_make_table <- function(area,
                            sens_nums,
                            sens_type = NULL,
                            write = FALSE) {

  if (area == "n") {
    Area <- "North"
  }
  if (area == "s") {
    Area <- "South"
  }
  
  # which things to read from the model output
  thingnames <- c("Recr_Virgin", "R0", "NatM", "Linf",
                  "LnQ_base_WCGBTS",
                  "SSB_Virg", "SSB_2021",
                  "Bratio_2021", "SPRratio_2020", "Ret_Catch_MSY", "Dead_Catch_MSY",
                  "SmryBio_unfished", "OFLCatch_2021")
  # likelihoods to include
  likenames = c("TOTAL", "Survey", "Length_comp", "Age_comp",
                "Discard", "priors")

  # sens dirs doesn't include the base
  sens_dirs <- info_basemodels[[Area]] %>%
    get_id_ling() %>%
    stringr::str_sub(end = nchar("2021.s.001.")) %>%
    paste0(., sprintf("%03d", sens_nums)) %>%
    get_dir_ling(id = .)

  # read the model output
  # sens_mods includes the base (re-read here because that's easy)
  sens_mods <-
    r4ss::SSgetoutput(dirvec = c(file.path("models",info_basemodels[[Area]]),
                                 sens_dirs),
                      getcovar = FALSE)
  # summarize the results
  sens_summary <- r4ss::SSsummarize(sens_mods, verbose = FALSE)

  # names for the columns in the table
  sens_names <- c("Base model",
                  stringr::str_sub(sens_dirs,
                                   start = 1 + nchar("models/2021.s.001.001_")
                                   )
                  )
  # TODO: convert short sens_names to long names by adding a long name
  #       column to selectivities.csv

  # make table of model results
  sens_table <-
    r4ss::SStableComparisons(sens_summary,
                             modelnames = sens_names,
                             names = thingnames,
                             likenames = likenames,
                             csv = FALSE
                             )

  # convert some things to new units (non-log or non-offset)
  sens_table <- sens_table %>%
    sens_convert_vals() %>%
    #sens_convert_offsets() %>% # not needed here
    sens_clean_labels()

  # convert likelihoods to difference from base (assumed to be in column 2)
  like_rows <- grep("likelihood", sens_table$Label)
  for (icol in ncol(sens_table):2) {
    sens_table[like_rows, icol] <- sens_table[like_rows, icol] - sens_table[like_rows, 2]
  }
  
  # write to file
  if (write) {
    csvfile <- file.path(paste0("tables/sens_table_", area, "_", sens_type, ".csv"))
    message("writing ", csvfile)
    write.csv(sens_table, file = csvfile, row.names = FALSE)
  }

  invisible(sens_table)
}
