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
 2 4 5 1 #_blocks_per_pattern 
# begin and end years of blocks
 1998 2010 2011 2016
 1998 2006 2007 2009 2010 2010 2011 2016
 1973 1982 1983 1992 1993 2002 2003 2010 2011 2016
 1999 2016
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
 4 60 17.2792 0 0 0 2 0 0 0 0 0.5 0 0 # L_at_Amin_Fem_GP_1
 40 130 110 0 0 0 -2 0 0 0 0 0.5 0 0 # L_at_Amax_Fem_GP_1
 0.01 0.5 0.128177 0 0 0 3 0 0 0 0 0.5 0 0 # VonBert_K_Fem_GP_1
 0.01 0.5 0.143666 0 0 0 4 0 0 0 0 0.5 0 0 # CV_young_Fem_GP_1
 0.01 0.5 0.0606102 0 0 0 4 0 0 0 0 0 0 0 # CV_old_Fem_GP_1
# Sex: 1  BioPattern: 1  WtLen
 -3 3 2.76e-06 0 0 0 -3 0 0 0 0 0.5 0 0 # Wtlen_1_Fem_GP_1
 -3 5 3.28 0 0 0 -3 0 0 0 0 0.5 0 0 # Wtlen_2_Fem_GP_1
# Sex: 1  BioPattern: 1  Maturity&Fecundity
 -3 100 56.7 0 0 0 -3 0 0 0 0 0.5 0 0 # Mat50%_Fem_GP_1
 -5 5 -0.269 0 0 0 -3 0 0 0 0 0.5 0 0 # Mat_slope_Fem_GP_1
 -3 3 1 0 0 0 -3 0 0 0 0 0.5 0 0 # Eggs/kg_inter_Fem_GP_1
 -3 3 0 0 0 0 -3 0 0 0 0 0.5 0 0 # Eggs/kg_slope_wt_Fem_GP_1
# Sex: 2  BioPattern: 1  NatMort
 0.15 0.45 0.304948 -1.532 0.438 3 7 0 0 0 0 0.5 0 0 # NatM_p_1_Mal_GP_1
# Sex: 2  BioPattern: 1  Growth
 10 60 14.8755 0 0 0 2 0 0 0 0 0.5 0 0 # L_at_Amin_Mal_GP_1
 40 110 76.7129 0 0 0 2 0 0 0 0 0.5 0 0 # L_at_Amax_Mal_GP_1
 0.01 1 0.301256 0 0 0 3 0 0 0 0 0.5 0 0 # VonBert_K_Mal_GP_1
 0.01 0.5 0.156754 0 0 0 4 0 0 0 0 0.5 0 0 # CV_young_Mal_GP_1
 0.01 0.5 0.0722663 0 0 0 4 0 0 0 0 0 0 0 # CV_old_Mal_GP_1
# Sex: 2  BioPattern: 1  WtLen
 -3 3 1.61e-06 0 0 0 -3 0 0 0 0 0.5 0 0 # Wtlen_1_Mal_GP_1
 -5 5 3.42 0 0 0 -3 0 0 0 0 0.5 0 0 # Wtlen_2_Mal_GP_1
