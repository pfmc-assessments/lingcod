get_mod(area = "n", num = 23)
get_mod(area = "s", num = 17)

#range of years to average over
yrs_range <- 2011:2020 #<------TO CHANGE

#catches to apply for 2021:2022
N_tot <- c("2021" = 1500, "2022" = 1400) #<------TO CHANGE
S_tot <- c("2021" = 471, "2022" = 500) #<------TO CHANGE


#North
prop <- mod.2021.n.023.001$catch %>% 
  dplyr::filter(Yr %in% yrs_range) %>%
  dplyr::select(c(Yr,Fleet,Obs)) %>%
  dplyr::group_by(Fleet) %>%
  dplyr::summarise(sum = sum(Obs)) %>%
  dplyr::mutate(percent = sum/sum(sum))
#Breakdown by fleet
proj_catch <- prop$percent %*% t(N_tot)
rownames(proj_catch) <- prop$Fleet
proj_catch


#South
prop <- mod.2021.s.017.001$catch %>% 
  dplyr::filter(Yr %in% yrs_range) %>%
  dplyr::select(c(Yr,Fleet,Obs)) %>%
  dplyr::group_by(Fleet) %>%
  dplyr::summarise(sum = sum(Obs)) %>%
  dplyr::mutate(percent = sum/sum(sum))
#Breakdown by fleet
proj_catch <- prop$percent %*% t(S_tot)
rownames(proj_catch) <- prop$Fleet
proj_catch
