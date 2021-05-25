#V3.30.16.02;_2020_09_21;_safe;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.2
#Stock Synthesis (SS) is a work of the U.S. Government and is not subject to copyright protection in the United States.
#Foreign copyrights may apply. See copyright.txt for more information.
#_user_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_user_info_available_at:https://vlab.ncep.noaa.gov/group/stock-synthesis
#_data_and_control_files: Ling.dat // Ling.ctl
0  # 0 means do not read wtatage.ss; 1 means read and use wtatage.ss and also read and use growth parameters
1  #_N_Growth_Patterns (Growth Patterns, Morphs, Bio Patterns, GP are terms used interchangeably in SS)
1 #_N_platoons_Within_GrowthPattern 
#_Cond 1 #_Platoon_within/between_stdev_ratio (no read if N_platoons=1)
#_Cond  1 #vector_platoon_dist_(-1_in_first_val_gives_normal_approx)
#
2 # recr_dist_method for parameters:  2=main effects for GP, Area, Settle timing; 3=each Settle entity; 4=none (only when N_GP*Nsettle*pop==1)
1 # not yet implemented; Future usage: Spawner-Recruitment: 1=global; 2=by area
1 #  number of recruitment settlement assignments 
0 # unused option
#GPattern month  area  age (for each settlement assignment)
 1 1 1 0
#
#_Cond 0 # N_movement_definitions goes here if Nareas > 1
#_Cond 1.0 # first age that moves (real age at begin of season, not integer) also cond on do_migration>0
#_Cond 1 1 1 2 4 10 # example move definition for seas=1, morph=1, source=1 dest=2, age1=4, age2=10
#
4 #_Nblock_Patterns
 4 4 5 4 #_blocks_per_pattern 
# begin and end years of blocks
 1998 2001 2002 2002 2003 2010 2011 2016
 1998 2006 2007 2009 2010 2010 2011 2016
 1973 1982 1983 1992 1993 2002 2003 2010 2011 2016
 1959 1974 1975 1989 1990 2003 2004 2016
#
# controls for all timevary parameters 
1 #_time-vary parm bound check (1=warn relative to base parm bounds; 3=no bound check); Also see env (3) and dev (5) options to constrain with base bounds
#
# AUTOGEN
 1 1 1 1 1 # autogen: 1st element for biology, 2nd for SR, 3rd for Q, 4th reserved, 5th for selex
# where: 0 = autogen time-varying parms of this category; 1 = read each time-varying parm line; 2 = read then autogen if parm min==-12345
#
#_Available timevary codes
#_Block types: 0: P_block=P_base*exp(TVP); 1: P_block=P_base+TVP; 2: P_block=TVP; 3: P_block=P_block(-1) + TVP
#_Block_trends: -1: trend bounded by base parm min-max and parms in transformed units (beware); -2: endtrend and infl_year direct values; -3: end and infl as fraction of base range
#_EnvLinks:  1: P(y)=P_base*exp(TVP*env(y));  2: P(y)=P_base+TVP*env(y);  3: P(y)=f(TVP,env_Zscore) w/ logit to stay in min-max;  4: P(y)=2.0/(1.0+exp(-TVP1*env(y) - TVP2))
#_DevLinks:  1: P(y)*=exp(dev(y)*dev_se;  2: P(y)+=dev(y)*dev_se;  3: random walk;  4: zero-reverting random walk with rho;  5: like 4 with logit transform to stay in base min-max
#_DevLinks(more):  21-25 keep last dev for rest of years
#
#_Prior_codes:  0=none; 6=normal; 1=symmetric beta; 2=CASAL's beta; 3=lognormal; 4=lognormal with biascorr; 5=gamma
#
# setup for M, growth, wt-len, maturity, fecundity, (hermaphro), recr_distr, cohort_grow, (movement), (age error), (catch_mult), sex ratio 
#
0 #_natM_type:_0=1Parm; 1=N_breakpoints;_2=Lorenzen;_3=agespecific;_4=agespec_withseasinterpolate
  #_no additional input for selected M option; read 1P per morph
#
1 # GrowthModel: 1=vonBert with L1&L2; 2=Richards with L1&L2; 3=age_specific_K_incr; 4=age_specific_K_decr; 5=age_specific_K_each; 6=NA; 7=NA; 8=growth cessation
0.5 #_Age(post-settlement)_for_L1;linear growth below this
10 #_Growth_Age_for_L2 (999 to use as Linf)
-999 #_exponential decay for growth above maxage (value should approx initial Z; -999 replicates 3.24; -998 to not allow growth above maxage)
0  #_placeholder for future growth feature
#
0 #_SD_add_to_LAA (set to 0.1 for SS2 V1.x compatibility)
0 #_CV_Growth_Pattern:  0 CV=f(LAA); 1 CV=F(A); 2 SD=F(LAA); 3 SD=F(A); 4 logSD=F(A)
#
1 #_maturity_option:  1=length logistic; 2=age logistic; 3=read age-maturity matrix by growth_pattern; 4=read age-fecundity; 5=disabled; 6=read length-maturity
1 #_First_Mature_Age
1 #_fecundity option:(1)eggs=Wt*(a+b*Wt);(2)eggs=a*L^b;(3)eggs=a*Wt^b; (4)eggs=a+b*L; (5)eggs=a+b*W
0 #_hermaphroditism option:  0=none; 1=female-to-male age-specific fxn; -1=male-to-female age-specific fxn
1 #_parameter_offset_approach for M, G, CV_G:  1- direct, no offset; 2- male=fem_parm*exp(male_parm); 3: male=female*exp(parm) then old=young*exp(parm)
#
#_growth_parms
#_ LO HI INIT PRIOR PR_SD PR_type PHASE env_var&link dev_link dev_minyr dev_maxyr dev_PH Block Block_Fxn
# Sex: 1  BioPattern: 1  NatMort
 0.05 0.3 0.257 -1.53 0.438 3 -7 0 0 0 0 0 0 0 # NatM_p_1_Fem_GP_1