# Hermaphroditism
#  Recruitment Distribution  
 -3 3 0 0 0 0 -4 0 0 0 0 0 0 0 # RecrDist_GP_1
 -3 3 0 0 0 0 -3 0 0 0 0 0 0 0 # RecrDist_Area_1
 0 999 1 0 0 0 -3 0 0 0 0 0.5 0 0 # RecrDist_month_1
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
             5            15       9.06708             0             0             0          1          0          0          0          0          0          0          0 # SR_LN(R0)
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
#  1889E 1890E 1891E 1892E 1893E 1894E 1895E 1896E 1897E 1898E 1899E 1900E 1901E 1902E 1903E 1904E 1905E 1906E 1907E 1908E 1909E 1910E 1911E 1912E 1913E 1914E 1915E 1916E 1917E 1918E 1919E 1920E 1921E 1922E 1923E 1924E 1925E 1926E 1927E 1928E 1929E 1930E 1931E 1932E 1933E 1934E 1935E 1936E 1937E 1938E 1939E 1940E 1941E 1942E 1943E 1944E 1945E 1946E 1947E 1948E 1949E 1950E 1951E 1952E 1953E 1954E 1955E 1956E 1957E 1958E 1959E 1960E 1961E 1962E 1963E 1964E 1965R 1966R 1967R 1968R 1969R 1970R 1971R 1972R 1973R 1974R 1975R 1976R 1977R 1978R 1979R 1980R 1981R 1982R 1983R 1984R 1985R 1986R 1987R 1988R 1989R 1990R 1991R 1992R 1993R 1994R 1995R 1996R 1997R 1998R 1999R 2000R 2001R 2002R 2003R 2004R 2005R 2006R 2007R 2008R 2009R 2010R 2011R 2012R 2013R 2014R 2015R 2016F 2017F 2018F 2019F 2020F 2021F 2022F 2023F 2024F 2025F 2026F 2027F 2028F 2029F 2030F
#  -8.29147e-06 -9.72775e-06 -1.14149e-05 -1.33981e-05 -1.57269e-05 -1.846e-05 -2.16651e-05 -2.54273e-05 -2.98449e-05 -3.50345e-05 -4.11377e-05 -4.83064e-05 -5.6714e-05 -6.65652e-05 -7.81032e-05 -9.16223e-05 -0.000107472 -0.000126038 -0.000147718 -0.00017297 -0.000202356 -0.000236536 -0.000276574 -0.000323747 -0.000379455 -0.000445188 -0.000522279 -0.000612087 -0.000716889 -0.000839088 -0.000981359 -0.00114807 -0.00134313 -0.00157054 -0.00183652 -0.00214645 -0.00250705 -0.00292401 -0.00340122 -0.0039436 -0.00455765 -0.00524375 -0.00600753 -0.00685662 -0.00778961 -0.0088031 -0.00988685 -0.0110345 -0.0122579 -0.0135837 -0.0150252 -0.0166574 -0.0185251 -0.0207061 -0.0231638 -0.0259283 -0.0289231 -0.0323432 -0.036131 -0.040541 -0.0452926 -0.050401 -0.0558296 -0.0617644 -0.0685975 -0.0762954 -0.0843941 -0.0924322 -0.0996218 -0.102978 -0.0981743 -0.0814313 -0.0560905 -0.0134072 0.151146 0.569574 0.39797 0.0806568 0.00971164 0.0713762 0.244362 0.315525 0.130579 -0.0879898 -0.202855 -0.207168 -0.339364 -0.396383 0.0421061 1.01551 0.688293 0.471604 -0.147851 0.162029 -0.395789 -0.219671 1.12053 -0.773394 -0.313894 0.0178226 0.0625341 1.0993 0.89877 0.46982 -0.0998058 0.253995 -0.185334 -0.426079 -0.28831 -0.529669 -0.102124 0.254382 0.0985481 -0.441297 -0.739119 -0.489814 -0.80292 -0.579441 -0.386585 0.7917 -0.0394597 0.02167 -0.482227 -0.440386 0.436918 -0.36891 0.330136 -0.0408062 0 0 0 0 0 0 0 0 0 0 0 0 0 0
# implementation error by year in forecast:  0 0 0 0 0 0 0 0 0 0 0 0 0 0
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
#2030 2067
# F rates by fleet
# Yr:  1889 1890 1891 1892 1893 1894 1895 1896 1897 1898 1899 1900 1901 1902 1903 1904 1905 1906 1907 1908 1909 1910 1911 1912 1913 1914 1915 1916 1917 1918 1919 1920 1921 1922 1923 1924 1925 1926 1927 1928 1929 1930 1931 1932 1933 1934 1935 1936 1937 1938 1939 1940 1941 1942 1943 1944 1945 1946 1947 1948 1949 1950 1951 1952 1953 1954 1955 1956 1957 1958 1959 1960 1961 1962 1963 1964 1965 1966 1967 1968 1969 1970 1971 1972 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021 2022 2023 2024 2025 2026 2027 2028 2029 2030
# seas:  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
# 1_N_TRAWL 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.000318648 0.00127065 0.000287524 0.000410206 0.00111956 0.0036966 0.00433247 0.00612764 0.0087796 0.00610042 0.0132817 0.0246259 0.0235485 0.0395014 0.0416492 0.0697957 0.053425 0.0674459 0.0360855 0.0556707 0.039927 0.0441835 0.052531 0.0340084 0.0162811 0.0267873 0.0576854 0.04225 0.0447634 0.0517397 0.085908 0.102033 0.102611 0.0606323 0.0453179 0.07279 0.0834868 0.0920902 0.138816 0.163243 0.0888563 0.0561271 0.0617499 0.0578985 0.0880885 0.0993719 0.0971037 0.0961815 0.091847 0.0757836 0.134316 0.148298 0.147118 0.179353 0.535352 0.54614 0.651609 0.302483 0.440316 0.480345 0.668185 0.576119 1.05223 0.661771 1.103 0.841223 0.526731 0.555669 0.532548 0.0829499 0.0772296 0.0230184 0.0179276 0.0326056 0.023321 0.0229233 0.0270761 0.0368659 0.0266109 0.0302612 0.0262376 0.0108932 0.0150594 0.016969 0.015037 0.00882879 0.00670779 0.0106221 0.0192808 0.010631 0.0195219 0.0189342 0.111551 0.111069 0.110467 0.109985 0.109503 0.108901 0.108419 0.107937 0.107455 0.106853
# 2_N_FIX 0.00396894 0.00411258 0.00422596 0.00580511 0.00460664 0.0046111 0.00503224 0.00605854 0.00608237 0.00261587 0.00166486 0.00210686 0.00215145 0.00219673 0.0022426 0.00268592 0.00211886 0.00216524 0.00221175 0.00164457 0.00710277 0.00717076 0.00723606 0.00729791 0.00735639 0.00741202 0.0129572 0.0190021 0.0191828 0.0253866 0.00850978 0.0067202 0.00625064 0.00349372 0.00307415 0.00728749 0.00970112 0.0110041 0.0135725 0.0109167 0.0213689 0.0183594 0.00975685 0.0095488 0.0140001 0.0158955 0.0163273 0.0216492 0.0195978 0.0459668 0.0294874 0.034765 0.0324251 0.0367942 0.0269356 0.0311629 0.0192385 0.0293499 0.0172165 0.0225078 0.0285028 0.0176733 0.017743 0.0197413 0.00848121 0.0114133 0.00906889 0.008612 0.0094352 0.00754354 0.00687541 0.0097655 0.00871114 0.00780661 0.00579607 0.00454103 0.00432282 0.00520756 0.00629543 0.00461563 0.00614156 0.00681574 0.00574732 0.00528364 0.00506731 0.0036894 0.00560726 0.00477583 0.00919825 0.0108748 0.0150715 0.00857874 0.0117053 0.0152617 0.0167722 0.0179954 0.0253796 0.0196327 0.0241505 0.0237357 0.0335901 0.0384408 0.0247613 0.0306333 0.0242484 0.0310402 0.0142497 0.0172806 0.0237892 0.00957352 0.0106073 0.00622604 0.00770539 0.00681695 0.00645367 0.00624403 0.00618886 0.00810831 0.00746801 0.0102281 0.00963476 0.00588864 0.00650814 0.00615639 0.00646069 0.00625979 0.00994776 0.00742815 0.00881221 0.00890145 0.00970577 0.00932103 0.0276781 0.0275586 0.0274091 0.0272896 0.02717 0.0270206 0.026901 0.0267814 0.0266619 0.0265124
# 3_WA_REC 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.00130658 0.00147496 0.00142319 0.00142905 0.0014614 0.00146455 0.00143122 0.00141957 0.00173963 0.00104706 0.00154708 0.00141332 0.00132927 0.00179371 0.00165435 0.00145293 0.00174904 0.00356524 0.00366754 0.00479237 0.00565631 0.00498845 0.00485527 0.00646363 0.00838461 0.0144356 0.0152537 0.012144 0.00679291 0.00635512 0.00671261 0.00448125 0.00493312 0.00350474 0.0041788 0.00534261 0.00585511 0.0060689 0.00544353 0.0042788 0.00499289 0.0056359 0.00645441 0.00826834 0.00946207 0.0078038 0.0069587 0.00746386 0.00745804 0.0101172 0.00880957 0.00740797 0.00740244 0.00714707 0.0291459 0.02902 0.0288626 0.0287367 0.0286108 0.0284535 0.0283276 0.0282017 0.0280758 0.0279184
# 4_OR_REC 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.00227331 0.00248109 0.00360378 0.00362327 0.00417845 0.00461601 0.00579529 0.00401174 0.00363393 0.00400933 0.0052932 0.0044831 0.00497486 0.00687472 0.00464213 0.00673669 0.00664537 0.00629302 0.0105662 0.011745 0.0108994 0.00610849 0.00749226 0.00951141 0.00600581 0.00924555 0.00572037 0.00668797 0.00861639 0.0114408 0.0087735 0.0105986 0.00835464 0.00867209 0.0080142 0.00756043 0.00915514 0.00927338 0.00983458 0.012944 0.0101783 0.0138911 0.00952314 0.0104945 0.0120811 0.0113338 0.0109657 0.0413075 0.0411291 0.0409061 0.0407276 0.0405492 0.0403261 0.0401477 0.0399693 0.0397908 0.0395678
#
#_Q_setup for fleets with cpue or survey data
#_1:  fleet number
#_2:  link type: (1=simple q, 1 parm; 2=mirror simple q, 1 mirrored parm; 3=q and power, 2 parm; 4=mirror with offset, 2 parm)
#_3:  extra input for link, i.e. mirror fleet# or dev index number
#_4:  0/1 to select extra sd parameter
#_5:  0/1 for biasadj or not
#_6:  0/1 to float
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
           -15            15      -1.16564             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_1_N_TRAWL(1)
         0.001             2     0.0663831             0             0             0          2          0          0          0          0          0          0          0  #  Q_extraSD_1_N_TRAWL(1)
           -15            15      -7.08336             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_2_N_FIX(2)
         0.001             2      0.120874             0             0             0          2          0          0          0          0          0          0          0  #  Q_extraSD_2_N_FIX(2)
           -15            15      -8.56188             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_3_WA_REC(3)
         0.001             2      0.261407             0             0             0          2          0          0          0          0          0          0          0  #  Q_extraSD_3_WA_REC(3)
           -15            15      -11.0516             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_4_OR_REC(4)
         0.001             2      0.216859             0             0             0          2          0          0          0          0          0          0          0  #  Q_extraSD_4_OR_REC(4)
           -15            15       -0.7337             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_5_N_TRI_Early(5)
           -15            15     -0.645514             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_6_N_TRI_Late(6)
           -15            15      -0.30433             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_7_N_NWFSC(7)
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
 24 2 3 0 # 1 1_N_TRAWL
 24 2 3 0 # 2 2_N_FIX
 24 0 3 0 # 3 3_WA_REC
 24 0 0 0 # 4 4_OR_REC
 24 0 0 0 # 5 5_N_TRI_Early
 24 0 0 0 # 6 6_N_TRI_Late
 24 0 0 0 # 7 7_N_NWFSC
 24 0 3 0 # 8 8_N_Lam_Research
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
 11 0 0 0 # 1 1_N_TRAWL
 11 0 0 0 # 2 2_N_FIX
 11 0 0 0 # 3 3_WA_REC
 11 0 0 0 # 4 4_OR_REC
 11 0 0 0 # 5 5_N_TRI_Early
 11 0 0 0 # 6 6_N_TRI_Late
 11 0 0 0 # 7 7_N_NWFSC
 11 0 0 0 # 8 8_N_Lam_Research
