# processing discard comp data from Andi Stephens

# based on code for Big Skate 2019 assessment:
# https://github.com/IanTaylor-NOAA/BigSkate_Doc/blob/master/R/WCGOP_discard_comps.R

# define directory on a specific computer
if (Sys.info()["user"] == "Ian.Taylor") {
  dir.ling <- 'c:/SS/Lingcod/Lingcod_2021/'
}

discard_comp_dir <- file.path(dir.ling, 'data/commercial/discards')

# read files
# these were created by Andi and loaded to Google Drive
# in the folder Lingcod_2021/data/WCGOP/
# https://drive.google.com/drive/u/0/folders/11Qd7kA-PpIOXN6nDuHWtxaxGcqNVjYc8
Length_Freq <- read.csv(file.path(discard_comp_dir,
                                  "Mendocino_Lincod_2021_WCGOP_Comps_Length_Freq.csv"))
LF_Sample_Sizes <- read.csv(file.path(discard_comp_dir,
                                      "Mendocino_Lincod_2021_WCGOP_Comps_LF_Sample_Sizes.csv"))

# make data frame for SS inputs with 0s for all comps
# note that "area" column will be removed after separating into 2 tables
SSinput <- data.frame(expand.grid(area = c("North", "South"),
                                  Yr = sort(unique(Length_Freq$Year)),
                                  Seas = 7,
                                  FltSvy = 1:2,
                                  Gender = 0,
                                  Part = 1,
                                  Nsamp = NA))
lbins <- seq(10, 130, 2)
SSinput[,c(paste0("f", lbins), paste0("m", lbins))] <- 0

SSinput[1:4,1:10]
##   year month fleet sex part Nsamp F10 F12 F14 F16
## 1 2004     7     1   3    1    NA   0   0   0   0
## 2 2005     7     1   3    1    NA   0   0   0   0
## 3 2006     7     1   3    1    NA   0   0   0   0
## 4 2007     7     1   3    1    NA   0   0   0   0


# loop over rows to fill in sample size and comps
for(irow in 1:nrow(SSinput)){
  area <- SSinput$area[irow]
  fleet <- SSinput$FltSvy[irow] # 1 = trawl, 2 = fixed gear
  gear_name <- c("TRAWL", "H&L&Pot&Fixed")[fleet]
  y <- SSinput$Yr[irow]
  # get number of hauls
  Nhauls <- sum(LF_Sample_Sizes$N_unique_Hauls[LF_Sample_Sizes$State == area &
                                               LF_Sample_Sizes$Year == y &
                                               LF_Sample_Sizes$Gear == gear_name])
  # get sample sizes
  Nfish <- sum(LF_Sample_Sizes$N_Fish[LF_Sample_Sizes$State == area &
                                      LF_Sample_Sizes$Year == y &
                                      LF_Sample_Sizes$Gear == gear_name])
  SSinput$Nsamp[irow] <- Nhauls

  # get individual length values
  for(len in lbins){
    colname <- paste0("f", len)
    prop <- Length_Freq$Prop.wghtd[Length_Freq$State == area &
                                   Length_Freq$Year == y &
                                   Length_Freq$Gear == gear_name &
                                   Length_Freq$Lenbin == len]
    if(length(prop) > 0){
      SSinput[irow, colname] <- round(prop, 4)
    }
  }
}

# split north and south and remove area column (col 1)
SSinput_North <- SSinput[SSinput$area == "North", -1]
SSinput_South <- SSinput[SSinput$area == "South", -1]

write.table(file = file.path(discard_comp_dir, "lencomps_discard_north.csv"),
            SSinput_North,
            row.names = FALSE)
write.table(file = file.path(discard_comp_dir, "lencomps_discard_south.csv"),
            SSinput_South,
            row.names = FALSE)



# read data files from 2017 for comparison
ling17n_dat <- SS_readdat("C:/SS/Lingcod/Lingcod_2017/models/north_base/Ling.dat",
                          verbose = FALSE)
ling17s_dat <- SS_readdat("C:/SS/Lingcod/Lingcod_2017/models/south_base/Ling.dat",
                          verbose = FALSE)

all(names(ling17n_dat$lencomp) == names(SSinput_North))
## [1] TRUE


