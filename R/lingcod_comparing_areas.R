# code related to comparisons associated with different areas

# define directory on a specific computer
if (Sys.info()["user"] == "Ian.Taylor") {
  dir.ling <- 'c:/SS/Lingcod/Lingcod_2021/'
}

if(FALSE){
  # read models from NWFSC assessment archive
  ling2017N <- SS_output('C:/ss/lingcod/Lingcod_2017/models/north_base')
  ling2017S <- SS_output('C:/ss/lingcod/Lingcod_2017/models/south_base')

  # model re-run to get Hessian
  ling2017N <- SS_output('C:/ss/lingcod/Lingcod_2017/models/north_base_run')
  ling2017S <- SS_output('C:/ss/lingcod/Lingcod_2017/models/south_base_run')
}

# run summary function
lingsum <- SSsummarize(list(ling2017N, ling2017S))

# table with recruitment deviations
head(lingsum$recdevs, 2)
##          model1      model2              Label   Yr
## 31 -8.29359e-06 2.12088e-05 Early_RecrDev_1889 1889
## 32 -9.73032e-06 2.48361e-05 Early_RecrDev_1890 1890

range(lingsum$recdevs[,1:2], na.rm = TRUE)
# [1] -1.82608  1.38475

# plot recruitment deviations
png(file.path(dir.ling, "figures/recdev_comparisons_2017_N_vs_S.png"),
              res = 300, units = 'in', width = 9, height = 9)
plot(0, type = 'n', xlim = c(-2, 2), ylim = c(-2, 2),
     xlab = '2017 North model recruitment deviation',
     ylab = '2017 South model recruitment deviation')
abline(h = 0, v = 0, lty = 3)
# get subset of rows of recruitment deviation table for recent years
yrs <- 1971:2016
sub <- lingsum$recdevs$Yr %in% yrs
# add points labeled by year
text(x = lingsum$recdevs[sub, 1:2],
     labels = lingsum$recdevs$Yr[sub],
     col = rainbow(length(yrs))[lingsum$recdevs$Yr[sub]-min(yrs)+1])
dev.off()
cor(x = lingsum$recdevs[sub, 1], y = lingsum$recdevs[sub, 2])
## [1] 0.2744754
