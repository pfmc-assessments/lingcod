#' Format text for a range from a vector
#'
#' Format the range (i.e., minimum and maximum) from a vector
#' for inclusion in a text document with or without parentheses.
#'
#' @details todo:
#' Format the range values to have a given number of digits if users are not
#' using it for just a year range.
#'
#' @param x A vector of numeric values.
#' @param parentheses A logical value specifying if you want the value returned
#' to be wrapped in parentheses or not. By default, they are included.
#'
#' @author Kelli Faye Johnson
#' @export
#' @return A formatted character string.
#' @examples
#' format_range(1:12)
format_range <- function(x, parentheses = TRUE) {
  text <- knitr::combine_words(range(x), and = " to ")
  if (parentheses) {
    sprintf("(%s)", text)
  } else {
    sprintf("%s", text)
  }
}
