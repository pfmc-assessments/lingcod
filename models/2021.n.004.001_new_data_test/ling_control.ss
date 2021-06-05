#V3.30.16.02;_2020_09_21;_safe;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.2
#Stock Synthesis (SS) is a work of the U.S. Government and is not subject to copyright protection in the United States.
#Foreign copyrights may apply. See copyright.txt for more information.
#_user_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_user_info_available_at:https://vlab.ncep.noaa.gov/group/stock-synthesis
#C file created using the SS_writectl function in the R package r4ss
#C file write time: 2021-05-26 09:09:52
#_data_and_control_files: ling_data.ss // ling_control.ss
0  # 0 means do not read wtatage.ss; 1 means read and use wtatage.ss and also read and use growth parameters
1  #_N_Growth_Patterns (Growth Patterns, Morphs, Bio Patterns, GP are terms used interchangeably in SS)
1 #_N_platoons_Within_GrowthPattern 
#_Cond 1 #_Platoon_within/between_stdev_ratio (no read if N_platoons=1)
#_Cond  1 #vector_platoon_dist_(-1_in_first_val_gives_normal_approx)
#
4 # recr_dist_method for parameters:  2=main effects for GP, Area, Settle timing; 3=each Settle entity; 4=none (only when N_GP*Nsettle*pop==1)
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
5 #_Nblock_Patterns
 2 4 5 1 1 #_blocks_per_pattern 
# begin and end years of blocks
 1998 2010 2011 2016
 1998 2006 2007 2009 2010 2010 2011 2016
 1973 1982 1983 1992 1993 2002 2003 2010 2011 2016
 1999 2016
 1995 2004
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
14 #_Growth_Age_for_L2 (999 to use as Linf)
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
 0.05 0.4 0.257 -1.53 0.438 3 -7 0 0 0 0 0.5 0 0 # NatM_p_1_Fem_GP_1
# Sex: 1  BioPattern: 1  Growth
 4 60 17.5903 0 0 0 2 0 0 0 0 0.5 0 0 # L_at_Amin_Fem_GP_1
 40 130 110 0 0 0 -2 0 0 0 0 0.5 0 0 # L_at_Amax_Fem_GP_1
 0.01 0.5 0.127976 0 0 0 3 0 0 0 0 0.5 0 0 # VonBert_K_Fem_GP_1
 0.01 0.5 0.137763 0 0 0 4 0 0 0 0 0.5 0 0 # CV_young_Fem_GP_1
 0.01 0.5 0.0643729 0 0 0 4 0 0 0 0 0 0 0 # CV_old_Fem_GP_1
# Sex: 1  BioPattern: 1  WtLen
 -3 3 2.76e-06 0 0 0 -3 0 0 0 0 0.5 0 0 # Wtlen_1_Fem_GP_1
 -3 5 3.28 0 0 0 -3 0 0 0 0 0.5 0 0 # Wtlen_2_Fem_GP_1
# Sex: 1  BioPattern: 1  Maturity&Fecundity
 -3 100 56.7 0 0 0 -3 0 0 0 0 0.5 0 0 # Mat50%_Fem_GP_1
 -5 5 -0.269 0 0 0 -3 0 0 0 0 0.5 0 0 # Mat_slope_Fem_GP_1
 -3 3 1 0 0 0 -3 0 0 0 0 0.5 0 0 # Eggs/kg_inter_Fem_GP_1
 -3 3 0 0 0 0 -3 0 0 0 0 0.5 0 0 # Eggs/kg_slope_wt_Fem_GP_1
# Sex: 2  BioPattern: 1  NatMort
 0.15 0.45 0.308384 -1.532 0.438 3 7 0 0 0 0 0.5 0 0 # NatM_p_1_Mal_GP_1
# Sex: 2  BioPattern: 1  Growth
 10 60 14.574 0 0 0 2 0 0 0 0 0.5 0 0 # L_at_Amin_Mal_GP_1
 40 110 76.2737 0 0 0 2 0 0 0 0 0.5 0 0 # L_at_Amax_Mal_GP_1
 0.01 1 0.309525 0 0 0 3 0 0 0 0 0.5 0 0 # VonBert_K_Mal_GP_1
 0.01 0.5 0.152205 0 0 0 4 0 0 0 0 0.5 0 0 # CV_young_Mal_GP_1
 0.01 0.5 0.074496 0 0 0 4 0 0 0 0 0 0 0 # CV_old_Mal_GP_1
