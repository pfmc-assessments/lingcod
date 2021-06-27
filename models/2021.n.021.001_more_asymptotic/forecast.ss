#C forecast file written by R function SS_writeforecast
#C rerun model to get more complete formatting in forecast.ss_new
#C should work with SS version: 3.3
#C file write time: 2021-06-26 13:56:14
#
1 #_benchmarks
2 #_MSY
0.45 #_SPRtarget
0.4 #_Btarget
#_Bmark_years: beg_bio, end_bio, beg_selex, end_selex, beg_relF, end_relF,  beg_recr_dist, end_recr_dist, beg_SRparm, end_SRparm (enter actual year, or values of 0 or -integer to be rel. endyr)
0 0 0 0 0 0 0 0 0 0
1 #_Bmark_relF_Basis
1 #_Forecast
12 #_Nforecastyrs
1 #_F_scalar
#_Fcast_years:  beg_selex, end_selex, beg_relF, end_relF, beg_recruits, end_recruits (enter actual year, or values of 0 or -integer to be rel. endyr)
0 0 0 0 0 0
0 #_Fcast_selex
1 #_ControlRuleMethod
0.4 #_BforconstantF
0.1 #_BfornoF
-1 #_Flimitfraction
 #_years    V2
    2021 1.000
    2022 1.000
    2023 0.935
    2024 0.930
    2025 0.926
    2026 0.922
    2027 0.917
    2028 0.913
    2029 0.909
    2030 0.904
    2031 0.900
    2032 0.896
-9999 0
3 #_N_forecast_loops
3 #_First_forecast_loop_with_stochastic_recruitment
0 #_Forecast_loop_control_3
1 #_Forecast_loop_control_4
0 #_Forecast_loop_control_5
2040 #_FirstYear_for_caps_and_allocations
0 #_stddev_of_log_catch_ratio
0 #_Do_West_Coast_gfish_rebuilder_output
1999 #_Ydecl
2009 #_Yinit
1 #_fleet_relative_F
# Note that fleet allocation is used directly as average F if Do_Forecast=4 
2 #_basis_for_fcast_catch_tuning
# enter list of fleet number and max for fleets with max annual catch; terminate with fleet=-9999
-9999 -1
# enter list of area ID and max annual catch; terminate with area=-9999
-9999 -1
# enter list of fleet number and allocation group assignment, if any; terminate with fleet=-9999
-9999 -1
2 #_InputBasis
 #_#Year Seas Fleet dead(B)               comment
    2021    1     1  463.52 #sum_for_2021: 997.32
    2021    1     2  695.28                      
    2021    1     3  182.91                      
    2021    1     4  180.58                      
    2021    1     5   54.43                      
    2022    1     1  463.52 #sum_for_2022: 997.32
    2022    1     2  695.28                      
    2022    1     3  182.91                      
    2022    1     4  180.58                      
    2022    1     5   54.43                      
-9999 0 0 0
#
999 # verify end of input 
