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
 10 60 17.9847 0 0 0 2 0 0 0 0 0 0 0 # L_at_Amin_Fem_GP_1
 40 130 93.3387 0 0 0 2 0 0 0 0 0 0 0 # L_at_Amax_Fem_GP_1
 0.01 0.5 0.130257 0 0 0 3 0 0 0 0 0 0 0 # VonBert_K_Fem_GP_1
 0.01 0.5 0.150804 0 0 0 4 0 0 0 0 0 0 0 # CV_young_Fem_GP_1
 0.01 0.5 0.0704482 0 0 0 4 0 0 0 0 0 0 0 # CV_old_Fem_GP_1
# Sex: 1  BioPattern: 1  WtLen
 -3 3 3.308e-06 0 0 0 -3 0 0 0 0 0 0 0 # Wtlen_1_Fem_GP_1
 -3 5 3.248 0 0 0 -3 0 0 0 0 0 0 0 # Wtlen_2_Fem_GP_1
# Sex: 1  BioPattern: 1  Maturity&Fecundity
 -3 100 52.3 0 0 0 -3 0 0 0 0 0 0 0 # Mat50%_Fem_GP_1
 -5 5 -0.219 0 0 0 -3 0 0 0 0 0 0 0 # Mat_slope_Fem_GP_1
 -3 3 1 0 0 0 -3 0 0 0 0 0 0 0 # Eggs/kg_inter_Fem_GP_1
 -3 3 0 0 0 0 -3 0 0 0 0 0 0 0 # Eggs/kg_slope_wt_Fem_GP_1
# Sex: 2  BioPattern: 1  NatMort
 0.15 0.4 0.322736 -1.532 0.438 3 7 0 0 0 0 0 0 0 # NatM_p_1_Mal_GP_1