# Sex: 1  BioPattern: 1  Growth
 10 60 18.0067 0 0 0 2 0 0 0 0 0 0 0 # L_at_Amin_Fem_GP_1
 40 130 93.4011 0 0 0 2 0 0 0 0 0 0 0 # L_at_Amax_Fem_GP_1
 0.01 0.5 0.129805 0 0 0 3 0 0 0 0 0 0 0 # VonBert_K_Fem_GP_1
 0.01 0.5 0.150482 0 0 0 4 0 0 0 0 0 0 0 # CV_young_Fem_GP_1
 0.01 0.5 0.0697104 0 0 0 4 0 0 0 0 0 0 0 # CV_old_Fem_GP_1
# Sex: 1  BioPattern: 1  WtLen
 -3 3 3.308e-06 0 0 0 -3 0 0 0 0 0 0 0 # Wtlen_1_Fem_GP_1
 -3 5 3.248 0 0 0 -3 0 0 0 0 0 0 0 # Wtlen_2_Fem_GP_1
# Sex: 1  BioPattern: 1  Maturity&Fecundity
 -3 100 52.3 0 0 0 -3 0 0 0 0 0 0 0 # Mat50%_Fem_GP_1
 -5 5 -0.219 0 0 0 -3 0 0 0 0 0 0 0 # Mat_slope_Fem_GP_1
 -3 3 1 0 0 0 -3 0 0 0 0 0 0 0 # Eggs/kg_inter_Fem_GP_1
 -3 3 0 0 0 0 -3 0 0 0 0 0 0 0 # Eggs/kg_slope_wt_Fem_GP_1
# Sex: 2  BioPattern: 1  NatMort
 0.15 0.4 0.319169 -1.532 0.438 3 7 0 0 0 0 0 0 0 # NatM_p_1_Mal_GP_1
# Sex: 2  BioPattern: 1  Growth
 10 60 18.1262 0 0 0 2 0 0 0 0 0 0 0 # L_at_Amin_Mal_GP_1
 40 110 83.8073 0 0 0 2 0 0 0 0 0 0 0 # L_at_Amax_Mal_GP_1
 0.01 1 0.16026 0 0 0 3 0 0 0 0 0 0 0 # VonBert_K_Mal_GP_1
 0.01 0.5 0.136656 0 0 0 4 0 0 0 0 0 0 0 # CV_young_Mal_GP_1
 0.01 0.5 0.0874039 0 0 0 4 0 0 0 0 0 0 0 # CV_old_Mal_GP_1
# Sex: 2  BioPattern: 1  WtLen
 -3 3 2.179e-06 0 0 0 -3 0 0 0 0 0 0 0 # Wtlen_1_Mal_GP_1
 -5 5 3.36 0 0 0 -3 0 0 0 0 0 0 0 # Wtlen_2_Mal_GP_1
# Hermaphroditism
#  Recruitment Distribution  
 -3 3 0 0 0 0 -4 0 0 0 0 0 0 0 # RecrDist_GP_1
 -3 3 0 0 0 0 -3 0 0 0 0 0 0 0 # RecrDist_Area_1
 0 999 1 0 0 0 -3 0 0 0 0 0 0 0 # RecrDist_month_1
#  Cohort growth dev base
 0.1 10 1 1 1 0 -1 0 0 0 0 0 0 0 # CohortGrowDev
#  Movement
#  Age Error from parameters
#  catch multiplier
#  fraction female, by GP
 1e-06 0.999999 0.5 0 0 0 -3 0 0 0 0 0 0 0 # FracFemale_GP_1
#
#_no timevary MG parameters
#
#_seasonal_effects_on_biology_parms
 0 0 0 0 0 0 0 0 0 0 #_femwtlen1,femwtlen2,mat1,mat2,fec1,fec2,Malewtlen1,malewtlen2,L1,K
#_ LO HI INIT PRIOR PR_SD PR_type PHASE
#_Cond -2 2 0 0 -1 99 -2 #_placeholder when no seasonal MG parameters
#
3 #_Spawner-Recruitment; Options: 1=NA; 2=Ricker; 3=std_B-H; 4=SCAA; 5=Hockey; 6=B-H_flattop; 7=survival_3Parm; 8=Shepherd_3Parm; 9=RickerPower_3parm
0  # 0/1 to use steepness in initial equ recruitment calculation
0  #  future feature:  0/1 to make realized sigmaR a function of SR curvature
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type      PHASE    env-var    use_dev   dev_mnyr   dev_mxyr     dev_PH      Block    Blk_Fxn #  parm_name
             5            15        8.4864             0             0             0          1          0          0          0          0          0          0          0 # SR_LN(R0)
           0.2             1           0.7             0             0             0         -4          0          0          0          0          0          0          0 # SR_BH_steep
             0             2          0.75             0             0             0         -3          0          0          0          0          0          0          0 # SR_sigmaR
            -5             5             0             0             0             0         -5          0          0          0          0          0          0          0 # SR_regime
             0             2             0             0             0             0        -50          0          0          0          0          0          0          0 # SR_autocorr
