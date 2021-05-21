### testing with newer version of Stock Synthesis

### make sure SSv3.30.16.02 executable is available
# first download Windows executable if not already present
dir.exe <- file.path("models/SSv3.30.16.02")

if (file.info(dir.exe)$isdir && "ss.exe" %in% dir(dir.exe)) {
  message("SS executable found in ", dir.exe)
} else {
  message("downloading SS executable into ", dir.exe)
  if (is.na(file.info(dir.exe)$isdir)) {
    dir.create(dir.exe)
  }
  download.file(url = "https://vlab.ncep.noaa.gov/documents/259399/11944598/ss.exe",
                destfile = "models/SSv3.30.16.02/ss.exe",
                mode = "wb")
}

# define new and old directories
# 2017 base models
dir.2017.n.001.001 <- "models/2017.n.001.001.final_base"
dir.2017.s.001.001 <- "models/2017.s.001.001.final_base"
# 2019 base models
dir.2019.n.001.001 <- "models/2019.n.001.001.cou"
dir.2019.s.001.001 <- "models/2019.s.001.001.cou"

# models run with new executables

# copy input files to new directories
# 2019 north model with new SS exe
dir.2019.n.002.001 <- "models/2019.n.002.001.SSv3.30.16.02"
r4ss::copy_SS_inputs(dir.old = dir.2019.n.001.001,
                     dir.new = dir.2019.n.002.001,
                     use_ss_new = TRUE,
                     copy_exe = TRUE,
                     dir.exe = dir.exe)

# 2019 south model with new SS exe
dir.2019.s.002.001 <- "models/2019.s.002.001.SSv3.30.16.02"
r4ss::copy_SS_inputs(dir.old = dir.2019.s.001.001,
                     dir.new = dir.2019.s.002.001,
                     use_ss_new = TRUE,
                     copy_exe = TRUE,
                     dir.exe = dir.exe)
# 2017 south model with new SS exe
dir.2017.s.002.001 <- "models/2017.s.002.001.SSv3.30.16.02"
r4ss::copy_SS_inputs(dir.old = dir.2017.s.001.001,
                     dir.new = dir.2017.s.002.001,
                     use_ss_new = TRUE,
                     copy_exe = TRUE,
                     dir.exe = dir.exe)
# 2019 south model with new SS exe and .par file from 2019 run
dir.2019.s.002.002 <- "models/2019.s.002.002.SSv3.30.16.02_par"
r4ss::copy_SS_inputs(dir.old = dir.2019.s.001.001,
                     dir.new = dir.2019.s.002.002,
                     use_ss_new = TRUE,
                     copy_par = TRUE,
                     copy_exe = TRUE,
                     dir.exe = dir.exe)
# modify starter file to use .par
start <- r4ss::SS_readstarter(file = file.path(dir.2019.s.002.002,
                                               "starter.ss"),
                              verbose = FALSE)
start$init_values_src <- 1
r4ss::SS_writestarter(mylist = start,
                      dir = file.path(dir.2019.s.002.002),
                      verbose = FALSE,
                      overwrite = TRUE)


        
### run models (can also be done via command line as easy method for parallelization)
r4ss::run_SS_models(dirvec = c(dir.2019.n.002.001,
                               dir.2019.n.002.001),
                    intern = TRUE)


### Read in Stock Synthesis files
mod.2017.n.001.001 <- SS_output(dir.2017.n.001.001) # 2017 models
mod.2017.s.001.001 <- SS_output(dir.2017.s.001.001)
mod.2017.s.002.001 <- SS_output(dir.2017.s.002.001) # 2017 south with new exe
mod.2019.n.001.001 <- SS_output(dir.2019.n.001.001) # 2019 models
mod.2019.s.001.001 <- SS_output(dir.2019.s.001.001)
mod.2019.n.002.001 <- SS_output(dir.2019.n.002.001) # 2019 models with new exe
mod.2019.s.002.001 <- SS_output(dir.2019.s.002.001)
mod.2019.s.002.002 <- SS_output(dir.2019.s.002.002) # 2019 south with new exe and .par