#
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type      PHASE    env-var    use_dev   dev_mnyr   dev_mxyr     dev_PH      Block    Blk_Fxn  #  parm_name
# 1   1_N_TRAWL LenSelex
            14           120       65.0789             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_peak_1_N_TRAWL(1)
           -20             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_1_N_TRAWL(1)
            -1            15             6             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_ascend_se_1_N_TRAWL(1)
            -1            15            14             0             0             0         -3          0          0          0          0          0          3          2  #  Size_DblN_descend_se_1_N_TRAWL(1)
            -5             9           -10             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_1_N_TRAWL(1)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_1_N_TRAWL(1)
            10           100       86.3541             0             0             0          4          0          0          0          0          0          2          2  #  Retain_L_infl_1_N_TRAWL(1)
           0.1            12       10.6768             0             0             0          4          0          0          0          0          0          2          2  #  Retain_L_width_1_N_TRAWL(1)
           -10            10       7.42502           -10             0             0          4          0          0          0          0          0          2          2  #  Retain_L_asymptote_logit_1_N_TRAWL(1)
           -10            10      0.808075             0             0             0          4          0          0          0          0          0          0          0  #  Retain_L_maleoffset_1_N_TRAWL(1)
            -1             1             0             0             0             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_infl_1_N_TRAWL(1)
            -1             1        0.0001             0             0             0         -5          0          0          0          0          0          0          0  #  DiscMort_L_width_1_N_TRAWL(1)
         0.001             1           0.5             0             0             0         -6          0          0          0          0          0          0          0  #  DiscMort_L_level_old_1_N_TRAWL(1)
            -2             2             0             0             0             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_male_offset_1_N_TRAWL(1)
           -30            15      -1.39219             0             0             0         -3          0          0          0          0          0          0          0  #  SzSel_Male_Peak_1_N_TRAWL(1)
           -15            15      0.204583             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Ascend_1_N_TRAWL(1)
           -15            15      -2.67285             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Descend_1_N_TRAWL(1)
           -15            15             0             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Final_1_N_TRAWL(1)
           -15            15             1             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Scale_1_N_TRAWL(1)
