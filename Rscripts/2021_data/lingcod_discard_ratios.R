#' ---
#' title: "Lingcod discard ratios"
#' author: "Ian G. Taylor"
#' date: "`r format(Sys.time(), '%B %d, %Y')`"
#' output:
#'   bookdown::html_document2:
#'     keep_md: true
#' ---
#+ setup_knitr, echo = FALSE
utils_knit_opts(type = "data-raw")

# stuff related to exploring discard ratios 
# data provided by Chantel are in
# \\nwcfile\FRAM\Assessments\CurrentAssessments\lingcod_2021\data\wcgop
# copied on Ian's computer to c:/SS/Lingcod/Lingcod_2021/data/WCGOP/

# Loading WCGOP discard rates
info_ncs <- read.csv(file.path(
  "data-raw",
  "CONFIDENTIAL_DATA_lingcod_OB_DisRatios_boot_ncs_All_Gears_4010__2021-03-08.csv" 
))
info_cs <- read.csv(file.path(
  "data-raw",
  "CONFIDENTIAL_DATA_lingcod_OB_DisRatios_boot_cs_All_Gears_4010__2021-03-08.csv"
))
info_em <- read.csv(file.path(
  "data-raw",
  "CONFIDENTIAL_DATA_lingcod_DisRatios_noboot_cs_EM_All_Gears_4010__2021-03-08.csv"
))

### TO DO:
# bottom trawl: combine em + cs + ncs for 2011 onward,
#               use ncs for 2002-2011
#               BottomTrawl only
# fixed gear: combine em + cs + ncs for 2011 onward,
#               use ncs for 2002-2011
#               FixedGears + HKL + Pot

### look at total by gear within each group

# EM only significant in 2018 and 2019 and still small compared to catch-shares
aggregate(info_em$Observed_DISCARD.MTS + info_em$Observed_RETAINED.MTS,
          FUN = function(x){ round(sum(x), 1) },
          by = list(gear2 = info_em$gear2,
                    ryear = info_em$ryear,
                    Area = info_em$Area))
##            gear2 ryear      Area    x
## 1    BottomTrawl  2015 North4010  0.1
## 2  MidwaterTrawl  2015 North4010  2.7
## 3            Pot  2015 North4010  5.0
## 4    BottomTrawl  2016 North4010  0.4
## 5  MidwaterTrawl  2016 North4010  7.3
## 6            Pot  2016 North4010  0.2
## 7    BottomTrawl  2017 North4010  3.4
## 8  MidwaterTrawl  2017 North4010  7.9
## 9            Pot  2017 North4010  0.4
## 10   BottomTrawl  2018 North4010  3.9
## 11 MidwaterTrawl  2018 North4010 14.7
## 12           Pot  2018 North4010  2.0
## 13   BottomTrawl  2019 North4010 20.6
## 14 MidwaterTrawl  2019 North4010 14.6
## 15           Pot  2019 North4010  2.5
## 16   BottomTrawl  2015 South4010  2.5
## 17           Pot  2015 South4010  0.0
## 18   BottomTrawl  2016 South4010  6.5
## 19           Pot  2016 South4010  0.0
## 20   BottomTrawl  2017 South4010 15.1
## 21           Pot  2017 South4010  0.1
## 22   BottomTrawl  2018 South4010 36.0
## 23           Pot  2018 South4010  0.0
## 24   BottomTrawl  2019 South4010 26.0
## 25           Pot  2019 South4010  0.1

# catch-shares in the south is similar in magnitude to EM
aggregate(info_cs$Observed_DISCARD.MTS + info_cs$Observed_RETAINED.MTS,
          FUN = function(x){ round(sum(x), 1) },
          by = list(gear2 = info_cs$gear2,
                    ryear = info_cs$ryear,
                    Area = info_cs$Area))
