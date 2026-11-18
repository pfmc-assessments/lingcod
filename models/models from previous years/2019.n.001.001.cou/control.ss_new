#V3.30.14.02-safe;_2019_08_01;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.0
#Stock Synthesis (SS) is a work of the U.S. Government and is not subject to copyright protection in the United States.
#Foreign copyrights may apply. See copyright.txt for more information.
#_user_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_user_info_available_at:https://vlab.ncep.noaa.gov/group/stock-synthesis
#_data_and_control_files: Ling.dat // Ling.ctl
0  # 0 means do not read wtatage.ss; 1 means read and use wtatage.ss and also read and use growth parameters
1  #_N_Growth_Patterns (Growth Patterns, Morphs, Bio Patterns, GP are terms used interchangeably in SS)
1 #_N_platoons_Within_GrowthPattern 
#_Cond 1 #_Platoon_between/within_stdev_ratio (no read if N_platoons=1)
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
1 #_env/block/dev_adjust_method for all time-vary parms (1=warn relative to base parm bounds; 3=no bound check)
#
# AUTOGEN
1 1 1 1 1 # autogen: 1st element for biology, 2nd for SR, 3rd for Q, 4th reserved, 5th for selex
# where: 0 = autogen all time-varying parms; 1 = read each time-varying parm line; 2 = read then autogen if parm min==-12345
#
#_Available timevary codes
#_Block types: 0: P_block=P_base*exp(TVP); 1: P_block=P_base+TVP; 2: P_block=TVP; 3: P_block=P_block(-1) + TVP
#_Block_trends: -1: trend bounded by base parm min-max and parms in transformed units (beware); -2: endtrend and infl_year direct values; -3: end and infl as fraction of base range
#_EnvLinks:  1: P(y)=P_base*exp(TVP*env(y));  2: P(y)=P_base+TVP*env(y);  3: null;  4: P(y)=2.0/(1.0+exp(-TVP1*env(y) - TVP2))
#_DevLinks:  1: P(y)*=exp(dev(y)*dev_se;  2: P(y)+=dev(y)*dev_se;  3: random walk;  4: zero-reverting random walk with rho;  21-24 keep last dev for rest of years
#
#_Prior_codes:  0=none; 6=normal; 1=symmetric beta; 2=CASAL's beta; 3=lognormal; 4=lognormal with biascorr; 5=gamma
#
# setup for M, growth, maturity, fecundity, recruitment distibution, movement 
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
1 #_parameter_offset_approach (1=none, 2= M, G, CV_G as offset from female-GP1, 3=like SS2 V1.x)
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
 0.01 0.5 0.0606103 0 0 0 4 0 0 0 0 0 0 0 # CV_old_Fem_GP_1
# Sex: 1  BioPattern: 1  WtLen
 -3 3 2.76e-006 0 0 0 -3 0 0 0 0 0.5 0 0 # Wtlen_1_Fem_GP_1
 -3 5 3.28 0 0 0 -3 0 0 0 0 0.5 0 0 # Wtlen_2_Fem_GP_1
# Sex: 1  BioPattern: 1  Maturity&Fecundity
 -3 100 56.7 0 0 0 -3 0 0 0 0 0.5 0 0 # Mat50%_Fem_GP_1
 -5 5 -0.269 0 0 0 -3 0 0 0 0 0.5 0 0 # Mat_slope_Fem_GP_1
 -3 3 1 0 0 0 -3 0 0 0 0 0.5 0 0 # Eggs/kg_inter_Fem_GP_1
 -3 3 0 0 0 0 -3 0 0 0 0 0.5 0 0 # Eggs/kg_slope_wt_Fem_GP_1
# Sex: 2  BioPattern: 1  NatMort
 0.15 0.45 0.304947 -1.532 0.438 3 7 0 0 0 0 0.5 0 0 # NatM_p_1_Mal_GP_1
# Sex: 2  BioPattern: 1  Growth
 10 60 14.8756 0 0 0 2 0 0 0 0 0.5 0 0 # L_at_Amin_Mal_GP_1
 40 110 76.7131 0 0 0 2 0 0 0 0 0.5 0 0 # L_at_Amax_Mal_GP_1
 0.01 1 0.301254 0 0 0 3 0 0 0 0 0.5 0 0 # VonBert_K_Mal_GP_1
 0.01 0.5 0.156754 0 0 0 4 0 0 0 0 0.5 0 0 # CV_young_Mal_GP_1
 0.01 0.5 0.0722661 0 0 0 4 0 0 0 0 0 0 0 # CV_old_Mal_GP_1
