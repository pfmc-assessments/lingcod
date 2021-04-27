#V3.30.01.05-trans
#_data_and_control_files: LingN.dat // LingN.ctl
#_SS-V3.30.01.05-trans;_2017_01_13;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_11.2
#_SS-V3.30.01.05-trans;user_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_SS-V3.30.01.05-trans;user_info_available_at:https://vlab.ncep.noaa.gov/group/stock-synthesis
0  # 0 means do not read wtatage.ss; 1 means read and use wtatage.ss and also read and use growth parameters
1  #_N_Growth_Patterns
1 #_N_platoons_Within_GrowthPattern
#_Cond 1 #_Morph_between/within_stdev_ratio (no read if N_morphs=1)
#_Cond  1 #vector_Morphdist_(-1_in_first_val_gives_normal_approx)
#
2 # recr_dist_method for parameters:  1=like 3.24; 2=main effects for GP, Settle timing, Area; 3=each Settle entity; 4=none when N_GP*Nsettle*pop==1
1 # Recruitment: 1=global; 2=by area (future option)
1 #2 #  number of recruitment settlement assignments
0 # year_x_area_x_settlement_event interaction requested (only for recr_dist_method=1)
#GPat month  area age (for each settlement assignment)
#one area
1 1 1 0
#
#0 #_Cond 0 # N_movement_definitions goes here if N_areas > 1
#_Cond 1.0 # first age that moves (real age at begin of season, not integer) also cond on do_migration>0
#_Cond 1 1 1 2 4 10 # example move definition for seas=1, morph=1, source=1 dest=2, age1=4, age2=10
#
4 #N block designs
2 4 5 1#_blocks_per_pattern
# begin and end years of blocks
1998 2010 2011 2016
1998 2006 2007 2009 2010 2010 2011 2016
1973 1982 1983 1992 1993 2002 2003 2010 2011 2016 #for trawl only based on past discuscions with industry
1999 2016 #or rec
#
# controls for all timevary parameters 
1 #_env/block/dev_adjust_method for all time-vary parms (1=warn relative to base parm bounds; 3=no bound check)
0 0 0 0 1 # autogen
# where: 0 = autogen all time-varying parms; 1 = read each time-varying parm line; 2 = read then autogen if min=-12345
# 1st element for biology, 2nd for SR, 3rd for Q, 5th for selex, 4th reserved
#
0 #_natM_type:_0=1Parm; 1=N_breakpoints;_2=Lorenzen;_3=agespecific;_4=agespec_withseasinterpolate
#_N_breakpoints
1 # GrowthModel: 1=vonBert with L1&L2; 2=Richards with L1&L2; 3=age_specific_K; 4=not implemented
0.5 #_Growth_Age_for_L1
14 #_Growth_Age_for_L2 (999 to use as Linf)
-999 #_exponential decay for growth above maxage (fixed at 0.2 in 3.24; value should approx initial Z; -999 replicates 3.24)
0  #_placeholder for future growth feature
0 #_SD_add_to_LAA (set to 0.1 for SS2 V1.x compatibility)
0 #_CV_Growth_Pattern:  0 CV=f(LAA); 1 CV=F(A); 2 SD=F(LAA); 3 SD=F(A); 4 logSD=F(A)
1 #_maturity_option:  1=length logistic; 2=age logistic; 3=read age-maturity matrix by growth_pattern; 4=read age-fecundity; 5=disabled; 6=read length-maturity
1 #_First_Mature_Age
1 #_fecundity option:(1)eggs=Wt*(a+b*Wt);(2)eggs=a*L^b;(3)eggs=a*Wt^b; (4)eggs=a+b*L; (5)eggs=a+b*W
0 #_hermaphroditism option:  0=none; 1=female-to-male age-specific fxn; -1=male-to-female age-specific fxn
1 #_parameter_offset_approach (1=none, 2= M, G, CV_G as offset from female-GP1, 3=like SS2 V1.x)
#
#_growth_parms
#females growth/area 1
#LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env_var&link	dev_link	dev_minyr	dev_maxyr	dev_PH	Block	Block_Fxn
 0.05 0.4 0.257 -1.53 0.438 3 -7 0 0 0 0 0.5 0 0 # NatM_p_1_Fem_GP_1
 4 60 16.8299 0 0 0 2 0 0 0 0 0.5 0 0 # L_at_Amin_Fem_GP_1
 40 130 110 0 0 0 -2 0 0 0 0 0.5 0 0 # L_at_Amax_Fem_GP_1
 0.01 0.5 0.11634 0 0 0 3 0 0 0 0 0.5 0 0 # VonBert_K_Fem_GP_1
 0.01 0.5 0.141116 0 0 0 4 0 0 0 0 0.5 0 0 # CV_young_Fem_GP_1
 0.01 0.5 0.0986375 0 0 0 4 0 0 0 0 0 0 0 # CV_old_Fem_GP_1
 -3 3 2.76e-006 0 0 0 -3 0 0 0 0 0.5 0 0 # Wtlen_1_Fem
 -3 5 3.28 0 0 0 -3 0 0 0 0 0.5 0 0 # Wtlen_2_Fem
 -3 100 56.7 0 0 0 -3 0 0 0 0 0.5 0 0 # Mat50%_Fem
 -5 5 -0.269 0 0 0 -3 0 0 0 0 0.5 0 0 # Mat_slope_Fem
 -3 3 1 0 0 0 -3 0 0 0 0 0.5 0 0 # Eggs/kg_inter_Fem
 -3 3 0 0 0 0 -3 0 0 0 0 0.5 0 0 # Eggs/kg_slope_wt_Fem
 0.15 0.45 0.257 -1.532 0.438 3 7 0 0 0 0 0.5 0 0 # NatM_p_1_Mal_GP_1
 10 60 18.8068 0 0 0 2 0 0 0 0 0.5 0 0 # L_at_Amin_Mal_GP_1
 40 110 88.1872 0 0 0 2 0 0 0 0 0.5 0 0 # L_at_Amax_Mal_GP_1
 0.01 1 0.184049 0 0 0 3 0 0 0 0 0.5 0 0 # VonBert_K_Mal_GP_1
 0.01 0.5 0.149041 0 0 0 4 0 0 0 0 0.5 0 0 # CV_young_Mal_GP_1
 0.01 0.5 0.0431707 0 0 0 4 0 0 0 0 0 0 0 # CV_old_Mal_GP_1