##            gear2 ryear      Area     x
## 1    BottomTrawl  2011 North4010 272.7
## 2            HKL  2011 North4010   0.4
## 3  MidwaterTrawl  2011 North4010   4.6
## 4            Pot  2011 North4010   3.0
## 5    BottomTrawl  2012 North4010 356.1
## 6            HKL  2012 North4010   0.2
## 7  MidwaterTrawl  2012 North4010   4.3
## 8            Pot  2012 North4010   1.9
## 9    BottomTrawl  2013 North4010 328.2
## 10           HKL  2013 North4010   0.3
## 11 MidwaterTrawl  2013 North4010   8.6
## 12           Pot  2013 North4010   2.6
## 13   BottomTrawl  2014 North4010 222.4
## 14           HKL  2014 North4010   0.3
## 15 MidwaterTrawl  2014 North4010  13.4
## 16           Pot  2014 North4010   1.4
## 17   BottomTrawl  2015 North4010 165.2
## 18           HKL  2015 North4010   1.2
## 19           Pot  2015 North4010   3.8
## 20   BottomTrawl  2016 North4010 249.1
## 21           HKL  2016 North4010   0.3
## 22           Pot  2016 North4010   1.9
## 23   BottomTrawl  2017 North4010 602.3
## 24           HKL  2017 North4010   0.2
## 25           Pot  2017 North4010   2.4
## 26   BottomTrawl  2018 North4010 411.9
## 27           HKL  2018 North4010   0.3
## 28           Pot  2018 North4010   1.0
## 29   BottomTrawl  2019 North4010 400.9
## 30           HKL  2019 North4010   0.0
## 31           Pot  2019 North4010   2.0
## 32   BottomTrawl  2011 South4010   7.3
## 33           Pot  2011 South4010   0.0
## 34   BottomTrawl  2012 South4010  15.7
## 35           Pot  2012 South4010   0.3
## 36   BottomTrawl  2013 South4010  16.3
## 37           HKL  2013 South4010   0.0
## 38           Pot  2013 South4010   0.0
## 39   BottomTrawl  2014 South4010  18.5
## 40           HKL  2014 South4010   0.0
## 41           Pot  2014 South4010   0.1
## 42   BottomTrawl  2015 South4010  29.7
## 43           Pot  2015 South4010   0.0
## 44   BottomTrawl  2016 South4010  18.0
## 45   BottomTrawl  2017 South4010   9.0
## 46           HKL  2017 South4010   0.0
## 47           Pot  2017 South4010   0.1
## 48   BottomTrawl  2018 South4010  15.5
## 49   BottomTrawl  2019 South4010  58.4

# non-catch-shares
aggregate(info_ncs$Observed_DISCARD.MTS +
          info_ncs$Observed_RETAINED.MTS,
          FUN = function(x){round(sum(x),1)},
          by = list(gear2 = info_ncs$gear2,
                    ryear = info_ncs$ryear,
                    Area = info_ncs$Area))
