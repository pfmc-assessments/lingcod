#' Summarize profile results of parameters
#'
#' @param summarylist A list of summarized Report.sso files.
#' @param pargrep A character value to search for using [grepl] on the column
#'   `summarylist[["Label"]]`.
#' @author Kelli F. Johnson
#' @examples
#' \dontrun{
#' # Read in models
#' profilemodels <- SSgetoutput(
#'   dirvec = mydir,
#'   keyvec = 1:((dir(mydir,pattern="^Report") %>% length)-1)
#' )
#' # Summarize output
#' profilesummary <- SSsummarize(profilemodels)
#' table_profile(profilesummary, pargrep = "NatM") %>%
#' knitr::kable(
#'   format = "latex",
#'   align = "r",
#'   position = "H",
#'   digits = 3,
#'   booktabs = TRUE,
#'   longtable = FALSE,
#'   caption = "Parameter estimates of natural mortality, $M$, from the likelihood profile over $M_{female}$ showing the correlation between the two parameters.",
#'   label = "profile-M",
#'   escape = FALSE,
#'   linesep = ""
#' ) %>%
#' kableExtra::save_kable(
#'   file = file.path(profilemodels$replist1$inputs$dir, "profile-M.tex")
#' )
#' }
table_profile <- function(
  summarylist,
  pargrep
) {
  summarylist[["pars"]] %>%
    dplyr::filter(grepl(pargrep, Label)) %>%
    dplyr::select(!Yr) %>%
    dplyr::select(!recdev) %>%
    tidyr::pivot_longer(!Label, names_prefix = "replist") %>%
    tidyr::pivot_wider(names_from = Label, values_from = value) %>%
    dplyr::select(!name) %>%
    dplyr::arrange(dplyr::across(dplyr::contains(pargrep))) %>%
    dplyr::rename(
      "$M_{female}$" = NatM_uniform_Fem_GP_1,
      "$M_{male}$" = NatM_uniform_Mal_GP_1
    )
}