#_no timevary SR parameters
1 #do_recdev:  0=none; 1=devvector (R=F(SSB)+dev); 2=deviations (R=F(SSB)+dev); 3=deviations (R=R0*dev; dev2=R-f(SSB)); 4=like 3 with sum(dev2) adding penalty
1965 # first year of main recr_devs; early devs can preceed this era
2015 # last year of main recr_devs; forecast devs start in following year
2 #_recdev phase 
1 # (0/1) to read 13 advanced options
 1889 #_recdev_early_start (0=none; neg value makes relative to recdev_start)
 6 #_recdev_early_phase
 0 #_forecast_recruitment phase (incl. late recr) (0 value resets to maxphase+1)
 1 #_lambda for Fcast_recr_like occurring before endyr+1
 1950 #_last_yr_nobias_adj_in_MPD; begin of ramp
 2001 #_first_yr_fullbias_adj_in_MPD; begin of plateau
 2015 #_last_yr_fullbias_adj_in_MPD
 2017 #_end_yr_for_ramp_in_MPD (can be in forecast to shape ramp, but SS sets bias_adj to 0.0 for fcast yrs)
 0.94 #_max_bias_adj_in_MPD (typical ~0.8; -3 sets all years to 0.0; -2 sets all non-forecast yrs w/ estimated recdevs to 1.0; -1 sets biasadj=1.0 for all yrs w/ recdevs)
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
#  1889E 1890E 1891E 1892E 1893E 1894E 1895E 1896E 1897E 1898E 1899E 1900E 1901E 1902E 1903E 1904E 1905E 1906E 1907E 1908E 1909E 1910E 1911E 1912E 1913E 1914E 1915E 1916E 1917E 1918E 1919E 1920E 1921E 1922E 1923E 1924E 1925E 1926E 1927E 1928E 1929E 1930E 1931E 1932E 1933E 1934E 1935E 1936E 1937E 1938E 1939E 1940E 1941E 1942E 1943E 1944E 1945E 1946E 1947E 1948E 1949E 1950E 1951E 1952E 1953E 1954E 1955E 1956E 1957E 1958E 1959E 1960E 1961E 1962E 1963E 1964E 1965R 1966R 1967R 1968R 1969R 1970R 1971R 1972R 1973R 1974R 1975R 1976R 1977R 1978R 1979R 1980R 1981R 1982R 1983R 1984R 1985R 1986R 1987R 1988R 1989R 1990R 1991R 1992R 1993R 1994R 1995R 1996R 1997R 1998R 1999R 2000R 2001R 2002R 2003R 2004R 2005R 2006R 2007R 2008R 2009R 2010R 2011R 2012R 2013R 2014R 2015R 2016F 2017F 2018F 2019F 2020F 2021F 2022F 2023F 2024F 2025F 2026F 2027F 2028F 2029F 2030F 2031F 2032F
#  2.12299e-05 2.48544e-05 2.90705e-05 3.39706e-05 3.96576e-05 4.62529e-05 5.38943e-05 6.27384e-05 7.2966e-05 8.47795e-05 9.84078e-05 0.000114107 0.000132161 0.000152888 0.000176648 0.000203849 0.000234955 0.000270493 0.000311041 0.000357245 0.000409749 0.000469352 0.000536911 0.000613441 0.000699961 0.000797572 0.00090748 0.00103107 0.00116986 0.00132543 0.00149952 0.00169403 0.00191091 0.00215257 0.0024214 0.00272041 0.00305379 0.0034266 0.00384606 0.0043213 0.00486005 0.00547494 0.00618317 0.00698934 0.00792422 0.00898439 0.0102305 0.0116709 0.0133066 0.0151185 0.0170557 0.0190943 0.0211821 0.0232543 0.0253655 0.0277065 0.0308136 0.0355938 0.0437416 0.057659 0.0798517 0.108638 0.132264 0.132704 0.0968287 0.0431488 0.0175177 -0.0571676 -0.314688 -0.303036 0.00453472 0.218806 0.36011 -0.176478 -0.106791 -0.0836546 -0.119507 0.0430721 0.117905 0.136868 -0.0152239 -0.0347964 -0.149565 0.0898688 0.503394 0.524872 0.225249 0.784525 0.621637 -0.237975 0.743927 -0.14606 -0.421764 -0.448713 0.142927 1.38475 1.11394 0.611668 0.567914 -0.0445174 0.435291 -0.051498 0.772003 -0.776586 -0.151044 0.38017 -0.556563 0.5033 -0.459392 -0.643238 1.00449 0.423661 0.118172 -0.619268 -0.421681 -1.3895 -1.46568 -1.82608 -1.27735 -0.44869 -0.361738 0.341975 0.22132 0.372112 0.648109 -0.300687 -0.466014 -0.857053 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
# implementation error by year in forecast:  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
#
#Fishing Mortality info 
0.1 # F ballpark value in units of annual_F
-2001 # F ballpark year (neg value to disable)
3 # F_Method:  1=Pope; 2=instan. F; 3=hybrid (hybrid is recommended)
4 # max F or harvest rate, depends on F_Method
# no additional F input needed for Fmethod 1
# if Fmethod=2; read overall start F value; overall phase; N detailed inputs to read
# if Fmethod=3; read N iterations for tuning for Fmethod 3
5  # N iterations for tuning F in hybrid method (recommend 3 to 7)
#
#_initial_F_parms; count = 0
#_ LO HI INIT PRIOR PR_SD  PR_type  PHASE
#2032 2067
# F rates by fleet
# Yr:  1889 1890 1891 1892 1893 1894 1895 1896 1897 1898 1899 1900 1901 1902 1903 1904 1905 1906 1907 1908 1909 1910 1911 1912 1913 1914 1915 1916 1917 1918 1919 1920 1921 1922 1923 1924 1925 1926 1927 1928 1929 1930 1931 1932 1933 1934 1935 1936 1937 1938 1939 1940 1941 1942 1943 1944 1945 1946 1947 1948 1949 1950 1951 1952 1953 1954 1955 1956 1957 1958 1959 1960 1961 1962 1963 1964 1965 1966 1967 1968 1969 1970 1971 1972 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021 2022 2023 2024 2025 2026 2027 2028 2029 2030 2031 2032
# seas:  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
# 1_CA_TRAWL 0 0.000587868 0.00117712 0.0017691 0.00236503 0.00296602 0.00357299 0.00418679 0.0048081 0.00543747 0.0060755 0.00672261 0.00737921 0.00804569 0.00872241 0.00940967 0.0101079 0.0108175 0.0115386 0.0122718 0.0130173 0.0137755 0.0145468 0.0153316 0.0161304 0.0169436 0.0177716 0.0186149 0.0194739 0.0203494 0.0212417 0.0221515 0.0230793 0.0240257 0.0249916 0.0259774 0.026984 0.0280121 0.0290625 0.030136 0.0312351 0.0323632 0.0335218 0.0242022 0.0382816 0.0238656 0.0281551 0.0208101 0.0265889 0.020387 0.0156173 0.0185142 0.0139768 0.00814904 0.0183983 0.0189306 0.0176569 0.0291785 0.0502278 0.0545238 0.043911 0.0533987 0.0521011 0.0410534 0.0415337 0.0416256 0.0291973 0.0390632 0.0495347 0.0463191 0.0417595 0.0408179 0.0437602 0.0344649 0.0373183 0.0270698 0.025634 0.0250343 0.0294813 0.0348511 0.0389784 0.0546626 0.0738088 0.125893 0.158464 0.196926 0.19928 0.222708 0.133496 0.142162 0.226525 0.219905 0.20261 0.243472 0.365497 0.42607 0.382438 0.26357 0.362037 0.343576 0.369135 0.388012 0.380871 0.323007 0.396565 0.318508 0.270061 0.255731 0.313849 0.112025 0.105028 0.0322054 0.0233656 0.028341 0.00927959 0.00959366 0.00979166 0.0120621 0.023429 0.0213115 0.0240925 0.0162319 0.00215712 0.00517112 0.00662243 0.00850984 0.00832116 0.00673887 0.0186479 0.0304759 0.0355385 0.037012 0.076101 0.076105 0.0762048 0.0763225 0.076352 0.0762376 0.0761712 0.0760776 0.0759587 0.0757323 0.0759173 0.0760705
# 2_CA_FIX 0 0.000647166 0.00129591 0.00194762 0.0026035 0.00326445 0.00393115 0.00460408 0.0052836 0.00597001 0.00666357 0.00736452 0.00807314 0.00878958 0.00951416 0.0102472 0.0109888 0.0117393 0.012499 0.0132681 0.014047 0.0148357 0.0156348 0.0164445 0.0172649 0.0180967 0.01894 0.0197951 0.0206626 0.0215426 0.0224357 0.0233423 0.0242626 0.0251974 0.0261469 0.0271116 0.0280921 0.0290889 0.0301024 0.0311335 0.0321844 0.0332587 0.034357 0.0242406 0.0446774 0.0212931 0.0269143 0.0235898 0.02542 0.0324367 0.0167659 0.0201675 0.0176089 0.00883639 0.0197377 0.0192814 0.0197608 0.0317669 0.065131 0.0424457 0.0363116 0.0286237 0.0144699 0.0628393 0.0437574 0.0432998 0.00782343 0.0408927 0.0146455 0.0157536 0.0134067 0.00773723 0.0154291 0.0119627 0.0141338 0.00803641 0.00794234 0.00754572 0.00717435 0.00609531 0.00830508 0.00815241 0.0160468 0.0277536 0.0241617 0.0390095 0.0504994 0.0313351 0.0185754 0.0272235 0.0190188 0.0181081 0.0183536 0.015863 0.0119746 0.0112427 0.0285868 0.0630289 0.0599514 0.0653418 0.126425 0.107079 0.0806077 0.0994541 0.094376 0.0800428 0.101245 0.106106 0.106173 0.050557 0.0372679 0.0134742 0.0172823 0.0251226 0.0179832 0.0168042 0.0127187 0.0109329 0.0114367 0.012522 0.0101836 0.0118112 0.0163315 0.0206793 0.0243941 0.0326393 0.0392506 0.0226853 0.0203302 0.0174414 0.0182776 0.0202876 0.0229383 0.0229395 0.0229696 0.023005 0.0230139 0.0229795 0.0229594 0.0229312 0.0228954 0.0228271 0.0228829 0.0229291
# 3_CA_REC 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.000176435 0.000355967 0.000537702 0.000718624 0.000902618 0.00108761 0.0012616 0.00143449 0.00220964 0.00266771 0.00365527 0.00379926 0.00347697 0.00181773 0.00171622 0.0014031 0.00186425 0.00322325 0.0120613 0.0137315 0.0154012 0.014083 0.0146926 0.0105131 0.007753 0.0123759 0.0129953 0.0175119 0.0204805 0.0229886 0.018368 0.015872 0.0163713 0.0164084 0.0161895 0.0150368 0.0211431 0.0294136 0.031675 0.0314527 0.0250034 0.0388774 0.0464902 0.0607492 0.0678651 0.0803244 0.116614 0.134161 0.0958759 0.118539 0.124605 0.181083 0.170856 0.139393 0.100403 0.101724 0.250928 0.2948 0.266861 0.240006 0.217025 0.224683 0.286375 0.349132 0.235498 0.139359 0.136894 0.204756 0.172926 0.157104 0.188002 0.10132 0.0876531 0.203145 0.293387 0.0463664 0.0910142 0.0811589 0.0560091 0.0381163 0.0601086 0.0601912 0.135723 0.140542 0.161781 0.157936 0.161055 0.12164 0.105564 0.0830745 0.117733 0.135335 0.170553 0.170562 0.170786 0.171049 0.171115 0.170859 0.17071 0.1705 0.170234 0.169727 0.170141 0.170484
#
#_Q_setup for fleets with cpue or survey data
#_1:  fleet number
#_2:  link type: (1=simple q, 1 parm; 2=mirror simple q, 1 mirrored parm; 3=q and power, 2 parm; 4=mirror with offset, 2 parm)
#_3:  extra input for link, i.e. mirror fleet# or dev index number
#_4:  0/1 to select extra sd parameter
#_5:  0/1 for biasadj or not
#_6:  0/1 to float
#_   fleet      link link_info  extra_se   biasadj     float  #  fleetname
         1         1         0         1         0         1  #  1_CA_TRAWL
         4         1         0         0         0         1  #  4_CA_TRI_Early
         5         1         0         0         0         1  #  5_CA_TRI_Late
         6         1         0         0         0         1  #  6_CA_NWFSC
         7         1         0         0         0         1  #  7_CA_HookLine