-3	3	0.00000161	0	0	0	-3	0	0	0	0	0.5	0	0	#Male	wt-len-1
-5	5	3.42	0	0	0	-3	0	0	0	0	0.5	0	0	#Male	wt-len-2
#other	bio
-3	3	0	0	0	0	-4	0	0	0	0	0	0	0	#	RecrDist_GP_1
-3	3	0	0	0	0	-3	0	0	0	0	0	0	0	#	RecrDist_Area_1
0	999	1	0	0	0	-3	0	0	0	0	0.5	0	0	#	RecrDist_Bseas_1
0	0	0	0	0	0	-4	0	0	0	0	0	0	0	#	CohortGrowDev
0.000001	0.999999	0.5	0	0	0	-3	0	0	0	0	0	0	0	#	FracFemale_GP_1
#
#_no timevary MG parameters
#
#_seasonal_effects_on_biology_parms
 0 0 0 0 0 0 0 0 0 0 #_femwtlen1,femwtlen2,mat1,mat2,fec1,fec2,Malewtlen1,malewtlen2,L1,K
#_ LO HI INIT PRIOR PR_SD PR_type PHASE
#_Cond -2 2 0 0 -1 99 -2 #_placeholder when no seasonal MG parameters
#
#_Spawner-Recruitment
3 #_SR_function: 2=Ricker; 3=std_B-H; 4=SCAA; 5=Hockey; 6=B-H_flattop; 7=survival_3Parm; 8=Shepard_3Parm
0  # 0/1 to use steepness in initial equ recruitment calculation
0  #  future feature:  0/1 to make realized sigmaR a function of SR curvature
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type      PHASE    env-var    use_dev   dev_mnyr   dev_mxyr     dev_PH      Block    Blk_Fxn #  parm_name
             5            15       8.8           0             0             0          1          0          0          0          0          0          0          0 # SR_LN(R0)
           0.2             1           0.7        0            0             0         -4          0          0          0          0          0          0          0 # SR_BH_steep
             0            2           0.55        0            0             0         -3          0          0          0          0          0          0          0 # SR_sigmaR
            -5             5             0        0            0             0         -5          0          0          0          0          0          0          0 # SR_regime
             0             2             0        0            0             0        -50          0          0          0          0          0          0          0 # SR_autocorr
