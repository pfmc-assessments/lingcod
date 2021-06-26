# values from hake assessment
x <- seq(0.2, 0.99, length = 1e4) # x vector for subsequent calcs
prior_hake <- exp(-1 * get_SS_prior(Ptype = "Full_Beta",
                                     Pmin = 0.2, Pmax = 0.99,
                                     Pr = 0.777, Psd = 0.113, Pval = x))
## # values from fishlife
## fishlife::Plot_taxa(Search_species(Genus="Ophiodon",
##                     Species="elongatus",
##                     add=FALSE)$match_taxonomy)
##  https://github.com/iantaylor-NOAA/Lingcod_2021/issues/85#issuecomment-866296197

## # values from fishlife fails with "bad Beta prior: Aprior = 0.854, Bprior = 1.254"
## prior_fishlife <- get_beta_prior(Pr = 0.67, Psd = 0.22, Pval = x)

# slightly narrow prior works OK as beta
prior_fishlife <- exp(-1 * get_SS_prior(Ptype = "Full_Beta",
                                        Pmin = 0.2, Pmax = 0.99,
                                        Pr = 0.67, Psd = 0.20, Pval = x))
prior_fishlife_normal <- dnorm(x, 0.67, 0.20)
# make plot
colvec1 <- c(rgb(0,1,0,.2), rgb(1,0,0,.2), rgb(0,0,1,.2))
colvec2 <- c(rgb(0,1,0,.7), rgb(1,0,0,.7), rgb(0,0,1,.7))

png('figures/prior-steepness-comparisons.png',
    res = 300, units = 'in',
    width = 6.5, height = 4.0, pointsize = 10)
plot(0, type = 'n', col = 2, lwd = 3,
     xlab = "Steepness (h)", ylab = "Prior likelihood",
     xaxs = 'i', yaxs = 'i', xlim = c(0.2, 1), ylim = c(0, 4))
polygon(c(0.2, x, 0.99), c(0, prior_fishlife_normal/(diff(x[1:2])*sum(prior_fishlife_normal)), 0),
        col = colvec1[1], border = colvec2[1], lwd = 3)
polygon(c(0.2, x, 0.99), c(0, prior_fishlife/(diff(x[1:2])*sum(prior_fishlife)), 0),
        col = colvec1[2], border = colvec2[2], lwd = 3)
polygon(c(0.2, x, 0.99), c(0, prior_hake/(diff(x[1:2])*sum(prior_hake)), 0),
        col = colvec1[3], border = colvec2[3], lwd = 3)
#abline(v = 0.7, lwd = 3, lty = 2)
legend('topleft', fill = colvec1, border = colvec2, bty = 'n',
       legend = c("fishlife prior (normal)",
                  "fishlife prior (beta)",
                  "Hake prior (beta)"))
dev.off()