-9999 0 0 0 0 0
#
#_Q_parms(if_any);Qunits_are_ln(q)
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type      PHASE    env-var    use_dev   dev_mnyr   dev_mxyr     dev_PH      Block    Blk_Fxn  #  parm_name
           -15            15      -1.53314             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_1_CA_TRAWL(1)
         0.001             2     0.0456127             0             0             0          2          0          0          0          0          0          0          0  #  Q_extraSD_1_CA_TRAWL(1)
           -15            15     -0.163515             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_4_CA_TRI_Early(4)
           -15            15      0.248616             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_5_CA_TRI_Late(5)
           -15            15       0.17325             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_6_CA_NWFSC(6)
           -15            15      -11.6101             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_7_CA_HookLine(7)
#_no timevary Q parameters
#
#_size_selex_patterns
#Pattern:_0;  parm=0; selex=1.0 for all sizes
#Pattern:_1;  parm=2; logistic; with 95% width specification
#Pattern:_5;  parm=2; mirror another size selex; PARMS pick the min-max bin to mirror
#Pattern:_11; parm=2; selex=1.0  for specified min-max population length bin range
#Pattern:_15; parm=0; mirror another age or length selex
#Pattern:_6;  parm=2+special; non-parm len selex
#Pattern:_43; parm=2+special+2;  like 6, with 2 additional param for scaling (average over bin range)
#Pattern:_8;  parm=8; double_logistic with smooth transitions and constant above Linf option
#Pattern:_9;  parm=6; simple 4-parm double logistic with starting length; parm 5 is first length; parm 6=1 does desc as offset
#Pattern:_21; parm=2+special; non-parm len selex, read as pairs of size, then selex
#Pattern:_22; parm=4; double_normal as in CASAL
#Pattern:_23; parm=6; double_normal where final value is directly equal to sp(6) so can be >1.0
#Pattern:_24; parm=6; double_normal with sel(minL) and sel(maxL), using joiners
#Pattern:_25; parm=3; exponential-logistic in size
#Pattern:_27; parm=3+special; cubic spline 
#Pattern:_42; parm=2+special+3; // like 27, with 2 additional param for scaling (average over bin range)
#_discard_options:_0=none;_1=define_retention;_2=retention&mortality;_3=all_discarded_dead;_4=define_dome-shaped_retention
#_Pattern Discard Male Special
 24 2 3 0 # 1 1_CA_TRAWL
 24 2 3 0 # 2 2_CA_FIX
 24 0 0 0 # 3 3_CA_REC
 24 0 0 0 # 4 4_CA_TRI_Early
 24 0 0 0 # 5 5_CA_TRI_Late
 24 0 0 0 # 6 6_CA_NWFSC
 24 0 3 0 # 7 7_CA_HookLine
 24 0 3 0 # 8 8_CA_Lam_Research
