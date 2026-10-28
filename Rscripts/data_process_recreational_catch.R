# Process recreational catch
# Results are saved in ..\data-raw\catch.RData <- update location as necessary
#
# TO DO (from 2021)
# 1.  Think about splitting catch_comm_CA_CALCOM ERK into area
# where right now it is all going to the North
# 2. for catch_rec_2000 maybe assign only a portion of Redwood
# from early years to the north model
#
# PIE IN THE SKY
# 1.  Recreational catch: MODE, how party boat vs. private boat landings differ
###############################################################################
# Set up objects, file paths,
###############################################################################

# Input required by user to change these things
calcom_fleet_TW <- c("TWL", "NET")
erddapmaxyrmeanbyarea <- 1933
catch_comm_WA_yearstartpacfin <- 1995

# patterns for dir(file.path("..", "data-raw"), pattern = grep_...)
grep_recweightfile <- "rec_bio_lingcod"
grep_rec_501 <- "CTE501"
grep_rec_mrfss <- "MRFSS-CATCH-ESTIMATES"
grep_rec_or <- "FINAL RECREATIONAL LANDINGS"
grep_rec_wa <- "Lingcod_RecCatch"

# paths for file.path("..", "data-raw", file_...)
file_albin <- "Albin_et_al_1993_Lingcod_rows.csv"
file_erddap <- dir(
  path = file.path("..", "data-raw"),
  pattern = "earlyCAlingcod",
  full.names = TRUE,
  recursive = TRUE
)
###############################################################################
# Recreational data
###############################################################################
catch_rec_2000 <- RecFIN::read_cte501(
  file = dir(file.path("..", "data-raw"), pattern = grep_rec_501, full.names = TRUE, recursive = TRUE)
) %>%
  dplyr::mutate(Source = "RecFIN") %>%
  dplyr::filter(!grepl("CAN|MEX|PUG", WATER_AREA_NAME)) %>%
  dplyr::mutate(
    area = dplyr::case_when(
      grepl("REDWOOD", PORT_NAME) ~ "North",
      state == "CA" ~ "South",
      TRUE ~ "North"
    ),
    source = "CRFS"
  )

catch_rec_1980 <- RecFIN::read_mrfss(
  file = dir(file.path("..", "data-raw"), pattern = grep_rec_mrfss, full.names = TRUE, recursive = TRUE)
) %>%
  dplyr::filter(
    SPECIES_NAME == lingcod::utils_name(type = "Common"),
    Year > min(Year)
  ) %>%
  dplyr::mutate(Source = "RecFIN")

bio_rec_recfin <- utils::read.csv(
  file = dir_recent(file.path("..", "data-raw"), pattern = grep_recweightfile),
  header = TRUE
) %>% dplyr::rename(Year = "RECFIN_YEAR") %>%
  dplyr::mutate(
    AGENCY_WEIGHT_KG = dplyr::case_when(
      grepl("^G", AGENCY_WEIGHT_UNITS) ~ AGENCY_WEIGHT / 1000,
      TRUE ~ AGENCY_WEIGHT,
    ),
    sex = dplyr::case_when(
      FISH_SEX %in% c(2, "F") ~ "F",
      FISH_SEX %in% c(1, "M") ~ "M",
      FISH_SEX %in% c(3, 8, "U") ~ "U"
    )
  ) %>%
  # Remove bad sample for lingcod, already emailed Jason and Theresa T.
  dplyr::filter(!(RECFIN_DATE == "07/25/2007" & RECFIN_LENGTH_MM > 7499))

# Mean length to convert numbers to weight
bio_rec_recfin_meanlength <- bio_rec_recfin %>%
  dplyr::group_by(STATE_NAME, IS_RETAINED) %>%
  dplyr::summarize(
    mean_length = mean(RECFIN_LENGTH_MM, na.rm = TRUE),
    n = dplyr::n(),
    .groups = "keep"
  )