# Sex: 2  BioPattern: 1  WtLen
 -3 3 1.61e-06 0 0 0 -3 0 0 0 0 0.5 0 0 # Wtlen_1_Mal_GP_1
 -5 5 3.42 0 0 0 -3 0 0 0 0 0.5 0 0 # Wtlen_2_Mal_GP_1
# Hermaphroditism
#  Recruitment Distribution  
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
             5            15       9.55216             0             0             0          1          0          0          0          0          0          0          0 # SR_LN(R0)
           0.2             1           0.7             0             0             0         -4          0          0          0          0          0          0          0 # SR_BH_steep
             0             2          0.55             0             0             0         -3          0          0          0          0          0          0          0 # SR_sigmaR
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
 1969 #_last_yr_nobias_adj_in_MPD; begin of ramp
 1993.6 #_first_yr_fullbias_adj_in_MPD; begin of plateau
 2013.7 #_last_yr_fullbias_adj_in_MPD
 2016.4 #_end_yr_for_ramp_in_MPD (can be in forecast to shape ramp, but SS sets bias_adj to 0.0 for fcast yrs)
 0.9113 #_max_bias_adj_in_MPD (typical ~0.8; -3 sets all years to 0.0; -2 sets all non-forecast yrs w/ estimated recdevs to 1.0; -1 sets biasadj=1.0 for all yrs w/ recdevs)
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
#  1889E 1890E 1891E 1892E 1893E 1894E 1895E 1896E 1897E 1898E 1899E 1900E 1901E 1902E 1903E 1904E 1905E 1906E 1907E 1908E 1909E 1910E 1911E 1912E 1913E 1914E 1915E 1916E 1917E 1918E 1919E 1920E 1921E 1922E 1923E 1924E 1925E 1926E 1927E 1928E 1929E 1930E 1931E 1932E 1933E 1934E 1935E 1936E 1937E 1938E 1939E 1940E 1941E 1942E 1943E 1944E 1945E 1946E 1947E 1948E 1949E 1950E 1951E 1952E 1953E 1954E 1955E 1956E 1957E 1958E 1959E 1960E 1961E 1962E 1963E 1964E 1965R 1966R 1967R 1968R 1969R 1970R 1971R 1972R 1973R 1974R 1975R 1976R 1977R 1978R 1979R 1980R 1981R 1982R 1983R 1984R 1985R 1986R 1987R 1988R 1989R 1990R 1991R 1992R 1993R 1994R 1995R 1996R 1997R 1998R 1999R 2000R 2001R 2002R 2003R 2004R 2005R 2006R 2007R 2008R 2009R 2010R 2011R 2012R 2013R 2014R 2015R 2016F 2017F 2018F 2019F 2020F 2021F
#  -7.0555e-06 -8.28325e-06 -9.72561e-06 -1.14211e-05 -1.34128e-05 -1.57518e-05 -1.84968e-05 -2.17205e-05 -2.55071e-05 -2.99561e-05 -3.5187e-05 -4.13328e-05 -4.85468e-05 -5.7009e-05 -6.69326e-05 -7.85728e-05 -9.22324e-05 -0.000108255 -0.000127015 -0.000148942 -0.000174556 -0.000204462 -0.000239538 -0.000280834 -0.000329532 -0.000386958 -0.000454402 -0.000533252 -0.000625589 -0.000733593 -0.000859834 -0.00100778 -0.00118119 -0.00138376 -0.00162098 -0.00189771 -0.00222021 -0.00259411 -0.00302408 -0.00351561 -0.00407478 -0.00470384 -0.00540765 -0.00619289 -0.00705872 -0.00800197 -0.00901349 -0.0100883 -0.0112398 -0.0124957 -0.0138799 -0.0154565 -0.017281 -0.0194304 -0.0218819 -0.0246485 -0.0276727 -0.0311142 -0.0349597 -0.0394093 -0.0442463 -0.0494513 -0.0549499 -0.0609571 -0.0678661 -0.0755929 -0.083708 -0.0917908 -0.0990795 -0.1026 -0.0978791 -0.0808548 -0.0543698 -0.0111689 0.151588 0.572626 0.411033 0.0856487 0.0112706 0.0705045 0.246033 0.324644 0.146533 -0.0687726 -0.184209 -0.187044 -0.320984 -0.38851 0.0463636 1.05259 0.667343 0.45993 -0.174714 0.035506 -0.313927 -0.293032 1.11118 -0.663702 -0.273732 0.0828295 0.192404 1.13036 1.02516 0.507391 -0.27958 0.390417 -0.323056 -0.788523 -0.203432 -0.791295 0.00721262 0.375713 0.0467242 -0.465722 -0.761492 -0.48238 -0.802546 -0.574263 -0.37359 0.802711 -0.0255134 0.0255702 -0.467169 -0.431082 0.440457 -0.374184 0.316929 -0.0361998 0 0 0 0 0
# implementation error by year in forecast:  0
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
#2021 2071
# F rates by fleet
# Yr:  1889 1890 1891 1892 1893 1894 1895 1896 1897 1898 1899 1900 1901 1902 1903 1904 1905 1906 1907 1908 1909 1910 1911 1912 1913 1914 1915 1916 1917 1918 1919 1920 1921 1922 1923 1924 1925 1926 1927 1928 1929 1930 1931 1932 1933 1934 1935 1936 1937 1938 1939 1940 1941 1942 1943 1944 1945 1946 1947 1948 1949 1950 1951 1952 1953 1954 1955 1956 1957 1958 1959 1960 1961 1962 1963 1964 1965 1966 1967 1968 1969 1970 1971 1972 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021
# seas:  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
# 1_Comm_Trawl 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.000355003 0.00141264 0.000319307 0.000455524 0.00124293 0.00410044 0.00480037 0.00677838 0.00969186 0.0067079 0.0145271 0.0268076 0.0255052 0.0425546 0.0446358 0.0744055 0.0567056 0.0713741 0.0381368 0.0588703 0.0422014 0.0467229 0.0556066 0.0360481 0.0173236 0.0286388 0.0618189 0.0453587 0.0481636 0.0557649 0.0926008 0.10975 0.110078 0.0650374 0.0487551 0.078522 0.0901669 0.0995029 0.149712 0.175338 0.0953295 0.0603767 0.0666257 0.0626265 0.0957143 0.10789 0.105203 0.103906 0.098862 0.0812308 0.142938 0.156149 0.153439 0.18562 0.57261 0.585222 0.697362 0.324602 0.475478 0.521843 0.730871 0.629551 1.12842 0.687895 1.16606 0.879602 0.548849 0.580743 0.556414 0.0472705 0.044475 0.0135813 0.0109232 0.0202259 0.0138354 0.0132704 0.0153369 0.0206971 0.0151403 0.0173562 0.0151063 0.00634789 0.00871337 0.00982076 0.00870199 0.00510909 0.00388172 0.00614449 0 0 0 0 0
# 2_Comm_Fix 0.00246439 0.00255123 0.00261944 0.00359525 0.00285101 0.0028527 0.00311229 0.00374556 0.00375859 0.00161655 0.00102947 0.00130356 0.00133171 0.00136012 0.00138875 0.00166336 0.00131222 0.00134104 0.00136993 0.00101874 0.00439773 0.00443486 0.00447093 0.00450565 0.00453908 0.00457142 0.00798356 0.0116819 0.0117614 0.015519 0.00519642 0.00411053 0.00383065 0.00214537 0.00189136 0.00448788 0.00597281 0.0067693 0.00833885 0.00670017 0.0130929 0.0112228 0.00596167 0.00584008 0.00856594 0.00972068 0.00997646 0.013209 0.0119372 0.0278782 0.0177937 0.0209193 0.0194641 0.0220384 0.0161146 0.0186324 0.0115086 0.0175693 0.0103173 0.0135105 0.017103 0.010606 0.010659 0.0118698 0.00511196 0.00690024 0.0054916 0.00522302 0.00573081 0.00458768 0.00418484 0.00594389 0.00530123 0.00475573 0.0035378 0.00277556 0.00264337 0.00318313 0.00383862 0.00280512 0.00372874 0.00414247 0.00349975 0.00322293 0.00309136 0.00224714 0.00340667 0.00289441 0.00555924 0.00655015 0.00903146 0.00510661 0.00691606 0.00897485 0.00987029 0.0106396 0.0150834 0.0117631 0.0145936 0.0144008 0.0204212 0.0232727 0.0147161 0.0176351 0.0135998 0.0171779 0.00784387 0.00953468 0.0130827 0.00527456 0.00593716 0.00357864 0.00453132 0.00406171 0.00378354 0.00356733 0.00349246 0.00455614 0.00420058 0.00577902 0.00547075 0.00335815 0.00371793 0.00351446 0.00368202 0.0035629 0.00566331 0.00423214 0 0 0 0 0
# 3_Rec_WA 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.000243446 0.000279222 0.000263213 0.000254485 0.000254189 0.00025524 0.00025294 0.00025103 0.000301514 0.000176636 0.000255868 0.000231068 0.000216887 0.000306294 0.000316019 0.000289282 0.000334854 0.000642634 0.000639072 0.000833339 0.00102174 0.00101876 0.000984762 0.0012124 0.00151546 0.00274632 0.00324225 0.00259348 0.0013441 0.00116322 0.00117727 0.000768194 0.000835001 0.000595879 0.000713796 0.000924082 0.00102765 0.00105315 0.000905909 0.00067428 0.000758289 0.000843831 0.000972948 0.00131421 0.0016925 0.00143909 0.00122072 0.00122353 0.0011658 0.00160719 0 0 0 0 0
# 4_Rec_OR 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.00143181 0.00156163 0.00226655 0.00227553 0.00261953 0.00288262 0.00357791 0.00244295 0.00220971 0.00245213 0.00327093 0.0028008 0.00311883 0.00430052 0.00289712 0.00421323 0.00412375 0.00381714 0.00618468 0.00675313 0.0061952 0.00348176 0.00431748 0.00543774 0.00347276 0.00541526 0.00344614 0.00408143 0.00524474 0.00666906 0.00499001 0.00605813 0.00481283 0.00502284 0.00465638 0.00439925 0.00533393 0.00539352 0.00572209 0.00752794 0.00591902 0.00807893 0.00553886 0 0 0 0 0
# 5_Rec_CA 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
#
#_Q_setup for fleets with cpue or survey data
#_1:  fleet number
#_2:  link type: (1=simple q, 1 parm; 2=mirror simple q, 1 mirrored parm; 3=q and power, 2 parm; 4=mirror with offset, 2 parm)
#_3:  extra input for link, i.e. mirror fleet# or dev index number
#_4:  0/1 to select extra sd parameter
#_5:  0/1 for biasadj or not
#_6:  0/1 to float
#_   fleet      link link_info  extra_se   biasadj     float  #  fleetname
         1         1         0         1         0         1  #  1_Comm_Trawl
         2         1         0         1         0         1  #  2_Comm_Fix
         3         1         0         1         0         1  #  3_Rec_WA
         4         1         0         1         0         1  #  4_Rec_OR
         6         1         0         0         0         1  #  6_Surv_TRI
         7         1         0         0         0         1  #  7_Surv_WCGBTS
