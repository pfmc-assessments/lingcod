mydir <- "models/2021.s.018.001_fixTri3_retro"
retroModels <- r4ss::SSgetoutput(
  dirvec = file.path(mydir, "retro", paste("retro", -1:-5, sep = ""))
)
model_settings <- list()
model_settings$retro_yrs <- -1:-5
get_mod("n",23)
get_mod("s",18)
retroSummary <- r4ss::SSsummarize(c(list(mod.2021.n.023.001), retroModels))
endyrvec <- retroSummary[["endyrs"]] + 0:-5

rhos <- r4ss::SSmohnsrho(retroSummary,
           endyrvec = endyrvec,
           startyr = 2015,
           verbose = TRUE
)

  r4ss::SSplotComparisons(retroSummary, 
endyrvec = endyrvec, 
legendlabels = c("Base Model", paste("Data", model_settings$retro_yrs, "Years")),
plotdir = mydir, 
legendloc = "topright", 
print = TRUE, plot = FALSE,
pdf = FALSE)


r4ss::SSplotComparisons(retroSummary, 
endyrvec = endyrvec, 
legendlabels = c("Base Model", paste("Data", model_settings$retro_yrs, "Years")),
plotdir = mydir,
subplot = 2,
legendloc = "topright", 
print = FALSE, plot = TRUE,
pdf = FALSE)
xx <- rhos[grep("SSB", names(rhos))]
legend("topleft",legend = sprintf("%s = %.2f", names(xx), xx), bty = "n")
dev.copy(png, file.path(mydir, "compare2_spawnbio_uncertainty.png"), res=200,height = 7, width = 7, unit="in")
dev.off()
dev.off()
r4ss::SSplotComparisons(retroSummary, 
endyrvec = endyrvec, 
legendlabels = c("Base Model", paste("Data", model_settings$retro_yrs, "Years")),
plotdir = mydir,
subplot = 4,
legendloc = "topright", 
print = FALSE, plot = TRUE,
pdf = FALSE)
xx <- rhos[grep("Bratio", names(rhos))]
legend("topleft",legend = sprintf("%s = %.2f", names(xx), xx), bty = "n")
dev.copy(png, file.path(mydir, "compare4_Bratio_uncertainty.png"), res=200,height = 7, width = 7, unit="in")
dev.off()
dev.off()
r4ss::SSplotComparisons(retroSummary, 
endyrvec = endyrvec, 
legendlabels = c("Base Model", paste("Data", model_settings$retro_yrs, "Years")),
plotdir = mydir,
subplot = 10,
legendloc = "topright", 
print = FALSE, plot = TRUE,
pdf = FALSE)
xx <- rhos[grep("Rec", names(rhos))]
legend("topleft",legend = sprintf("%s = %.2f", names(xx), xx), bty = "n")
dev.copy(png, file.path(mydir, "compare10_recruits_uncertainty.png"), res=200,height = 7, width = 7, unit="in")
dev.off()
dev.off()