#
#_age_selex_patterns
#Pattern:_0; parm=0; selex=1.0 for ages 0 to maxage
#Pattern:_10; parm=0; selex=1.0 for ages 1 to maxage
#Pattern:_11; parm=2; selex=1.0  for specified min-max age
#Pattern:_12; parm=2; age logistic
#Pattern:_13; parm=8; age double logistic
#Pattern:_14; parm=nages+1; age empirical
#Pattern:_15; parm=0; mirror another age or length selex
#Pattern:_16; parm=2; Coleraine - Gaussian
#Pattern:_17; parm=nages+1; empirical as random walk  N parameters to read can be overridden by setting special to non-zero
#Pattern:_41; parm=2+nages+1; // like 17, with 2 additional param for scaling (average over bin range)
#Pattern:_18; parm=8; double logistic - smooth transition
#Pattern:_19; parm=6; simple 4-parm double logistic with starting age
#Pattern:_20; parm=6; double_normal,using joiners
#Pattern:_26; parm=3; exponential-logistic in age
#Pattern:_27; parm=3+special; cubic spline in age
#Pattern:_42; parm=2+special+3; // cubic spline; with 2 additional param for scaling (average over bin range)
#Age patterns entered with value >100 create Min_selage from first digit and pattern from remainder
#_Pattern Discard Male Special
 11 0 0 0 # 1 1_CA_TRAWL
 11 0 0 0 # 2 2_CA_FIX
 11 0 0 0 # 3 3_CA_REC
 11 0 0 0 # 4 4_CA_TRI_Early
 11 0 0 0 # 5 5_CA_TRI_Late
 11 0 0 0 # 6 6_CA_NWFSC
 11 0 0 0 # 7 7_CA_HookLine
 11 0 0 0 # 8 8_CA_Lam_Research
#
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type      PHASE    env-var    use_dev   dev_mnyr   dev_mxyr     dev_PH      Block    Blk_Fxn  #  parm_name
# 1   1_CA_TRAWL LenSelex
            14           100       60.1524             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_peak_1_CA_TRAWL(1)
            -6             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_1_CA_TRAWL(1)
            -5            15             7             0             0             0         -3          0          0          0          0          0          3          2  #  Size_DblN_ascend_se_1_CA_TRAWL(1)
            -5            15       13.1537             0             0             0          3          0          0          0          0          0          3          2  #  Size_DblN_descend_se_1_CA_TRAWL(1)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_1_CA_TRAWL(1)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_1_CA_TRAWL(1)
            10           100       60.4058             0             0             0          4          0          0          0          0          0          2          2  #  Retain_L_infl_1_CA_TRAWL(1)
           0.1            15             9             0             0             0         -4          0          0          0          0          0          2          2  #  Retain_L_width_1_CA_TRAWL(1)
           -10            10             2           -10             0             0         -4          0          0          0          0          0          0          0  #  Retain_L_asymptote_logit_1_CA_TRAWL(1)
            -2             2             0             0             0             0         -4          0          0          0          0          0          0          0  #  Retain_L_maleoffset_1_CA_TRAWL(1)
            -1             1             0             0             0             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_infl_1_CA_TRAWL(1)
            -1             1        0.0001             0             0             0         -5          0          0          0          0          0          0          0  #  DiscMort_L_width_1_CA_TRAWL(1)
         0.001             1           0.5             0             0             0         -6          0          0          0          0          0          0          0  #  DiscMort_L_level_old_1_CA_TRAWL(1)
            -2             2             0             0             0             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_male_offset_1_CA_TRAWL(1)
           -30            15      -3.32043             0             0             0          3          0          0          0          0          0          0          0  #  SzSel_Male_Peak_1_CA_TRAWL(1)
           -15            15       3.16906             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Ascend_1_CA_TRAWL(1)
           -15            15      -1.25677             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Descend_1_CA_TRAWL(1)
           -15            15             0             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Final_1_CA_TRAWL(1)
           -15            15             1             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Scale_1_CA_TRAWL(1)