# Sex: 2  BioPattern: 1  Growth
 10 60 18.1021 0 0 0 2 0 0 0 0 0 0 0 # L_at_Amin_Mal_GP_1
 40 110 82.8113 0 0 0 2 0 0 0 0 0 0 0 # L_at_Amax_Mal_GP_1
 0.01 1 0.166267 0 0 0 3 0 0 0 0 0 0 0 # VonBert_K_Mal_GP_1
 0.01 0.5 0.136972 0 0 0 4 0 0 0 0 0 0 0 # CV_young_Mal_GP_1
 0.01 0.5 0.087085 0 0 0 4 0 0 0 0 0 0 0 # CV_old_Mal_GP_1
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
             5            15       8.41406             0             0             0          1          0          0          0          0          0          0          0 # SR_LN(R0)
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
#  2.3427e-05 2.74344e-05 3.20991e-05 3.75223e-05 4.38198e-05 5.11243e-05 5.95868e-05 6.93794e-05 8.06979e-05 9.37645e-05 0.000108831 0.000126182 0.000146137 0.000169055 0.000195335 0.000225422 0.000259807 0.000299038 0.000343723 0.000394574 0.000452329 0.00051791 0.000592255 0.000676428 0.000771488 0.000878629 0.000999169 0.00113462 0.0012867 0.00145716 0.00164752 0.00185967 0.00209615 0.00235965 0.00265243 0.00297737 0.00333935 0.00374339 0.00419786 0.00471208 0.00529453 0.00595863 0.00672308 0.00759109 0.0085991 0.00974021 0.0110851 0.0126375 0.0144023 0.0163572 0.0184485 0.0206522 0.0229078 0.0251466 0.0274262 0.029931 0.0331973 0.0381216 0.046403 0.0604829 0.0830571 0.112574 0.136907 0.137442 0.100739 0.0459291 0.0195647 -0.0553127 -0.311601 -0.299172 0.0126628 0.233575 0.375344 -0.165673 -0.0945762 -0.069297 -0.0952383 0.0684388 0.147292 0.170765 0.0207939 0.00335581 -0.11291 0.129146 0.548411 0.547748 0.250963 0.827458 0.664381 -0.200878 0.798991 -0.11795 -0.396258 -0.423334 0.1738 1.40103 1.12559 0.668787 0.607498 -0.0128726 0.457681 -0.0357866 0.785208 -0.779722 -0.148456 0.384093 -0.576032 0.475541 -0.483004 -0.689202 0.929807 0.335215 0.0527192 -0.676031 -0.483472 -1.43852 -1.5435 -1.87574 -1.34415 -0.478737 -0.354281 0.349831 0.204923 0.362824 0.59462 -0.326714 -0.494121 -0.880744 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
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
# 1_CA_TRAWL 0 0.000571727 0.00114486 0.00172074 0.00230061 0.00288556 0.00347655 0.00407439 0.00467978 0.00529327 0.00591545 0.00654676 0.00718761 0.0078384 0.00849949 0.00917119 0.00985396 0.0105481 0.011254 0.011972 0.0127024 0.0134457 0.0142023 0.0149726 0.015757 0.0165559 0.01737 0.0181996 0.0190452 0.0199075 0.020787 0.0216843 0.0226 0.0235348 0.0244894 0.0254645 0.0264608 0.0274792 0.0285205 0.0295856 0.0306771 0.0317988 0.0329521 0.0237939 0.0376482 0.0234773 0.0276902 0.0204617 0.0261376 0.0200407 0.0153483 0.0181876 0.0137249 0.00799614 0.0180412 0.0185584 0.0173056 0.0286032 0.0493224 0.0536814 0.0433146 0.0527462 0.0515062 0.0406192 0.0411278 0.0412289 0.0289018 0.038648 0.0490336 0.045877 0.0413874 0.0404633 0.0433877 0.0341655 0.0369502 0.0267408 0.0252547 0.0246198 0.0289661 0.0342158 0.0382156 0.053503 0.0721462 0.123017 0.155041 0.193029 0.195848 0.219091 0.130893 0.138744 0.220357 0.213472 0.196463 0.235377 0.356713 0.417061 0.377171 0.259601 0.352885 0.334112 0.359337 0.377476 0.370793 0.315309 0.385555 0.309982 0.264249 0.253522 0.316284 0.127453 0.122003 0.0381569 0.0276368 0.0342846 0.0120287 0.0126999 0.0127915 0.0156355 0.0323138 0.0292744 0.0329739 0.0212062 0.00313829 0.00738869 0.00910157 0.0112377 0.0108114 0.00872827 0.0249727 0.0415084 0.0494687 0.0521162 0.0670181 0.0686806 0.0700675 0.071085 0.0717621 0.0721565 0.0725031 0.0727514 0.0729139 0.0729212 0.0732828 0.0735812
# 2_CA_FIX 0 0.000514822 0.00103094 0.0015495 0.00207147 0.00259758 0.00312836 0.00366422 0.00420542 0.00475222 0.00530483 0.00586345 0.0064283 0.00699953 0.00757738 0.00816213 0.00875386 0.00935286 0.00995939 0.0105736 0.0111957 0.011826 0.0124647 0.0131121 0.0137683 0.0144338 0.0151088 0.0157935 0.0164883 0.0171935 0.0179094 0.0186364 0.0193748 0.0201251 0.0208876 0.0216626 0.0224508 0.0232523 0.0240679 0.0248979 0.0257445 0.0266108 0.0274974 0.0194003 0.0357642 0.0170475 0.0215411 0.0188756 0.020336 0.025951 0.0134117 0.0161278 0.014078 0.00706019 0.0157622 0.0153956 0.0157761 0.0253671 0.0520987 0.0340337 0.0291579 0.023003 0.0116301 0.0505223 0.0351909 0.0348152 0.0062846 0.0328305 0.0117649 0.0126648 0.010787 0.00622711 0.0124204 0.00962701 0.0113543 0.00643548 0.00633968 0.00601073 0.00570835 0.00484583 0.00659363 0.00645962 0.0126863 0.0219035 0.0190527 0.0307686 0.0398724 0.0247033 0.014592 0.0213426 0.014883 0.0141419 0.0143302 0.01234 0.0092502 0.00864512 0.0220226 0.0489505 0.0467801 0.0509853 0.0983277 0.0828431 0.0621891 0.0769353 0.0732878 0.0622616 0.0789353 0.0836002 0.0849761 0.0413838 0.0311648 0.0114855 0.0148804 0.0217503 0.0219039 0.0219198 0.0164817 0.0136976 0.013984 0.0149718 0.0119041 0.0135231 0.0173627 0.0225972 0.0269526 0.0367269 0.044253 0.0254428 0.0233555 0.0199027 0.0205598 0.0226042 0.0202005 0.0207016 0.0211197 0.0214264 0.0216304 0.0217493 0.0218538 0.0219286 0.0219776 0.0219798 0.0220888 0.0221788
# 3_CA_REC 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.000193464 0.000390424 0.000589914 0.000788383 0.000990484 0.00119364 0.0013842 0.00157354 0.00242345 0.00292607 0.00400863 0.00416523 0.00381084 0.00199107 0.00187898 0.00153592 0.00204038 0.00352843 0.0132241 0.0150864 0.0169404 0.0154997 0.0161714 0.0115751 0.00853844 0.0136273 0.0142991 0.019266 0.0225523 0.0253386 0.0201028 0.0173608 0.0178928 0.0179172 0.0176528 0.016362 0.022952 0.0318764 0.0342885 0.0340002 0.0269694 0.0418345 0.0499286 0.0651742 0.0728043 0.086242 0.123872 0.14283 0.102134 0.126339 0.132889 0.193011 0.181859 0.147774 0.105585 0.106108 0.261132 0.309086 0.283062 0.255897 0.231136 0.235727 0.298899 0.364584 0.246925 0.146554 0.144724 0.218737 0.187593 0.17341 0.212005 0.116337 0.101655 0.241413 0.364027 0.058756 0.114853 0.102005 0.0699412 0.0472544 0.0741537 0.0741365 0.167653 0.173345 0.19792 0.192981 0.198245 0.150924 0.131897 0.104196 0.148009 0.16936 0.150197 0.153923 0.157031 0.159311 0.160829 0.161713 0.162489 0.163046 0.16341 0.163426 0.164237 0.164906
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
           -15            15      -1.55534             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_1_CA_TRAWL(1)
         0.001             2     0.0429328             0             0             0          2          0          0          0          0          0          0          0  #  Q_extraSD_1_CA_TRAWL(1)
           -15            15      -0.10008             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_4_CA_TRI_Early(4)
           -15            15      0.391871             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_5_CA_TRI_Late(5)
           -15            15      0.337655             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_6_CA_NWFSC(6)
           -15            15      -11.2852             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_7_CA_HookLine(7)
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
            14           100       60.3836             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_peak_1_CA_TRAWL(1)
            -6             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_1_CA_TRAWL(1)
            -5            15             7             0             0             0         -3          0          0          0          0          0          3          2  #  Size_DblN_ascend_se_1_CA_TRAWL(1)
            -5            15       13.1857             0             0             0          3          0          0          0          0          0          3          2  #  Size_DblN_descend_se_1_CA_TRAWL(1)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_1_CA_TRAWL(1)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_1_CA_TRAWL(1)
            10           100       60.7898             0             0             0          4          0          0          0          0          0          2          2  #  Retain_L_infl_1_CA_TRAWL(1)
           0.1            15             9             0             0             0         -4          0          0          0          0          0          2          2  #  Retain_L_width_1_CA_TRAWL(1)
           -10            10            10           -10             0             0         -4          0          0          0          0          0          0          0  #  Retain_L_asymptote_logit_1_CA_TRAWL(1)
            -2             2             0             0             0             0         -4          0          0          0          0          0          0          0  #  Retain_L_maleoffset_1_CA_TRAWL(1)
            -1             1             0             0             0             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_infl_1_CA_TRAWL(1)
            -1             1        0.0001             0             0             0         -5          0          0          0          0          0          0          0  #  DiscMort_L_width_1_CA_TRAWL(1)
         0.001             1           0.5             0             0             0         -6          0          0          0          0          0          0          0  #  DiscMort_L_level_old_1_CA_TRAWL(1)
            -2             2             0             0             0             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_male_offset_1_CA_TRAWL(1)
           -30            15      -5.93727             0             0             0          3          0          0          0          0          0          0          0  #  SzSel_Male_Peak_1_CA_TRAWL(1)
           -15            15       2.84655             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Ascend_1_CA_TRAWL(1)
           -15            15     -0.853305             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Descend_1_CA_TRAWL(1)
           -15            15             0             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Final_1_CA_TRAWL(1)
           -15            15             1             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Scale_1_CA_TRAWL(1)
