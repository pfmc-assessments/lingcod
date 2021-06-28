#' Make a series of plots comparing the north and south models
#'
#' Uses `r4ss::SSplotComparisons()` but applies defaults as
#' appropriate for the lingcod stocks
#'
#' @param mod.n A north model as produced by `r4ss::SS_output()`
#' or [get_mod()]
#' @param mod.s A south model as produced by `r4ss::SS_output()`
#' or [get_mod()]
#' @param subplot Which plots to create (currently there are 3)
#' 
#' @examples
#' \dontrun{
#' plot_north_vs_south(mod.2021.n.022.001, mod.2021.s.014.001)
#' }
#' 
plot_north_vs_south <- function(mod.n,
                                mod.s,
                                subplot = 1:3) {

  # empty place to store info on each plot
  plot_info <- NULL

  mod.sum <- r4ss::SSsummarize(list(mod.n, mod.s))


  # wrapper for an r4ss function
  plot_density <- function(densitynames, legendloc = FALSE,
                           par = list(),
                           add = TRUE, ...) {
    r4ss::SSplotComparisons(mod.sum,
                            subplot=16,
                            densitynames = densitynames,
                            densityscalex = 1.1,
                            legendlabels = c("North", "South"),
                            legendloc = legendloc,
                            col = info_areacolors,
                            shadealpha = 0.2,
                            par = par,
                            new = FALSE,
                            add = add,
                            ...)
  }
  
  # growth comparison
  if (1 %in% subplot) {
    caption <- paste("Comparison of estimated growth curves and variability",
                     "in growth for the north and south base models.")
    filename <- "compare_north_vs_south_growth.png"
    filepath <- file.path("figures", filename)
    plot_info <- rbind(plot_info, 
                       data.frame(caption = caption, filename = filename)
                       )
    png(filepath, width = 6.5, height = 6.5, res = 300,
        units = 'in', pointsize = 10)

    # plot north growth
    col1 <- get_fleet(c(5,1), col = "col.n")
    col2 <- get_fleet(c(5,1), col = "col.s")
    r4ss::SSplotBiology(mod.n, subplot=1,
                        colvec = col1,
                        legendloc=FALSE, ltyvec=c(5,4),
                        mainTitle = FALSE)
    # plot south growth
    r4ss::SSplotBiology(mod.s, subplot=1,
                        colvec = col2, 
                        legendloc=FALSE, ltyvec=c(1,2),
                        add=TRUE)
    # add legend
    legend('topleft', lty=c(5,4,1,2),
           col = c(col1, col2),
           legend=c("North females","North males",
                    "South females","South males"),
           lwd=2, bty='n', seg.len=3)
    dev.off()

  }

  # parameter distributions (assuming north and south have the same priors)
  if (2 %in% subplot) {
    caption <- paste("Comparison estimates for parameters of interest from",
                     "each model with normal approximation to posterior based",
                     "on asymptotic standard error with priors shown in black.")
    filename <- "compare_north_vs_south_pars.png"
    filepath <- file.path("figures", filename)
    plot_info <- rbind(plot_info, 
                       data.frame(caption = caption, filename = filename)
                       )
    png(filepath, width = 6.5, height = 6.5, res = 300,
        units = 'in', pointsize = 10)

    # steepness prior
    # Pr and Psd inputs could be made dynamic
    x_h <- seq(0.2, 0.99, length = 1000) # x vector for subsequent calcs
    prior_h <- exp(-1 * get_SS_prior(Ptype = "Full_Beta",
                                     Pmin = 0.2, Pmax = 0.99,
                                     Pr = 0.777, Psd = 0.113, Pval = x_h))
    # M priors
    M_fem <- mod.n$parameters["NatM_uniform_Fem_GP_1",]
    M_mal <- mod.n$parameters["NatM_uniform_Mal_GP_1",]
    x_M <- seq(0, 0.8, length = 1000) # x vector for subsequent calcs

    prior_M_fem <- exp(-1 * get_SS_prior(Ptype = "Log_Norm",
                                         Pmin = M_fem$Min,
                                         Pmax = M_fem$Max,
                                         Pr = M_fem$Prior,
                                         Psd = M_fem$Pr_SD,
                                         Pval = x_M))
    prior_M_mal <- exp(-1 * get_SS_prior(Ptype = "Log_Norm",
                                         Pmin = M_mal$Min,
                                         Pmax = M_mal$Max,
                                         Pr = M_mal$Prior,
                                         Psd = M_mal$Pr_SD,
                                         Pval = x_M))

    par(mfcol = c(2,2), mar = c(4,4,1,1), las = 1, mgp = c(2.5,1,0))
    plot(0, type = 'n', xlim = c(0, 0.5), ylim = c(0,30), xaxs = "i", yaxs = 'i',
         xlab = "Female natural mortality (M)", ylab = "Density",
         axes = FALSE)
    plot_density(densitynames = "NatM_uniform_Fem_GP_1") #, legendloc = "topleft")
    legend("topleft", col = c(info_areacolors, "#000000"),
           lty = c(1,1,2), lwd = c(2,2,1), pch = c(1,2,NA), bty = 'n',
           legend = c("North", "South", "prior"))
    lines(x_M, prior_M_fem/(diff(x_M[1:2])*sum(prior_M_fem)), lty = 2)
    axis(1)
    box()

    plot(0, type = 'n', xlim = c(0, 0.5), ylim = c(0,30), xaxs = "i", yaxs = 'i',
         xlab = "Male natural mortality (M)", ylab = "Density",
         axes = FALSE)
    plot_density(densitynames = "NatM_uniform_Mal_GP_1")
    lines(x_M, prior_M_mal/(diff(x_M[1:2])*sum(prior_M_mal)), lty = 2)
    axis(1)
    box()

    plot(0, type = 'n', xlim = c(90, 110), ylim = c(0,1), xaxs = "i", yaxs = 'i',
         xlab = "Female length at age 14", ylab = "Density",
         axes = FALSE)
    plot_density(densitynames = "L_at_Amax_Fem")
    axis(1)
    box()

    plot(0, type = 'n', xlim = c(0.2, 1.0), ylim = c(0,6), xaxs = "i", yaxs = 'i',
         xlab = "Stock-recruit steepness (h)", ylab = "Density",
         axes = FALSE)
    plot_density(densitynames = "steep")
    lines(x_h, prior_h/(diff(x_M[1:2])*sum(prior_h)), lty = 2)
    axis(1)
    box()

    dev.off()
  }


  # quantities distributions
  if (3 %in% subplot) {
    caption <- paste("Comparison estimates for quantities of interest from",
                     "each model with normal approximation to posterior based",
                     "on asymptotic standard error.")
    filename <- "compare_north_vs_south_quants.png"
    filepath <- file.path("figures", filename)
    plot_info <- rbind(plot_info, 
                       data.frame(caption = caption, filename = filename)
                       )
    png(filepath, width = 6.5, height = 6.5, res = 300,
        units = 'in', pointsize = 10)

    names <- c("SmryBio_unfished", "Bratio_2021", "SPRratio_2020", "Dead_Catch_MSY")
    goodnames <- c("Unfished age 3+ biomass (1000 mt)",
                   "Fraction unfished 2021",
                   "Fishing intensity 2020",
                   "MSY (total dead catch, 1000 mt)")
    par(mfcol = c(2,2), mar = c(4,4,1,1), las = 0, mgp = c(2.5,1,0))
    plot_density(densitynames = names,
                 densityxlabs = goodnames,
                 legendloc = FALSE, add = FALSE,
                 par = list(mar = c(4,4,1,1)))
    legend("topright", col = info_areacolors,
           lty = 1, lwd = 2, pch = c(1,2), bty = 'n',
           legend = c("North", "South"))

    dev.off()
  }

  
  write.csv(data.frame(plot_info$caption,
                       alt_caption = "",
                       label = gsub(".png", "", plot_info$filename),
                       filein = file.path("..", "figures", plot_info$filename)),
            file = file.path("figures", "figures_compare_north_vs_south.csv"),
            row.names = FALSE)

}

