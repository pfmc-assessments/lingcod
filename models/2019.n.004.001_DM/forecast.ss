#V3.30.14.02-safe;_2019_08_01;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.0
#Stock Synthesis (SS) is a work of the U.S. Government and is not subject to copyright protection in the United States.
#Foreign copyrights may apply. See copyright.txt for more information.
# for all year entries except rebuilder; enter either: actual year, -999 for styr, 0 for endyr, neg number for rel. endyr
1 # Benchmarks: 0=skip; 1=calc F_spr,F_btgt,F_msy; 2=calc F_spr,F0.1,F_msy 
2 # MSY: 1= set to F(SPR); 2=calc F(MSY); 3=set to F(Btgt) or F0.1; 4=set to F(endyr) 
0.45 # SPR target (e.g. 0.40)
0.4 # Biomass target (e.g. 0.40)
#_Bmark_years: beg_bio, end_bio, beg_selex, end_selex, beg_relF, end_relF, beg_recr_dist, end_recr_dist, beg_SRparm, end_SRparm (enter actual year, or values of 0 or -integer to be rel. endyr)
 2016 2016 2016 2016 2016 2016 2016 2016 2016 2016
1 #Bmark_relF_Basis: 1 = use year range; 2 = set relF same as forecast below
#
0 # Forecast: 0=none; 1=F(SPR); 2=F(MSY) 3=F(Btgt) or F0.1; 4=Ave F (uses first-last relF yrs); 5=input annual F scalar
14 # N forecast years 
1 # F scalar (only used for Do_Forecast==5)
#_Fcast_years:  beg_selex, end_selex, beg_relF, end_relF, beg_mean recruits, end_recruits  (enter actual year, or values of 0 or -integer to be rel. endyr)
 -5 -5 -5 -5 0 0
0 # Forecast selectivity (0=fcast selex is mean from year range; 1=fcast selectivity from annual time-vary parms)
1 # Control rule method (1: ramp does catch=f(SSB), buffer on F; 2: ramp does F=f(SSB), buffer on F; 3: ramp does catch=f(SSB), buffer on catch; 4: ramp does F=f(SSB), buffer on catch) 
0.4 # Control rule Biomass level for constant F (as frac of Bzero, e.g. 0.40); (Must be > the no F level below) 
0.1 # Control rule Biomass level for no F (as frac of Bzero, e.g. 0.10) 
-1 # Buffer:  enter Control rule target as fraction of Flimit (e.g. 0.75), negative value invokes list of [year, scalar] with filling from year to YrMax 
 2017 1
 2018 1
 2019 1
 2020 1
 2021 0.926
 2022 0.922
 2023 0.917
 2024 0.913
 2025 0.909
 2026 0.904
 2027 0.9
 2028 0.896
 2029 0.892
 2030 0.887
 -9999 0
3 #_N forecast loops (1=OFL only; 2=ABC; 3=get F from forecast ABC catch with allocations applied)
3 #_First forecast loop with stochastic recruitment
0 #_Forecast recruitment:  0= spawn_recr; 1=value*spawn_recr_fxn; 2=value*VirginRecr; 3=recent mean from yr range above (need to set phase to -1 in control to get constant recruitment in MCMC)
1 # value is ignored 
0 #_Forecast loop control #5 (reserved for future bells&whistles) 
2021  #FirstYear for caps and allocations (should be after years with fixed inputs) 
0 # stddev of log(realized catch/target catch) in forecast (set value>0.0 to cause active impl_error)
0 # Do West Coast gfish rebuilder output (0/1) 
1999 # Rebuilder:  first year catch could have been set to zero (Ydecl)(-1 to set to 1999)
2009 # Rebuilder:  year for current age structure (Yinit) (-1 to set to endyear+1)
2 # fleet relative F:  1=use first-last alloc year; 2=read seas, fleet, alloc list below
# Note that fleet allocation is used directly as average F if Do_Forecast=4 
2 # basis for fcast catch tuning and for fcast catch caps and allocation  (2=deadbio; 3=retainbio; 5=deadnum; 6=retainnum); NOTE: same units for all fleets
# Conditional input if relative F choice = 2
# enter list of:  season,  fleet, relF; if used, terminate with season=-9999
1 1 0.532
1 2 0.132
1 3 0.139
1 4 0.197
-9999 0 0  # terminator for list of relF
# enter list of: fleet number, max annual catch for fleets with a max; terminate with fleet=-9999
-9999 -1
# enter list of area ID and max annual catch; terminate with area=-9999
-9999 -1
# enter list of fleet number and allocation group assignment, if any; terminate with fleet=-9999
-9999 -1
#_if N allocation groups >0, list year, allocation fraction for each group 
# list sequentially because read values fill to end of N forecast
# terminate with -9999 in year field 
# no allocation groups
2 # basis for input Fcast catch: -1=read basis with each obs; 2=dead catch; 3=retained catch; 99=input Hrate(F); NOTE: bio vs num based on fleet's catchunits
#enter list of Fcast catches; terminate with line having year=-9999
#_Yr Seas Fleet Catch(or_F)
 2017 1 1 524.49
 2017 1 2 123.05
 2017 1 3 46.24
 2017 1 4 178.16
 2018 1 1 300.73
 2018 1 2 126.28
 2018 1 3 41.11
 2018 1 4 213.43
 2019 1 1 576.94
 2019 1 2 143.68
 2019 1 3 43.67
 2019 1 4 213.43
 2020 1 1 576.94
 2020 1 2 143.68
 2020 1 3 43.67
 2020 1 4 213.43
-9999 1 1 0 
#
999 # verify end of input 