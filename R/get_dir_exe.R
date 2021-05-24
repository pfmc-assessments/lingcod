#' Get directory with Stock Synthesis executable in Lingcod package
#'
#' Should find executable within package regardless of the location
#' on any user's system. Could be expanded in the future for different
#' operating systems.
#'
#' @author Ian G. Taylor
#' @export
#' @seealso [get_dir_ling()]
#' @examples
#' \dontrun{
#'   # find directory with executable
#'   get_dir_exe()
#' 
#'   # copy model files to a new directory and bring in executable
#'   r4ss::copy_SS_inputs(dir.old = get_dir_ling(area = area, num = 1),
#'                        dir.new = get_dir_ling(area = area, num = 2), 
#'                        use_ss_new = FALSE,
#'                        copy_exe = TRUE,
#'                        dir.exe = get_dir_exe())
#' }

get_dir_exe <- function(){
  system.file("inst/bin/Windows64", package = "lingcod")
}