# 2   2_CA_FIX LenSelex
            14           100       85.1152             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_peak_2_CA_FIX(2)
            -6             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_2_CA_FIX(2)
            -5            15        7.4932             0             0             0          3          0          0          0          0          0          1          2  #  Size_DblN_ascend_se_2_CA_FIX(2)
            -5            15        5.5395             0             0             0          3          0          0          0          0          0          1          2  #  Size_DblN_descend_se_2_CA_FIX(2)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_2_CA_FIX(2)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_2_CA_FIX(2)
            10           100       51.8365             0             0             0          4          0          0          0          0          0          1          2  #  Retain_L_infl_2_CA_FIX(2)
           0.1            10       2.41183             0             0             0          4          0          0          0          0          0          1          2  #  Retain_L_width_2_CA_FIX(2)
           -10            10            10           -10             0             0         -4          0          0          0          0          0          0          0  #  Retain_L_asymptote_logit_2_CA_FIX(2)
            -2             2             0             0             0             0         -6          0          0          0          0          0          0          0  #  Retain_L_maleoffset_2_CA_FIX(2)
            -1             1             0             0             0             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_infl_2_CA_FIX(2)
            -1             1        0.0001             0             0             0         -5          0          0          0          0          0          0          0  #  DiscMort_L_width_2_CA_FIX(2)
         0.001             1          0.07             0             0             0         -6          0          0          0          0          0          0          0  #  DiscMort_L_level_old_2_CA_FIX(2)
            -2             2             0             0             0             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_male_offset_2_CA_FIX(2)
           -30            20           -22             0             0             0         -3          0          0          0          0          0          0          0  #  SzSel_Male_Peak_2_CA_FIX(2)
           -15            15      -1.50834             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Ascend_2_CA_FIX(2)
           -15            15      0.539577             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Descend_2_CA_FIX(2)
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
            10           100       38.7612             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_peak_4_CA_TRI_Early(4)
            -6             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_4_CA_TRI_Early(4)
            -1            15       5.40342             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_ascend_se_4_CA_TRI_Early(4)
            -1            15       14.3218             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_descend_se_4_CA_TRI_Early(4)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_4_CA_TRI_Early(4)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_4_CA_TRI_Early(4)