# Washington recreational data
catch_rec_WA <- suppressWarnings(suppressMessages(
  dplyr::bind_rows(.id = "Type", mapply(readxl::read_excel,
                                        MoreArgs = list(
                                          col_names = FALSE,
                                          col_types = "numeric",
                                          .name_repair = "minimal",
                                          path = dir(
                                            file.path("..", "data-raw"),
                                            pattern = grep_rec_wa,
                                            full.names = TRUE,
                                            recursive = TRUE
                                          )
                                        ),
                                        sheet = c(OSP = 1, PSSP = 2, historical = 3),
                                        skip = c(2, 1, 1),
                                        n_max = c(Inf, 15, Inf),
                                        SIMPLIFY = FALSE
  )) %>%
    dplyr::rename(Year = 2, LINGCOD = 3, RELEASED = 4)
) %>%
  dplyr::select(1:4)
) %>%
  dplyr::filter(!is.na(Year)) %>%
  dplyr::group_by(Year) %>%
  dplyr::summarize(.groups = "keep",
                   num = sum(LINGCOD + ifelse(is.na(RELEASED), 0, RELEASED) * 0.07),
                   numdeaddiscard = sum(ifelse(is.na(RELEASED), 0, RELEASED) * 0.07),
                   numretained = sum(LINGCOD)
  ) %>%
  dplyr::ungroup() %>%
  dplyr::mutate(interpolate = 0) %>%
  tidyr::complete(Year = tidyr::full_seq(Year, 1), fill = list(interpolate = 999)) %>%
  dplyr::mutate(
    num = stats::approx(Year, num, n = length(Year))$y,
    interpolate = dplyr::case_when(
      interpolate == 999 ~ num,
      TRUE ~ interpolate
    ),
    mean_length = bio_rec_recfin_meanlength %>% dplyr::filter(STATE_NAME == "WASHINGTON") %>% dplyr::pull(mean_length),
    mean_weight = lw.WCGBTS[["all"]][["a"]] * (mean_length / 10)^(lw.WCGBTS[["all"]][["b"]]),
    mt = mean_weight / 1000 * num,
    state = "WA",
    mtdeaddiscard = mean_weight / 1000 * numdeaddiscard,
    mtretained = mean_weight / 1000 * numretained,
  )

gg <- ggplot2::ggplot(catch_rec_WA, ggplot2::aes(Year, mtretained)) +
  ggplot2::geom_line() +
  ggplot2::geom_line(ggplot2::aes(y = mtdeaddiscard), col = "red") +
  ggplot2::geom_line(ggplot2::aes(y = mt), col = "green") +
  ggplot2::labs(ylab = "mt") +
  ggplot2::theme_bw() + 
  ggplot2::xlim(c(2000, 2020)) +
  ggplot2::ylab("mt")
ggplot2::ggsave(gg, filename = file.path("..", "figures", "catch_rec_WA_retainedvdead.png"))

# Oregon recreational data
catch_rec_OR <- dplyr::full_join(by = c("Year", "mt"), .id = "dataset",
                                 # OR data from Ali
                                 readxl::read_excel(
                                   path = dir(
                                     file.path("..", "data-raw"),
                                     pattern = grep_rec_or,
                                     full.names = TRUE,
                                     recursive = TRUE
                                   ),
                                   sheet = 2
                                 ) %>%
                                   dplyr::rename(Year = YEAR) %>%
                                   dplyr::group_by(Year) %>%
                                   dplyr::mutate(mt = sum(`TOTAL MORTALITY_MT`)) %>%
                                   dplyr::select(!dplyr::matches("RET|REL")) %>%
                                   tidyr::spread(key = MODE, value = `TOTAL MORTALITY_MT`),
                                 # 2017 dat file from Northern model
                                 last_ssdat[[1]][["catch"]] %>%
                                   dplyr::filter(
                                     fleet == grep("OR", ignore.case = TRUE, last_ssdat[[1]][["fleetnames"]]),
                                     catch > 0
                                   ) %>%
                                   dplyr::rename(Year = year, mt = catch) %>%
                                   dplyr::select(Year, mt)
) %>%
  dplyr::distinct(Year, .keep_all = TRUE) %>%
  dplyr::arrange(Year) %>%
  dplyr::mutate(area = "North", state = "OR")

