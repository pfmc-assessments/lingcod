#' Plot sample sizes by group horizontally
#'
#' Plot sample sizes by area (y axis, line color), survey (color),
#' and measurement type (vertical panels) with text
#' providing the number of samples per group.
#' The horizontal stacked bar plots are helpful for relative
#' comparisons between areas and surveys.
#'
#' @param data A data frame with the following columns:
#'   * survey: sampling group
#'   * area: geographic area
#'   * measurement: type of measurement
#'   * values: stores the sample sizes
#' @param dodge_n A value between 0 and 1.0 that determines how
#' far apart the text values are with respect to their group on
#' the y axis such that long numbers do not overlap when the
#' samples sizes are small. In short, how much of the vertical
#' space within your y-axis group do you want to use when printing
#' the sample sizes. A large value means that there is no chance
#' for overlap because each value will have a unique height and
#' zero will place all values within a single plane. The default
#' is fairly large and will space the numbers vertically.
#' @param font_family The font family used for the sample size
#' information that is printed on the figure.
#' @param title_fill A character entry specifying the title for
#' the fill legend. The default of `""` removes the title.
#' @param file A file path to save the figure to.
#' The path should end in `.png`.
#' @param file_width The width in inches that you wish the resulting
#' figure that is saved to the disk to be. The default of 15 results
#' in a wide figure.
#'
#' @import ggplot2
#' @author Kelli F. Johnson
#' @return A \pkg{ggplot2} object is returned.
#' If `file` is specified then a the same returned figure is
#' also saved to the disk given the specified name using
#' [ggplot2::ggsave].
#'
#' @examples
#' ninfo <- data.frame(
#'   survey = rep(c("WCGBTS", "Triennial", "Hook and Line"), each = 6),
#'   area = rep(c("North", "South"), 9),
#'   measurement = rep(rep(c("Length", "Weight", "Age"), each = 2), 3),
#'   values = c(
#'     14360, 10917, 7869, 5548, 4655, 2905,
#'     3539, 1622, 2238, 939, 1731, 802,
#'     NA, 825, NA, 825, NA, 187
#'   )
#' )
#' x <- plot_n(data = ninfo, file = "n_surveybiological.png")
#' print(x)
#' unlink("n_surveybiological.png")
#'
plot_ntable <- function(
  data,
  dodge_n = 0.9,
  font_family = "sans",
  title_fill = "",
  file,
  file_width = 15
) {

data <- data %>%
  dplyr::group_by(survey, area, measurement) %>% 
  dplyr::arrange(measurement, dplyr::desc(survey), dplyr::desc(area)) %>%
  dplyr::mutate(area = factor(area, levels = rev(unique(data[["area"]])))) %>%
  dplyr::group_by(area, measurement) %>%
  dplyr::mutate(nlabel = cumsum(values) - values/2) %>%
  dplyr::ungroup()
gg <- ggplot(data,
  aes(
    y = area,
    x = values,
    col = area,
    fill = survey
  )
  ) +
  geom_col(position = "stack", size = 0.9, width = 0.98) +
  geom_text(
    check_overlap = FALSE,
    position = position_dodge(dodge_n),
    col = "black",
    aes(x = nlabel, label = values),
    size = 18/.pt,
    family = font_family
  ) +
  scale_y_discrete(expand = c(0, 0), name = NULL) +
  scale_x_continuous(expand = c(0, 0), breaks = NULL, name = NULL) +
  colorblindr::scale_fill_OkabeIto() +
  scale_colour_manual(
    values = rev(r4ss::rich.colors.short(length(unique(data[["area"]])))),
    name = NULL
  ) +
  facet_grid(measurement ~ .) +
  coord_cartesian(clip = "off") +
  theme(
    # panel.background = element_blank(),
    plot.margin = margin(14/2/2, 1.5, 14/2/2, 1.5),
    complete = TRUE,
    panel.background = element_rect(fill = NA),
    panel.border = element_rect(colour = "black", fill = NA, size = 0.5),
    panel.grid.major = element_blank(),
    axis.ticks = element_blank(),
    axis.text = element_text(size = 16),
    legend.text = element_text(size = 16),
    strip.text = element_text(size = 16),
    legend.position = "bottom",
    legend.justification = "center",
    legend.background = element_rect(fill = "white"),
    legend.spacing.x = grid::unit(4.5, "pt"),
    legend.spacing.y = grid::unit(0, "cm"),
    legend.box.spacing = grid::unit(7, "pt"),
    strip.placement = "outside",
    strip.text.y.right = element_text(angle = 0),
    strip.background = element_blank()
  ) + 
  guides(
    col = FALSE,
    fill = guide_legend(title = title_fill, reverse = TRUE)
  )

# Save the figure only if the input argument file is provided
if (!missing(file)) {
  ggplot2::ggsave(gg,
    file = file,
    width = file_width)
}
return(invisible(gg))
}

###############################################################################
# Original code
# https://github.com/clauswilke/dataviz/blob/master/visualizing_amounts.Rmd

# titanic_groups <- titanic_all %>% filter(class != "*") %>% 
#   select(class, sex) %>% 
#   group_by(class, sex) %>% 
#   tally() %>% arrange(class, desc(sex)) %>%
#   mutate(sex = factor(sex, levels = c("female", "male"))) %>%
#   group_by(class) %>%
#   mutate(nlabel = cumsum(n) - n/2) %>%
#   ungroup() %>%
#   mutate(class = paste(class, "class"))
# ggplot(titanic_groups, aes(x = class, y = n, fill = sex)) +
#   geom_col(position = "stack", color = "white", size = 1, width = 1) +
#   geom_text(
#     aes(y = nlabel, label = n), color = "white", size = 14/.pt,
#     family = font_family
#   ) +
#   scale_x_discrete(expand = c(0, 0), name = NULL) +
#   scale_y_continuous(expand = c(0, 0), breaks = NULL, name = NULL) +
#   scale_fill_manual(
#     values = c("#D55E00", "#0072B2"),
#     breaks = c("female", "male"),
#     labels = c("female passengers   ", "male passengers"),
#     name = NULL
#   ) +
#   coord_cartesian(clip = "off") +
#   theme_dviz_grid() +
#   theme(
#     panel.grid.major = element_blank(),
#     axis.ticks = element_blank(),
#     axis.text = element_text(size = 14),
#     legend.position = "bottom",
#     legend.justification = "center",
#     legend.background = element_rect(fill = "white"),
#     legend.spacing.x = grid::unit(4.5, "pt"),
#     legend.spacing.y = grid::unit(0, "cm"),
#     legend.box.spacing = grid::unit(7, "pt")
#   )