# Sex: 2  BioPattern: 1  WtLen
 -3 3 1.61e-006 0 0 0 -3 0 0 0 0 0.5 0 0 # Wtlen_1_Mal_GP_1
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
 1e-006 0.999999 0.5 0 0 0 -3 0 0 0 0 0 0 0 # FracFemale_GP_1
#
#_no timevary MG parameters
#
#_seasonal_effects_on_biology_parms
 0 0 0 0 0 0 0 0 0 0 #_femwtlen1,femwtlen2,mat1,mat2,fec1,fec2,Malewtlen1,malewtlen2,L1,K
#_ LO HI INIT PRIOR PR_SD PR_type PHASE
#_Cond -2 2 0 0 -1 99 -2 #_placeholder when no seasonal MG parameters
#
3 #_Spawner-Recruitment; Options: 2=Ricker; 3=std_B-H; 4=SCAA; 5=Hockey; 6=B-H_flattop; 7=survival_3Parm; 8=Shepherd_3Parm; 9=RickerPower_3parm
0  # 0/1 to use steepness in initial equ recruitment calculation
0  #  future feature:  0/1 to make realized sigmaR a function of SR curvature
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type      PHASE    env-var    use_dev   dev_mnyr   dev_mxyr     dev_PH      Block    Blk_Fxn #  parm_name
             5            15        9.0669             0             0             0          1          0          0          0          0          0          0          0 # SR_LN(R0)
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
 0.9113 #_max_bias_adj_in_MPD (-1 to override ramp and set biasadj=1.0 for all estimated recdevs)
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
#  -8.29357e-006 -9.73024e-006 -1.14178e-005 -1.34016e-005 -1.57311e-005 -1.8465e-005 -2.16712e-005 -2.54346e-005 -2.98536e-005 -3.50448e-005 -4.11499e-005 -4.83207e-005 -5.67307e-005 -6.65844e-005 -7.81253e-005 -9.16479e-005 -0.000107502 -0.000126073 -0.00014776 -0.000173019 -0.000202413 -0.000236601 -0.000276649 -0.000323833 -0.000379556 -0.000445306 -0.000522416 -0.000612247 -0.000717077 -0.000839304 -0.000981611 -0.00114836 -0.00134346 -0.00157093 -0.00183697 -0.00214697 -0.00250765 -0.0029247 -0.00340202 -0.00394451 -0.0045587 -0.00524493 -0.00600885 -0.00685808 -0.00779124 -0.00880488 -0.0098888 -0.0110366 -0.0122602 -0.0135861 -0.0150278 -0.0166601 -0.018528 -0.0207092 -0.0231671 -0.0259318 -0.0289267 -0.032347 -0.036135 -0.0405452 -0.0452969 -0.0504055 -0.0558341 -0.0617691 -0.0686024 -0.0763007 -0.0843998 -0.0924382 -0.099628 -0.102984 -0.0981788 -0.0814344 -0.056094 -0.0134099 0.151145 0.569574 0.397962 0.0806494 0.00970659 0.0713734 0.24436 0.315525 0.130582 -0.0879851 -0.202848 -0.207162 -0.339358 -0.396377 0.0421108 1.01551 0.688303 0.4716 -0.147859 0.162024 -0.395792 -0.219663 1.12052 -0.773401 -0.313902 0.0177964 0.0625172 1.09927 0.898731 0.469799 -0.0998088 0.253992 -0.185328 -0.426062 -0.288299 -0.529663 -0.102116 0.254389 0.0985572 -0.441287 -0.73911 -0.489805 -0.802912 -0.579433 -0.386579 0.791705 -0.0394541 0.0216757 -0.482224 -0.440384 0.436919 -0.368908 0.330137 -0.0408081 0 0 0 0 0 0 0 0 0 0 0 0 0 0
# implementation error by year in forecast:  0 0 0 0 0 0 0 0 0 0 0 0 0 0
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
#_initial_F_parms; count = 0
#_ LO HI INIT PRIOR PR_SD  PR_type  PHASE
#2030 2037
# F rates by fleet
# Yr:  1889 1890 1891 1892 1893 1894 1895 1896 1897 1898 1899 1900 1901 1902 1903 1904 1905 1906 1907 1908 1909 1910 1911 1912 1913 1914 1915 1916 1917 1918 1919 1920 1921 1922 1923 1924 1925 1926 1927 1928 1929 1930 1931 1932 1933 1934 1935 1936 1937 1938 1939 1940 1941 1942 1943 1944 1945 1946 1947 1948 1949 1950 1951 1952 1953 1954 1955 1956 1957 1958 1959 1960 1961 1962 1963 1964 1965 1966 1967 1968 1969 1970 1971 1972 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021 2022 2023 2024 2025 2026 2027 2028 2029 2030
# seas:  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
# 1_N_TRAWL 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.000318622 0.00127055 0.000287502 0.000410175 0.00111947 0.00369633 0.00433216 0.00612721 0.00877901 0.00610004 0.0132809 0.0246247 0.0235475 0.0395 0.0416479 0.0697939 0.0534238 0.0674447 0.0360849 0.05567 0.0399264 0.0441828 0.0525301 0.0340078 0.0162807 0.0267866 0.0576835 0.0422486 0.0447617 0.0517375 0.0859043 0.102028 0.102606 0.0606295 0.0453157 0.0727862 0.0834825 0.0920853 0.138808 0.163234 0.0888511 0.0561238 0.0617461 0.0578948 0.0880824 0.099365 0.0970968 0.0961746 0.0918399 0.075778 0.134306 0.148288 0.147108 0.179341 0.535314 0.546098 0.651559 0.30246 0.440282 0.480309 0.668133 0.576077 1.05216 0.661728 1.10292 0.841164 0.526692 0.555626 0.532506 0.0829643 0.0772434 0.0230226 0.0179308 0.0326116 0.0233253 0.0229275 0.0270812 0.0368728 0.0266159 0.0302669 0.0262426 0.0108952 0.0150623 0.0169723 0.0150399 0.00883051 0.00670911 0.0106242 0.0192847 0.0106331 0.0195258 0.018938 0.111551 0.111069 0.110467 0.109985 0.109503 0.108901 0.108419 0.107937 0.107455 0.106853
# 2_N_FIX 0.00398704 0.00413135 0.00424524 0.0058316 0.00462768 0.00463216 0.00505522 0.00608621 0.00611015 0.00262782 0.00167247 0.00211648 0.00216128 0.00220676 0.00225284 0.00269818 0.00212853 0.00217512 0.00222185 0.00165208 0.0071352 0.0072035 0.00726912 0.00733126 0.00739001 0.00744589 0.0130164 0.019089 0.0192706 0.025503 0.00854881 0.006751 0.00627928 0.00350972 0.00308821 0.00732082 0.0097455 0.0110544 0.0136347 0.0109666 0.0214668 0.0184436 0.00980159 0.00959257 0.0140643 0.0159684 0.0164022 0.0217485 0.0196878 0.046178 0.0296232 0.0349252 0.0325746 0.0369641 0.02706 0.0313068 0.0193274 0.0294854 0.017296 0.0226116 0.0286343 0.0177548 0.0178248 0.0198323 0.00852028 0.0114659 0.00911061 0.00865159 0.00947855 0.00757819 0.00690698 0.00981033 0.00875112 0.00784244 0.00582265 0.00456185 0.00434263 0.00523141 0.00632425 0.00463676 0.00616966 0.00684692 0.00577361 0.00530781 0.00509049 0.00370627 0.00563289 0.00479765 0.00924027 0.0109244 0.0151403 0.00861794 0.0117588 0.0153314 0.0168488 0.0180775 0.0254953 0.0197222 0.0242606 0.023844 0.0337434 0.0386162 0.0248743 0.0307733 0.0243593 0.0311822 0.0143148 0.0173595 0.0238978 0.00957528 0.0106093 0.00622723 0.00770686 0.00681825 0.0064549 0.00624523 0.00619006 0.00810988 0.00746947 0.0102301 0.00963665 0.00588979 0.00650941 0.00615759 0.00646195 0.00626103 0.00994973 0.00742963 0.00881397 0.00890324 0.00970773 0.00932293 0.0276781 0.0275585 0.0274091 0.0272895 0.02717 0.0270205 0.0269009 0.0267814 0.0266618 0.0265124
# 3_WA_REC 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.00130683 0.00147524 0.00142346 0.00142933 0.00146168 0.00146483 0.00143149 0.00141984 0.00173995 0.00104725 0.00154736 0.00141358 0.00132951 0.00179403 0.00165465 0.00145319 0.00174935 0.00356586 0.00366817 0.00479319 0.0056573 0.00498933 0.00485612 0.00646476 0.00838611 0.0144382 0.0152566 0.0121463 0.00679417 0.00635628 0.00671383 0.00448207 0.00493404 0.0035054 0.00417959 0.00534362 0.00585622 0.00607005 0.00544457 0.00427962 0.00499386 0.00563699 0.00645567 0.00826994 0.00946389 0.00780529 0.00696004 0.00746531 0.0074595 0.0101192 0.00881131 0.00740944 0.00740392 0.00714851 0.0291459 0.02902 0.0288626 0.0287367 0.0286108 0.0284534 0.0283275 0.0282016 0.0280757 0.0279183
# 4_OR_REC 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.00227373 0.00248155 0.00360442 0.00362392 0.00417919 0.00461686 0.00579636 0.00401248 0.00363458 0.00401005 0.00529415 0.00448389 0.00497573 0.00687594 0.00464296 0.00673788 0.00664656 0.00629418 0.0105682 0.0117473 0.0109015 0.00610962 0.00749363 0.00951308 0.00600689 0.00924724 0.00572143 0.00668921 0.00861799 0.011443 0.00877514 0.0106006 0.00835621 0.00867375 0.00801572 0.00756186 0.00915687 0.00927517 0.00983643 0.0129464 0.0101802 0.0138938 0.00952501 0.0104966 0.0120835 0.011336 0.0109679 0.0413074 0.041129 0.040906 0.0407275 0.0405491 0.0403261 0.0401476 0.0399692 0.0397908 0.0395677
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
           -15            15      -1.16572             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_1_N_TRAWL(1)
         0.001             2     0.0663833             0             0             0          2          0          0          0          0          0          0          0  #  Q_extraSD_1_N_TRAWL(1)
           -15            15      -7.08317             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_2_N_FIX(2)
         0.001             2      0.120872             0             0             0          2          0          0          0          0          0          0          0  #  Q_extraSD_2_N_FIX(2)
           -15            15      -8.56169             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_3_WA_REC(3)
         0.001             2      0.261407             0             0             0          2          0          0          0          0          0          0          0  #  Q_extraSD_3_WA_REC(3)
           -15            15      -11.0514             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_4_OR_REC(4)
         0.001             2      0.216863             0             0             0          2          0          0          0          0          0          0          0  #  Q_extraSD_4_OR_REC(4)
           -15            15     -0.733503             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_5_N_TRI_Early(5)
           -15            15     -0.645328             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_6_N_TRI_Late(6)
           -15            15      -0.30414             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_7_N_NWFSC(7)
