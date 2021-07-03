#' Write a csv file of figures for a given VAST index
#'
#' Find four files of interest written to the disk from VASTWestCoast
#' and include their details in a csv file that is helpful for
#' including figures in main document.
#'
#' @param dir The directory you want to search for VAST files in.
#' @seealso [sa4ss::add_figure]; [add_figure_ling]
#'
add_figure_vast <- function(dir, outfile) {
  modelname <- basename(dir)
  modelnamesplit <- strsplit(modelname, "_")[[1]]
  row <- grep(modelnamesplit[1], get_fleet(col = "label_short"))
  boilerplate <- text_boilerplate_vast(dir)
  data <- data.frame(
    filein = file.path(dir, dir(dir,
      pattern = "VASTWestCoast_[Qmis].*\\.png")
    ),
    order = c(1, 2, 3, 4),
    caption = c(
      paste0(
        "Map of the area modeled by the index-standardization process for ",
        boilerplate, "."
      ),
      paste0(
        "Map of knot locations used to approximate the spatial field for ",
        boilerplate, "."
      ),
      paste0("Quantile-Quantile (QQ) plot of the theoretical quantiles versus ",
        "the standardized quantiles given fits to the data for ", boilerplate, "."
      ),
      text_caption_vastscaledresidualsmap(boilerplate)
    ),
    alt_caption = c(
      paste0("Blue outline of area included in the model."),
      paste0("Web of points connected to 'knots', which is an input to the model."),
      paste0("Data largely follow the one-to-one line."),
      paste0("No spatial pattern is apparent in the residuals.")
    )
  )

  data[, "label"] <- paste0(get_fleet(col = "gls")[row], "-",
    gsub("WestCoast|_[0-9]{4}\\.[a-zA-Z]{3}|\\.[a-zA-Z]{3}", "",
      basename(data[["filein"]])
    )
  )

  cat(add_figure_ling(data))

}

write_htmlcsv_vast <- function(
  getfilesfrom,
  pattern = "VAST.+residualsmap"
) {

  # Set up objects
  filenames <- dir(getfilesfrom, pattern = pattern, recursive = TRUE)
  newnames <- gsub("_.+/", "-", filenames)
  area <- gsub("^.+_([A-Za-z]+)_.+", "\\1", filenames)
  captions <- text_caption_vastscaledresidualsmap(
    text_boilerplate_vast(dirname(filenames))
  )

  # copy the files to the correct folders
  ignore <- file.copy(
    overwrite = TRUE, recursive = FALSE,
    file.path(getfilesfrom, filenames),
    file.path("docs", area, newnames)
  )
  stopifnot(all(ignore))


  ignore <- mapply(utils::write.csv,
    file = file.path("docs", unique(area), "plotInfoTable_vast.csv"),
    x = mapply(data.frame, SIMPLIFY = FALSE,
      file = split(newnames, area),
      caption = split(captions, area),
      category = "VAST",
      png_time = Sys.time(),
      StartTime = Sys.time()
    ),
    MoreArgs = list(row.names = FALSE)
  )

}

text_caption_vastscaledresidualsmap <- function(boilerplate) {
  caption <- paste0(
    "Map of standardized residuals by year (panels) from ",
    boilerplate, ". Dark blue are the lowest value, ",
    "white are closest to the mean, and red are the highest values."
  )
  return(caption)
}

text_boilerplate_vast <- function(dir) {
  modelnamesplit <- strsplit(basename(dir), "_")
  row <- mapply(grep, SIMPLIFY = TRUE,
    pattern = lapply(modelnamesplit, "[[", 1),
    MoreArgs = list(x = get_fleet(col = "label_short"))
  )
  boilerplate <- paste0(
    "the index-standardization process for the ",
    get_fleet(col = "label_long")[row]
  )
}
