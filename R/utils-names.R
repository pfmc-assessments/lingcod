#' Get name
#'
#' Get a name for the analysis.
#'
#' @param type The type of name that you want.
#' Only one type is allowed, where the first type listed will be the default.
#' Capitalization of the input argument will dictate how the output if formatted.
#' For example `common` leads to `lingcod` and `Common` leads to `Lingcod` unless
#' the capitalization is the same whether or not the result is a title or not
#' such as for latin names.
#'
#' @return A string of text based on what type of output you specify.
#' @export
#' @examples
#' utils_name(type = "common")
#'
#' @author Kelli Faye Johnson
#'
utils_name <- function(
  type = c("common", "Common", "latin", "PACFIN", "area", "Area", "latitude", "latitude2")
) {

  type <- match.arg(type, several.ok = FALSE)

  output <- unlist(switch(EXPR = type,
    common = "lingcod",
    Common = "Lingcod",
    latin = "Ophiodon elongatus",
    PACFIN = "LCOD",
    latitude = 40 + 10/60,
    latitude2 = round(40 + 10/60, 2),
    area = list("north", "south"),
    Area = list("North", "South"),
    paste0("todo: DEFINE THIS type in utils_name(type = ", type, ")")
  ))

  return(output)
}