#_no timevary Q parameters
#
#_size_selex_patterns
#Pattern:_0; parm=0; selex=1.0 for all sizes
#Pattern:_1; parm=2; logistic; with 95% width specification
#Pattern:_5; parm=2; mirror another size selex; PARMS pick the min-max bin to mirror
#Pattern:_15; parm=0; mirror another age or length selex
#Pattern:_6; parm=2+special; non-parm len selex
#Pattern:_43; parm=2+special+2;  like 6, with 2 additional param for scaling (average over bin range)
#Pattern:_8; parm=8; New doublelogistic with smooth transitions and constant above Linf option
#Pattern:_9; parm=6; simple 4-parm double logistic with starting length; parm 5 is first length; parm 6=1 does desc as offset
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
            14           120       65.0792             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_peak_1_N_TRAWL(1)
           -20             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_1_N_TRAWL(1)
            -1            15             6             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_ascend_se_1_N_TRAWL(1)
            -1            15            14             0             0             0         -3          0          0          0          0          0          3          2  #  Size_DblN_descend_se_1_N_TRAWL(1)
            -5             9           -10             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_1_N_TRAWL(1)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_1_N_TRAWL(1)
            10           100       86.3558             0             0             0          4          0          0          0          0          0          2          2  #  Retain_L_infl_1_N_TRAWL(1)
           0.1            12       10.6771             0             0             0          4          0          0          0          0          0          2          2  #  Retain_L_width_1_N_TRAWL(1)
         0.001            12       8.24746             0             0             0          4          0          0          0          0          0          2          2  #  Retain_L_asymptote_logit_1_N_TRAWL(1)
           -10            10      0.808181             0             0             0          4          0          0          0          0          0          0          0  #  Retain_L_maleoffset_1_N_TRAWL(1)
            -1             1             0             0             0             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_infl_1_N_TRAWL(1)
            -1             1        0.0001             0             0             0         -5          0          0          0          0          0          0          0  #  DiscMort_L_width_1_N_TRAWL(1)
         0.001             1           0.5             0             0             0         -6          0          0          0          0          0          0          0  #  DiscMort_L_level_old_1_N_TRAWL(1)
            -2             2             0             0             0             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_male_offset_1_N_TRAWL(1)
           -30            15      -1.39219             0             0             0         -3          0          0          0          0          0          0          0  #  SzSel_Male_Peak_1_N_TRAWL(1)
           -15            15       0.20461             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Ascend_1_N_TRAWL(1)
           -15            15      -2.67287             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Descend_1_N_TRAWL(1)
           -15            15             0             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Final_1_N_TRAWL(1)
           -15            15             1             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Scale_1_N_TRAWL(1)
