#' Summarize the configuration of the SS output
#'
#' @param output A list from [r4ss::SS_output].
#' @export
#' @examples
#' table_outputconfig(output)
table_outputconfig <- function(output) {

  slxtable <- table_outputslx(output)

  data <- data.frame(
    Section = c(
      "Maximum age",
      "Sexes",
      "Population bins",
      "Summary biomass (mt) age",
      "Number of areas",
      "Number of seasons",
      "Number of growth patterns",
      "Start year",
      "Catch units",
      "Data length bins",
      "Data age bins",
      "First age with positive maturity",
      "First year of main recruitment deviations",
      "Fishing mortality ($F$) method"
    ),
    Parameterization = c(
      output[["accuage"]],
      ifelse(output[["nsexes"]] == 2, "Females \\& males", "Females"),
      sprintf(
        "%i-%i cm by %i cm bins",
        output[["lbinspop"]][1],
        dplyr::last(output[["lbinspop"]]),
        output[["lbinspop"]][2] - output[["lbinspop"]][1]
      ),
      sprintf("%i+", output[["summary_age"]]),
      output[["nareas"]],
      output[["nseasons"]],
      output[["ngpatterns"]],
      output[["startyr"]],
      ifelse(all(output[["catch_units"]] == 1), "mt", "I don't know"),
      sprintf(
        "%i-%i cm by %i cm bins",
        output[["lbins"]][1],
        dplyr::last(output[["lbins"]]),
        output[["lbins"]][2] - output[["lbins"]][1]
      ),
      sprintf(
        "%i-%i cm by %i year",
        output[["agebins"]][1],
        dplyr::last(output[["agebins"]]),
        output[["agebins"]][2] - output[["agebins"]][1]
      ),
      output[["endgrowth"]] %>% dplyr::filter(Sex == 1, Age_Beg < 5, Age_Mat != 0) %>% dplyr::select(Age_Beg,Age_Mat) %>% round(3) %>% dplyr::pull(Age_Beg) %>% dplyr::first(),
      output[["recruitpars"]]%>%dplyr::filter(grepl("Main", type)) %>% dplyr::pull(Yr) %>% min,
      ifelse(output[["F_method"]] == 3, "Hybrid $F$", "I don't know")
    )
  )

  ## Format the output_specifications table
  kableExtra::kbl(rbind(
    data,
    slxtable %>%
      dplyr::select(label_long, form) %>%
      dplyr::arrange(dplyr::vars("order")) %>%
      dplyr::mutate(label_long = paste(label_long, "selectivity")) %>%
      dplyr::rename(Section = label_long, Parameterization = form)
    ),
    booktabs = TRUE, escape = FALSE,
    format = "latex", longtable = FALSE,
    caption = "Specifications and structure of the base output.",
    label = "output-specifications"
  ) %>%
    kableExtra::pack_rows("Population characteristics", 1, 7) %>%
    kableExtra::pack_rows("Data characteristics", 8, 13) %>%
    kableExtra::pack_rows("Fishing characteristics", 14, 14+NROW(slxtable))

}

table_outputslx <- function(output) {
  slxtable <- output[["parameters"]] %>%
    dplyr::filter(grepl("Size", Label)) %>% dplyr::select(Label, Phase) %>%
    tidyr::separate(Label, remove = FALSE, extra = "merge", sep = "_", into = c("type", "form", "parameter", "something", "fleet")) %>%
    tidyr::separate(fleet, extra = "drop", sep = "\\(|\\)", into = c("fleet", "fleetnumber")) %>% 
    dplyr::mutate(fleet = gsub("^[0-9]+_", "", fleet)) %>%
    dplyr::distinct(fleetnumber, .keep_all = TRUE) %>%
    dplyr::mutate(
      fleetnumber = as.numeric(fleetnumber),
      form = dplyr::case_when(
        form == "DblN" ~ "double normal",
        TRUE ~ "I don't know"
    )) %>%
    dplyr::left_join(
      y = get_fleet(),
      by = c(fleetnumber = "num")
    ) %>%
    dplyr::mutate(label_long = gsub("&", "\\\\&", label_long))
  return(slxtable)
}