1 #1 #do_recdev:  0=none; 1=devvector; 2=simple deviations
1965 # first year of main recr_devs; early devs can preceed this era
2015 # last year of main recr_devs; forecast devs start in following year
2 #_recdev phase
1 # (0/1) to read 13 advanced options
1889 #_recdev_early_start (0=none; neg value makes relative to recdev_start)
6 #_recdev_early_phase
0 #_forecast_recruitment phase (incl. late recr) (0 value resets to maxphase+1)
1 #_lambda for Fcast_recr_like occurring before endyr+1
1969.0   #_last_early_yr_nobias_adj_in_MPD
1993.6   #_first_yr_fullbias_adj_in_MPD
2013.7   #_last_yr_fullbias_adj_in_MPD
2016.4   #_first_recent_yr_nobias_adj_in_MPD
0.9113   #_max_bias_adj_in_MPD (1.0 to mimic pre-2009 models)
0 #_period of cycles in recruitment (N parms read below)
-4 #min rec_dev
4 #max rec_dev
0 #_read_recdevs
#_end of advanced SR options
#
#_placeholder for full parameter lines for recruitment cycles
# read specified recr devs
#_Yr Input_value
#
# all recruitment deviations
#  1928R 1929R 1930R 1931R 1932R 1933R 1934R 1935R 1936R 1937R 1938R 1939R 1940R 1941R 1942R 1943R 1944R 1945R 1946R 1947R 1948R 1949R 1950R 1951R 1952R 1953R 1954R 1955R 1956R 1957R 1958R 1959R 1960R 1961R 1962R 1963R 1964R 1965R 1966R 1967R 1968R 1969R 1970R 1971R 1972R 1973R 1974R 1975R 1976R 1977R 1978R 1979R 1980R 1981R 1982R 1983R 1984R 1985R 1986R 1987R 1988R 1989R 1990R 1991R 1992R 1993R 1994R 1995R 1996R 1997R 1998R 1999R 2000R 2001R 2002R 2003R 2004R 2005R 2006R 2007R 2008F 2009F 2010F 2011F 2012F 2013F 2014F 2015F 2016F 2017F 2018F
#  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
# implementation error by year in forecast:  0 0 0 0 0 0 0 0 0 0
#
#Fishing Mortality info
0.1 # F ballpark
-2001 # F ballpark year (neg value to disable)
3 # F_Method:  1=Pope; 2=instan. F; 3=hybrid (hybrid is recommended)
4 # max F or harvest rate, depends on F_Method
# no additional F input needed for Fmethod 1
# if Fmethod=2; read overall start F value; overall phase; N detailed inputs to read
# if Fmethod=3; read N iterations for tuning for Fmethod 3
5  # N iterations for tuning F in hybrid method (recommend 3 to 7)
#
#_initial_F_parms; count = 1
#_ LO HI INIT PRIOR PR_SD  PR_type  PHASE
#
#_Q_setup
#_   fleet      link link_info  extra_se   biasadj     float  #  fleetname
         1         1         0         1         0         1  #  1_N_TRAWL
         2         1         0         1         0         1  #  2_N_FIX
         3         1         0         1         0         1  #  3_WA_REC
         4         1         0         1         0         1  #  4_OR_REC
         5         1         0         0         0         1  #  5_N_TRI_Early
         6         1         0         0         0         1  #  6_N_TRI_Late
         7         1         0         0         0         1  #  7_N_NWFSC
-9999 0 0 0 0 0
#
#_Q_parms(if_any);Qunits_are_ln(q)
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type      PHASE    env-var    use_dev   dev_mnyr   dev_mxyr     dev_PH      Block    Blk_Fxn  #  parm_name
           -15            15      -1.09094             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_1_N_TRAWL(1)
         0.001             2     0.0601034             0             0             0          2          0          0          0          0          0          0          0  #  Q_extraSD_1_N_TRAWL(1)
           -15            15      -5.99299             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_2_N_FIX(2)
         0.001             2      0.166599             0             0             0          2          0          0          0          0          0          0          0  #  Q_extraSD_2_N_FIX(2)
           -15            15      -8.62572             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_3_WA_REC(3)
         0.001             2      0.301493             0             0             0          2          0          0          0          0          0          0          0  #  Q_extraSD_3_WA_REC(3)
           -15            15      -11.0505             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_4_OR_REC(4)
         0.001             2        0.3191             0             0             0          2          0          0          0          0          0          0          0  #  Q_extraSD_4_OR_REC(4)
           -15            15      0.165958             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_5_N_TRI_Early(5)
           -15            15    -0.0424677             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_6_N_TRI_Late(6)
           -15            15      -0.1             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_7_N_NWFSC(7)
