#' ---
#' title: "Lingcod ageing error"
#' author: "Ian G. Taylor"
#' date: "`r format(Sys.time(), '%B %d, %Y')`"
#' output:
#'   bookdown::html_document2:
#'     keep_md: true
#' ---
#'
#+ setup_knitr
utils_knit_opts(type = "data-raw")
#'
#' ## Biological Data: Ageing precision and bias
#'
#' #' Text from 2017 [IGT 6/2/2021: needs update]:
#' A new aging error analysis was derived using the double reads from the NWFSC Cooperative Aging Project (CAP) and Washington State labs using a software designed for that purpose (Punt et al. 2008). Within lab reads for WDFW and CAP had 336 and 811 samples, respectively. Between lab reads had 404 samples. The results used are shown in Figure 47. The software is publicly available at https://github.com/pfmc-assessments/nwfscAgeingEror. The variability in age readings was estimated under an assumption of a linear increase in standard deviation with age. The resulting estimate indicated a standard deviation in age readings increasing from 0.13 years at age 1 by about 1 year of uncertainty per 10 years of age to a standard deviation of 3.16 years at age 25 (Figure 42). Note that all ages are from fin rays.
#'
#' Using otoliths, McFarlane and King (2001) validated that the observed annuli are generally annual marks, via a mark-recapture study which used oxytetracycline (OTC) injections to leave a distinct mark on the otoliths that could be observed upon recapture of the fish and extraction of the otoliths, their results did find some error in ageing (>5% miss-aged) even for a single year at large, and under research settings, which generally have higher precision than under production ageing conditions. More work needs to be done to identify potential biases in production ageing of lingcod. One of the sources of error in ageing lingcod using otoliths is that the first and second annuli can be re-absorbed as the fish ages. Beamish and Chilton (1977) developed a method that used mean annual diameter measurement to locate the position of the first and second annuli and thus minimize, but not eliminate, error due to this re-absorption. Recent unpublished work suggests that ages produced from fin rays and otoliths are similar.
#'
#+ get_ageing_error
# read file
data_ageerror <- read.csv("data-raw/ageing/Pooled_labs/B0_S3maxage25/SS_format_Reader 1.csv")
# format for SS
data_ageerror <- rbind(data_ageerror[data_ageerror$X == "Expected_age", -1],
                       data_ageerror[data_ageerror$X == "SD", -1])

#' ## Make the .rda file for the package
#'
#+ end_makedata
# Uncomment the following line to actually make the data set for the package
usethis::use_data(data_ageerror, overwrite = TRUE)

#+ end_cleanup
rm(data_ageerror)