# 5   5_CA_TRI_Late LenSelex
            14            70       23.1583             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_peak_5_CA_TRI_Late(5)
            -6             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_5_CA_TRI_Late(5)
            -5            15      -3.96837             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_ascend_se_5_CA_TRI_Late(5)
            -1            15       10.5966             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_descend_se_5_CA_TRI_Late(5)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_5_CA_TRI_Late(5)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_5_CA_TRI_Late(5)
# 6   6_CA_NWFSC LenSelex
             5            30       26.4861             0             0             0          2          0          0          0          0          0          0          0  #  Size_DblN_peak_6_CA_NWFSC(6)
           -12             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_6_CA_NWFSC(6)
            -1            15       4.71764             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_ascend_se_6_CA_NWFSC(6)
            -1            15       8.06675             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_descend_se_6_CA_NWFSC(6)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_6_CA_NWFSC(6)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_6_CA_NWFSC(6)
# 7   7_CA_HookLine LenSelex
            35           100       67.5432             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_peak_7_CA_HookLine(7)
            -6             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_7_CA_HookLine(7)
            -6            15       5.53033             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_ascend_se_7_CA_HookLine(7)
            -6            15       6.67486             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_descend_se_7_CA_HookLine(7)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_7_CA_HookLine(7)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_7_CA_HookLine(7)
           -30            40       7.36059             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Peak_7_CA_HookLine(7)
           -15            15       1.07607             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Ascend_7_CA_HookLine(7)
           -15            15      -12.9005             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Descend_7_CA_HookLine(7)
           -15            15             0             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Final_7_CA_HookLine(7)
           -15            15             1             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Scale_7_CA_HookLine(7)
# 8   8_CA_Lam_Research LenSelex
            35           100       91.0768             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_peak_8_CA_Lam_Research(8)
            -6             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_8_CA_Lam_Research(8)
            -6            15       6.54197             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_ascend_se_8_CA_Lam_Research(8)
            -6            15          -5.6             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_descend_se_8_CA_Lam_Research(8)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_8_CA_Lam_Research(8)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_8_CA_Lam_Research(8)
           -30            40      -27.4041             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Peak_8_CA_Lam_Research(8)
           -15            15      -1.20012             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Ascend_8_CA_Lam_Research(8)
           -15            15        9.6828             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Descend_8_CA_Lam_Research(8)
           -15            15             0             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Final_8_CA_Lam_Research(8)
           -15            15             1             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Scale_8_CA_Lam_Research(8)
# 1   1_CA_TRAWL AgeSelex
             0             1             0           0.1            -1             0        -99          0          0          0          0        0.5          0          0  #  minage@sel=1_1_CA_TRAWL(1)
             0           101            25           100            -1             0        -99          0          0          0          0        0.5          0          0  #  maxage@sel=1_1_CA_TRAWL(1)
