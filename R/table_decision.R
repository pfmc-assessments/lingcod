#' Format a decision table
#'
#' Format a decision table for its inclusion in a document.
#'
#' @param ... Each element provided in the call to this function that is not
#' assigned to a particular input argument should be a vector of file paths
#' to the models you want to read for a given column of your decision table.
#' For example, if a single column has results from three models and
#' if your decision table has a low and high state of nature, then
#' there should be two vectors passed via `...` and each vector would contain
#' paths to three different models.
#' The order of the vectors will be the column order from left to right.
#' The order of the models within a vector will be the row order.
#' @param years A vector of years you want catches for.
#' @param rowgroup A vector of character strings to label the group names in
#' the first column that define the groups across rows.
#' Typically, this information is the catch-stream groups.
#' @param colgroup A vector of character strings to label the states of nature.
#' @template format
#' @export
#' @details todo:
#' * get lines below rowgroups, but I think this might be working in LaTeX only.
#' * write checks
#' * get vertical lines
#' * change year back to actual value
#' @author Ian G. Taylor, Chantel R. Wetzel, Kelli F. Johnson
#' @examples
#' table_decision(
#'   list(mod.2021.n.022.001, mod.2021.n.022.001, mod.2021.n.022.001),
#'   list(mod.2021.n.022.001, mod.2021.n.022.001),
#'   list(mod.2021.n.022.001, mod.2021.n.022.001),
#'   years = 2021:2032
#' )
#' table_decision(
#'   list(mod.2021.n.023.611,mod.2021.n.023.612,mod.2021.n.023.613),
#'   list(mod.2021.n.023.621,mod.2021.n.023.622,mod.2021.n.023.623),
#'   list(mod.2021.n.023.631,mod.2021.n.023.632,mod.2021.n.023.633),
#'   years = 2021:2032
#' )
table_decision <- function(
  ...,
  years,
  rowgroup = c("Constant", "ACL", "ACL2"),
  colgroup = c("Low", "Base", "High"),
  format = c("latex", "html")
) {

  mods <- list(...)
  format <- match.arg(format)

  nm <- setNames(c(1, 1, 1,rep(2, length(colgroup))), c(" ", " ", " ", colgroup))

  results <- purrr::modify_depth(mods, 2, r4ss:::SS_decision_table_stuff) %>%
  purrr::modify_depth(1, dplyr::bind_cols) %>%
  dplyr::bind_rows(.id = "Management") %>%
  dplyr::mutate(
    Management = rowgroup[as.numeric(Management)],
    Catch = pmax(na.rm = TRUE, !!!rlang::syms(grep(value = TRUE, "catch", names(.))))
  ) %>%
  dplyr::rename(Year = "yr...1") %>%
  dplyr::select_if(!grepl("yr\\.+", colnames(.))) %>%
  tidyr::pivot_longer(
    cols = grep("catch", colnames(.)),
    names_to = "group",
    values_to = "catch"
  ) %>%
  dplyr::mutate_at(
    .vars = dplyr::vars(grep(value = TRUE, "^SpawnBio", colnames(.))),
     ~ kableExtra::cell_spec(
      x = ., italic = .data$catch != .data$Catch
    )
  ) %>%
  dplyr::mutate_at(
    .vars = dplyr::vars(grep(value = TRUE, "^dep", colnames(.))),
     ~ kableExtra::cell_spec(
      x = ., italic = .data$catch != .data$Catch,
      color = "white",
      background = kableExtra::spec_color(
        .,
        begin = 0, end = 1,
        option = "D",
        scale_from = c(0,1)
        )
    )
  ) %>%
  dplyr::select_if(!grepl("catch|group", ignore.case = FALSE, colnames(.))) %>%
  dplyr::relocate(Catch, .after = Year) %>%
  dplyr::distinct(Management, Year, Catch, .keep_all = TRUE)
  rownames(results) <- NULL
  colnames(results) <- gsub("Spawn.+", "SSB   (mt)", colnames(results))
  colnames(results) <- gsub("dep.+", "Frac. unfished", colnames(results))

  results %>%
  kableExtra::kbl(
    # format = format,
    escape = FALSE,
    format = "html",
    booktabs = TRUE,
    align = c("l", "l", "r", rep(c("r", "r"), length(colgroup)))
  ) %>%
  kableExtra::column_spec(c(1), bold = TRUE) %>%
  kableExtra::column_spec(c(1, 3, 3+2*seq(1,length(colgroup)-2)), border_right = TRUE) %>%
  kableExtra::column_spec(3, color = "white",
                          background = kableExtra::spec_color(results[["Catch"]],
                                                              begin = 0.3,
                                                              end = 0.7,
                                                              option = "E",
                                                              direction = -1)) %>%
  kableExtra::kable_classic(full_width = FALSE) %>%
  kableExtra::add_header_above(nm) %>%
  kableExtra::collapse_rows(columns = 1:2, latex_hline = "major")
}
