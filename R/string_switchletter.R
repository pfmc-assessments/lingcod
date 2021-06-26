#' Switch a single letter in a string with a new letter
#'
#' Switch a single letter in a character string that is surrounded by
#' either full stops, underscores, or dashes with a new letter.
#' This is helpful when a file path has a single letter for area or
#' some other category and you want to easily switch it out with a new
#' letter. For example, "apple-a-sweet" can easily be changed to
#' "apple-b-sweet" with this function.
#'
#' @param x A character string.
#' @param newletter A character string of any length you want, but
#' only the first letter will be used to replace the value in `x`.
#' Note that we do not pay attention to case here and all new letters
#' will be lower-case.
#'
#' @author Kelli F. Johnson
string_switchletter <- function(x, newletter) {
  arealetter <- substr(tolower(newletter), 1, 1)
  gsub("([\\._-])[a-z]([\\._-])", paste0("\\1", arealetter, "\\1"), x)
}