# 2   2_N_FIX LenSelex
            14           100       86.0596             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_peak_2_N_FIX(2)
           -20            10           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_2_N_FIX(2)
           -10             9       6.57729             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_ascend_se_2_N_FIX(2)
            -1             9       5.18328             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_descend_se_2_N_FIX(2)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_2_N_FIX(2)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_2_N_FIX(2)
            10           100       58.6395             0             0             0          4          0          0          0          0          0          0          0  #  Retain_L_infl_2_N_FIX(2)
           0.1            10       6.84266             0             0             0          5          0          0          0          0          0          1          2  #  Retain_L_width_2_N_FIX(2)
         0.001             6       5.16147             0             0             0          5          0          0          0          0          0          1          2  #  Retain_L_asymptote_logit_2_N_FIX(2)
            -2             6          -1.3             0             0             0         -4          0          0          0          0          0          0          0  #  Retain_L_maleoffset_2_N_FIX(2)
            -1             1             0             0             0             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_infl_2_N_FIX(2)
            -1             1        0.0001             0             0             0         -5          0          0          0          0          0          0          0  #  DiscMort_L_width_2_N_FIX(2)
         0.001             1          0.07             0             0             0         -6          0          0          0          0          0          0          0  #  DiscMort_L_level_old_2_N_FIX(2)
            -2             2             0             0             0             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_male_offset_2_N_FIX(2)
           -30            20           -28             0             0             0         -3          0          0          0          0          0          0          0  #  SzSel_Male_Peak_2_N_FIX(2)
           -15            15      -1.40909             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Ascend_2_N_FIX(2)
           -15            15       1.67931             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Descend_2_N_FIX(2)
           -15            15             0             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Final_2_N_FIX(2)
           -15            15             1             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Scale_2_N_FIX(2)
