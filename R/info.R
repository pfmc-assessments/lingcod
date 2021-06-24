#' A list of authors used for writing the assessment(s)
#'
#' A list of authors with one vector for each assessment associated
#' with this species / stock.
#'
#' @name info_authors
#' @docType data
#' @format A list the same length as the number of documents you want to
#' produce, with a single vector per document.
#' @seealso [sa4ss::write_authors]
#'
"info_authors"

#' A list of bins used for composition data
#'
#' A list of bins for binning composition data.
#'
#' @name info_bins
#' @docType data
#' @format A list of length two, with information for age and length bins
#' in that order. List elements are integer values specifying the lower-left
#' edge of each bin and the last bin will therefore include everything
#' equal to and above the given integer.
#'
"info_bins"

#' A data frame of groups used to structure output and the document
#'
#' A data frame of grouping structures for working up the data and
#' writing the report. The data frame allows for the inclusion of as
#' many columns as you want. The lingcod 2021 assessment just used
#' a single column called area because there were two areas.
#'
#' @name info_groups
#' @docType data
#' @format A data frame where the column names are the group type
#' and the entries are character values for that given group type.
#'
"info_groups"

#' Names of included surveys
#'
#' A vector of names for the surveys included in the stock assessment.
#'
#' @name info_surveynames
#' @docType data
#' @format A vector of character values.
#'
"info_surveynames"

#' Base model folder names
#'
#' A vector of names for the base models. These can be sourced by appending
#' `"models"` to the beginning to make a file path, e.g.,
#' `file.path("models", info_basemodels)`.
#'
#' @name info_basemodels
#' @docType data
#' @format A vector of character values.
#'
"info_basemodels"