#_no timevary Q parameters
#
#_size_selex_types
#discard_options:_0=none;_1=define_retention;_2=retention&mortality;_3=all_discarded_dead
#_Pattern Discard Male Special
 24 2 3 0 # 1 1_N_TRAWL
 24 2 3 0 # 2 2_N_FIX
 24 0 3 0 # 3 3_WA_REC
 24 0 0 0 # 4 4_OR_REC
 24 0 0 0 # 5 _N_TRI_Early
 24 0 0 0 # 6 _N_TRI_Late
 24 0 0 0 # 7 7_N_NWFSC
 24 0 3 0 # 8_N_Lam_Research
#
#_age_selex_types
#_Pattern Discard Male Special
 11 0 0 0 #
 11 0 0 0 #
 11 0 0 0 #
 11 0 0 0 #
 11 0 0 0 #
 11 0 0 0 #
 11 0 0 0 #
 11 0 0 0 #
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type      PHASE    env-var    use_dev   dev_mnyr   dev_mxyr     dev_PH      Block    Blk_Fxn  #  parm_name
            14           120       73.4824             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P1_1_N_TRAWL(1)
           -20             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P2_1_N_TRAWL(1)
            -1            15       6             0             0             0          -3          0          0          0          0          0          0          0  #  SizeSel_P3_1_N_TRAWL(1)
            -1            15       14             0             0             0         -3          0          0          0          0          0          3          2  #  SizeSel_P4_1_N_TRAWL(1)
            -5             9           -10             0             0             0         -2          0          0          0          0          0          0          0  #  SizeSel_P5_1_N_TRAWL(1)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P6_1_N_TRAWL(1)
            10           100       68.6137             0             0             0          4          0          0          0          0          0          2          2  #  Retain_P1_1_N_TRAWL(1)
           0.1            12       7.5             0             0             0          4          0          0          0          0          0          2          2  #  Retain_P2_1_N_TRAWL(1)
         0.001            12       11.1607             0             0             0          4          0          0          0          0          0          2          2  #  Retain_P3_1_N_TRAWL(1)
           -10            10       8.08478             0             0             0          4          0          0          0          0          0          0          0  #  Retain_P4_1_N_TRAWL(1)
            -1             1             0             0             0             0         -4          0          0          0          0          0          0          0  #  DiscMort_P1_1_N_TRAWL(1)
            -1             1        0.0001             0             0             0         -5          0          0          0          0          0          0          0  #  DiscMort_P2_1_N_TRAWL(1)
         0.001             1           0.5             0             0             0         -6          0          0          0          0          0          0          0  #  DiscMort_P3_1_N_TRAWL(1)
            -2             2             0             0             0             0         -4          0          0          0          0          0          0          0  #  DiscMort_P4_1_N_TRAWL(1)
           -30            15      -1.39219             0             0             0          -3          0          0          0          0          0          0          0  #  SzSel_Male_Peak_1_N_TRAWL(1)
           -15            15      0.980737             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Ascend_1_N_TRAWL(1)
           -15            15      -6.07795             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Descend_1_N_TRAWL(1)
           -15            15             0             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Final_1_N_TRAWL(1)
           -15            15             1             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Scale_1_N_TRAWL(1)
            14           100       90.8916             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P1_2_N_FIX(2)
           -20            10           -15             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P2_2_N_FIX(2)
           -10             9       6.55036             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P3_2_N_FIX(2)
            -1             9       4.98809             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P4_2_N_FIX(2)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  SizeSel_P5_2_N_FIX(2)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P6_2_N_FIX(2)
            10           100       58.3425             0             0             0          4          0          0          0          0          0          0          0  #  Retain_P1_2_N_FIX(2)
           0.1            10       6.34218             0             0             0          5          0          0          0          0          0          1          2  #  Retain_P2_2_N_FIX(2)
         0.001             6       5.75691             0             0             0          5          0          0          0          0          0          1          2  #  Retain_P3_2_N_FIX(2)
            -2             6     -1.3             0             0             0          -4          0          0          0          0          0          0          0  #  Retain_P4_2_N_FIX(2)
            -1             1             0             0             0             0         -4          0          0          0          0          0          0          0  #  DiscMort_P1_2_N_FIX(2)
            -1             1        0.0001             0             0             0         -5          0          0          0          0          0          0          0  #  DiscMort_P2_2_N_FIX(2)
         0.001             1          0.07             0             0             0         -6          0          0          0          0          0          0          0  #  DiscMort_P3_2_N_FIX(2)
            -2             2             0             0             0             0         -4          0          0          0          0          0          0          0  #  DiscMort_P4_2_N_FIX(2)
           -30            20           -28             0             0             0         -3          0          0          0          0          0          0          0  #  SzSel_Male_Peak_2_N_FIX(2)
           -15            15      -1.15439             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Ascend_2_N_FIX(2)
           -15            15      0.434331             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Descend_2_N_FIX(2)
           -15            15             0             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Final_2_N_FIX(2)
           -15            15             1             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Scale_2_N_FIX(2)
            35           100       78.3177             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P1_3_WA_REC(3)
           -20            10           -15             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P2_3_WA_REC(3)
            -1             9       5.34409             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P3_3_WA_REC(3)
            -1             9       5.32895             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P4_3_WA_REC(3)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  SizeSel_P5_3_WA_REC(3)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P6_3_WA_REC(3)
           -15            15      -13.3732             0             0             0          3          0          0          0          0          0          0          0  #  SzSel_Male_Peak_3_WA_REC(3)
           -15            15     -0.980025             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Ascend_3_WA_REC(3)
           -15            15     -0.145975             0             0             0          -4          0          0          0          0          0          0          0  #  SzSel_Male_Descend_3_WA_REC(3)
           -15            15             0             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Final_3_WA_REC(3)
           -15            15             1             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Scale_3_WA_REC(3)
            35           100       60.5613             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P1_4_OR_REC(4)
           -20             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P2_4_OR_REC(4)
            -4             9       4.71177             0             0             0          3          0          0          0          0          0          4          2  #  SizeSel_P3_4_OR_REC(4)
            -1             9       8.97             0             0             0          3          0          0          0          0          0          4          2  #  SizeSel_P4_4_OR_REC(4)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  SizeSel_P5_4_OR_REC(4)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P6_4_OR_REC(4)
            14           120       98.9179             0             0             0          3          0          0          0          0        0.5          0          0  #  SizeSel_P1_5_N_TRI_Early(5)
           -20             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P2_5_N_TRI_Early(5)
            -1             9       6.98321             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P3_5_N_TRI_Early(5)
            -1             9             6             0             0             0         -2          0          0          0          0          0          0          0  #  SizeSel_P4_5_N_TRI_Early(5)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  SizeSel_P5_5_N_TRI_Early(5)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P6_5_N_TRI_Early(5)
            14           110       36.6103             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P1_6_N_TRI_Late(6)
           -20             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P2_6_N_TRI_Late(6)
            -1             9       3.57716             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P3_6_N_TRI_Late(6)
            -1            15       8             0             0             0          -2          0          0          0          0          0          0          0  #  SizeSel_P4_6_N_TRI_Late(6)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  SizeSel_P5_6_N_TRI_Late(6)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P6_6_N_TRI_Late(6)
            35           120       69.5813             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P1_7_N_NWFSC(7)
           -20             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P2_7_N_NWFSC(7)
            -1             9       6.63432             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P3_7_N_NWFSC(7)
            -1             9        6.3517             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P4_7_N_NWFSC(7)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  SizeSel_P5_7_N_NWFSC(7)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P6_7_N_NWFSC(7)
            35           100       86.3411             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P1_9_N_Lam_Research(9)
           -20             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P2_9_N_Lam_Research(9)
            -1             9       5.64217             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P3_9_N_Lam_Research(9)
            -1             9       4.71455             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P4_9_N_Lam_Research(9)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  SizeSel_P5_9_N_Lam_Research(9)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P6_9_N_Lam_Research(9)
           -30            40      -20.5595             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Peak_9_N_Lam_Research(9)
           -15            15     -0.644465             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Ascend_9_N_Lam_Research(9)
           -15            15      -0.59314             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Descend_9_N_Lam_Research(9)
           -15            15             0             0             0             0          -4          0          0          0          0          0          0          0  #  SzSel_Male_Final_9_N_Lam_Research(9)
           -15            15      1             0             0             0          -4          0          0          0          0          0          0          0  #  SzSel_Male_Scale_9_N_Lam_Research(9)
             0             1           0.1           0.1            -1             0         -3          0          0          0          0        0.5          0          0  #  AgeSel_P1_1_N_TRAWL(1)
             0           101           100           100            -1             0         -3          0          0          0          0        0.5          0          0  #  AgeSel_P2_1_N_TRAWL(1)
             0             1           0.1           0.1            -1             0         -3          0          0          0          0        0.5          0          0  #  AgeSel_P1_2_N_FIX(2)
             0           101           100           100            -1             0         -3          0          0          0          0        0.5          0          0  #  AgeSel_P2_2_N_FIX(2)
             0             1           0.1           0.1            -1             0         -3          0          0          0          0        0.5          0          0  #  AgeSel_P1_3_WA_REC(3)
             0           101           100           100            -1             0         -3          0          0          0          0        0.5          0          0  #  AgeSel_P2_3_WA_REC(3)
             0             1           0.1           0.1            -1             0         -3          0          0          0          0        0.5          0          0  #  AgeSel_P1_4_OR_REC(4)
             0           101           100           100            -1             0         -3          0          0          0          0        0.5          0          0  #  AgeSel_P2_4_OR_REC(4)
             0             1           0.1           0.1            -1             0         -3          0          0          0          0        0.5          0          0  #  AgeSel_P1_5_N_TRI_Early(5)
             0           101           100           100            -1             0         -3          0          0          0          0        0.5          0          0  #  AgeSel_P2_5_N_TRI_Early(5)
             0             1           0.1           0.1            -1             0         -3          0          0          0          0        0.5          0          0  #  AgeSel_P1_6_N_TRI_Late(6)
             0           101           100           100            -1             0         -3          0          0          0          0        0.5          0          0  #  AgeSel_P2_6_N_TRI_Late(6)
             0             1           0.1           0.1            -1             0         -3          0          0          0          0        0.5          0          0  #  AgeSel_P1_7_N_NWFSC(7)
             0           101           100           100            -1             0         -3          0          0          0          0        0.5          0          0  #  AgeSel_P2_7_N_NWFSC(7)
             0             1           0.1           0.1            -1             0         -3          0          0          0          0        0.5          0          0  #  AgeSel_P1_9_N_Lam_Research(9)
             0           101           100           100            -1             0         -3          0          0          0          0        0.5          0          0  #  AgeSel_P2_9_N_Lam_Research(9)