# 3   3_WA_REC LenSelex
            35           100        72.581             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_peak_3_WA_REC(3)
           -20            10           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_3_WA_REC(3)
            -1             9       4.92579             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_ascend_se_3_WA_REC(3)
            -1             9       6.27983             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_descend_se_3_WA_REC(3)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_3_WA_REC(3)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_3_WA_REC(3)
           -15            15      -8.64982             0             0             0          3          0          0          0          0          0          0          0  #  SzSel_Male_Peak_3_WA_REC(3)
           -15            15     -0.505136             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Ascend_3_WA_REC(3)
           -15            15     -0.145975             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Descend_3_WA_REC(3)
           -15            15             0             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Final_3_WA_REC(3)
           -15            15             1             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Scale_3_WA_REC(3)
# 4   4_OR_REC LenSelex
            35           100         58.66             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_peak_4_OR_REC(4)
           -20             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_4_OR_REC(4)
            -4             9       4.62899             0             0             0          3          0          0          0          0          0          4          2  #  Size_DblN_ascend_se_4_OR_REC(4)
            -1             9       8.10352             0             0             0          3          0          0          0          0          0          4          2  #  Size_DblN_descend_se_4_OR_REC(4)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_4_OR_REC(4)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_4_OR_REC(4)
# 5   5_N_TRI_Early LenSelex
            14           120       94.7887             0             0             0          3          0          0          0          0        0.5          0          0  #  Size_DblN_peak_5_N_TRI_Early(5)
           -20             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_5_N_TRI_Early(5)
            -1             9       7.06894             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_ascend_se_5_N_TRI_Early(5)
            -1             9             6             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_descend_se_5_N_TRI_Early(5)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_5_N_TRI_Early(5)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_5_N_TRI_Early(5)
