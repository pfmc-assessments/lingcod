#' Compile the stock assessment document(s) for a given species
#'
#' @description
#' Compile the stock assessment document(s) for a given species where the number of
#' documents depends on the number of directories that you pass to dir.
#' Typically, this happens in the directory called `doc` that stores a single
#' directory for each stock.
#' [bookdown::render_book] will be called inside on each directory in `dir`.
#'
#' @details status:
#' This function is currently in beta testing, which means that it
#' * might be helpful,
#' * could contain bugs,
#' * will more than likely have non-descript error and warning messages.
#' Please post an [issue](https::/github.com/nwfsc-assess/sa4ss/issues)
#' or email the author of this function.
#' Thank you for helping test it out, and we hope the pain is worth the gain!
#'
#' @details index.Rmd
#' When specifying a directory to [bookdown::render_book], the
#' file `index.Rmd` is normally used as the master file for rendering the book
#' and all other files are brought in as chapters in alphabetical order.
#' Here, in the \pkg{sa4ss} package we use `00a.Rmd` as the indexing file and
#' all other .Rmd files are sourced in alphabetical order.
#' The renaming is done automatically for you in the call to [draft] and just
#' mentioned here for completeness.
#'
#' @param dir A terribly named parameter that specifies which pdf you want to build.
#' For lingcod, this is just `"North"` or `"South"`.
#' Also for just lingcod, we can use `get_groups(info_groups)` to get a vector of
#' all the groups we have, which results in both documents being built.
#' @param wipe A logical values specifying if you want to remove all cached objects.
#' For lingcod, this will remove plots, custom_plots, and cached markdown files and
#' will lead to the document taking approximately an hour to build.
#' @param ... Arguments you want to pass to [bookdown::render_book].
#'
#' @author Kelli F. Johnson and undergoing testing by Kelli F. Johnson
#' @export
#' @seealso See [compile_internal] for the non-vectorized version of what happens
#' inside each directory.
#' @family compile
#' @examples
#' \dontrun{
#' # An example for lingcod in 2021.
#' compile_ling(dir = file.path(get_groups(info_groups)))
#' }
#'
compile_ling <- function(dir = "North", wipe = FALSE, ...) {
  mapply(
    FUN = compile_internal,
    dir = dir,
    MoreArgs = c(wipe = wipe, list(...))
  )
}

#' A non-vectorized version of [compile]
#'
#' A non-vectorized version of [compile] that acts as internal
#' code for the wrapper [compile]. Users typically will not interact
#' with this function, but the code is exported for easier viewing.
#'
#' @param dir A *SINGLE* directory where the draft files are located.
#' @param time The number of seconds you will have to close the pdf
#' if it is found to be open.
#' The integer value is passed to [base::Sys.sleep].
#' @param ... Arguments passed to [bookdown::render_book]
#'
#' @author Kelli F. Johnson
#' @family compile
#' @export
#'
compile_internal <- function(dir, time = 10, wipe = FALSE, ...) {

  basemodelname <- info_basemodels[basename(dir)]
  fullpathbasemodel <- file.path(
    dirname(system.file(package = "lingcod")),
    "models", basemodelname
  )

  # If wipe, remove cache and plots
  if (wipe) {
    unlink(file.path(fullpathbasemodel, "plots"), recursive = TRUE)
    unlink(file.path(fullpathbasemodel, "custom_plots"), recursive = TRUE)
  }

  if (
    !file.exists(file.path(fullpathbasemodel, "plots")) |
    !file.exists(file.path(fullpathbasemodel, "00mod.Rdata"))
  ) {
    compile_precursur(
      basemodelname,
      plot = !file.exists(file.path(fullpathbasemodel, "plots"))
    )
  }

  # Set working directory back to getwd() upon exit
  stopifnot(length(dir) == 1)
  stopifnot(utils::file_test("-d", fullpathbasemodel))
  olddir <- getwd()
  setwd(file.path(dirname(system.file(package = "lingcod")), "doc"))
  on.exit(setwd(olddir), add = TRUE)

  if (wipe) {
    unlink(file.path("_bookdown_files", paste0(dir, "_cache")), recursive = TRUE)
  }

  # Create the file name for the output based on in dir name
  hidden_book_filename <- paste0(ifelse(
    basename(dir) == ".",
    basename(getwd()),
    basename(dir)
  ))

  # Check if the pdf file exists and if it is open
  test <- tryCatch(
    pdf(dir(
      pattern = paste0(hidden_book_filename, ".pdf"),
      full.names = TRUE
    )),
    error = function(e) {
      message(
        "You have ", time, " seconds to close the pdf named ",
        file.path(dir, hidden_book_filename)
      )
      flush.console()
      Sys.sleep(time)
      return(FALSE)
    },
    finally = TRUE
  )
  if (is.null(test)) dev.off()

  # Make the document
  bookdown::render_book("00a.Rmd", output_dir = getwd(), clean = FALSE,
    config_file = paste0("_bookdown_", tolower(hidden_book_filename), ".yml"),
    params = list(
      area = dir,
      model = file.path("..", "models", basemodelname)
    )
  )

  return(invisible(TRUE))

}

#' Change bookname in the _bookdown.yml file
#'
#' Change the name of the bookdown yaml file that sets up the call
#' to [bookdown::render_book] as suggested on
#' [this Rstudio community thread](https://community.rstudio.com/t/is-it-possible-to-use-variables-set-in-index-rmd-in-the-other-yaml-files/78483/5).
#'
#' @param bookname A character value that will be used to name the output from
#' [bookdown::render_book], which is normally called `_main[ext]`.
#' This value will overwrite whatever you have in `_bookdown.yml` for `bookname`.
#'
#' @author Kelli F. Johnson
#' @family compile
compile_changebookname <- function(bookname) {
  ori_yml <- "_bookdown.yml"
  tmp_yml <- tempfile(fileext = ".yml")
  if (file.exists(ori_yml)) {
    yml_content <- yaml::read_yaml(ori_yml)
  } else{
    yml_content <- list(book_filename = "x")
  }
  yml_content[["book_filename"]] <- bookname
  yaml::write_yaml(yml_content, tmp_yml)
  return(tmp_yml)
}

compile_precursur <- function(basemodel, plot = TRUE) {

  oldwd <- getwd()
  on.exit(setwd(oldwd))
  setwd(dirname(system.file(package = "lingcod")))
  # Read the model files
  sa4ss::read_model(
    mod_loc = file.path("models", basemodel),
    create_plots = plot,
    save_loc = file.path("models", basemodel, "tex_tables"),
    verbose = TRUE
  )

  # Load in the resulting 00mod file
  modenv <- new.env()
  load(file.path("00mod.Rdata"), envir = modenv)
  modenv$model$area <- gsub("[0-9]{4}\\.|\\.[0-9]+\\.[0-9]+_.+$", "", basemodel)
  if (plot) {
    make_r4ss_plots_ling(modenv$model, verbose = TRUE)
  }

  # get exec summary tables
  r4ss::SSexecutivesummary(replist = modenv$model, format = FALSE)
  sa4ss::es_table_tex(
    dir = modenv$mod_loc,
    save_loc = file.path("models", basemodel, "tex_tables"),
    csv_name = "table_labels.csv"
  )
  save(
    list = ls(envir = modenv),
    file = file.path("models", basemodel, "00mod.Rdata"),
    envir = modenv
  )
  unlink("00mod.Rdata")

}
