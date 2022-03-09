# Pulled from doc/catch.Rmd
# to do - figure out a way to run this in its own file to create the
# data frame and then test it.
# data_albin <- read.csv(file = file.path("..", "data-raw", file_albin),
#   skip = 2, header = TRUE, check.names = FALSE
# ) %>%
#   rlang::set_names(paste(sep = "_",
#     read.csv(
#       file = file.path("..", "data-raw", file_albin),
#       skip = 1, header = FALSE, check.names = FALSE, nrows = 1
#     ),
#     colnames(.))
#   ) %>%
#   dplyr::rename(Year = "NA_Year") %>%
#   tidyr::gather("type", "value", -Year) %>%
#   tidyr::separate(type, into = c("Area", "type"), sep = "_") %>%
#   tidyr::spread(key = "type", value = "value") %>%
#   dplyr::arrange(Area) %>%
#   dplyr::mutate(Source = "albinetal1993") %>%
#   dplyr::filter(Area != "Total") %>%
#   dplyr::group_by(Year) %>%
#   dplyr::mutate(sum = sum(Est)) %>%
#   dplyr::group_by(Area, Year) %>%
#   dplyr::mutate(prop_source = Est / sum) %>%
#   dplyr::ungroup()

# # confirm that outputs are same as previously calculated values
# testthat::expect_equal(
#   stats::aggregate(data_albin$Est,
#     by = list(data_albin$Year),
#     FUN = sum
#   ),
#   data.frame(
#     Group.1 = 1981:1986,
#     x = c(118, 111, 108, 134, 168, 219)
#   ),
#   label = "Yearly total of albinetal1993 Est"
# )
# #
# testthat::expect_equal(tolerance = 0.001,
#   data_albin %>%
#     dplyr::group_by(Area) %>%
#     dplyr::summarize(mean = mean(prop_source), .groups = "keep") %>%
#     dplyr::pull(mean),
#   c(0.178, 0.192, 0.166, 0.124, 0.340),
#   label = "Area-specific mean of albinetal1993 prop_source"
# )
# #
# testthat::expect_equal(tolerance = 0.001,
#   data_albin %>%
#     dplyr::group_by(Year) %>%
#     dplyr::mutate(YearT = sum(Est)) %>% dplyr::ungroup() %>%
#     dplyr::group_by(Area) %>%
#     dplyr::summarize(wmean = stats::weighted.mean(prop_source, w = YearT), .groups = "keep") %>%
#     dplyr::pull(wmean),
#   c(0.181, 0.189, 0.161, 0.127, 0.343),
#   label = "Area-specific weighted mean of albinetal1993 prop_source"
# )
