#' get id for a lingcod model from the directory
#'
#' Uses either a `dir` like "models/2021.s.002.001_new_fleets"
#' and returns just the `id` part: "2021.s.002.001". `dir` can be a
#' vector of directories as well.
#'
#' @param dir model directory within lingcod package structure
#' @author Ian G. Taylor
#' @export
#' @seealso [get_dir_ling()]
#' @examples
#'   get_id_ling(dir = "models/2021.s.002.001_new_fleets")
#'   get_id_ling(dir = "2021.s.002.001_new_fleets")
#'   # acts as the inverse of get_dir_ling()
#'   get_id_ling(get_dir_ling(id = "2021.s.002.001"))

get_id_ling <- function(dir) {
  dir %>%
    basename() %>%
    stringr::str_sub(end = nchar("2021.s.002.001"),)
}
