#Script to plot catch and dead discards for North and South
#STAR panel on day 1, Request 4
library(ggplot2)

##
#North model
##
output <- get_mod(area = "n", num = 22)

output$catch$dead_disc_bio <- output$catch$kill_bio - output$catch$ret_bio
n_out <- output$catch[,c("Yr", "Fleet", "Fleet_Name","ret_bio", "dead_disc_bio", "kill_bio")]
n_out$percentage <- n_out$dead_disc_bio/n_out$kill_bio

n_out_long <- tidyr::gather(n_out, key = disposition, value = value, dead_disc_bio:ret_bio) 

#Plot of output

gg <- n_out_long %>%
  dplyr::filter(Fleet %in% c(1,2)) %>%
  ggplot2::ggplot(ggplot2::aes(
    x = Yr,
    y = value,
    fill = disposition
  )) +
    #ggplot2::scale_fill_manual(
    #  values = unlist(t(get_fleet(value="Comm")[,c("col.n","col.s")]),use.names=FALSE)
    #) +
    ggplot2::facet_grid(Fleet_Name ~ .) +
    ggplot2::geom_bar(position = "stack", stat = "identity") +
    #ggplot2::scale_y_continuous(labels = scales::percent) +
    ggplot2::theme_bw() + ggplot2::theme(
      strip.background = ggplot2::element_rect(fill = NA),
      # text = ggplot2::element_text(size = 10),
      legend.position = c(0.15,0.8)
    ) +
    ggplot2::xlab("Year") + ggplot2::ylab("Disposition of Total Mortality in Comm. Fleets")
ggplot2::ggsave(
  filename = file.path(getwd(), "figures", "STAR_Day1_request4", "North_comm_catch_disposition_stacked.png"),
  width=6,height=4, units="in"
)

#Percentage stack
gg <- n_out_long %>%
  dplyr::filter(Fleet %in% c(1,2)) %>%
  ggplot2::ggplot(ggplot2::aes(
    x = Yr,
    y = value,
    fill = disposition
  )) +
  #ggplot2::scale_fill_manual(
  #  values = unlist(t(get_fleet(value="Comm")[,c("col.n","col.s")]),use.names=FALSE)
  #) +
  ggplot2::facet_grid(Fleet_Name ~ .) +
  ggplot2::geom_bar(position = "fill", stat = "identity") +
  #ggplot2::scale_y_continuous(labels = scales::percent) +
  ggplot2::theme_bw() + ggplot2::theme(
    strip.background = ggplot2::element_rect(fill = NA),
    # text = ggplot2::element_text(size = 10),
    legend.position = c(0.15,0.8)
  ) +
  ggplot2::xlab("Year") + ggplot2::ylab("Percentage of Catch Discarded in Comm. Fleets")
ggplot2::ggsave(
  filename = file.path(getwd(), "figures", "STAR_Day1_request4", "North_comm_catch_disposition_percentage.png"),
  width=6,height=4, units="in"
)

##
#South model
##
output <- get_mod(area = "s", num = 14)

output$catch$dead_disc_bio <- output$catch$kill_bio - output$catch$ret_bio
s_out <- output$catch[,c("Yr", "Fleet", "Fleet_Name","ret_bio", "dead_disc_bio", "kill_bio")]
s_out$percentage <- s_out$dead_disc_bio/s_out$kill_bio

s_out_long <- tidyr::gather(s_out, key = disposition, value = value, dead_disc_bio:ret_bio) 

#Plot of output

gg <- s_out_long %>%
  dplyr::filter(Fleet %in% c(1,2)) %>%
  ggplot2::ggplot(ggplot2::aes(
    x = Yr,
    y = value,
    fill = disposition
  )) +
  #ggplot2::scale_fill_manual(
  #  values = unlist(t(get_fleet(value="Comm")[,c("col.n","col.s")]),use.names=FALSE)
  #) +
  ggplot2::facet_grid(Fleet_Name ~ .) +
  ggplot2::geom_bar(position = "stack", stat = "identity") +
  #ggplot2::scale_y_continuous(labels = scales::percent) +
  ggplot2::theme_bw() + ggplot2::theme(
    strip.background = ggplot2::element_rect(fill = NA),
    # text = ggplot2::element_text(size = 10),
    legend.position = c(0.15,0.8)
  ) +
  ggplot2::xlab("Year") + ggplot2::ylab("Disposition of Total Mortality in Comm. Fleets")
ggplot2::ggsave(
  filename = file.path(getwd(), "figures", "STAR_Day1_request4", "South_comm_catch_disposition_stacked.png"),
  width=6,height=4, units="in"
)

#Percentage stack
gg <- s_out_long %>%
  dplyr::filter(Fleet %in% c(1,2)) %>%
  ggplot2::ggplot(ggplot2::aes(
    x = Yr,
    y = value,
    fill = disposition
  )) +
  #ggplot2::scale_fill_manual(
  #  values = unlist(t(get_fleet(value="Comm")[,c("col.n","col.s")]),use.names=FALSE)
  #) +
  ggplot2::facet_grid(Fleet_Name ~ .) +
  ggplot2::geom_bar(position = "fill", stat = "identity") +
  #ggplot2::scale_y_continuous(labels = scales::percent) +
  ggplot2::theme_bw() + ggplot2::theme(
    strip.background = ggplot2::element_rect(fill = NA),
    # text = ggplot2::element_text(size = 10),
    legend.position = c(0.15,0.8)
  ) +
  ggplot2::xlab("Year") + ggplot2::ylab("Percentage of Catch Discarded in Comm. Fleets")
ggplot2::ggsave(
  filename = file.path(getwd(), "figures", "STAR_Day1_request4", "South_comm_catch_disposition_percentage.png"),
  width=6,height=4, units="in"
)