# California recreational data
# albin
# 2020-11-06 E.J. Dick, M. Monk, C. Wetzel, J. Budrick, I. Taylor
# engaged in an email conversation but it pertained to Point Reyes, i.e.,
# split between Mendocino/Sonoma and San Francisco, around 38.25
#
# 2021-04-14 E.J. Dick, M. Monk, I. Taylor, and K.F. Johnson
# engaged in a video chat regarding how to split at 40-10 because
# Redwood includes Humboldt County with Shelter Cove rather than
# Humboldt County without Shelter Cove, which is what we want.
# E.J. does not know of any other way to partition MRFSS data that has
# two groups, Northern and Southern, for SUB_REGION_NAME == CA
#   * 1990-1992 San Luis Obispo County in Southern region
#   * 1993-.... San Luis Obispo County in Northern region
#
# csv is group = "35. LINGCOD" of Table 1 in Albin et al. 1993 which
# contains county-specific catch estimates for 1981-1986
data_albin <- read.csv(file = file.path("..", "data-raw", file_albin),
                       skip = 2, header = TRUE, check.names = FALSE
) %>%
  rlang::set_names(paste(sep = "_",
                         read.csv(
                           file = file.path("..", "data-raw", file_albin),
                           skip = 1, header = FALSE, check.names = FALSE, nrows = 1
                         ),
                         colnames(.))
  ) %>%
  dplyr::rename(Year = "NA_Year") %>%
  tidyr::gather("type", "value", -Year) %>%
  tidyr::separate(type, into = c("Area", "type"), sep = "_") %>%
  tidyr::spread(key = "type", value = "value") %>%
  dplyr::arrange(Area) %>%
  dplyr::mutate(Source = "albinetal1993") %>%
  dplyr::filter(Area != "Total") %>%
  dplyr::group_by(Year) %>%
  dplyr::mutate(sum = sum(Est)) %>%
  dplyr::group_by(Area, Year) %>%
  dplyr::mutate(prop_source = Est / sum) %>%
  dplyr::ungroup()

albinmeanpropN <- data_albin %>%
  dplyr::group_by(Year) %>%
  dplyr::mutate(YearT = sum(Est)) %>%
  dplyr::ungroup() %>% dplyr::group_by(Area) %>%
  dplyr::summarize(wm = stats::weighted.mean(prop_source, w = YearT)) %>%
  dplyr::filter(grepl("Del", Area)) %>% dplyr::pull(wm)
catch_rec_CA <- catch_rec_1980 %>%
  dplyr::filter(state == "CA") %>%
  dplyr::group_by(Year, state) %>%
  dplyr::summarize(
    mt = sum(WGT_AB1, na.rm = TRUE) / 1000,
    .groups = "keep"
  ) %>%
  dplyr::ungroup() %>%
  dplyr::mutate(source = "MRFSS") %>%
  dplyr::full_join(
    by = c("Year", "state", "mt", "source"),
    x = .,
    y = dplyr::anti_join(
      by = c("Year", "mt", "state", "source"),
      y = .,
      x = last_ssdat[[2]][["catch"]] %>%
        dplyr::mutate(state = "CA", source = "old SS") %>%
        dplyr::filter(
          fleet == grep("CA_REC", last_ssdat[[2]][["fleetnames"]]),
          catch > 0,
          year < min(catch_rec_1980$Year)
        ) %>%
        dplyr::select(-seas, -catch_se, -fleet) %>%
        dplyr::rename(Year = year, mt = catch)
    )) %>%
  tidyr::crossing(area = get_groups(info_groups)) %>%
  dplyr::mutate(
    mt = dplyr::case_when(
      state == "CA" & area == "North" ~ mt * albinmeanpropN,
      state == "CA" & area == "South" ~ mt * (1 - albinmeanpropN),
      TRUE ~ mt
    )
  ) %>%
  dplyr::full_join(
    by = c("Year", "state", "mt", "source", "area"),
    x = .,
    y = catch_rec_2000 %>%
      dplyr::group_by(area, state, Year, source) %>%
      dplyr::summarize(mt = sum(TOTAL_MORTALITY_MT), .groups = "keep") %>%
      dplyr::filter(state == "CA") %>%
      dplyr::ungroup()
  ) %>%
  dplyr::group_by(area) %>%
  tidyr::complete(
    Year = tidyr::full_seq(Year, 1),
    fill = list(source = "interpolate", state = "CA")
  ) %>%
  dplyr::mutate(mt = stats::approx(Year, mt, n = length(Year))$y) %>%
  dplyr::ungroup()

###############################################################################
# Summarize recreational catches
# 1 For use in the stock assessment
# 2 For Table 1 in the document
###############################################################################

#### # 1
data_catch_rec <- dplyr::full_join(
  by = c("Year", "mt", "state"),
  catch_rec_WA,
  catch_rec_OR,
) %>%
  dplyr::select(Year, mt, state) %>%
  dplyr::mutate(area = "North") %>%
  dplyr::full_join(
    y = catch_rec_CA,
    by = c("Year", "area", "state", "mt"),
  )

