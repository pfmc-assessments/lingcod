#' Model catches
#'
#' A data frame of commercial and recreational catches for
#' the northern and southern areas by fleet.
#'
#' @name data_catch
#' @docType data
#' @format A data frame with four columns
#' * Year: a four digit integer for year
#' * area: a character value denoting the area the catches pertain to
#' * fleet: character values denoting the fleet, with
#' fixed gear (FG), trawl (TW), and abbreviations for state are all
#' valid entries and states signify recreational catches
#' * mt: catches in metric tons (mt)
#'
"data_catch"

#' Index for Oregon recreational fishery
#'
#' A data frame formatted for SS with information on the
#' Oregon recreational fishery CPUE.
#'
#' @name data_index_RecOR
#' @docType data
#' @format A data frame with four columns
#' * year: a four digit integer for year
#' * seas: equal to 7 because all fleets "operate" in the middle of the year
#' * index: equal to the proper fleet number returned from
#'   [get_fleet]
#' * obs: the median of the posterior estimate per year
#' * se_log: the log standard error of the estimate
#'
"data_index_RecOR"

#' Index for Oregon commercial near-shore fishery
#'
#' A data frame formatted for SS with information on the
#' Oregon commercial near-shore fishery CPUE.
#'
#' @name data_index_CommFix
#' @docType data
#' @format A data frame with four columns
#' * year: a four digit integer for year
#' * seas: equal to 7 because all fleets "operate" in the middle of the year
#' * index: equal to the proper fleet number returned from
#'   [get_fleet]
#' * obs: the median of the posterior estimate per year
#' * se_log: the log standard error of the estimate
#'
"data_index_CommFix"
