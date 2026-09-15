# processing discard comp data from Andi Stephens

# based on code for Big Skate 2019 assessment:
# https://github.com/IanTaylor-NOAA/BigSkate_Doc/blob/master/R/WCGOP_discard_comps.R

# read files
# these were created by Andi and loaded to Google Drive
# in the folder Lingcod_2021/data/WCGOP/
# https://drive.google.com/drive/u/0/folders/11Qd7kA-PpIOXN6nDuHWtxaxGcqNVjYc8
Length_Freq <-
  read.csv("data-raw/Mendocino_Lincod_2021_WCGOP_Comps_Length_Freq.csv")
LF_Sample_Sizes <-
  read.csv("data-raw/Mendocino_Lincod_2021_WCGOP_Comps_LF_Sample_Sizes.csv")

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

# change some names to match convention chosen for Lingcod assessment
SSinput <- SSinput %>%
  dplyr::rename(year = "Yr",
                month = "Seas",
                fleet = "FltSvy",
                sex = "Gender",
                part = "Part",
                nsamp = "Nsamp")

# split north and south and remove area column (col 1)
lenCompN_comm_discards <- SSinput[SSinput$area == "North", -1]
lenCompS_comm_discards <- SSinput[SSinput$area == "South", -1]



### read average weight worksheet (not yet updated for Lingcod except filename)
Avg_Weight <- read.csv("data-raw/Mendocino_Lincod_2021_WCGOP_Comps_Avg_Wt.csv")
Avg_Weight$fleet <- ifelse(Avg_Weight$Gear == "TRAWL",
                           get_fleet("trawl", col = "num"),
                           get_fleet("fix", col = "num"))
                           
# create table to paste into data file
SSinput <- data.frame(area = Avg_Weight$State,
                      year = Avg_Weight$Year,
                      month = 7,
                      fleet = Avg_Weight$fleet,
                      part = 1,
                      type = 2,
                      Value = round(Avg_Weight$Wghtd.AVG_W/2.205, 4),
                      Std_in = round(Avg_Weight$Wghtd.AVG_W.SD/Avg_Weight$Wghtd.AVG_W, 4)
                      )

# sort by year within fleet within area
SSinput <- SSinput[order(SSinput$area,
                         SSinput$fleet,
                         SSinput$year),]

# separate north and south
data_meanbodywt_N <- SSinput[SSinput$area == "North", -1]
data_meanbodywt_S <- SSinput[SSinput$area == "South", -1]

# save stuff for the package
usethis::use_data(lenCompN_comm_discards, overwrite = TRUE)
usethis::use_data(lenCompS_comm_discards, overwrite = TRUE)

usethis::use_data(data_meanbodywt_N, overwrite = TRUE)
usethis::use_data(data_meanbodywt_S, overwrite = TRUE)

# cleanup
rm(list = c("area", "Avg_Weight", "colname", "data_meanbodywt_N",
            "data_meanbodywt_S", "fleet", "gear_name", "irow", "lbins",
            "len", "lenCompN_comm_discards", "lenCompS_comm_discards",
            "Length_Freq", "LF_Sample_Sizes", "Nfish", "Nhauls", "prop",
            "SSinput", "y"))
