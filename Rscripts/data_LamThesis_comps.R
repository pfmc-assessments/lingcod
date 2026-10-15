####
# Create age and length comps from data collected for Laurel Lam's thesis
# These data are the same used in the 2017 assessment, but adjusted to accommodate the
# new area separation at 40`10, and removing all samples before 1/20/2016, which
# were on CCFRP boats
#
####

# where to get the raw data
dir_raw <- file.path("data-raw", "Biology") 

# Make directories for processed output
dir <- file.path("data_output", "Biology", "LamThesis")
dir_n <- file.path(dir, "north")
dir_s <- file.path(dir, "south")
dir.create(dir_n, showWarnings = FALSE, recursive = TRUE)
dir.create(dir_s, showWarnings = FALSE, recursive = TRUE)
stopifnot(file.exists(dir_n))
stopifnot(file.exists(dir_s))

#Read in data -
# 2021 comment: copied file from L:/Assessments/Archives/Lingcod/Lingcod_2017/Data/MLMLResearchSamples
# 2027 comment: copied from data-raw/SA_Lam_MergedAges.csv to data-raw/Biology/LamThesis/SA_Lam_MergedAges.csv
data <- read.csv(file.path(dir_raw, "SA_Lam_MergedAges.csv"), header = TRUE)

#Rename fields so they work with UnexpandedLFs.fn and SurveyAgeAtLen.fn
#Convert length to fork length following Laidig (see github issue: https://github.com/pfmc-assessments/lingcod/issues/26)
data$Length_cm <- data$TL.cm * 0.981 - 0.521
data$Year <- as.numeric(substr(data$Date..yymmdd., 1, 4))

# checking up on "NAs introduced by coercion"
data |> dplyr::count(Year)
#   Year    n
# 1 2015   32
# 2 2016 1618
# 3 2017  132
# 4   NA    4

#Remove CCRFP fish (sampled before 1/20/2016, which all occurred in 2015)
#Also removes the four fish with no year
data <- subset(data, data$Year > 2015)

#Set one record with sex = "M " to "M"
data[which(data$Sex == "M "), "Sex"] <- "M"

#Separate north and south of 40`10
data_n <- subset(data, data$Lat > (40 + 10 / 60))
data_s <- subset(data, data$Lat <= (40 + 10 / 60))

###############################
# Length comps - North and South
###############################

#Generate Comps - North

# median date is close to the middle of the year, so will assign to month 7
# since this is an annual model where expected size distributions will only be
# calculated at beginning and middle of the year
data$Date..yymmdd. |> substring(5, 6) |> as.numeric() |> table()
#   1   3   4   5   6   7   9  10
# 369  56  93 145 386 369 291  41
data$Date..yymmdd. |> substring(5, 6) |> as.numeric() |> median()
# [1] 6

lfs_n <- nwfscSurvey::get_raw_comps(
  data = data_n,
  comp_bins = info_bins[["length"]],
  comp_column_name = "Length_cm",
  input_n_method = "total_samples",
  month = 7,
  fleet = get_fleet("Lam")$num,
  dir = dir_n
)

#Visualize
nwfscSurvey::plot_comps(dir = dir_n, dat = lfs_n)
nwfscSurvey::plot_sex_ratio(dir = dir_n, dat = data_n)


#Generate Comps - South
lfs_s <- nwfscSurvey::get_raw_comps(
  data = data_s,
  comp_bins = info_bins[["length"]],
  comp_column_name = "Length_cm",
  input_n_method = "total_samples",
  month = 7,
  fleet = get_fleet("Lam")$num,
  dir = dir_s
)

#Visualize
nwfscSurvey::plot_comps(dir = dir_s, dat = lfs_s)
nwfscSurvey::plot_sex_ratio(dir = dir_s, dat = data_s)

#############
# Marginal Age Comps - just for visualization figures
#############

#Generate Comps - North
afs_n <- nwfscSurvey::get_raw_comps(
  data = data_n,
  dir = dir_n,
  comp_bins = info_bins[["age"]],
  comp_column_name = "Ages",
  input_n_method = "total_samples",
  fleet = get_fleet("Lam")$num,
  month = 7
)

#Visualize
nwfscSurvey::plot_comps(dir = dir_n, dat = afs_n)

#Generate Comps - South
afs_s <- nwfscSurvey::get_raw_comps(
  data = data_s,
  dir = dir_s,
  comp_bins = info_bins[["age"]],
  comp_column_name = "Ages",
  input_n_method = "total_samples",
  fleet = get_fleet("Lam")$num,
  month = 7
)

#Visualize
nwfscSurvey::plot_comps(dir = dir_s, dat = afs_s)


###############################
# CAAL comps - North and South
###############################

#Generate Comps - North
ageCAAL_N_LamThesis <- nwfscSurvey::get_raw_caal(
  data = data_n,
  dir = dir_n,
  len_bins = info_bins[["length"]],
  age_bins = info_bins[["age"]],
  length_column_name = "Length_cm",
  age_column_name = "Ages",
  month = 7,
  fleet = get_fleet("Lam")$num,
  partition = 0,
  ageerr = 1
)

#Generate Comps - South
ageCAAL_S_LamThesis <- nwfscSurvey::get_raw_caal(
  data = data_s,
  dir = dir_s,
  len_bins = info_bins[["length"]],
  age_bins = info_bins[["age"]],
  length_column_name = "Length_cm",
  age_column_name = "Ages",
  month = 7,
  fleet = get_fleet("Lam")$num,
  partition = 0,
  ageerr = 1
)


###############################
# Make the .rda file for the package
###############################
#Not adding Laurels Thesis data at this time.
lenCompN_LamThesis <- lfs_n
lenCompS_LamThesis <- lfs_s
usethis::use_data(lenCompN_LamThesis, overwrite = TRUE)
usethis::use_data(lenCompS_LamThesis, overwrite = TRUE)
usethis::use_data(ageCAAL_N_LamThesis, overwrite = TRUE)
usethis::use_data(ageCAAL_S_LamThesis, overwrite = TRUE)

# # Move png files to "figures"
# ignore <- file.copy(
#   recursive = TRUE,
#   dir(dir, pattern = "png", recursive = TRUE, full.names = TRUE),
#   "figures"
# )

#### Remove objects
# rm()

# spot check if results are the same as in 2021 
# (depends on file in local directory on Ian's computer)
if (FALSE) {
  rm(ageCAAL_N_LamThesis)
  load("C:/SS/Lingcod/Lingcod_2021/data/ageCAAL_N_LamThesis.rda")
  test1 <- ageCAAL_N_LamThesis$female
  # make all columns of test1 numeric
  test1[] <- lapply(test1, as.numeric)
  load("data/ageCAAL_N_LamThesis.rda")
  test2 <- ageCAAL_N_LamThesis[ageCAAL_N_LamThesis$sex == 1, 1:ncol(test1)]
  names(test1) <- names(ageCAAL_N_LamThesis)[1:ncol(test1)]
  rownames(test1) <- rownames(test2)
  
  # some kind of differences in integer vs numeric
  # require the as.matrix() to pass the test below
  identical(as.matrix(test1), as.matrix(test2))
}