# 2   2_CA_FIX AgeSelex
             0             1             0           0.1            -1             0        -99          0          0          0          0        0.5          0          0  #  minage@sel=1_2_CA_FIX(2)
             0           101            25           100            -1             0        -99          0          0          0          0        0.5          0          0  #  maxage@sel=1_2_CA_FIX(2)
# 3   3_CA_REC AgeSelex
             0             1             0           0.1            -1             0        -99          0          0          0          0        0.5          0          0  #  minage@sel=1_3_CA_REC(3)
             0           101            25           100            -1             0        -99          0          0          0          0        0.5          0          0  #  maxage@sel=1_3_CA_REC(3)
# 4   4_CA_TRI_Early AgeSelex
             0             1             0           0.1            -1             0        -99          0          0          0          0        0.5          0          0  #  minage@sel=1_4_CA_TRI_Early(4)
             0           101            25           100            -1             0        -99          0          0          0          0        0.5          0          0  #  maxage@sel=1_4_CA_TRI_Early(4)
# 5   5_CA_TRI_Late AgeSelex
             0             1             0           0.1            -1             0        -99          0          0          0          0        0.5          0          0  #  minage@sel=1_5_CA_TRI_Late(5)
             0           101            25           100            -1             0        -99          0          0          0          0        0.5          0          0  #  maxage@sel=1_5_CA_TRI_Late(5)
# 6   6_CA_NWFSC AgeSelex
             0             1             0           0.1            -1             0        -99          0          0          0          0        0.5          0          0  #  minage@sel=1_6_CA_NWFSC(6)
             0           101            25           100            -1             0        -99          0          0          0          0        0.5          0          0  #  maxage@sel=1_6_CA_NWFSC(6)
# 7   7_CA_HookLine AgeSelex
             0             1             0           0.1            -1             0        -99          0          0          0          0        0.5          0          0  #  minage@sel=1_7_CA_HookLine(7)
             0           101            25           100            -1             0        -99          0          0          0          0        0.5          0          0  #  maxage@sel=1_7_CA_HookLine(7)
# 8   8_CA_Lam_Research AgeSelex
             0             1             0           0.1            -1             0        -99          0          0          0          0        0.5          0          0  #  minage@sel=1_8_CA_Lam_Research(8)
             0           101            25           100            -1             0        -99          0          0          0          0        0.5          0          0  #  maxage@sel=1_8_CA_Lam_Research(8)