# 2   2_CA_FIX LenSelex
            14           100       85.6044             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_peak_2_CA_FIX(2)
            -6             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_2_CA_FIX(2)
            -5            15       7.53636             0             0             0          3          0          0          0          0          0          1          2  #  Size_DblN_ascend_se_2_CA_FIX(2)
            -5            15        5.6008             0             0             0          3          0          0          0          0          0          1          2  #  Size_DblN_descend_se_2_CA_FIX(2)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_2_CA_FIX(2)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_2_CA_FIX(2)
            10           100       51.6048             0             0             0          4          0          0          0          0          0          1          2  #  Retain_L_infl_2_CA_FIX(2)
           0.1            10       2.36349             0             0             0          4          0          0          0          0          0          1          2  #  Retain_L_width_2_CA_FIX(2)
           -10            10             1           -10             0             0         -4          0          0          0          0          0          0          0  #  Retain_L_asymptote_logit_2_CA_FIX(2)
            -2             2             0             0             0             0         -6          0          0          0          0          0          0          0  #  Retain_L_maleoffset_2_CA_FIX(2)
            -1             1             0             0             0             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_infl_2_CA_FIX(2)
            -1             1        0.0001             0             0             0         -5          0          0          0          0          0          0          0  #  DiscMort_L_width_2_CA_FIX(2)
         0.001             1          0.07             0             0             0         -6          0          0          0          0          0          0          0  #  DiscMort_L_level_old_2_CA_FIX(2)
            -2             2             0             0             0             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_male_offset_2_CA_FIX(2)
           -30            20           -22             0             0             0         -3          0          0          0          0          0          0          0  #  SzSel_Male_Peak_2_CA_FIX(2)
           -15            15      -1.66309             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Ascend_2_CA_FIX(2)
           -15            15       0.28567             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Descend_2_CA_FIX(2)
           -15            15             0             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Final_2_CA_FIX(2)
           -15            15             1             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Scale_2_CA_FIX(2)
# 3   3_CA_REC LenSelex
            35           100          62.5             0             0             0         -3          0          0          0          0          0          4          2  #  Size_DblN_peak_3_CA_REC(3)
           -16             1           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_3_CA_REC(3)
            -1            15           5.8             0             0             0         -3          0          0          0          0          0          4          2  #  Size_DblN_ascend_se_3_CA_REC(3)
            -1            15           7.2             0             0             0         -3          0          0          0          0          0          4          2  #  Size_DblN_descend_se_3_CA_REC(3)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_start_logit_3_CA_REC(3)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_3_CA_REC(3)
# 4   4_CA_TRI_Early LenSelex
            10           100       38.7585             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_peak_4_CA_TRI_Early(4)
            -6             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_4_CA_TRI_Early(4)
            -1            15       5.39432             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_ascend_se_4_CA_TRI_Early(4)
            -1            15       14.2359             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_descend_se_4_CA_TRI_Early(4)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_4_CA_TRI_Early(4)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_4_CA_TRI_Early(4)
# 5   5_CA_TRI_Late LenSelex
            14            70       23.1505             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_peak_5_CA_TRI_Late(5)
            -6             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_5_CA_TRI_Late(5)
            -5            15      -4.10109             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_ascend_se_5_CA_TRI_Late(5)
            -1            15       10.3139             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_descend_se_5_CA_TRI_Late(5)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_5_CA_TRI_Late(5)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_5_CA_TRI_Late(5)
# 6   6_CA_NWFSC LenSelex
             5            30        26.852             0             0             0          2          0          0          0          0          0          0          0  #  Size_DblN_peak_6_CA_NWFSC(6)
           -12             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_6_CA_NWFSC(6)
            -1            15        4.8011             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_ascend_se_6_CA_NWFSC(6)
            -1            15       7.93487             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_descend_se_6_CA_NWFSC(6)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_6_CA_NWFSC(6)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_6_CA_NWFSC(6)
# 7   7_CA_HookLine LenSelex
            35           100       65.7738             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_peak_7_CA_HookLine(7)
            -6             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_7_CA_HookLine(7)
            -6            15       5.46662             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_ascend_se_7_CA_HookLine(7)
            -6            15        6.8943             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_descend_se_7_CA_HookLine(7)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_7_CA_HookLine(7)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_7_CA_HookLine(7)
           -30            40      -9.73646             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Peak_7_CA_HookLine(7)
           -15            15    -0.0904599             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Ascend_7_CA_HookLine(7)
           -15            15      -2.00426             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Descend_7_CA_HookLine(7)
           -15            15             0             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Final_7_CA_HookLine(7)
           -15            15             1             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Scale_7_CA_HookLine(7)
# 8   8_CA_Lam_Research LenSelex
            35           100       91.0741             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_peak_8_CA_Lam_Research(8)
            -6             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_8_CA_Lam_Research(8)
            -6            15       6.55887             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_ascend_se_8_CA_Lam_Research(8)
            -6            15          -5.6             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_descend_se_8_CA_Lam_Research(8)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_8_CA_Lam_Research(8)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_8_CA_Lam_Research(8)
           -30            40      -27.4041             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Peak_8_CA_Lam_Research(8)
           -15            15      -1.18923             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Ascend_8_CA_Lam_Research(8)
           -15            15       9.63188             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Descend_8_CA_Lam_Research(8)
           -15            15             0             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Final_8_CA_Lam_Research(8)
           -15            15             1             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Scale_8_CA_Lam_Research(8)
# 1   1_CA_TRAWL AgeSelex
             0             1           0.1           0.1            -1             0        -99          0          0          0          0        0.5          0          0  #  minage@sel=1_1_CA_TRAWL(1)
             0           101           100           100            -1             0        -99          0          0          0          0        0.5          0          0  #  maxage@sel=1_1_CA_TRAWL(1)
# 2   2_CA_FIX AgeSelex
             0             1           0.1           0.1            -1             0        -99          0          0          0          0        0.5          0          0  #  minage@sel=1_2_CA_FIX(2)
             0           101           100           100            -1             0        -99          0          0          0          0        0.5          0          0  #  maxage@sel=1_2_CA_FIX(2)
# 3   3_CA_REC AgeSelex
             0             1           0.1           0.1            -1             0        -99          0          0          0          0        0.5          0          0  #  minage@sel=1_3_CA_REC(3)
             0           101           100           100            -1             0        -99          0          0          0          0        0.5          0          0  #  maxage@sel=1_3_CA_REC(3)
# 4   4_CA_TRI_Early AgeSelex
             0             1           0.1           0.1            -1             0        -99          0          0          0          0        0.5          0          0  #  minage@sel=1_4_CA_TRI_Early(4)
             0           101           100           100            -1             0        -99          0          0          0          0        0.5          0          0  #  maxage@sel=1_4_CA_TRI_Early(4)
# 5   5_CA_TRI_Late AgeSelex
             0             1           0.1           0.1            -1             0        -99          0          0          0          0        0.5          0          0  #  minage@sel=1_5_CA_TRI_Late(5)
             0           101           100           100            -1             0        -99          0          0          0          0        0.5          0          0  #  maxage@sel=1_5_CA_TRI_Late(5)