##             gear2 ryear      Area     x
## 1     BottomTrawl  2002 North4010  38.4
## 2             HKL  2002 North4010   1.3
## 3             Pot  2002 North4010   0.2
## 4     BottomTrawl  2003 North4010  24.0
## 5      FixedGears  2003 North4010   1.1
## 6             HKL  2003 North4010   1.6
## 7             Pot  2003 North4010   0.8
## 8     BottomTrawl  2004 North4010  29.3
## 9      FixedGears  2004 North4010   5.4
## 10            HKL  2004 North4010   0.9
## 11            Pot  2004 North4010   0.4
## 12    ShrimpTrawl  2004 North4010   0.0
## 13    BottomTrawl  2005 North4010 101.0
## 14     FixedGears  2005 North4010   5.0
## 15            HKL  2005 North4010   4.5
## 16            Pot  2005 North4010   1.5
## 17    ShrimpTrawl  2005 North4010   0.0
## 18    BottomTrawl  2006 North4010  75.5
## 19     FixedGears  2006 North4010   4.7
## 20            HKL  2006 North4010   7.8
## 21            Pot  2006 North4010   3.5
## 22    BottomTrawl  2007 North4010  30.3
## 23     FixedGears  2007 North4010   3.9
## 24            HKL  2007 North4010   1.3
## 25            Pot  2007 North4010   2.2
## 26    ShrimpTrawl  2007 North4010   0.1
## 27    BottomTrawl  2008 North4010  29.9
## 28     FixedGears  2008 North4010   3.9
## 29            HKL  2008 North4010   4.8
## 30            Pot  2008 North4010   2.3
## 31    ShrimpTrawl  2008 North4010   0.0
## 32    BottomTrawl  2009 North4010  44.7
## 33     FixedGears  2009 North4010   3.1
## 34            HKL  2009 North4010   1.6
## 35            Pot  2009 North4010   1.9
## 36    ShrimpTrawl  2009 North4010   0.0
## 37    BottomTrawl  2010 North4010  11.9
## 38     FixedGears  2010 North4010   2.8
## 39            HKL  2010 North4010   2.2
## 40            Pot  2010 North4010   2.3
## 41    ShrimpTrawl  2010 North4010   0.0
## 42     FixedGears  2011 North4010   5.5
## 43            HKL  2011 North4010   1.7
## 44            Pot  2011 North4010   1.2
## 45    ShrimpTrawl  2011 North4010   0.1
## 46     FixedGears  2012 North4010   7.6
## 47            HKL  2012 North4010   1.9
## 48            Pot  2012 North4010   1.6
## 49    ShrimpTrawl  2012 North4010   0.1
## 50     FixedGears  2013 North4010   9.5
## 51            HKL  2013 North4010   0.6
## 52            Pot  2013 North4010   0.2
## 53    ShrimpTrawl  2013 North4010   0.0
## 54     FixedGears  2014 North4010   6.5
## 55            HKL  2014 North4010   0.9
## 56            Pot  2014 North4010   1.5
## 57    ShrimpTrawl  2014 North4010   0.0
## 58     FixedGears  2015 North4010  10.1
## 59            HKL  2015 North4010   2.9
## 60  MidwaterTrawl  2015 North4010   6.1
## 61            Pot  2015 North4010   4.4
## 62    ShrimpTrawl  2015 North4010   0.1
## 63    BottomTrawl  2016 North4010   0.0
## 64     FixedGears  2016 North4010   8.5
## 65            HKL  2016 North4010   4.0
## 66  MidwaterTrawl  2016 North4010   0.7
## 67            Pot  2016 North4010   7.3
## 68    ShrimpTrawl  2016 North4010   0.0
## 69    BottomTrawl  2017 North4010   0.1
## 70     FixedGears  2017 North4010   9.9
## 71            HKL  2017 North4010   4.3
## 72  MidwaterTrawl  2017 North4010   2.3
## 73            Pot  2017 North4010   1.1
## 74    ShrimpTrawl  2017 North4010   0.0
## 75    BottomTrawl  2018 North4010   1.8
## 76     FixedGears  2018 North4010   8.5
## 77            HKL  2018 North4010   7.9
## 78  MidwaterTrawl  2018 North4010   2.8
## 79            Pot  2018 North4010   2.7
## 80    ShrimpTrawl  2018 North4010   0.0
## 81    BottomTrawl  2019 North4010   3.3
## 82     FixedGears  2019 North4010   8.8
## 83            HKL  2019 North4010   8.7
## 84  MidwaterTrawl  2019 North4010   1.7
## 85            Pot  2019 North4010   2.8
## 86    ShrimpTrawl  2019 North4010   0.0
## 87    BottomTrawl  2002 South4010   4.5
## 88            HKL  2002 South4010   0.2
## 89  MidwaterTrawl  2002 South4010   0.2
## 90    BottomTrawl  2003 South4010   4.5
## 91     FixedGears  2003 South4010   1.2
## 92            HKL  2003 South4010   0.3
## 93            Pot  2003 South4010   0.0
## 94    BottomTrawl  2004 South4010   9.0
## 95     FixedGears  2004 South4010   1.9
## 96            HKL  2004 South4010   0.0
## 97            Pot  2004 South4010   0.6
## 98    BottomTrawl  2005 South4010   6.9
## 99     FixedGears  2005 South4010   1.1
## 100           HKL  2005 South4010   0.1
## 101           Pot  2005 South4010   0.0
## 102   ShrimpTrawl  2005 South4010   0.0
## 103   BottomTrawl  2006 South4010   2.2
## 104    FixedGears  2006 South4010   0.6
## 105           HKL  2006 South4010   0.0
## 106           Pot  2006 South4010   1.4
## 107   BottomTrawl  2007 South4010   9.4
## 108    FixedGears  2007 South4010   0.6
## 109           HKL  2007 South4010   0.0
## 110           Pot  2007 South4010   0.7
## 111   BottomTrawl  2008 South4010   5.7
## 112    FixedGears  2008 South4010   0.4
## 113           HKL  2008 South4010   0.0
## 114           Pot  2008 South4010   0.2
## 115   BottomTrawl  2009 South4010  10.8
## 116    FixedGears  2009 South4010   0.6
## 117           Pot  2009 South4010   0.1
## 118   BottomTrawl  2010 South4010   2.3
## 119    FixedGears  2010 South4010   0.7
## 120           Pot  2010 South4010   0.2
## 121   BottomTrawl  2011 South4010   0.0
## 122    FixedGears  2011 South4010   1.0
## 123           HKL  2011 South4010   0.2
## 124           Pot  2011 South4010   0.0
## 125    FixedGears  2012 South4010   1.5
## 126           HKL  2012 South4010   0.3
## 127           Pot  2012 South4010   0.0
## 128   BottomTrawl  2013 South4010   0.0
## 129    FixedGears  2013 South4010   1.9
## 130           Pot  2013 South4010   0.1
## 131   BottomTrawl  2014 South4010   0.0
## 132    FixedGears  2014 South4010   1.6
## 133           HKL  2014 South4010   0.1
## 134           Pot  2014 South4010   0.0
## 135   BottomTrawl  2015 South4010   1.4
## 136    FixedGears  2015 South4010   2.5
## 137           HKL  2015 South4010   1.1
## 138           Pot  2015 South4010   0.0
## 139   BottomTrawl  2016 South4010   2.9
## 140    FixedGears  2016 South4010   0.8
## 141           HKL  2016 South4010   0.2
## 142           Pot  2016 South4010   0.1
## 143   ShrimpTrawl  2016 South4010   0.0
## 144   BottomTrawl  2017 South4010   3.1
## 145    FixedGears  2017 South4010   1.3
## 146           HKL  2017 South4010   0.3
## 147           Pot  2017 South4010   0.1
## 148   ShrimpTrawl  2017 South4010   0.1
## 149   BottomTrawl  2018 South4010  16.2
## 150    FixedGears  2018 South4010   1.0
## 151           HKL  2018 South4010   0.1
## 152           Pot  2018 South4010   0.1
## 153   ShrimpTrawl  2018 South4010   0.1
## 154   BottomTrawl  2019 South4010   7.9
## 155    FixedGears  2019 South4010   1.5
## 156           HKL  2019 South4010   0.3
## 157           Pot  2019 South4010   0.2
## 158   ShrimpTrawl  2019 South4010   0.0