-9999 0 0 0 0 0
#
#_Q_parms(if_any);Qunits_are_ln(q)
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type      PHASE    env-var    use_dev   dev_mnyr   dev_mxyr     dev_PH      Block    Blk_Fxn  #  parm_name
           -15            15      -1.10386             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_1_Comm_Trawl(1)
             0             2     0.0654107             0             0             0          2          0          0          0          0          0          0          0  #  Q_extraSD_1_Comm_Trawl(1)
           -15            15      -7.64897             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_2_Comm_Fix(2)
             0             2      0.120822             0             0             0          2          0          0          0          0          0          0          0  #  Q_extraSD_2_Comm_Fix(2)
           -15            15      -9.09714             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_3_Rec_WA(3)
             0             2      0.255935             0             0             0          2          0          0          0          0          0          0          0  #  Q_extraSD_3_Rec_WA(3)
           -15            15      -11.5844             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_4_Rec_OR(4)
             0             2      0.199525             0             0             0          2          0          0          0          0          0          0          0  #  Q_extraSD_4_Rec_OR(4)
           -15            15      -1.23319             0             0             0         -1          0          0          0          0          0          5          2  #  LnQ_base_6_Surv_TRI(6)
           -15            15     -0.853236             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_7_Surv_WCGBTS(7)