# timevary selex parameters
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type    PHASE  #  parm_name
#            -1            15       5.5             0             0             0      -5  # SizeSel_P3_1_N_TRAWL(1)_BLK3repl_1973
#            -1            15       5.5             0             0             0      -5  # SizeSel_P3_1_N_TRAWL(1)_BLK3repl_1983
#            -1            15       6             0             0             0      -5  # SizeSel_P3_1_N_TRAWL(1)_BLK3repl_1993
#            -1            15       6             0             0             0      -5  # SizeSel_P3_1_N_TRAWL(1)_BLK3repl_2003
#            -1            15       6             0             0             0      5  # SizeSel_P3_1_N_TRAWL(1)_BLK3repl_2011
            -1            15       10.0             0             0             0      -5  # SizeSel_P4_1_N_TRAWL(1)_BLK3repl_1973
            -1            15       8             0             0             0      5  # SizeSel_P4_1_N_TRAWL(1)_BLK3repl_1983
            -1            15       6.52732             0             0             0      5  # SizeSel_P4_1_N_TRAWL(1)_BLK3repl_1993
            -1            15       6.52478             0             0             0      5  # SizeSel_P4_1_N_TRAWL(1)_BLK3repl_2003
            -1            15       7             0             0             0      5  # SizeSel_P4_1_N_TRAWL(1)_BLK3repl_2011
            10           100       79.5951             0             0             0      5  # Retain_P1_1_N_TRAWL(1)_BLK2repl_1998
            10           100       76.4172             0             0             0      5  # Retain_P1_1_N_TRAWL(1)_BLK2repl_2007
            10           100        59.451             0             0             0      5  # Retain_P1_1_N_TRAWL(1)_BLK2repl_2010
            10           100       53.8642             0             0             0      5  # Retain_P1_1_N_TRAWL(1)_BLK2repl_2011
           0.1            12       7.58008             0             0             0      -5  # Retain_P2_1_N_TRAWL(1)_BLK2repl_1998
           0.1            12        5.2594             0             0             0      5  # Retain_P2_1_N_TRAWL(1)_BLK2repl_2007
           0.1            12         5.011             0             0             0      5  # Retain_P2_1_N_TRAWL(1)_BLK2repl_2010
           0.1            12       2.20225             0             0             0      5  # Retain_P2_1_N_TRAWL(1)_BLK2repl_2011
         0.001            12             7             0             0             0      -5  # Retain_P3_1_N_TRAWL(1)_BLK2repl_1998
         0.001            12       8.84518             0             0             0      5  # Retain_P3_1_N_TRAWL(1)_BLK2repl_2007
         0.001            12       10.2143             0             0             0      5  # Retain_P3_1_N_TRAWL(1)_BLK2repl_2010
         0.001            12         11.44             0             0             0      5  # Retain_P3_1_N_TRAWL(1)_BLK2repl_2011
           0.1            10       1.66207             0             0             0      5  # Retain_P2_2_N_FIX(2)_BLK1repl_1998
           0.1            10       1.54477             0             0             0      5  # Retain_P2_2_N_FIX(2)_BLK1repl_2011
         0.001             6      0.672468             0             0             0      5  # Retain_P3_2_N_FIX(2)_BLK1repl_1998
         0.001             6      0.842444             0             0             0      5  # Retain_P3_2_N_FIX(2)_BLK1repl_2011
            -4             9       2.65781             0             0             0      5  # SizeSel_P3_4_OR_REC(4)_BLK4repl_1999
            -1             9       6.63631             0             0             0      5  # SizeSel_P4_4_OR_REC(4)_BLK4repl_1999
