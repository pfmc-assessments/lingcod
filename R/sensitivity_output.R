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
#' @param area Which area "n" or "s"
#' @template num
#' @param sens_base Sensitivity number associated with the base model
#' or source for the other sensitivities.
#' @param sens_nums A vector of values from /inst/extdata/sensitivities.csv
#' @param sens_mods Optional list containing output from multiple models. If present
#' this will skip the reading of the models specified by the inputs above.
#' @param sens_type A string indicating the type which is appended to the csv
#' file containing the sensitivity results
#' @param plot Logical for whether to make a two-panel time series plot
#' @param plot_dir Directory for the plot
#' @param table_dir Directory for the table
#' @param write Logical to write csv file to doc or not
#' @param dots Additional arguments passed to plot_twopanel_comparison()
#'
#' @example 
#' @author Ian G. Taylor
#' @export

sens_make_table <- function(area,
                            num,
                            sens_base = 1,
                            yr = 2021,
                            sens_nums,
                            sens_mods = NULL,
                            sens_type = NULL,
                            plot = TRUE,
                            plot_dir = NULL,
                            table_dir = "tables",
                            write = FALSE,
                            ...) {

  # which things to read from the model output
  thingnames <- c("Recr_Virgin", "steep", "NatM", "Linf",
                  "LnQ_base_WCGBTS",
                  "SSB_Virg", "SSB_2021",
                  "Bratio_2021", "SPRratio_2020", "Ret_Catch_MSY", "Dead_Catch_MSY",
                  "SmryBio_unfished", "OFLCatch_2021")
  # likelihoods to include
  likenames = c("TOTAL", "Survey", "Length_comp", "Age_comp",
                "Discard", "priors")

  # read models (if needed)
  if (!is.null(sens_mods)) {
    # get vectory of directory associated with each model
    sens_dirs <- NULL
    for (i in 1:length(sens_mods)) {
      sens_dirs <- c(sens_dirs, sens_mods$inputs$dir)
    }
    basedir <- ""
  } else {
    # get base model directory (may not always match info_basemodels)
    basedir <- basename(get_dir_ling(area, num, sens = sens_base, yr = yr))

    # sens dirs doesn't include the base
    sens_dirs <- basedir %>%
      get_id_ling() %>%
      stringr::str_sub(end = nchar("2021.s.001.")) %>%
      paste0(., sprintf("%03d", sens_nums)) %>%
      get_dir_ling(id = .)

    # filter for directories which are present
    message("the following directories not found for this model:\n",
            paste(sens_dirs[!dir.exists(sens_dirs)], collapse = "\n"))
    sens_dirs <- sens_dirs[dir.exists(sens_dirs)]
    
    # read the model output
    # sens_mods includes the base (re-read here because that's easy)
    sens_mods <-
      r4ss::SSgetoutput(dirvec = c(file.path("models",basedir),
                                   sens_dirs),
                        getcovar = FALSE)
  }
  
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

  # make plot
  if (plot) {
    plot_filename <- paste0("sens_timeseries_", area, "_", sens_type, ".png")
    if (is.null(plot_dir)) {
      plot_dir <- file.path("models",
                            basedir,
                            "custom_plots"
                            )
    }
    plot_twopanel_comparison(mods = sens_mods,
                             legendlabels = sens_names,
                             legendloc = "bottomleft",
                             legendncol = ifelse(length(sens_mods) < 5, 1, 2),
                             file = plot_filename,
                             dir = plot_dir,
                             ...
                             )

    # get an explanation of the type for use in the caption
    sens_type_long <- ""
    if (sens_type == "bio_rec") {
      sens_type_long <- "biology and recruitment."
    }
    if (sens_type == "index") {
      sens_type_long <- "indices of abundance."
    }
    if (sens_type == "comp") {
      sens_type_long <- "composition data."
    }
    
    caption <-
      paste("Time series of spawning biomass (top) and fraction of unfished",
            "(bottom) for the sensitivity analyses related to",
            sens_type_long)
            
    write_custom_plots_csv(mod = sens_mods[[1]],
                           filename = plot_filename,
                           caption = caption)
  }
  
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

  # convert male offset for the shareM case
  if ("shareM" %in% names(sens_table)) {
    sens_table[grep("M Male", sens_table$Label), "shareM"] <-
      sens_table[grep("M Female", sens_table$Label), "shareM"]
  }

  # write to file
  if (write) {
    csvfile <- file.path(table_dir,
                         paste0("sens_table_", area, "_", sens_type, ".csv"))
    message("writing ", csvfile)
    write.csv(sens_table, file = csvfile, row.names = FALSE)
  }

  sens_table
}