# timevary Q parameters 
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type     PHASE  #  parm_name
           -15            15             0             0             0             0      -1  # LnQ_base_6_Surv_TRI(6)_BLK5repl_1995
# info on dev vectors created for Q parms are reported with other devs after tag parameter section 
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
 24 2 3 0 # 1 1_Comm_Trawl
 24 2 3 0 # 2 2_Comm_Fix
 24 0 3 0 # 3 3_Rec_WA
 24 0 0 0 # 4 4_Rec_OR
 0 0 0 0 # 5 5_Rec_CA
 24 0 0 0 # 6 6_Surv_TRI
 24 0 0 0 # 7 7_Surv_WCGBTS
 0 0 0 0 # 8 8_Surv_HookLine
 24 0 3 0 # 9 9_Research_Lam
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
 0 0 0 0 # 1 1_Comm_Trawl
 0 0 0 0 # 2 2_Comm_Fix
 0 0 0 0 # 3 3_Rec_WA
 0 0 0 0 # 4 4_Rec_OR
 0 0 0 0 # 5 5_Rec_CA
 0 0 0 0 # 6 6_Surv_TRI
 0 0 0 0 # 7 7_Surv_WCGBTS
 0 0 0 0 # 8 8_Surv_HookLine
 0 0 0 0 # 9 9_Research_Lam