# 6   6_N_TRI_Late LenSelex
            14           110       57.3908             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_peak_6_N_TRI_Late(6)
           -20             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_6_N_TRI_Late(6)
            -1             9       6.16568             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_ascend_se_6_N_TRI_Late(6)
            -1            15             8             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_descend_se_6_N_TRI_Late(6)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_6_N_TRI_Late(6)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_6_N_TRI_Late(6)
# 7   7_N_NWFSC LenSelex
            35           120       61.2144             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_peak_7_N_NWFSC(7)
           -20             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_7_N_NWFSC(7)
            -1             9       6.45783             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_ascend_se_7_N_NWFSC(7)
            -1             9        7.0512             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_descend_se_7_N_NWFSC(7)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_7_N_NWFSC(7)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_7_N_NWFSC(7)
# 8   8_N_Lam_Research LenSelex
            35           100       82.4813             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_peak_8_N_Lam_Research(8)
           -20             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_8_N_Lam_Research(8)
            -1             9       5.82225             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_ascend_se_8_N_Lam_Research(8)
            -1             9       5.55355             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_descend_se_8_N_Lam_Research(8)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_8_N_Lam_Research(8)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_8_N_Lam_Research(8)
           -30            40      -18.8697             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Peak_8_N_Lam_Research(8)
           -15            15      -1.00808             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Ascend_8_N_Lam_Research(8)
           -15            15      -1.52421             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Descend_8_N_Lam_Research(8)
           -15            15             0             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Final_8_N_Lam_Research(8)
           -15            15             1             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Scale_8_N_Lam_Research(8)
# 1   1_N_TRAWL AgeSelex
             0             1           0.1           0.1            -1             0         -3          0          0          0          0        0.5          0          0  #  minage@sel=1_1_N_TRAWL(1)
             0           101           100           100            -1             0         -3          0          0          0          0        0.5          0          0  #  maxage@sel=1_1_N_TRAWL(1)
# 2   2_N_FIX AgeSelex
             0             1           0.1           0.1            -1             0         -3          0          0          0          0        0.5          0          0  #  minage@sel=1_2_N_FIX(2)
             0           101           100           100            -1             0         -3          0          0          0          0        0.5          0          0  #  maxage@sel=1_2_N_FIX(2)
# 3   3_WA_REC AgeSelex
             0             1           0.1           0.1            -1             0         -3          0          0          0          0        0.5          0          0  #  minage@sel=1_3_WA_REC(3)
             0           101           100           100            -1             0         -3          0          0          0          0        0.5          0          0  #  maxage@sel=1_3_WA_REC(3)
# 4   4_OR_REC AgeSelex
             0             1           0.1           0.1            -1             0         -3          0          0          0          0        0.5          0          0  #  minage@sel=1_4_OR_REC(4)
             0           101           100           100            -1             0         -3          0          0          0          0        0.5          0          0  #  maxage@sel=1_4_OR_REC(4)
# 5   5_N_TRI_Early AgeSelex
             0             1           0.1           0.1            -1             0         -3          0          0          0          0        0.5          0          0  #  minage@sel=1_5_N_TRI_Early(5)
             0           101           100           100            -1             0         -3          0          0          0          0        0.5          0          0  #  maxage@sel=1_5_N_TRI_Early(5)
# 6   6_N_TRI_Late AgeSelex
             0             1           0.1           0.1            -1             0         -3          0          0          0          0        0.5          0          0  #  minage@sel=1_6_N_TRI_Late(6)
             0           101           100           100            -1             0         -3          0          0          0          0        0.5          0          0  #  maxage@sel=1_6_N_TRI_Late(6)
# 7   7_N_NWFSC AgeSelex
             0             1           0.1           0.1            -1             0         -3          0          0          0          0        0.5          0          0  #  minage@sel=1_7_N_NWFSC(7)
             0           101           100           100            -1             0         -3          0          0          0          0        0.5          0          0  #  maxage@sel=1_7_N_NWFSC(7)
