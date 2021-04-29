#' Converter to get from pounds to metric tons
#'
#' Multiply by this value to get from pounds to metric tons.
#'
#' @author Kelli Faye Johnson
#' @export
#' @return A single numeric values
#' @examples
#' # Convert 1 lb to metric tons
#' 1 * mult_lbs2mt()
#'
mult_lbs2mt <- function() {
  return(1 / 2204.6226)
}
