#' Get fleet abbreviation based on gear group
#'
#' Get the fleet, i.e., `"TW"` or `"FG"`, depending on matching the pattern
#' to the values in `x`.
#' @param x A vector of character values.
#' @param pattern A regular expression to search for.
#' @param use A vector of two character values, where the first value will
#' be used for all values in `x` that match `pattern` and the second will
#' be used for those that do not match. The default are for trawl and
#' fixed gear abbreviations.
#' @return A vector of `"TW"` or `"FG"` depending on if the values
#' in `x` match the pattern, respectively. If you change the default
#' values in `use`, then the output will be different but still one
#' value for TRUE and another for all FALSE [grepl].
#' @author Kelli Faye Johnson
#' @export
#' @examples
#' use_fleet(c("HKL", "TWL", "POT"))
use_fleetabb <- function(
  x, 
  pattern = "^TW|^DRG|NET",
  use = c("TW", "FG")
) {
  out <- ifelse(
    test = grepl(pattern = pattern, x),
    yes = use[1],
    no = use[2]
  )
  return(out)
}
