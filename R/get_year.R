#' 
#' Get the assessment year
#'
#' Get the assessment year based on the current month.
#' If the current month is past June, then it is more than likely that you are working
#' on an assessment for next year and thus the assessment year would be current year + 1.
#'
#' @param incrementafter A character or numeric value representing the last
#' month you would be working on an assessment for the current year.
#' The default, `"September"`, leads to the returned value being the next year
#' if the current month is October or later.
#' If using the character version, it must be the full month name,
#' though case is ignored.
#'
#' @author Kelli Faye Johnson
#' @export
#' @return An integer object representing the current year.
#'
#' @examples
#' # Use an integer to represent the month
#' get_year(2)
#' # Use full month name
#' get_year("February")
#' # Case does not matter
#' get_year("may")
#'
get_year <- function(incrementafter = "September") {
  stopifnot(tolower(incrementafter) %in% c(1:12, tolower(month.name)))
  date <- Sys.Date()
  year <- as.integer(format(date, "%Y"))
  month <- as.integer(format(date, "%m"))
  if (is.character(incrementafter)) {
    incrementafter_i <- match(
      x = tolower(incrementafter),
      table = tolower(month.name)
    )
  } else {
    incrementafter_i <- incrementafter
  }

  if (month > incrementafter_i) {
    year <- year + 1
  }

  return(year)
}
