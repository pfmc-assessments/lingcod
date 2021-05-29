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

#' Index for the standardized surveys
#'
#' A data frame of index values for the standardized surveys that
#' are relevant to this species.
#'
#' @name data_index_survey
#' @docType data
#' @format A data frame with four columns
#' * Year: a four digit integer for year
#' * dir: the directory where the data are stored in data-raw
#' * surveyname: the survey name using characters
#' * area: the model area of relevance, e.g., North
#' * distribution: the assumed distribution used to fit the model
#' * Fleet: a version of the strata with depth
#' * Estimate_metric_tons: estimate in mt
#' * SD_log: the log standard deviation
#' * SD_mt: the standard deviation in normal space
#' * strata: the stratafication the estimate pertains to
#' * year: a four digit integer for year
#' * obs: the estimate per year
#' * se_log: the log standard error of the estimate
#' * seas: equal to 7 because all fleets "operate" in the middle of the year
#' * index: equal to 7 because all fleets "operate" in the middle of the year
#'
"data_index_survey"
