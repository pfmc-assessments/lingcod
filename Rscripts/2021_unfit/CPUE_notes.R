# plot rec CPUE for southern model
data_index_cpue %>%
 dplyr::filter(index %in% c(5,10), area == "south") %>%
 dplyr::select(year, obs, source) %>%
 ggplot(aes(x=year, y=obs, color=source)) + geom_point()