# 2   2_N_FIX LenSelex
            14           100       86.0594             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_peak_2_N_FIX(2)
           -20            10           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_2_N_FIX(2)
           -10             9       6.57728             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_ascend_se_2_N_FIX(2)
            -1             9       5.18328             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_descend_se_2_N_FIX(2)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_2_N_FIX(2)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_2_N_FIX(2)
            10           100       58.6395             0             0             0          4          0          0          0          0          0          0          0  #  Retain_L_infl_2_N_FIX(2)
           0.1            10       6.84254             0             0             0          5          0          0          0          0          0          1          2  #  Retain_L_width_2_N_FIX(2)
           -10            10       6.60971           -10             0             0          5          0          0          0          0          0          1          2  #  Retain_L_asymptote_logit_2_N_FIX(2)
            -2             6          -1.3             0             0             0         -4          0          0          0          0          0          0          0  #  Retain_L_maleoffset_2_N_FIX(2)
            -1             1             0             0             0             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_infl_2_N_FIX(2)
            -1             1        0.0001             0             0             0         -5          0          0          0          0          0          0          0  #  DiscMort_L_width_2_N_FIX(2)
         0.001             1          0.07             0             0             0         -6          0          0          0          0          0          0          0  #  DiscMort_L_level_old_2_N_FIX(2)
            -2             2             0             0             0             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_male_offset_2_N_FIX(2)
           -30            20           -28             0             0             0         -3          0          0          0          0          0          0          0  #  SzSel_Male_Peak_2_N_FIX(2)
           -15            15      -1.40909             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Ascend_2_N_FIX(2)
           -15            15       1.67935             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Descend_2_N_FIX(2)
           -15            15             0             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Final_2_N_FIX(2)
           -15            15             1             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Scale_2_N_FIX(2)
