# Fix LL's figure that is a .tiff

filetiffs <- file.path("data-raw", "F7_Lat.tiff")
tiger <- magick::image_read(filetiffs)
tiger_png <- magick::image_convert(tiger, "png")
magick::image_crop(
magick::image_crop(tiger_png, 
  geometry = "858x475", gravity = "South"),
  geometry = "858x440", gravity = "North"
) %>%
magick::image_annotate(text = "Latitude (decimal degrees)", size = 20, gravity = "south", color = "black") %>%
magick::image_write(path = file.path("figures", "Lam-kapurage7latitude.png"))
