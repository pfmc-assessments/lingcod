#' change parameter values in a table within the control file list object in R
#'
#' applies no LO, HI, INIT, or PHASE value to parameter line in a table of
#' parameters within the list created by [get_inputs_ling()] or
#' `r4ss::SS_readctl()`. This is similar to `r4ss::SS_changepars()`
#' but that function modifies the control file itself not the corresponding
#' R object.
#'
#' @param pars A parameter table from the control file list object. For the
#' initial 2021 lingcod models, this can be any of 
#' `MG_parms`, `SR_parms`, `Q_parms`, `Q_parms_tv`, `size_selex_parms`, or
#' `size_selex_parms_tv`.
#' @param string String which matches part of the parameter labels for the
#' parameters to be modified. When multiple parameters match the string
#' they will all be changed.
#' @param LO New lower bound value
#' @param HI New upper bound value
#' @param INIT New initial value
#' @param PHASE New phase value
#' @param Block New block value (which block pattern to use)
#' @param Block_Fxn New phase function value (e.g. 2 = replace)
#' @param allrows Logical: TRUE = return the full parameter table,
#' FALSE = return only the parameter lines that match `string`.
#' @template verbose
#' @author Ian G. Taylor
#' @export
#' @return Either the full table of parameters that can be inserted into
#' directly into the inputs$ctl list or (if `allrows = FALSE`),
#' a subset of that table with just the lines matching `string`.
#' @examples
#' \dontrun{
#'   # read inputs
#'   inputs <- get_inputs_ling(id = get_id_ling(newdir))
#'   # copy control file info to new object
#'   newctl <- inputs$ctl
#'   # update parameter lines for first double-normal parameter
#'   newctl$size_selex_parms <-
#'     change_pars(pars = newctl$size_selex_parms,
#'                 string = "SizeSel_P_1",
#'                 LO = 20,
#'                 HI = 100,
#'                 INIT = 60
#'                 PHASE = 3)
#'
#'   # check which lines match a string with no changes
#'   change_pars(pars = newctl$SR_parm, string = "R0", allrows = FALSE)
#' }
 
change_pars <- function(pars,
                        string,
                        LO = NULL,
                        HI = NULL,
                        INIT = NULL,
                        PHASE = NULL,
                        PRIOR = NULL,
                        PR_SD = NULL,
                        PR_type = NULL,
                        Block = NULL,
                        Block_Fxn = NULL,
                        allrows = TRUE,
                        verbose = TRUE
                        ) {

  # get lines and associated lables
  lines <- grep(string, rownames(pars))
  labels <- rownames(pars)[lines]
  if (length(lines) == 0) {
    stop("string not found")
  } else {
    if (verbose) {
      message("updating parameters:\n", paste(labels, collapse = "\n"))
    }
  }

  # update values
  if (!is.null(LO)) {
    pars[lines, "LO"] <- LO
  }
  if (!is.null(HI)) {
    pars[lines, "HI"] <- HI
  }
  if (!is.null(INIT)) {
    pars[lines, "INIT"] <- INIT
  }
  if (!is.null(PHASE)) {
    pars[lines, "PHASE"] <- PHASE
  }
  if (!is.null(PRIOR)) {
    pars[lines, "PRIOR"] <- PRIOR
  }
  if (!is.null(PR_SD)) {
    pars[lines, "PR_SD"] <- PR_SD
  }
  if (!is.null(PR_type)) {
    pars[lines, "PR_type"] <- PR_type
  }
  if (!is.null(Block)) {
    pars[lines, "Block"] <- Block
  }
  if (!is.null(Block_Fxn)) {
    pars[lines, "Block_Fxn"] <- Block_Fxn
  }

  
  # return either full table or a subset
  if (allrows) {
    pars
  } else {
    pars[lines, ]
  }
}
