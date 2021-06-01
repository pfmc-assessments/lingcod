#' Get grouping structure for a given species
#'
#' Get grouping structure based on a data frame of categories.
#' The data frame allows for any number of grouping variables,
#' where each row is a unique entry based on potentially multiple groups.
#'
#' @param data A data frame with a potentially infinite number of columns
#' and one row per unique entries. Columns can be named anything you desire,
#' but `area` would be a typical entry.
#' @param collapsecharacter A character value that will be used to paste names
#' together. The default is `-` and it is NOT recommended to use an underscore
#' because underscores can cause issues in LaTeX.
#'
#' @author Kelli F. Johnson
#' @export
#' @return A vector of unique names based on row entries.
#'
#' @examples
#' get_groups(data.frame(group = c("North", "South")))
#' get_groups(data.frame(
#'   area = c("North", "South"),
#' depth = c("inshore", "offshore")
#' ))
#'
get_groups <- function(
  data,
  collapsecharacter = "-"
) {
  stopifnot(is.data.frame(data))
  stopifnot(is.character(collapsecharacter))
  apply(data, 1, paste, collapse = collapsecharacter)
}
