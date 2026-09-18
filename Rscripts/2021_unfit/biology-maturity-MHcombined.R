file_fig1 <- file.path("data-raw", "age_mat_forassessment.png")
file_fig2 <- file.path("data-raw", "Length_mat_forassessment.png")

tiger1 <- magick::image_read(file_fig1) %>%
  magick::image_annotate(
    c("                           "), gravity = "southeast",
    size = 30, location = "+220+10", boxcolor = "white"
  ) %>%
  magick::image_crop(gravity = "north", "1000x500") %>%
  magick::image_crop(gravity = "southwest", "620x445")
plot(tiger1)
tiger2 <- magick::image_read(file_fig2) %>%
  magick::image_annotate(
    c("                           "), gravity = "southeast",
    size = 30, location = "+220+10", boxcolor = "white"
  )  %>%
  magick::image_crop(gravity = "northeast", "575x500") %>%
  magick::image_crop(gravity = "south", "575x445")
plot(tiger2)
dual <- c(tiger1, tiger2) %>%
  magick::image_annotate(
    c("Age (yr)", "Length (cm)"), gravity = "south",
    size = 30, location = "0"
  )

magick::image_write(
  image_append(dual),
  path = file.path("figures", "age_mat_forassessment.png")
)
dev.off()
