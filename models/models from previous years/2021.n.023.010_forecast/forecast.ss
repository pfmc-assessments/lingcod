#C forecast file written by R function SS_writeforecast
#C rerun model to get more complete formatting in forecast.ss_new
#C should work with SS version: 3.3
#C file write time: 2021-07-26 15:52:45
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
3 #_ControlRuleMethod
0.4 #_BforconstantF
0.1 #_BfornoF
-1 #_Flimitfraction
 #_years    V2
    2021 1.000
    2022 1.000
    2023 0.874
    2024 0.865
    2025 0.857
    2026 0.849
    2027 0.841
    2028 0.833
    2029 0.826
    2030 0.818
    2031 0.810
    2032 0.803
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
 #_#Year Seas Fleet dead(B)             comment
    2021    1     1  518.57 #sum_for_2021: 1200
    2021    1     2  161.76                    
    2021    1     3  191.34                    
    2021    1     4  247.57                    
    2021    1     5   80.76                    
    2022    1     1  518.57 #sum_for_2022: 1200
    2022    1     2  161.76                    
    2022    1     3  191.34                    
    2022    1     4  247.57                    
    2022    1     5   80.76                    
-9999 0 0 0
#
999 # verify end of input 