# 2021-07-13 Day 2 STAR requests to fix a mistake in WA rec landings
# gg <- catch_rec %>%
#   dplyr::filter(area=="North") %>%
#   ggplot2::ggplot(ggplot2::aes(Year, mt,group=state,col=state)) +
#   ggplot2::geom_line(size = 1.1) +
#   ggplot2::theme_bw() +
#   ggplot2::theme(legend.position = c(0.1, 0.87)) +
#   ggplot2::scale_color_manual(values = c(rev(get_fleet("Rec", col = "col.n")), "black"))
# ggplot2::ggsave(plot = gg, filename = file.path("..", "figures", "catch_rec_WA_correcttotallandings.png"))

#### # 2
catch_fordoc <- dplyr::full_join(
  x = catch_comm_fordoc %>%
    dplyr::mutate(state = paste0(fleet, "-", state)) %>%
    dplyr::select(-fleet) %>%
    tidyr::spread("state", "mt"),
  y = catch_rec %>%
    # dplyr::mutate(state = paste0("rec-", state)) %>%
    dplyr::select(-source) %>%
    tidyr::spread("state", "mt"),
  by = c("Year", "area")
) %>%
  dplyr::mutate_if(is.numeric, tidyr::replace_na, 0) %>%
  dplyr::mutate(Total = purrr::reduce(dplyr::select(., !dplyr::matches("Year|area")), `+`)) %>%
  dplyr::rename_with(~ gsub("FG-", "  ", .x)) %>%
  dplyr::rename_with(~ gsub("TW-", " ", .x)) %>%
  dplyr::filter(Total != 0, Year < as.numeric(substr(Sys.Date(), 1, 4))) %>%
  dplyr::mutate_at(3:NCOL(.), ~ sprintf("%.2f", .x))

catchcaption <- "Commercial (by fleet and state) and recreational (by state) landings (mt) with yearly totals. Commercial landings were modeled as gear-specific landings and separated here by state for information purposes only."
catchlabel <- "table-catchbystate"
kableExtra::kbl(catch_fordoc %>% dplyr::filter(area == "North") %>% dplyr::select(-area),
                booktabs = TRUE, longtable = TRUE,
                caption = catchcaption, label = catchlabel, format = "latex",
                align = "r",
) %>%
  kableExtra::kable_styling(latex_options = c("repeat_header")) %>%
  kableExtra::add_header_above(c(" ", "Fixed gear" = 3, "Trawl" = 3, "Recreational" = 3, "")) %>%
  kableExtra::save_kable(file = file.path("..", "tables", paste0(catchlabel, "-n-", ".tex")))
kableExtra::kbl(catch_fordoc %>% dplyr::filter(area == "South") %>% dplyr::select(-area),
                booktabs = TRUE, longtable = TRUE,
                caption = catchcaption, label = catchlabel, format = "latex",
                align = "r",
) %>%
  kableExtra::add_header_above(c(" ", "Fixed gear" = 3, "Trawl" = 3, "Recreational" = 3, "")) %>%
  kableExtra::kable_styling(latex_options = c("repeat_header")) %>%
  kableExtra::save_kable(file = file.path("..", "tables", paste0(catchlabel, "-s-", ".tex")))

###############################################################################
# Save the data
###############################################################################
save.image(file = file.path("..", "data-raw", "catch_data_rec.RData"))
usethis::use_data(data_catch_rec, overwrite = TRUE)

gg <- bio_rec_recfin %>%
  dplyr::group_by(Year, STATE_NAME, AGENCY_WEIGHT_UNITS, IS_RETAINED, sex) %>%
  dplyr::summarize(.groups = "keep",
                   mean = mean(RECFIN_LENGTH_MM, na.rm = TRUE)
  ) %>%
  ggplot2::ggplot(ggplot2::aes(Year, mean, col = STATE_NAME, lty = STATE_NAME)) +
  ggplot2::geom_point(cex = 5, alpha = 0.5) +
  ggplot2::geom_smooth(method = "lm", se = FALSE) +
  ggplot2::scale_color_manual(
    values = get_fleet(value="rec")[,c("col.n")]
  ) +
  ggplot2::ylab("Mean length (mm)") +
  ggplot2::labs(col = "", lty = "") +
  ggplot2::theme_bw() +
  ggplot2::theme(
    legend.position = c(0.15, 0.90),
    strip.background = ggplot2::element_rect(fill = NA)
  ) +
  ggplot2::facet_grid(tolower(IS_RETAINED) ~ factor(sex, labels = c("female", "male", "unknown sex")))