#
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type      PHASE    env-var    use_dev   dev_mnyr   dev_mxyr     dev_PH      Block    Blk_Fxn  #  parm_name
# 1   1_Comm_Trawl LenSelex
            14           120       64.5899             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_peak_1_Comm_Trawl(1)
           -20             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_1_Comm_Trawl(1)
            -1            15             6             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_ascend_se_1_Comm_Trawl(1)
            -1            15            14             0             0             0         -3          0          0          0          0          0          3          2  #  Size_DblN_descend_se_1_Comm_Trawl(1)
            -5             9           -10             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_1_Comm_Trawl(1)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_1_Comm_Trawl(1)
            10           100       85.5253             0             0             0          4          0          0          0          0          0          2          2  #  Retain_L_infl_1_Comm_Trawl(1)
           0.1            12       10.3791             0             0             0          4          0          0          0          0          0          2          2  #  Retain_L_width_1_Comm_Trawl(1)
           -10            10      0.120167           -10             0             0          4          0          0          0          0          0          2          2  #  Retain_L_asymptote_logit_1_Comm_Trawl(1)
           -10            10      0.505441             0             0             0          4          0          0          0          0          0          0          0  #  Retain_L_maleoffset_1_Comm_Trawl(1)
            -1             1             0             0             0             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_infl_1_Comm_Trawl(1)
            -1             1        0.0001             0             0             0         -5          0          0          0          0          0          0          0  #  DiscMort_L_width_1_Comm_Trawl(1)
         0.001             1           0.5             0             0             0         -6          0          0          0          0          0          0          0  #  DiscMort_L_level_old_1_Comm_Trawl(1)
            -2             2             0             0             0             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_male_offset_1_Comm_Trawl(1)
           -30            15      -1.39219             0             0             0         -3          0          0          0          0          0          0          0  #  SzSel_Male_Peak_1_Comm_Trawl(1)
           -15            15      0.186783             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Ascend_1_Comm_Trawl(1)
           -15            15      -2.71055             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Descend_1_Comm_Trawl(1)
           -15            15             0             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Final_1_Comm_Trawl(1)
           -15            15             1             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Scale_1_Comm_Trawl(1)