# 6   6_CA_NWFSC AgeSelex
             0             1           0.1           0.1            -1             0        -99          0          0          0          0        0.5          0          0  #  minage@sel=1_6_CA_NWFSC(6)
             0           101           100           100            -1             0        -99          0          0          0          0        0.5          0          0  #  maxage@sel=1_6_CA_NWFSC(6)
# 7   7_CA_HookLine AgeSelex
             0             1           0.1           0.1            -1             0        -99          0          0          0          0        0.5          0          0  #  minage@sel=1_7_CA_HookLine(7)
             0           101           100           100            -1             0        -99          0          0          0          0        0.5          0          0  #  maxage@sel=1_7_CA_HookLine(7)
# 8   8_CA_Lam_Research AgeSelex
             0             1           0.1           0.1            -1             0        -99          0          0          0          0        0.5          0          0  #  minage@sel=1_8_CA_Lam_Research(8)
             0           101           100           100            -1             0        -99          0          0          0          0        0.5          0          0  #  maxage@sel=1_8_CA_Lam_Research(8)
# timevary selex parameters 
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type    PHASE  #  parm_name
            -5            15             7             0             0             0      -4  # Size_DblN_ascend_se_1_CA_TRAWL(1)_BLK3repl_1973
            -5            15       7.52964             0             0             0      4  # Size_DblN_ascend_se_1_CA_TRAWL(1)_BLK3repl_1983
            -5            15       7.12344             0             0             0      4  # Size_DblN_ascend_se_1_CA_TRAWL(1)_BLK3repl_1993
            -5            15       3.36683             0             0             0      4  # Size_DblN_ascend_se_1_CA_TRAWL(1)_BLK3repl_2003
            -5            15       2.95329             0             0             0      4  # Size_DblN_ascend_se_1_CA_TRAWL(1)_BLK3repl_2011
            -5            15       14.4138             0             0             0      4  # Size_DblN_descend_se_1_CA_TRAWL(1)_BLK3repl_1973
            -5            15       6.26799             0             0             0      4  # Size_DblN_descend_se_1_CA_TRAWL(1)_BLK3repl_1983
            -5            15       6.75754             0             0             0      4  # Size_DblN_descend_se_1_CA_TRAWL(1)_BLK3repl_1993
            -5            15       6.43936             0             0             0      4  # Size_DblN_descend_se_1_CA_TRAWL(1)_BLK3repl_2003
            -5            15       8.01456             0             0             0      4  # Size_DblN_descend_se_1_CA_TRAWL(1)_BLK3repl_2011
            10           100       66.6135             0             0             0      4  # Retain_L_infl_1_CA_TRAWL(1)_BLK2repl_1998
            10           100       67.3478             0             0             0      4  # Retain_L_infl_1_CA_TRAWL(1)_BLK2repl_2007
            10           100       56.4087             0             0             0      4  # Retain_L_infl_1_CA_TRAWL(1)_BLK2repl_2010
            10           100       56.5324             0             0             0      4  # Retain_L_infl_1_CA_TRAWL(1)_BLK2repl_2011
           0.1            10           3.5             0             0             0      -4  # Retain_L_width_1_CA_TRAWL(1)_BLK2repl_1998
           0.1            10       2.88578             0             0             0      4  # Retain_L_width_1_CA_TRAWL(1)_BLK2repl_2007
           0.1            10      0.713571             0             0             0      4  # Retain_L_width_1_CA_TRAWL(1)_BLK2repl_2010
           0.1            10       1.41804             0             0             0      4  # Retain_L_width_1_CA_TRAWL(1)_BLK2repl_2011
            -5            15           8.1             0             0             0      -4  # Size_DblN_ascend_se_2_CA_FIX(2)_BLK1repl_1998
            -5            15       5.22402             0             0             0      4  # Size_DblN_ascend_se_2_CA_FIX(2)_BLK1repl_2002
            -5            15       6.72637             0             0             0      4  # Size_DblN_ascend_se_2_CA_FIX(2)_BLK1repl_2003
            -5            15       6.41674             0             0             0      4  # Size_DblN_ascend_se_2_CA_FIX(2)_BLK1repl_2011
            -5            15           6.4             0             0             0      -4  # Size_DblN_descend_se_2_CA_FIX(2)_BLK1repl_1998
            -5            15       6.26523             0             0             0      4  # Size_DblN_descend_se_2_CA_FIX(2)_BLK1repl_2002
            -5            15       4.75298             0             0             0      4  # Size_DblN_descend_se_2_CA_FIX(2)_BLK1repl_2003
            -5            15       4.67845             0             0             0      4  # Size_DblN_descend_se_2_CA_FIX(2)_BLK1repl_2011
            10           100       61.3638             0             0             0      4  # Retain_L_infl_2_CA_FIX(2)_BLK1repl_1998
            10           100       30.2899             0             0             0      4  # Retain_L_infl_2_CA_FIX(2)_BLK1repl_2002
            10           100       59.7352             0             0             0      4  # Retain_L_infl_2_CA_FIX(2)_BLK1repl_2003
            10           100         59.58             0             0             0      4  # Retain_L_infl_2_CA_FIX(2)_BLK1repl_2011
           0.1            10       2.46814             0             0             0      4  # Retain_L_width_2_CA_FIX(2)_BLK1repl_1998
           0.1            10       2.06384             0             0             0      4  # Retain_L_width_2_CA_FIX(2)_BLK1repl_2002
           0.1            10      0.963062             0             0             0      4  # Retain_L_width_2_CA_FIX(2)_BLK1repl_2003
           0.1            10       1.03191             0             0             0      4  # Retain_L_width_2_CA_FIX(2)_BLK1repl_2011
            20           100       67.9819             0             0             0      4  # Size_DblN_peak_3_CA_REC(3)_BLK4repl_1959
            20           100       69.8458             0             0             0      4  # Size_DblN_peak_3_CA_REC(3)_BLK4repl_1975
            20           100       62.9863             0             0             0      4  # Size_DblN_peak_3_CA_REC(3)_BLK4repl_1990
            20           100       62.6268             0             0             0      4  # Size_DblN_peak_3_CA_REC(3)_BLK4repl_2004
            -1            15        5.7988             0             0             0      4  # Size_DblN_ascend_se_3_CA_REC(3)_BLK4repl_1959
            -1            15       5.60374             0             0             0      4  # Size_DblN_ascend_se_3_CA_REC(3)_BLK4repl_1975
            -1            15       3.98566             0             0             0      4  # Size_DblN_ascend_se_3_CA_REC(3)_BLK4repl_1990
            -1            15       3.93994             0             0             0      4  # Size_DblN_ascend_se_3_CA_REC(3)_BLK4repl_2004
            -1            15       7.11886             0             0             0      4  # Size_DblN_descend_se_3_CA_REC(3)_BLK4repl_1959
            -1            15       6.59035             0             0             0      4  # Size_DblN_descend_se_3_CA_REC(3)_BLK4repl_1975
            -1            15       6.53946             0             0             0      4  # Size_DblN_descend_se_3_CA_REC(3)_BLK4repl_1990
            -1            15       5.85994             0             0             0      4  # Size_DblN_descend_se_3_CA_REC(3)_BLK4repl_2004
