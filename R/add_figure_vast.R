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
  boilerplate <- paste0(
    "the index-standardization process for the ",
    "\\glsentrylong{", get_fleet(col = "gls")[row],
    "}"
  )
  data <- data.frame(
    filein = file.path(dir, dir(dir,
      pattern = "VASTWestCoast_[Qmi].*\\.png")
    ),
    order = c(1, 2, 3),
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
      )
    ),
    alt_caption = c(
      paste0("Blue outline of area included in the model."),
      paste0("Web of points connected to 'knots', which is an input to the model."),
      paste0("Data largely follow the one-to-one line.")
    )
  )

  data[, "label"] <- paste0(get_fleet(col = "gls")[row], "-",
    gsub("WestCoast|_[0-9]{4}\\.[a-zA-Z]{3}|\\.[a-zA-Z]{3}", "",
      basename(data[["filein"]])
    )
  )

  cat(add_figure_ling(data))

}
