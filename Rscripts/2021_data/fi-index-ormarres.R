# Make tables and figures for OR_FI_MarRes_CPUE
# Provided by Ali Whitman on the google drive in doc
# Data were not used in 2021 within SS

files_orfimarres <- dir(
  file.path("data-raw", "OR_FI_MarRes_CPUE"),
  full.names = TRUE
)
# Read in all excel files
excel <- mapply(readxl::read_excel, grep("xlsx$", files_orfimarres, value = TRUE))
colnames(excel[[1]]) <- c("category", excel[[1]][1,-1])

# Save the first table of sample sizes
excel[[1]][-1, ] %>% tidyr::gather(key = "Year", value = "info", -category) %>%
tidyr::spread(key = "category", value = "info") %>%
dplyr::select(-dplyr::matches("Total Cell")) %>%
dplyr::mutate_at(dplyr::vars(-Year), as.numeric) %>%
dplyr::mutate(Year = gsub("<NA>", "Total", as.character(Year))) %>%
dplyr::rename(`N pos. cell-days` = `Number of Positive Catch Cell-Days`) %>%
dplyr::rename(`N caught` = `Total Number of Lingcod Caught`) %>%
dplyr::mutate(`% pos. cell-days` = `Proportion of Positives` * 100) %>%
dplyr::select(Year, `N pos. cell-days`, `% pos. cell-days`, `N caught`) %>%
kableExtra::kbl(
  longtable = TRUE, format = "latex", booktabs = TRUE,
  label = "fi-index-ormarres-N",
  caption = paste0("Number (N) and percent positive (pos.) cell-days and ",
    "N caught across all cell-days for the Oregon hook and line survey ",
    "inside marine reserves. ",
    "Data were aggregated across sets within a cell for a given day (cell-day)."
  )
) %>%
kableExtra::row_spec(NROW(.)-1, hline_after = TRUE) %>%
kableExtra::save_kable(
  file = file.path("tables", "fi-index-ormarres-N.tex"),
)

# save the second table of areas sampled
excel[[2]] %>%
dplyr::mutate(`Years Sampled` = gsub(" – ", " - ", `Years Sampled`)) %>%
kableExtra::kbl(
  longtable = TRUE, format = "latex", booktabs = TRUE,
  label = "fi-index-ormarres-mr",
  caption = paste0(
    "Summary of marine reserves sampled within the ",
    "Oregon hook and line survey by the Marine Reserve Program."
  )
) %>%
kableExtra::save_kable(
  file.path("tables", "fi-index-ormarres-mr.tex")
)

# convert tiffs to pngs
filetiffs <- grep("tiff", files_orfimarres, value = TRUE)
filename <- gsub("\\s", "",
    gsub("tiff", "png",
      gsub("data-raw/.+/", "figures/fi-index-ormarres-", filetiffs)
    ))
for (ii in seq_along(filetiffs)) {
tiger <- magick::image_read(filetiffs[ii])
tiger_png <- magick::image_convert(tiger, "png")
magick::image_write(tiger_png, filename[ii])
}

# Write the captions
utils::write.csv(
  data.frame(
    caption = c(
     paste0("\\Glsentrylong{cpue} (\\glsentryshort{cpue}) of positive, ", spp, " records within the Oregon hook and line survey within marine reserves."),
     paste0("Frequency of positive catches of, ", spp, " across all years for the Oregon hook and line survey within marine reserves."),
     paste0("Relative mean \\Glsentrylong{cpue} (\\glsentryshort{cpue}), i.e., number of positive records per angler hour, for ", spp, " in the Oregon hook and line survey within marine reserves.")
    ),
    alt_caption = c(
      "Flat index with large uncertainty in recent years.",
      "Large number of records with few `r spp`.",
      "Index is centered around zero."
    ),
    label = gsub("\\.png|_", "", basename(filename))[c(2,1,3)],
    filein = file.path("..", filename)[c(2,1,3)]
  ),
  row.names = FALSE,
  file = file.path("figures", "figures-fi-index-ormarres.csv")
)
