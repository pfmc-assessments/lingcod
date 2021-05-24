#' translate between fleet names and numbers and old or new
#'
#' uses models/fleets.csv as a lookup table to translate between
#' different combinations
#' 
#' @param value either a fleet number or a string matching the fleet name
#' @param area either "n" or "s"
#' @param yr year (assumed 2021 if not specified)
#' @param ignore.case if FALSE, the pattern matching is case sensitive and
#' if TRUE, case is ignored during matching (passed to `grep`)
#' @param verbose logical controlling feedback about internal results
#' @author Ian G. Taylor
#' @export
#' @examples
#' \dontrun{
#'   # current fleet number for trawl fishery
#'   get_fleet("trawl")$num
#'
#'   # plain text label associated with fleet 3
#'   get_fleet(3)$label_short
#'
#'   # current fleet number that corresponds to an old fleet name
#'   get_fleet("TRI_Early", area = "s", yr = 2019)$num
#'
#'   # current fleet number that corresponds to an old fleet number
#'   get_fleet(4, area = "s", yr = 2019)$num
#'
#'   # info on all current rec fleets
#'   get_fleet("rec")
#' }

get_fleet <- function(value,
                      yr = 2021,
                      area = NULL,
                      ignore.case = TRUE,
                      verbose = FALSE){
  if (is.null(value)) {
    stop("Input 'value' needs to be provided")
  }
  if (!yr %in% c(2019, 2021)) {
    stop("Input 'yr' needs to be 2019 or 2021")
  }

  # read table of fleet info
  fleets <- read.csv("models/fleets.csv")

  # get numeric values for the fleets
  # (could instead be added as separate column to fleets.csv)
  fleets$num <- as.numeric(stringr::str_split(fleets$fleet,
                                              pattern = "_",
                                              n = 2,
                                              simplify = TRUE)[,1])
  
  if (yr == 2021) {
    colname <- "fleet"
  }
  if (yr == 2019) {
    if (is.character(value) & is.null(area)) {
      stop("'area' input needed in combination with 'value'",
           "for 2019 models")
    }
    if (!area %in% c("n", "s")) {
      stop("Area should be 'n' or 's'")
    }
    colname <- paste0("fleets_2019.", area)
  }

  # get first row which matches the fleet number
  if (is.numeric(value)) {
    rows <- which(fleets$num == value)
    # filter when multiple rows are returned based on fleet number
    if (length(rows) > 1 & verbose) {
      message("multiple rows have fleet number ", value, "using the first one")
      rows <- min(rows)
    }
  }
  
  # get all rows that match when a string is provided
  if (is.character(value)) {
    rows <- grep(value, fleets[[colname]], ignore.case = ignore.case)
  }

  # return subset of fleets
  fleets[rows,]
}