# 3   3_WA_REC LenSelex
            35           100       72.5808             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_peak_3_WA_REC(3)
           -20            10           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_3_WA_REC(3)
            -1             9       4.92578             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_ascend_se_3_WA_REC(3)
            -1             9       6.27982             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_descend_se_3_WA_REC(3)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_3_WA_REC(3)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_3_WA_REC(3)
           -15            15      -8.64971             0             0             0          3          0          0          0          0          0          0          0  #  SzSel_Male_Peak_3_WA_REC(3)
           -15            15     -0.505124             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Ascend_3_WA_REC(3)
           -15            15     -0.145975             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Descend_3_WA_REC(3)
           -15            15             0             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Final_3_WA_REC(3)
           -15            15             1             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Scale_3_WA_REC(3)
# 4   4_OR_REC LenSelex
            35           100         58.66             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_peak_4_OR_REC(4)
           -20             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_4_OR_REC(4)
            -4             9         4.629             0             0             0          3          0          0          0          0          0          4          2  #  Size_DblN_ascend_se_4_OR_REC(4)
            -1             9       8.10348             0             0             0          3          0          0          0          0          0          4          2  #  Size_DblN_descend_se_4_OR_REC(4)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_4_OR_REC(4)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_4_OR_REC(4)
# 5   5_N_TRI_Early LenSelex
            14           120       94.7876             0             0             0          3          0          0          0          0        0.5          0          0  #  Size_DblN_peak_5_N_TRI_Early(5)
           -20             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_5_N_TRI_Early(5)
            -1             9       7.06891             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_ascend_se_5_N_TRI_Early(5)
            -1             9             6             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_descend_se_5_N_TRI_Early(5)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_5_N_TRI_Early(5)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_5_N_TRI_Early(5)
