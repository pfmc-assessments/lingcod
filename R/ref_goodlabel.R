#' Format a vector of labels for markdown
#'
#' Format the labels to not have spaces or underscores.
#' Underscores are replaced with dashes.
#'
#' @param label A vector of character values you want to format.
#' @export
#' @author Kelli F. Johnson
#' @return A vector of formatted labels.
#' @examples
#' ref_goodlabel(c("Bad_label_with_underscores", "Bad label with spaces"))
#'
ref_goodlabel <- function(label) {
  out <- gsub("_", "-",
  gsub("\\s", "",
    label
  ))
  out
}
