add_figure_profile <- function(pathtobase, par, prior = 1) {
  
  path <- file.path(dirname(pathtobase),
    dir(dirname(pathtobase), pattern = paste0(basename(pathtobase), "_profile.*", par))
  )
  if (length(path) == 0) {
    message("Figure profile for ", par, " was not found.")
    return()
  }
  stopifnot(length(path) <= 1)
  if (length(path) > 1) {
    path <- path[grepl(paste0(prior, "$"), path)]
  }
  parname <- gsub(".+profile_|_prior_like.+$", "", basename(path))
  parpretty <- 
    gsub("LN(\\(R0\\))", "$log\\1$",
    gsub(" M$", " $M$",
    gsub("SR_|Nat|BH_", "",
    gsub("steep", "steepness",
    gsub("(.+)Fem$", "female \\1",
    gsub("_uniform_|_GP_[0-9]+", "", parname)
  )))))
  parshort <- gsub("[\\$,]|\\(|\\)|_)|\\s+", "", parpretty)
  data <- data.frame(
    caption = paste0(
      "Change in the ",
      c("negative log-likelihood", "spawning biomass", "fraction of unfished"),
      " across a range of ", parpretty, " values."
      ),
    alt_caption = c(
      paste0("to do"),
      paste0("to do"),
      paste0("to do")
    ),
    label = paste0(
      "profile-", c("piner-", "ssb-", "depl-"), parshort
    ),
    filein = file.path(path,
      mapply(FUN = dir, MoreArgs = list(path = path),
        pattern = c("piner_panel", "compare1_", "compare3")
      )
    )
  )

  cat(add_figure_ling(data))
}

add_figure_retro <- function(pathtobase, n) {
  
  path <- paste0(pathtobase, "_retro")
  data <- data.frame(
    caption = paste0(
      "Change in the ",
      c("spawning biomass", "fraction unfished"),
      " when the most recent ", n, " years of data are removed sequentially."
      ),
    alt_caption = c(
      paste0("to do"),
      paste0("to do")
    ),
    label = paste0("retro-", c("ssb-", "depl-")),
    filein = file.path(path,
      mapply(FUN = dir, MoreArgs = list(path = path),
        pattern = c("compare1_", "compare3")
      )
    )
  )

  cat(add_figure_ling(data))
}