# info on dev vectors created for selex parms are reported with other devs after tag parameter section 
#
0   #  use 2D_AR1 selectivity(0/1)
#_no 2D_AR1 selex offset used
#
# Tag loss and Tag reporting parameters go next
0  # TG_custom:  0=no read and autogen if tag data exist; 1=read
#_Cond -6 6 1 1 2 0.01 -4 0 0 0 0 0 0 0  #_placeholder if no parameters
#
# deviation vectors for timevary parameters
#  base   base first block   block  env  env   dev   dev   dev   dev   dev
#  type  index  parm trend pattern link  var  vectr link _mnyr  mxyr phase  dev_vector
#      5     3     1     3     2     0     0     0     0     0     0     0
#      5     4     6     3     2     0     0     0     0     0     0     0
#      5     7    11     2     2     0     0     0     0     0     0     0
#      5     8    15     2     2     0     0     0     0     0     0     0
#      5    22    19     1     2     0     0     0     0     0     0     0
#      5    23    23     1     2     0     0     0     0     0     0     0
#      5    26    27     1     2     0     0     0     0     0     0     0
#      5    27    31     1     2     0     0     0     0     0     0     0
#      5    39    35     4     2     0     0     0     0     0     0     0
#      5    41    39     4     2     0     0     0     0     0     0     0
#      5    42    43     4     2     0     0     0     0     0     0     0
     #
# Input variance adjustments factors: 
 #_1=add_to_survey_CV
 #_2=add_to_discard_stddev
 #_3=add_to_bodywt_CV
 #_4=mult_by_lencomp_N
 #_5=mult_by_agecomp_N
 #_6=mult_by_size-at-age_N
 #_7=mult_by_generalized_sizecomp
#_Factor  Fleet  Value
      4      1  0.216188
      4      2  0.366526
      4      3  0.024608
      4      4  0.985006
      4      5   2.70218
      4      6  0.125107
      4      7  0.210389
      4      8      0.89
      5      5   0.31992
      5      6   0.29841
      5      8      0.34
 -9999   1    0  # terminator
#
1 #_maxlambdaphase
1 #_sd_offset; must be 1 if any growthCV, sigmaR, or survey extraSD is an estimated parameter
# read 0 changes to default Lambdas (default value is 1.0)
# Like_comp codes:  1=surv; 2=disc; 3=mnwt; 4=length; 5=age; 6=SizeFreq; 7=sizeage; 8=catch; 9=init_equ_catch; 
# 10=recrdev; 11=parm_prior; 12=parm_dev; 13=CrashPen; 14=Morphcomp; 15=Tag-comp; 16=Tag-negbin; 17=F_ballpark; 18=initEQregime
#like_comp fleet  phase  value  sizefreq_method
-9999  1  1  1  1  #  terminator
#
# lambdas (for info only; columns are phases)
#  1 #_CPUE/survey:_1
#  0 #_CPUE/survey:_2
#  0 #_CPUE/survey:_3
#  1 #_CPUE/survey:_4
#  1 #_CPUE/survey:_5
#  1 #_CPUE/survey:_6
#  1 #_CPUE/survey:_7
#  0 #_CPUE/survey:_8
#  1 #_discard:_1
#  1 #_discard:_2
#  0 #_discard:_3
#  0 #_discard:_4
#  0 #_discard:_5
#  0 #_discard:_6
#  0 #_discard:_7
#  0 #_discard:_8
#  1 #_lencomp:_1
#  1 #_lencomp:_2
#  1 #_lencomp:_3
#  1 #_lencomp:_4
#  1 #_lencomp:_5
#  1 #_lencomp:_6
#  1 #_lencomp:_7
#  1 #_lencomp:_8
#  0 #_agecomp:_1
#  0 #_agecomp:_2
#  0 #_agecomp:_3
#  0 #_agecomp:_4
#  1 #_agecomp:_5
#  1 #_agecomp:_6
#  0 #_agecomp:_7
#  1 #_agecomp:_8
#  1 #_init_equ_catch1
#  1 #_init_equ_catch2
#  1 #_init_equ_catch3
#  1 #_init_equ_catch4
#  1 #_init_equ_catch5
#  1 #_init_equ_catch6
#  1 #_init_equ_catch7
#  1 #_init_equ_catch8
#  1 #_recruitments
#  1 #_parameter-priors
#  1 #_parameter-dev-vectors
#  1 #_crashPenLambda
#  0 # F_ballpark_lambda
0 # (0/1/2) read specs for more stddev reporting: 0 = skip, 1 = read specs for reporting stdev for selectivity, size, and numbers, 2 = add options for M and Dyn Bzero
 # 0 2 0 0 # Selectivity: (1) fleet, (2) 1=len/2=age/3=both, (3) year, (4) N selex bins
 # 0 0 # Growth: (1) growth pattern, (2) growth ages
 # 0 0 0 # Numbers-at-age: (1) area(-1 for all), (2) year, (3) N ages
 # -1 # list of bin #'s for selex std (-1 in first bin to self-generate)
 # -1 # list of ages for growth std (-1 in first bin to self-generate)
 # -1 # list of ages for NatAge std (-1 in first bin to self-generate)
999