# non-catch-shares after 2011
aggregate(info_ncs$Observed_DISCARD.MTS[info_ncs$ryear >= 2011] +
          info_ncs$Observed_RETAINED.MTS[info_ncs$ryear >= 2011],
          FUN = sum, by = list(info_ncs$gear2[info_ncs$ryear >= 2011]))
##         Group.1        x
## 1   BottomTrawl 36.78862
## 2    FixedGears 88.25765
## 3           HKL 35.33838
## 4 MidwaterTrawl 13.65291
## 5           Pot 23.61832

# conclusion: ignore shrimp trawl
info_ncs <- info_ncs[info_ncs$gear2 != "ShrimpTrawl",]
# after 2011, bottom trawl in non-catch-shares is very small compared to catch-shares

# run function to combine discard rates
disc_rate_N_TW <-
  discard_rates_combined(info_ncs = info_ncs,
                         info_cs = info_cs,
                         info_em = info_em,
                         Area = "North4010",
                         gears = c("BottomTrawl", "MidwaterTrawl"),
                         fleet = 1,
                         min_cv = 0.05)
disc_rate_S_TW <-
  discard_rates_combined(info_ncs = info_ncs,
                         info_cs = info_cs,
                         info_em = info_em,
                         Area = "South4010",
                         gears = c("BottomTrawl", "MidwaterTrawl"),
                         fleet = 1,
                         min_cv = 0.05)
disc_rate_N_FG <-
  discard_rates_combined(info_ncs = info_ncs,
                         info_cs = info_cs,
                         info_em = info_em,
                         Area = "North4010",
                         gears = c("FixedGears", "HKL", "Pot"),
                         fleet = 2,
                         min_cv = 0.05)

disc_rate_S_FG <-
  discard_rates_combined(info_ncs = info_ncs,
                         info_cs = info_cs,
                         info_em = info_em,
                         Area = "South4010",
                         gears = c("FixedGears", "HKL", "Pot"),
                         fleet = 2,
                         min_cv = 0.05)

# remove 2002 from disc_rate_S_FG because it represents on the HKL fleet with few trips
# and no observed discards
disc_rate_S_FG <- disc_rate_S_FG[disc_rate_S_FG$Yr > 2002,]

# combine the tables into a single table
data_discard_rates_WCGOP <-
  rbind(data.frame(disc_rate_N_TW, Area = "North", Gear = "TW"),
        data.frame(disc_rate_S_TW, Area = "South", Gear = "TW"),
        data.frame(disc_rate_N_FG, Area = "North", Gear = "FG"),
        data.frame(disc_rate_S_FG, Area = "South", Gear = "FG"))
rownames(data_discard_rates_WCGOP) <- 1:nrow(data_discard_rates_WCGOP)

#+ setup_usethis, echo = FALSE
# add .rda file
usethis::use_data(data_discard_rates_WCGOP, overwrite = TRUE)

#+ cleanup
rm(file_index_orbs)
rm(info_ncs)
rm(info_cs)
rm(info_em)
rm(disc_rate_N_TW)
rm(disc_rate_S_TW)
rm(disc_rate_N_FG)
rm(disc_rate_S_FG)
rm(data_discard_rates_WCGOP)