# timevary selex parameters 
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type    PHASE  #  parm_name
            -5            15             7             0             0             0      -4  # Size_DblN_ascend_se_1_CA_TRAWL(1)_BLK3repl_1973
            -5            15       7.50068             0             0             0      4  # Size_DblN_ascend_se_1_CA_TRAWL(1)_BLK3repl_1983
            -5            15       7.24684             0             0             0      4  # Size_DblN_ascend_se_1_CA_TRAWL(1)_BLK3repl_1993
            -5            15       3.53659             0             0             0      4  # Size_DblN_ascend_se_1_CA_TRAWL(1)_BLK3repl_2003
            -5            15       3.14724             0             0             0      4  # Size_DblN_ascend_se_1_CA_TRAWL(1)_BLK3repl_2011
            -5            15       14.3159             0             0             0      4  # Size_DblN_descend_se_1_CA_TRAWL(1)_BLK3repl_1973
            -5            15       6.11563             0             0             0      4  # Size_DblN_descend_se_1_CA_TRAWL(1)_BLK3repl_1983
            -5            15       6.60448             0             0             0      4  # Size_DblN_descend_se_1_CA_TRAWL(1)_BLK3repl_1993
            -5            15       6.30845             0             0             0      4  # Size_DblN_descend_se_1_CA_TRAWL(1)_BLK3repl_2003
            -5            15       7.44585             0             0             0      4  # Size_DblN_descend_se_1_CA_TRAWL(1)_BLK3repl_2011
            10           100       67.9738             0             0             0      4  # Retain_L_infl_1_CA_TRAWL(1)_BLK2repl_1998
            10           100       69.7485             0             0             0      4  # Retain_L_infl_1_CA_TRAWL(1)_BLK2repl_2007
            10           100        59.431             0             0             0      4  # Retain_L_infl_1_CA_TRAWL(1)_BLK2repl_2010
            10           100       57.8361             0             0             0      4  # Retain_L_infl_1_CA_TRAWL(1)_BLK2repl_2011
           0.1            10           3.5             0             0             0      -4  # Retain_L_width_1_CA_TRAWL(1)_BLK2repl_1998
           0.1            10       4.30403             0             0             0      4  # Retain_L_width_1_CA_TRAWL(1)_BLK2repl_2007
           0.1            10      0.253134             0             0             0      4  # Retain_L_width_1_CA_TRAWL(1)_BLK2repl_2010
           0.1            10       1.74205             0             0             0      4  # Retain_L_width_1_CA_TRAWL(1)_BLK2repl_2011
            -5            15           8.1             0             0             0      -4  # Size_DblN_ascend_se_2_CA_FIX(2)_BLK1repl_1998
            -5            15       5.38377             0             0             0      4  # Size_DblN_ascend_se_2_CA_FIX(2)_BLK1repl_2002
            -5            15       6.68519             0             0             0      4  # Size_DblN_ascend_se_2_CA_FIX(2)_BLK1repl_2003
            -5            15       6.32231             0             0             0      4  # Size_DblN_ascend_se_2_CA_FIX(2)_BLK1repl_2011
            -5            15           6.4             0             0             0      -4  # Size_DblN_descend_se_2_CA_FIX(2)_BLK1repl_1998
            -5            15       6.35221             0             0             0      4  # Size_DblN_descend_se_2_CA_FIX(2)_BLK1repl_2002
            -5            15       4.75916             0             0             0      4  # Size_DblN_descend_se_2_CA_FIX(2)_BLK1repl_2003
            -5            15       4.62125             0             0             0      4  # Size_DblN_descend_se_2_CA_FIX(2)_BLK1repl_2011
            10           100        61.519             0             0             0      4  # Retain_L_infl_2_CA_FIX(2)_BLK1repl_1998
            10           100        58.911             0             0             0      4  # Retain_L_infl_2_CA_FIX(2)_BLK1repl_2002
            10           100       65.7382             0             0             0      4  # Retain_L_infl_2_CA_FIX(2)_BLK1repl_2003
            10           100       62.4275             0             0             0      4  # Retain_L_infl_2_CA_FIX(2)_BLK1repl_2011
           0.1            10       2.50388             0             0             0      4  # Retain_L_width_2_CA_FIX(2)_BLK1repl_1998
           0.1            10      0.367921             0             0             0      4  # Retain_L_width_2_CA_FIX(2)_BLK1repl_2002
           0.1            10       9.99978             0             0             0      4  # Retain_L_width_2_CA_FIX(2)_BLK1repl_2003
           0.1            10       6.99634             0             0             0      4  # Retain_L_width_2_CA_FIX(2)_BLK1repl_2011
            20           100       68.4207             0             0             0      4  # Size_DblN_peak_3_CA_REC(3)_BLK4repl_1959
            20           100        70.152             0             0             0      4  # Size_DblN_peak_3_CA_REC(3)_BLK4repl_1975
            20           100       62.9778             0             0             0      4  # Size_DblN_peak_3_CA_REC(3)_BLK4repl_1990
            20           100        62.829             0             0             0      4  # Size_DblN_peak_3_CA_REC(3)_BLK4repl_2004
            -1            15       5.82041             0             0             0      4  # Size_DblN_ascend_se_3_CA_REC(3)_BLK4repl_1959
            -1            15       5.61183             0             0             0      4  # Size_DblN_ascend_se_3_CA_REC(3)_BLK4repl_1975
            -1            15       3.98715             0             0             0      4  # Size_DblN_ascend_se_3_CA_REC(3)_BLK4repl_1990
            -1            15       3.96507             0             0             0      4  # Size_DblN_ascend_se_3_CA_REC(3)_BLK4repl_2004
            -1            15       7.16388             0             0             0      4  # Size_DblN_descend_se_3_CA_REC(3)_BLK4repl_1959
            -1            15       6.69536             0             0             0      4  # Size_DblN_descend_se_3_CA_REC(3)_BLK4repl_1975
            -1            15       6.60539             0             0             0      4  # Size_DblN_descend_se_3_CA_REC(3)_BLK4repl_1990
            -1            15       5.91404             0             0             0      4  # Size_DblN_descend_se_3_CA_REC(3)_BLK4repl_2004
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

