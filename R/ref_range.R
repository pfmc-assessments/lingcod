#' Reference a range of figure numbers
#'
#' Often users will want to reference a range of figures that pertain to
#' a particular data type.
#' For example, you may want to reference the conditional age-at-length figures
#' for a particular fleet.
#' But what happens when the number of figures changes when you add or remove
#' fleets or years included in the model?
#' Worst case, you have to find everywhere in the markdown or LaTeX code that
#' this figure type is referenced and change each line.
#' Instead, you can use this function to find the references for you.
#' All you need is to supply the a bit of the files that you are looking for
#' and which fleet(s) is of interest to you.
#'
#' @param figuredata A data frame of specifications for figures within your document.
#' This data frame is most often automatically generated and specific to your model.
#' @param grep A character string to search for in `figuredata`.
#' @param column The column name that you want to search for `grep` in.
#' Typically this will be `"file"`.
#' @param fleets Either numeric values or a valid character string that can be used
#' to find the rows of the fleet table that are of interest.
#' Depending on how you made your csv files via [r4ss::SS_plot] the references
#' to fleets in the csv might be different.
#' Select the appropriate column of [get_fleet] based on how you made the figures.
#' @param fleettype A value to append to `fleets`.
#' The default is nothing, which leads to all types being included.
#' But, if you only wanted to include `"mkt0"` fleets, then you could use `"mkt0"`.
#' @param encapsulate A logical value specifying if you want the result to be
#' encapsulated in round brackets.
#'
#' @details
#' Try testing this function out before you include it in your .Rmd file.
#' All you will need is the file path to the csv that contains the information
#' in `figuredata` and you can use [utils::read.csv] right in the call to this
#' function so you don't pollute your workspace. The result of this function
#' should look exactly like how you want it to appear in your document, except
#' the @ symbol will be double escaped instead of just single escaped.
#' Trust me, it will still work like this.
#'
#' @export
#' @author Kelli F. Johnson
#' @return A character string formatted for markdown.
#'
ref_range <- function(
  figuredata,
  grep,
  column = "file",
  fleets = get_fleet(col = "num"),
  fleettype = "",
  encapsulate = TRUE
) {

  # Work out fleet numbers
  if (is.numeric(fleets)) {
    fleets <- paste0("flt", fleets)
  }
  rows_goodfleet <- grep(
    paste0(
      paste0(fleets, collapse = "|"),
      fleettype
    ),
    figuredata[, column]
  )
  figuredata <- figuredata[rows_goodfleet, ]
  if (NROW(figuredata) == 0) {
    return("")
  }

  # Search data frame
  if (length(grep) > 1) {
    grep <- paste0(grep, collapse = "|")
  }
  figuredata <- figuredata[grep(grep, figuredata[, column]), ]
  if (NROW(figuredata) == 0) {
    return("")
  }

  # Make the text
  figuredata[, "label"] <- ref_goodlabel(figuredata[, "label"])
  out <- sprintf("\\@ref(fig:%s)", figuredata[, "label"])
  # Check if there is just one b/c we want to use Figure ...
  # instead of Figures ...
  if (NROW(figuredata) == 1) {
    out <- paste0("Figure ", out)
  } else {
  # Check if all in the sequence are available, because then
  # we can use xx - yy instead of aa, bb, and cc
    seqinfo <- row.names(figuredata)
    if (all(min(seqinfo):max(seqinfo) %in% seqinfo)) {
      out <- paste0(out[1], " - ", out[length(out)])
    } else {
      out <- knitr::combine_words(out)
    }
    out <- paste0("Figures ", out)
  }
  # Add outer brackets if specified
  if (encapsulate) {
    out <- paste0("(", out, ")")
  }

  return(out)
}