# 6   6_N_TRI_Late LenSelex
            14           110       57.3902             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_peak_6_N_TRI_Late(6)
           -20             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_6_N_TRI_Late(6)
            -1             9       6.16564             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_ascend_se_6_N_TRI_Late(6)
            -1            15             8             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_descend_se_6_N_TRI_Late(6)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_6_N_TRI_Late(6)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_6_N_TRI_Late(6)
# 7   7_N_NWFSC LenSelex
            35           120       61.2139             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_peak_7_N_NWFSC(7)
           -20             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_7_N_NWFSC(7)
            -1             9        6.4578             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_ascend_se_7_N_NWFSC(7)
            -1             9       7.05121             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_descend_se_7_N_NWFSC(7)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_7_N_NWFSC(7)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_7_N_NWFSC(7)
# 8   8_N_Lam_Research LenSelex
            35           100       82.4812             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_peak_8_N_Lam_Research(8)
           -20             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_8_N_Lam_Research(8)
            -1             9       5.82225             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_ascend_se_8_N_Lam_Research(8)
            -1             9       5.55354             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_descend_se_8_N_Lam_Research(8)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_8_N_Lam_Research(8)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_8_N_Lam_Research(8)
           -30            40      -18.8698             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Peak_8_N_Lam_Research(8)
           -15            15      -1.00809             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Ascend_8_N_Lam_Research(8)
           -15            15      -1.52418             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Descend_8_N_Lam_Research(8)
           -15            15             0             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Final_8_N_Lam_Research(8)
           -15            15             1             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Scale_8_N_Lam_Research(8)
# 1   1_N_TRAWL AgeSelex
             0             1             0           0.1            -1             0        -99          0          0          0          0        0.5          0          0  #  minage@sel=1_1_N_TRAWL(1)
             0           101            25           100            -1             0        -99          0          0          0          0        0.5          0          0  #  maxage@sel=1_1_N_TRAWL(1)
# 2   2_N_FIX AgeSelex
             0             1             0           0.1            -1             0        -99          0          0          0          0        0.5          0          0  #  minage@sel=1_2_N_FIX(2)
             0           101            25           100            -1             0        -99          0          0          0          0        0.5          0          0  #  maxage@sel=1_2_N_FIX(2)
# 3   3_WA_REC AgeSelex
             0             1             0           0.1            -1             0        -99          0          0          0          0        0.5          0          0  #  minage@sel=1_3_WA_REC(3)
             0           101            25           100            -1             0        -99          0          0          0          0        0.5          0          0  #  maxage@sel=1_3_WA_REC(3)
# 4   4_OR_REC AgeSelex
             0             1             0           0.1            -1             0        -99          0          0          0          0        0.5          0          0  #  minage@sel=1_4_OR_REC(4)
             0           101            25           100            -1             0        -99          0          0          0          0        0.5          0          0  #  maxage@sel=1_4_OR_REC(4)
# 5   5_N_TRI_Early AgeSelex
             0             1             0           0.1            -1             0        -99          0          0          0          0        0.5          0          0  #  minage@sel=1_5_N_TRI_Early(5)
             0           101            25           100            -1             0        -99          0          0          0          0        0.5          0          0  #  maxage@sel=1_5_N_TRI_Early(5)
# 6   6_N_TRI_Late AgeSelex
             0             1             0           0.1            -1             0        -99          0          0          0          0        0.5          0          0  #  minage@sel=1_6_N_TRI_Late(6)
             0           101            25           100            -1             0        -99          0          0          0          0        0.5          0          0  #  maxage@sel=1_6_N_TRI_Late(6)
# 7   7_N_NWFSC AgeSelex
             0             1             0           0.1            -1             0        -99          0          0          0          0        0.5          0          0  #  minage@sel=1_7_N_NWFSC(7)
             0           101            25           100            -1             0        -99          0          0          0          0        0.5          0          0  #  maxage@sel=1_7_N_NWFSC(7)
