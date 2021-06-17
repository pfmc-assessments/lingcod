#' Save a [ggplot2::ggplot] figure with caption and alt text
#'
#' Save a [ggplot2::ggplot] figure and a csv file with additional
#' information, where the figure and csv are saved with the same
#' name just different extensions.
#'
#' @param ... Parameters passed to [ggplot2::ggsave].
#' @param caption A character string providing the caption.
#' @param alttext A character string providing the alternative text.
#' @param label A character string providing the LaTeX label.
#'
#' @author Kelli F. Johnson
#' @export
#' @return The label used for the figure.
#'
ggsave2 <- function(..., caption, alttext, label) {

  ggplot2::ggsave(...)
  dots <- list(...)
  if (missing(label)) {
    label <- gsub("\\.[a-zA-Z]{3}$", "", basename(dots[["filename"]]))
  }
  outdf <- data.frame(
    caption = caption,
    alt_caption = alttext,
    label = label,
    filein = dots[["filename"]]
  )
  utils::write.csv(outdf, gsub("\\.[pngjpg]{3}", ".csv", dots[["filename"]]))
  return(label)
}