#
0   #  use 2D_AR1 selectivity(0/1):  experimental feature
#_no 2D_AR1 selex offset used
#
# Tag loss and Tag reporting parameters go next
0  # TG_custom:  0=no read; 1=read if tags exist
#
# Input variance adjustments factors:
 #_1=add_to_survey_CV
 #_2=add_to_discard_stddev
 #_3=add_to_bodywt_CV
 #_4=mult_by_lencomp_N
 #_5=mult_by_agecomp_N
 #_6=mult_by_size-at-age_N
 #_7=mult_by_generalized_sizecomp
#francis
#_Factor  Fleet  Value
4	1	0.186871817	#	1_N_TRAWL
4	2	0.212219477	#	2_N_FIX
4	3	0.161760703	#	3_WA_REC
4	4	0.017189516	#	4_OR_REC
4	5	1.506498392	#	8_N_TRI_Early
4	6	0.172543033	#	9_N_TRI_Late
4	7	0.222312406	#	10_N_NWFSC
4	8	0.23	#	lam
5	6	0.305227701	#	10_N_tri
5	7	0.223223574	#	10_N_NWFSC
5	8	0.18	#	16_N_Lam_Research
-9999   1    0  # terminator
#
1 #_maxlambdaphase
1 #_sd_offset
# read 5 changes to default Lambdas (default value is 1.0)
# Like_comp codes:  1=surv; 2=disc; 3=mnwt; 4=length; 5=age; 6=SizeFreq; 7=sizeage; 8=catch; 9=init_equ_catch; 
# 10=recrdev; 11=parm_prior; 12=parm_dev; 13=CrashPen; 14=Morphcomp; 15=Tag-comp; 16=Tag-negbin; 17=F_ballpark
#like_comp fleet  phase  value  sizefreq_method
-9999  1  1  1  1  #  terminator
#
0 # (0/1) read specs for more stddev reporting
#
999