# 8   8_N_Lam_Research AgeSelex
             0             1             0           0.1            -1             0        -99          0          0          0          0        0.5          0          0  #  minage@sel=1_8_N_Lam_Research(8)
             0           101            25           100            -1             0        -99          0          0          0          0        0.5          0          0  #  maxage@sel=1_8_N_Lam_Research(8)
# timevary selex parameters 
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type    PHASE  #  parm_name
            -1            15            10             0             0             0      -5  # Size_DblN_descend_se_1_N_TRAWL(1)_BLK3repl_1973
            -1            15        6.7872             0             0             0      5  # Size_DblN_descend_se_1_N_TRAWL(1)_BLK3repl_1983
            -1            15       6.25788             0             0             0      5  # Size_DblN_descend_se_1_N_TRAWL(1)_BLK3repl_1993
            -1            15       6.27302             0             0             0      5  # Size_DblN_descend_se_1_N_TRAWL(1)_BLK3repl_2003
            -1            15       8.35918             0             0             0      5  # Size_DblN_descend_se_1_N_TRAWL(1)_BLK3repl_2011
            10           100       82.1169             0             0             0      5  # Retain_L_infl_1_N_TRAWL(1)_BLK2repl_1998
            10           100       73.2901             0             0             0      5  # Retain_L_infl_1_N_TRAWL(1)_BLK2repl_2007
            10           100       59.9288             0             0             0      5  # Retain_L_infl_1_N_TRAWL(1)_BLK2repl_2010
            10           100       55.0591             0             0             0      5  # Retain_L_infl_1_N_TRAWL(1)_BLK2repl_2011
           0.1            12       7.58008             0             0             0      -5  # Retain_L_width_1_N_TRAWL(1)_BLK2repl_1998
           0.1            12       5.27149             0             0             0      5  # Retain_L_width_1_N_TRAWL(1)_BLK2repl_2007
           0.1            12       4.28693             0             0             0      5  # Retain_L_width_1_N_TRAWL(1)_BLK2repl_2010
           0.1            12       2.21665             0             0             0      5  # Retain_L_width_1_N_TRAWL(1)_BLK2repl_2011
         0.001            12             7             0             0             0      -5  # Retain_L_asymptote_logit_1_N_TRAWL(1)_BLK2repl_1998
         0.001            12       1.81882             0             0             0      5  # Retain_L_asymptote_logit_1_N_TRAWL(1)_BLK2repl_2007
         0.001            12       9.88881             0             0             0      5  # Retain_L_asymptote_logit_1_N_TRAWL(1)_BLK2repl_2010
         0.001            12       11.4486             0             0             0      5  # Retain_L_asymptote_logit_1_N_TRAWL(1)_BLK2repl_2011
           0.1            10       1.69917             0             0             0      5  # Retain_L_width_2_N_FIX(2)_BLK1repl_1998
           0.1            10       1.44337             0             0             0      5  # Retain_L_width_2_N_FIX(2)_BLK1repl_2011
         0.001             6      0.646926             0             0             0      5  # Retain_L_asymptote_logit_2_N_FIX(2)_BLK1repl_1998
         0.001             6      0.777989             0             0             0      5  # Retain_L_asymptote_logit_2_N_FIX(2)_BLK1repl_2011
            -4             9       2.08459             0             0             0      5  # Size_DblN_ascend_se_4_OR_REC(4)_BLK4repl_1999
            -1             9       6.78121             0             0             0      5  # Size_DblN_descend_se_4_OR_REC(4)_BLK4repl_1999
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
#      5     4     1     3     2     0     0     0     0     0     0     0
#      5     7     6     2     2     0     0     0     0     0     0     0
#      5     8    10     2     2     0     0     0     0     0     0     0
#      5     9    14     2     2     0     0     0     0     0     0     0
#      5    27    18     1     2     0     0     0     0     0     0     0
#      5    28    20     1     2     0     0     0     0     0     0     0
#      5    52    22     4     2     0     0     0     0     0     0     0
#      5    53    23     4     2     0     0     0     0     0     0     0
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
      4      5    1.5065
      4      6  0.172543
      4      7  0.222312
      4      8      0.23
      5      6  0.305228
      5      7  0.223224
      5      8      0.18
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
#  0 #_agecomp:_5
#  1 #_agecomp:_6
#  1 #_agecomp:_7
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