ggsave2(
  gg,
  filename = file.path("..", "figures", "catch-rec-tsrecfinmeanlength.png"),
  caption = paste0(
    "Mean length (mm) of released (top panel) and retained (bottom panel) fish from the ",
    "recreational fishery for Washington (long dashes), ",
    "Oregon (short dashes), and California (solid line) ",
    " by sex (columns). ",
    "The average length of retained fish across all years was used to translate ",
    "numbers to weight for Washington."
  ),
  alttext = paste(
    ""
  )
)

gg <- ggplot2::ggplot(
  data_catch_rec %>%
    dplyr::group_by(Year, state) %>%
    dplyr::summarize(mt = sum(mt), .groups = "keep") %>%
    dplyr::ungroup(),
  ggplot2::aes(Year, mt)
) +
  ggplot2::geom_line(ggplot2::aes(col = state), lty = 2) +
  ggplot2::scale_color_manual(
    values = rev(get_fleet(value="rec")[,c("col.n")])
  ) +
  ggplot2::geom_line(
    lty = 1,
    col = get_fleet(value="CA")[,c("col.n")],
    data = last_ssdat[[2]][["catch"]] %>%
      dplyr::filter(fleet == grep("REC", last_ssdat[[2]][["fleetnames"]]), catch > 0),
    ggplot2::aes(year, catch)
  ) +
  ggplot2::geom_line(
    lty = 1,
    col = get_fleet(value="OR")[,c("col.n")],
    data = last_ssdat[[1]][["catch"]] %>%
      dplyr::filter(fleet == grep("OR", last_ssdat[[1]][["fleetnames"]]), catch > 0),
    ggplot2::aes(year, catch)
  ) +
  ggplot2::geom_line(
    lty = 1,
    col = get_fleet(value="WA")[,c("col.n")],
    data = last_ssdat[[1]][["catch"]] %>%
      dplyr::filter(fleet == grep("WA", last_ssdat[[1]][["fleetnames"]]), catch > 0),
    ggplot2::aes(year, catch)
  ) +
  ggplot2::theme_bw() +
  ggplot2::theme(legend.position = c(0.1, 0.8)) +
  ggplot2::ylab("Recreational landings (mt)")
ggsave2(
  gg,
  filename = file.path("..", "figures", "catch-rec-ca-oldts.png"),
  caption = paste0(
    "Comparison of recreational landings from this assessment (dashed line) versus ",
    "the previous assessment (solid line) for each state (colors). ",
    "The previous assessment used numbers for WA recreational landings, whereas this assessment used weight."
  ),
  alttext = paste(
    ""
  )
)

gg <- ggplot2::ggplot(
  catch_rec_CA,
  ggplot2::aes(Year, mt, col = area)
) +
  ggplot2::geom_point(ggplot2::aes(pch = source)) +
  ggplot2::geom_line() +
  ggplot2::scale_colour_manual(
    values = unlist(use.names = FALSE, get_fleet("CA", col = c("col.n", "col.s")))
  ) +
  ggplot2::theme_bw() +
  ggplot2::ylab("Recreational California landings (mt)")
ggsave2(
  gg,
  filename = file.path("..", "figures", "catch-rec-CA-ts.png"),
  caption = paste0(
    "Time series of California recreational landings (mt) for the ",
    "northern (darker color) and southern (lighter color) areas. ",
    "The shape of the points indicates the information source ",
    "(California Recreational Fisheries Survey, CRFS; linear interpolation, interpolate; ",
    "Marine Recreational Fisheries Statistics Survey, MRFSS; ",
    "old Stock Synthesis, SS, model)."
  ),
  alttext = paste(
    ""
  )
)

gg <- ggplot2::ggplot(
  data_catch_rec,
  ggplot2::aes(Year, mt, col = interaction(area, state, sep = " "))
) +
  ggplot2::geom_line(size=1.2) +
  ggplot2::scale_color_manual(
    values = unlist(use.names = FALSE, get_fleet(value="rec")[c(3,3,2,1), c("col.n", "col.s")])[c(1,5,3,4)]
  ) +
  ggplot2::labs(col = "fleet") +
  ggplot2::ylab("Recreational landings (mt)") +
  ggplot2::theme_bw()
ggsave2(
  gg,
  filename = file.path("..", "figures", "catch-rec-ts.png"),
  caption = paste0(
    "Time series of recreational landings by state and area."
  ),
  alttext = paste(
    ""
  )
)