# 8   8_N_Lam_Research AgeSelex
             0             1           0.1           0.1            -1             0         -3          0          0          0          0        0.5          0          0  #  minage@sel=1_8_N_Lam_Research(8)
             0           101           100           100            -1             0         -3          0          0          0          0        0.5          0          0  #  maxage@sel=1_8_N_Lam_Research(8)
# timevary selex parameters 
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type    PHASE  #  parm_name
            -1            15            10             0             0             0      -5  # Size_DblN_descend_se_1_N_TRAWL(1)_BLK3repl_1973
            -1            15       6.78718             0             0             0      5  # Size_DblN_descend_se_1_N_TRAWL(1)_BLK3repl_1983
            -1            15       6.25786             0             0             0      5  # Size_DblN_descend_se_1_N_TRAWL(1)_BLK3repl_1993
            -1            15       6.27301             0             0             0      5  # Size_DblN_descend_se_1_N_TRAWL(1)_BLK3repl_2003
            -1            15        8.3592             0             0             0      5  # Size_DblN_descend_se_1_N_TRAWL(1)_BLK3repl_2011
            10           100       82.1169             0             0             0      5  # Retain_L_infl_1_N_TRAWL(1)_BLK2repl_1998
            10           100       73.2902             0             0             0      5  # Retain_L_infl_1_N_TRAWL(1)_BLK2repl_2007
            10           100       59.9287             0             0             0      5  # Retain_L_infl_1_N_TRAWL(1)_BLK2repl_2010
            10           100       55.0591             0             0             0      5  # Retain_L_infl_1_N_TRAWL(1)_BLK2repl_2011
           0.1            12       7.58008             0             0             0      -5  # Retain_L_width_1_N_TRAWL(1)_BLK2repl_1998
           0.1            12       5.27153             0             0             0      5  # Retain_L_width_1_N_TRAWL(1)_BLK2repl_2007
           0.1            12       4.28695             0             0             0      5  # Retain_L_width_1_N_TRAWL(1)_BLK2repl_2010
           0.1            12       2.21665             0             0             0      5  # Retain_L_width_1_N_TRAWL(1)_BLK2repl_2011
         0.001            12             7             0             0             0      -5  # Retain_L_asymptote_logit_1_N_TRAWL(1)_BLK2repl_1998
         0.001            12       1.81885             0             0             0      5  # Retain_L_asymptote_logit_1_N_TRAWL(1)_BLK2repl_2007
         0.001            12       9.88841             0             0             0      5  # Retain_L_asymptote_logit_1_N_TRAWL(1)_BLK2repl_2010
         0.001            12       11.4485             0             0             0      5  # Retain_L_asymptote_logit_1_N_TRAWL(1)_BLK2repl_2011
           0.1            10       1.69917             0             0             0      5  # Retain_L_width_2_N_FIX(2)_BLK1repl_1998
           0.1            10       1.44337             0             0             0      5  # Retain_L_width_2_N_FIX(2)_BLK1repl_2011
         0.001             6      0.646927             0             0             0      5  # Retain_L_asymptote_logit_2_N_FIX(2)_BLK1repl_1998
         0.001             6      0.777991             0             0             0      5  # Retain_L_asymptote_logit_2_N_FIX(2)_BLK1repl_2011
            -4             9        2.0846             0             0             0      5  # Size_DblN_ascend_se_4_OR_REC(4)_BLK4repl_1999
            -1             9       6.78122             0             0             0      5  # Size_DblN_descend_se_4_OR_REC(4)_BLK4repl_1999
# info on dev vectors created for selex parms are reported with other devs after tag parameter section 
#
0   #  use 2D_AR1 selectivity(0/1):  experimental feature
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
#  1 #_init_equ_catch
#  1 #_recruitments
#  1 #_parameter-priors
#  1 #_parameter-dev-vectors
#  1 #_crashPenLambda
#  0 # F_ballpark_lambda
0 # (0/1) read specs for more stddev reporting 
 # 0 0 0 0 0 0 0 0 0 # placeholder for # selex_fleet, 1=len/2=age/3=both, year, N selex bins, 0 or Growth pattern, N growth ages, 0 or NatAge_area(-1 for all), NatAge_yr, N Natages
 # placeholder for vector of selex bins to be reported
 # placeholder for vector of growth ages to be reported
 # placeholder for vector of NatAges ages to be reported
999