# create summaries for north and south
summ.n.old_vs_new_SS <- SSsummarize(list(mod.2019.n.001.001,
                                         mod.2019.n.002.001))
summ.s.old_vs_new_SS <- SSsummarize(list(mod.2017.s.001.001,
                                         mod.2017.s.002.001,
                                         mod.2019.s.001.001,
                                         mod.2019.s.002.001,
                                         mod.2019.s.002.002))

# north models almost identical
SS_versions <- paste0("SSv", substring(summ.n.old_vs_new_SS$SS_versions, 1, 10))
SStableComparisons(summ.n.old_vs_new_SS,
                   likenames = "TOTAL",
                   names = c("SSB_Virgin", "Bratio_2019"),
                   modelnames = c(paste("2019 with", SS_versions[1]),
                                  paste("2019 with", SS_versions[2])
                                  ))
##                    Label 2019 with SSv3.30.14.02 2019 with SSv3.30.16.02
## 1             TOTAL_like             1381.190000             1381.190000
## 2 SSB_Virgin_thousand_mt               37.974000               37.981000
## 3            Bratio_2019                0.621021                0.621039

# south models differ: Bratio_2019: 33.6% vs 27.8% unless you use .par file
SS_versions <- paste0("SSv", substring(summ.s.old_vs_new_SS$SS_versions, 1, 10))
SStableComparisons(summ.s.old_vs_new_SS,
                   likenames = "TOTAL",
                   names = c("SSB_Virgin", "Bratio_2019"),
                   modelnames = c(paste("2017 with", SS_versions[1]),
                                  paste("2017 with", SS_versions[2]),
                                  paste("2019 with", SS_versions[3]),
                                  paste("2019 with", SS_versions[4]),
                                  paste("2019 with", SS_versions[5],
                                        "and original .par file")
                                  ))
##                    Label 2017 with SSv3.30.07.01 2017 with SSv3.30.16.02
## 1             TOTAL_like             1362.240000             1385.010000
## 2 SSB_Virgin_thousand_mt               20.260000               19.304000
## 3            Bratio_2019                0.341486                0.363324
##   2019 with SSv3.30.14.00 2019 with SSv3.30.16.02
## 1             1362.240000             1387.100000
## 2               20.260000               18.813000
## 3                0.336706                0.278177
##   2019 with SSv3.30.16.02 and original .par file
## 1                                    1362.240000
## 2                                      20.260000
## 3                                       0.336706



## changing data
# copy directory with 2019 south model with new SS exe and .par file from 2019 run
dir.2019.s.003.002 <- "models/2019.s.003.002_update_CA_catch"
r4ss::copy_SS_inputs(dir.old = dir.2019.s.002.002,
                     dir.new = dir.2019.s.003.002,
                     use_ss_new = TRUE,
                     copy_par = TRUE,
                     copy_exe = TRUE,
                     dir.exe = dir.exe)

# read data file
dat.2019.s.003.002 <- r4ss::SS_readdat(file.path(dir.2019.s.003.002, "ling.dat"),
                                       verbose = FALSE)
head(dat.2019.s.003.002$catch)
##   year seas fleet   catch catch_se
## 1 -999    1     1  0.0000     0.01
## 2 1889    1     1  0.0000     0.01
## 3 1890    1     1 13.2258     0.01
## 4 1891    1     1 26.4517     0.01
## 5 1892    1     1 39.6775     0.01
## 6 1893    1     1 52.9033     0.01

# make changes to dat.2019.s.003.002$catch

# write modified data file (overwriting old one because it's a copy of original file)
r4ss::SS_writedat(datlist = dat.2019.s.003.002,
                  outfile = file.path(dir.2019.s.003.002, "Ling.dat"),
                  verbose = TRUE,
                  overwrite = TRUE)