# 2   2_Comm_Fix LenSelex
            14           100       85.4081             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_peak_2_Comm_Fix(2)
           -20            10           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_2_Comm_Fix(2)
           -10             9       6.56276             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_ascend_se_2_Comm_Fix(2)
            -1             9       5.20441             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_descend_se_2_Comm_Fix(2)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_2_Comm_Fix(2)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_2_Comm_Fix(2)
            10           100        58.613             0             0             0          4          0          0          0          0          0          0          0  #  Retain_L_infl_2_Comm_Fix(2)
           0.1            10        6.6371             0             0             0          5          0          0          0          0          0          1          2  #  Retain_L_width_2_Comm_Fix(2)
           -10            10       6.25695           -10             0             0          5          0          0          0          0          0          1          2  #  Retain_L_asymptote_logit_2_Comm_Fix(2)
            -2             6          -1.3             0             0             0         -4          0          0          0          0          0          0          0  #  Retain_L_maleoffset_2_Comm_Fix(2)
            -1             1             0             0             0             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_infl_2_Comm_Fix(2)
            -1             1        0.0001             0             0             0         -5          0          0          0          0          0          0          0  #  DiscMort_L_width_2_Comm_Fix(2)
         0.001             1          0.07             0             0             0         -6          0          0          0          0          0          0          0  #  DiscMort_L_level_old_2_Comm_Fix(2)
            -2             2             0             0             0             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_male_offset_2_Comm_Fix(2)
           -30            20           -28             0             0             0         -3          0          0          0          0          0          0          0  #  SzSel_Male_Peak_2_Comm_Fix(2)
           -15            15      -1.43878             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Ascend_2_Comm_Fix(2)
           -15            15       1.80404             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Descend_2_Comm_Fix(2)
           -15            15             0             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Final_2_Comm_Fix(2)
           -15            15             1             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Scale_2_Comm_Fix(2)
# 3   3_Rec_WA LenSelex
            35           100       71.9851             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_peak_3_Rec_WA(3)
           -20            10           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_3_Rec_WA(3)
            -1             9       4.86157             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_ascend_se_3_Rec_WA(3)
            -1             9        6.2514             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_descend_se_3_Rec_WA(3)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_3_Rec_WA(3)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_3_Rec_WA(3)
           -15            15      -8.19349             0             0             0          3          0          0          0          0          0          0          0  #  SzSel_Male_Peak_3_Rec_WA(3)
           -15            15     -0.448462             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Ascend_3_Rec_WA(3)
           -15            15     -0.145975             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Descend_3_Rec_WA(3)
           -15            15             0             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Final_3_Rec_WA(3)
           -15            15             1             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Scale_3_Rec_WA(3)
# 4   4_Rec_OR LenSelex
            35           100       58.6144             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_peak_4_Rec_OR(4)
           -20             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_4_Rec_OR(4)
            -4             9       4.66295             0             0             0          3          0          0          0          0          0          4          2  #  Size_DblN_ascend_se_4_Rec_OR(4)
            -1             9       7.88185             0             0             0          3          0          0          0          0          0          4          2  #  Size_DblN_descend_se_4_Rec_OR(4)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_4_Rec_OR(4)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_4_Rec_OR(4)
# 5   5_Rec_CA LenSelex
# 6   6_Surv_TRI LenSelex
            14           120       92.4878             0             0             0          3          0          0          0          0        0.5          5          2  #  Size_DblN_peak_6_Surv_TRI(6)
           -20             4           -15             0             0             0         -3          0          0          0          0          0          5          2  #  Size_DblN_top_logit_6_Surv_TRI(6)
            -1             9       6.98137             0             0             0          3          0          0          0          0          0          5          2  #  Size_DblN_ascend_se_6_Surv_TRI(6)
            -1             9             6             0             0             0         -2          0          0          0          0          0          5          2  #  Size_DblN_descend_se_6_Surv_TRI(6)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          5          2  #  Size_DblN_start_logit_6_Surv_TRI(6)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          5          2  #  Size_DblN_end_logit_6_Surv_TRI(6)
# 7   7_Surv_WCGBTS LenSelex
            35           120       59.5966             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_peak_7_Surv_WCGBTS(7)
           -20             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_7_Surv_WCGBTS(7)
            -1             9       6.38323             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_ascend_se_7_Surv_WCGBTS(7)
            -1             9       7.12013             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_descend_se_7_Surv_WCGBTS(7)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_7_Surv_WCGBTS(7)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_7_Surv_WCGBTS(7)