table_north_vs_south <- function() {
  mod.old.n <- mod.2019.n.001.001
  mod.old.s <- mod.2019.s.001.001
  # rename some parameters so they line up in the table
  mod.old.n$parameters$Label <- gsub("NatM_p_1", "NatM_uniform",
                                     mod.old.n$parameters$Label)
  mod.old.s$parameters$Label <- gsub("NatM_p_1", "NatM_uniform",
                                     mod.old.s$parameters$Label)
  ## # north_vs_south_vs_old table
  ## sens_make_table(area = "both",
  ##                 sens_type = "both",
  ##                 plot = FALSE,
  ##                 write = TRUE)
  # make table of model results

  thingnames <- c("Recr_Virgin", "R0", "NatM", "Linf",
                  "LnQ_base_WCGBTS",
                  "SSB_Virg", "SSB_2021", "SSB_2017",
                  "Bratio_2017", "Bratio_2021",
                  "SPRratio_2016", "SPRratio_2020",
                  "Ret_Catch_MSY", "Dead_Catch_MSY",
                  "SmryBio_unfished", "OFLCatch_2021")

  compare_table <- r4ss::SSsummarize(list(mod.2021.n.022.001,
                                          mod.2021.s.014.001,
                                          mod.old.n,
                                          mod.old.s)) %>%
    r4ss::SStableComparisons(modelnames = c("North base",
                                            "South base",
                                            "North 2017",
                                            "South 2017"),
                             names = thingnames,
                             likenames = NULL,
                             csv = FALSE
                             )

  # convert some things to new units (non-log or non-offset)
  compare_table <- compare_table %>%
    sens_convert_vals() %>%
    #sens_convert_offsets() %>% # not needed here
    sens_clean_labels()

  # write to file
  csvfile <- file.path("tables",
                       paste0("table_compare_north_vs_south.csv"))
  message("writing ", csvfile)
  write.csv(compare_table, file = csvfile, row.names = FALSE)
}