### TODO: problem with mismatched length bins for south model
all(names(ling17s_dat$lencomp) == names(SSinput_South))
## [1] FALSE
## Warning message:
## In names(ling17s_dat$lencomp) == names(SSinput_South) :
##   longer object length is not a multiple of shorter object length

ling21n_dat <- ling17n_dat
ling21s_dat <- ling17s_dat
ling21n_dat$endyr <- 2020
### check to see what year/fleet combinations have discard length comps
table(ling21n_dat$lencomp$Yr[ling21n_dat$lencomp$Part == 1],
      ling21n_dat$lencomp$FltSvy[ling21n_dat$lencomp$Part == 1])
##      1 2
## 2004 1 1
## 2005 1 1
## 2006 1 1
## 2007 1 1
## 2008 1 1
## 2009 1 1
## 2010 1 1
## 2011 1 1
## 2012 1 1
## 2013 1 1
## 2014 1 1
## 2015 1 1

ling21n_dat$lencomp <- rbind(ling21n_dat$lencomp[ling21n_dat$lencomp$Part != 1,],
                             SSinput_North)
# remove some commas (presumably from Excel) in the sample size values from 2017
ling21n_dat$lencomp$Nsamp <- as.numeric(gsub(pattern = ",",
                                             replacement = "",
                                             ling21n_dat$lencomp$Nsamp))
table(ling21n_dat$lencomp$Yr[ling21n_dat$lencomp$Part == 1],
      ling21n_dat$lencomp$FltSvy[ling21n_dat$lencomp$Part == 1])

SS_writedat(datlist = ling21n_dat,
            outfile = "C:/SS/Lingcod/Lingcod_2021/models/0_north_data/Ling.dat",
            verbose = TRUE,
            overwrite = TRUE)

# run model

ling21n <- SS_output('C:/SS/Lingcod/Lingcod_2021/models/0_north_data')
SS_plots(ling21n, plot=c(13,16))

if(FALSE){
  ### read average weight worksheet (not yet updated for Lingcod except filename)
  Avg_Weight <- read.csv(file.path(discard_comp_dir,
                                   "Mendocino_Lincod_2021_WCGOP_Comps_Avg_Wt.csv"))

  # remove non-trawl
  Avg_Weight <- Avg_Weight[Avg_Weight$Gear == "Trawl",]

  # make a plots to compare mean, median, and weighted average
  plot(Avg_Weight$Year, Avg_Weight$AVG_WEIGHT.Mean, type='o', ylim=c(0,10))
  points(Avg_Weight$Year, Avg_Weight$AVG_WEIGHT.Median, type='o', col=2)
  points(Avg_Weight$Year, Avg_Weight$Wghtd.AVG_W, type='o', col=4)

  # create table to paste into data file
  SSinput <- data.frame(Year = Avg_Weight$Year,
                        Month = 7,
                        Fleet = 1,
                        Part = 1,
                        Type = 2,
                        Wghtd.AVG_W_kg = round(Avg_Weight$Wghtd.AVG_W/2.205, 4),
                        Wghtd.AVG_W.CV = round(Avg_Weight$Wghtd.AVG_W.SD/Avg_Weight$Wghtd.AVG_W, 4))
  ##    Year Month Fleet Part Type Wghtd.AVG_W_kg Wghtd.AVG_W.CV
  ## 1  2002     7     1    1    2         2.4332         0.2960
  ## 2  2003     7     1    1    2         1.3621         0.1637
  ## 3  2004     7     1    1    2         1.3525         0.1747
  ## 4  2005     7     1    1    2         1.7997         0.1748
  ## 5  2006     7     1    1    2         1.3914         0.2492
  ## 6  2007     7     1    1    2         1.2598         0.2315
  ## 7  2008     7     1    1    2         1.1066         0.2681
  ## 8  2009     7     1    1    2         1.2040         0.1851
  ## 9  2010     7     1    1    2         0.8579         0.2437
  ## 10 2011     7     1    1    2         0.8099         0.0983
  ## 11 2012     7     1    1    2         0.8445         0.1243
  ## 12 2013     7     1    1    2         1.5601         0.1021
  ## 13 2014     7     1    1    2         1.4196         0.0415
  ## 14 2015     7     1    1    2         1.4727         0.0556
  ## 15 2016     7     1    1    2         1.5104         0.0833
  ## 16 2017     7     1    1    2         1.9118         0.0752

}