# 8   8_Surv_HookLine LenSelex
# 9   9_Research_Lam LenSelex
            35           100       82.4299             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_peak_9_Research_Lam(9)
           -20             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_9_Research_Lam(9)
            -1             9       5.83501             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_ascend_se_9_Research_Lam(9)
            -1             9       5.50045             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_descend_se_9_Research_Lam(9)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_9_Research_Lam(9)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_9_Research_Lam(9)
           -30            40      -19.1497             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Peak_9_Research_Lam(9)
           -15            15      -1.02173             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Ascend_9_Research_Lam(9)
           -15            15      -1.40582             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Descend_9_Research_Lam(9)
           -15            15             0             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Final_9_Research_Lam(9)
           -15            15             1             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Scale_9_Research_Lam(9)
# 1   1_Comm_Trawl AgeSelex
# 2   2_Comm_Fix AgeSelex
# 3   3_Rec_WA AgeSelex
# 4   4_Rec_OR AgeSelex
# 5   5_Rec_CA AgeSelex
# 6   6_Surv_TRI AgeSelex
# 7   7_Surv_WCGBTS AgeSelex
# 8   8_Surv_HookLine AgeSelex
# 9   9_Research_Lam AgeSelex
# timevary selex parameters 
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type    PHASE  #  parm_name
            -1            15            10             0             0             0      -5  # Size_DblN_descend_se_1_Comm_Trawl(1)_BLK3repl_1973
            -1            15        6.8211             0             0             0      5  # Size_DblN_descend_se_1_Comm_Trawl(1)_BLK3repl_1983
            -1            15       6.24202             0             0             0      5  # Size_DblN_descend_se_1_Comm_Trawl(1)_BLK3repl_1993
            -1            15       6.30378             0             0             0      5  # Size_DblN_descend_se_1_Comm_Trawl(1)_BLK3repl_2003
            -1            15        8.2584             0             0             0      5  # Size_DblN_descend_se_1_Comm_Trawl(1)_BLK3repl_2011
            10           100       82.1147             0             0             0      5  # Retain_L_infl_1_Comm_Trawl(1)_BLK2repl_1998
            10           100       72.8712             0             0             0      5  # Retain_L_infl_1_Comm_Trawl(1)_BLK2repl_2007
            10           100        60.134             0             0             0      5  # Retain_L_infl_1_Comm_Trawl(1)_BLK2repl_2010
            10           100       55.2443             0             0             0      5  # Retain_L_infl_1_Comm_Trawl(1)_BLK2repl_2011
           0.1            12       7.58008             0             0             0      -5  # Retain_L_width_1_Comm_Trawl(1)_BLK2repl_1998
           0.1            12       5.14523             0             0             0      5  # Retain_L_width_1_Comm_Trawl(1)_BLK2repl_2007
           0.1            12       4.24535             0             0             0      5  # Retain_L_width_1_Comm_Trawl(1)_BLK2repl_2010
           0.1            12       2.21368             0             0             0      5  # Retain_L_width_1_Comm_Trawl(1)_BLK2repl_2011
         0.001            12             7             0             0             0      -5  # Retain_L_asymptote_logit_1_Comm_Trawl(1)_BLK2repl_1998
         0.001            12        1.6369             0             0             0      5  # Retain_L_asymptote_logit_1_Comm_Trawl(1)_BLK2repl_2007
         0.001            12       9.91066             0             0             0      5  # Retain_L_asymptote_logit_1_Comm_Trawl(1)_BLK2repl_2010
         0.001            12       11.4487             0             0             0      5  # Retain_L_asymptote_logit_1_Comm_Trawl(1)_BLK2repl_2011
           0.1            10       1.65384             0             0             0      5  # Retain_L_width_2_Comm_Fix(2)_BLK1repl_1998
           0.1            10       1.43414             0             0             0      5  # Retain_L_width_2_Comm_Fix(2)_BLK1repl_2011
         0.001             6      0.648244             0             0             0      5  # Retain_L_asymptote_logit_2_Comm_Fix(2)_BLK1repl_1998
         0.001             6      0.777026             0             0             0      5  # Retain_L_asymptote_logit_2_Comm_Fix(2)_BLK1repl_2011
            -4             9        2.0681             0             0             0      5  # Size_DblN_ascend_se_4_Rec_OR(4)_BLK4repl_1999
            -1             9       6.74297             0             0             0      5  # Size_DblN_descend_se_4_Rec_OR(4)_BLK4repl_1999
            14           110       53.9476             0             0             0      3  # Size_DblN_peak_6_Surv_TRI(6)_BLK5repl_1995
           -20             4           -15             0             0             0      -3  # Size_DblN_top_logit_6_Surv_TRI(6)_BLK5repl_1995
            -1             9       5.98626             0             0             0      3  # Size_DblN_ascend_se_6_Surv_TRI(6)_BLK5repl_1995
            -1            15             8             0             0             0      -2  # Size_DblN_descend_se_6_Surv_TRI(6)_BLK5repl_1995
            -5             9          -999             0             0             0      -2  # Size_DblN_start_logit_6_Surv_TRI(6)_BLK5repl_1995
            -5             9          -999             0             0             0      -3  # Size_DblN_end_logit_6_Surv_TRI(6)_BLK5repl_1995
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
#      3     9     1     5     2     0     0     0     0     0     0     0
#      5     4     2     3     2     0     0     0     0     0     0     0
#      5     7     7     2     2     0     0     0     0     0     0     0
#      5     8    11     2     2     0     0     0     0     0     0     0
#      5     9    15     2     2     0     0     0     0     0     0     0
#      5    27    19     1     2     0     0     0     0     0     0     0
#      5    28    21     1     2     0     0     0     0     0     0     0
#      5    52    23     4     2     0     0     0     0     0     0     0
#      5    53    24     4     2     0     0     0     0     0     0     0
#      5    56    25     5     2     0     0     0     0     0     0     0
#      5    57    26     5     2     0     0     0     0     0     0     0
#      5    58    27     5     2     0     0     0     0     0     0     0
#      5    59    28     5     2     0     0     0     0     0     0     0
#      5    60    29     5     2     0     0     0     0     0     0     0
#      5    61    30     5     2     0     0     0     0     0     0     0
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
      4      1  0.186872
      4      2  0.212219
      4      3  0.161761
      4      4 0.0171895
      4      6  0.839522
      4      7  0.222312
      4      9      0.23
      5      6  0.305228
      5      7  0.223224
      5      9      0.18
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
#  1 #_CPUE/survey:_2
#  1 #_CPUE/survey:_3
#  1 #_CPUE/survey:_4
#  0 #_CPUE/survey:_5
#  1 #_CPUE/survey:_6
#  1 #_CPUE/survey:_7
#  0 #_CPUE/survey:_8
#  0 #_CPUE/survey:_9
#  1 #_discard:_1
#  1 #_discard:_2
#  0 #_discard:_3
#  0 #_discard:_4
#  0 #_discard:_5
#  0 #_discard:_6
#  0 #_discard:_7
#  0 #_discard:_8
#  0 #_discard:_9
#  1 #_lencomp:_1
#  1 #_lencomp:_2
#  1 #_lencomp:_3
#  1 #_lencomp:_4
#  0 #_lencomp:_5
#  1 #_lencomp:_6
#  1 #_lencomp:_7
#  0 #_lencomp:_8
#  1 #_lencomp:_9
#  0 #_agecomp:_1
#  0 #_agecomp:_2
#  0 #_agecomp:_3
#  0 #_agecomp:_4
#  0 #_agecomp:_5
#  1 #_agecomp:_6
#  1 #_agecomp:_7
#  0 #_agecomp:_8
#  1 #_agecomp:_9
#  1 #_init_equ_catch1
#  1 #_init_equ_catch2
#  1 #_init_equ_catch3
#  1 #_init_equ_catch4
#  1 #_init_equ_catch5
#  1 #_init_equ_catch6
#  1 #_init_equ_catch7
#  1 #_init_equ_catch8
#  1 #_init_equ_catch9
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
