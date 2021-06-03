#' translate between fleet names and numbers and old or new
#'
#' uses models/fleets.csv as a lookup table to translate between
#' different combinations
#' 
#' @param value either a fleet number or a string matching the fleet name
#' a NULL value will return the full table of all fleet info for the associated
#' year (separate TRI_Early and TRI_Late will be returned with yr = 2019, not
#' yr = 2019).
#' a vector of numeric values will return a vector 
#' @param area either "n" or "s"
#' @param yr year (assumed 2021 if not specified)
#' @param ignore.case if FALSE, the pattern matching is case sensitive and
#' if TRUE, case is ignored during matching (passed to `grep`)
#' @param col column(s) to return. NULL will return all columns.
#' @author Ian G. Taylor
#' @export
#' @examples
#'   # current fleet number for trawl using "col" input added 3-June-2021
#'   get_fleet("trawl", col = "num")
#'
#'   # current fleet number for trawl before "col" input was available
#'   get_fleet("trawl")$num
#'
#'   # plain text label associated with fleet 3
#'   get_fleet(3, col = "label_short")
#'
#'   # current fleet number that corresponds to an old fleet name
#'   get_fleet("TRI_Early", area = "s", yr = 2019, col = "num")
#'
#'   # current fleet number that corresponds to an old fleet number
#'   get_fleet(4, area = "s", yr = 2019, col = "num")
#'
#'   # current fleet number that corresponds to a vector of old fleet numbers
#'   get_fleet(value = c(1,2,2,3), yr = 2019, area = 's', col = "num")
#'
#'   # info on all current rec fleets
#'   get_fleet("rec")
#'
#'   # info on all fleets in 2021 models (excludes duplicates)
#'   get_fleet()
#'
#'   # info on all fleets in 2019 models
#'   # (includes separate rows for TRI_Early and TRI_Late)
#'   get_fleet(yr = 2019)

get_fleet <- function(value = NULL,
                      yr = 2021,
                      area = NULL,
                      ignore.case = TRUE,
                      col = NULL){
  if (!yr %in% c(2019, 2021)) {
    stop("Input 'yr' needs to be 2019 or 2021")
  }

  # read table of fleet info
  fleets <- utils::read.csv(system.file("extdata", "fleets.csv", package = "lingcod"))

  # select all columns to return if not requested
  if (is.null(col)) {
    col <- names(fleets)
  }
  
  # get numeric values for the fleets
  # (could instead be added as separate column to fleets.csv)
  fleets$num <- as.numeric(stringr::str_split(fleets$fleet,
                                              pattern = "_",
                                              n = 2,
                                              simplify = TRUE)[,1])
  fleets$num_2019.s <- as.numeric(stringr::str_split(fleets$fleets_2019.s,
                                                     pattern = "_",
                                                     n = 2,
                                                     simplify = TRUE)[,1])
  fleets$num_2019.n <- as.numeric(stringr::str_split(fleets$fleets_2019.n,
                                                     pattern = "_",
                                                     n = 2,
                                                     simplify = TRUE)[,1])

  if(!all(col %in% names(fleets))) {
    stop ("'col' input need to be drawn from the list:",
          paste(names(fleets), collapse = ", "))
  }

  if (yr == 2021) {
    colname <- "fleet"
    # remove duplicates associated with separate fleets in earlier years
    fleets <- fleets[!duplicated(fleets$num),]

    # if no value was input, return everything (excluding duplicates)
    if (is.null(value)) {
      return(fleets[,col])
    }

    # use number when input is numeric
    if (is.numeric(value)) {
      colname <- "num"
    }
  }

  if (yr == 2019) {
    # if no value was input, return everything (excluding duplicates)
    if (is.null(value)) {
      return(fleets[,col])
    }

    if (is.null(area)) {
      stop("'area' input needed in combination with 'value'",
           "for 2019 models")
    }
    if (is.null(area) || !area %in% c("n", "s")) {
      stop("Area should be 'n' or 's'")
    }

    if (is.character(value)) {
      colname <- paste0("fleets_2019.", area)
    }

    if (is.numeric(value)) {
      colname <- paste0("num_2019.", area)
    }
  }

  # get all rows that match when a string is provided
  if (is.character(value)) {
    rows <- grep(value, fleets[[colname]], ignore.case = ignore.case)
  }

  # get matching rows if numerical value (integer or vector) is provided
  if (is.numeric(value)) {
    rows <- match(x = value, table = fleets[[colname]])
  }

  # return subset of fleets
  fleets[rows, col]
}

