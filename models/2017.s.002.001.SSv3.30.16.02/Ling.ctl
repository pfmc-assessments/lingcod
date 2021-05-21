#V3.30.07.01-opt;_2017_08_07;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_11.6
#_data_and_control_files: Ling.dat // Ling.ctl
#V3.30.07.01-opt;_2017_08_07;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_11.6
#_user_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_user_info_available_at:https://vlab.ncep.noaa.gov/group/stock-synthesis
0  # 0 means do not read wtatage.ss; 1 means read and use wtatage.ss and also read and use growth parameters
1  #_N_Growth_Patterns
1 #_N_platoons_Within_GrowthPattern 
#_Cond 1 #_Morph_between/within_stdev_ratio (no read if N_morphs=1)
#_Cond  1 #vector_Morphdist_(-1_in_first_val_gives_normal_approx)
#
2 # recr_dist_method for parameters:  2=main effects for GP, Area, Settle timing; 3=each Settle entity
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
1 #_env/block/dev_adjust_method for all time-vary parms (1=warn relative to base parm bounds; 3=no bound check)
#  autogen
1 1 1 1 1 # autogen: 1st element for biology, 2nd for SR, 3rd for Q, 4th reserved, 5th for selex
# where: 0 = autogen all time-varying parms; 1 = read each time-varying parm line; 2 = read then autogen if parm min==-12345
# 
#
# setup for M, growth, maturity, fecundity, recruitment distibution, movement 
#
0 #_natM_type:_0=1Parm; 1=N_breakpoints;_2=Lorenzen;_3=agespecific;_4=agespec_withseasinterpolate
  #_no additional input for selected M option; read 1P per morph
1 # GrowthModel: 1=vonBert with L1&L2; 2=Richards with L1&L2; 3=age_specific_K; 4=not implemented
0.5 #_Growth_Age_for_L1
10 #_Growth_Age_for_L2 (999 to use as Linf)
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
#_ LO HI INIT PRIOR PR_SD PR_type PHASE env_var&link dev_link dev_minyr dev_maxyr dev_PH Block Block_Fxn
 0.05 0.3 0.257 -1.53 0.438 3 -7 0 0 0 0 0 0 0 # NatM_p_1_Fem_GP_1
 10 60 18.0067 0 0 0 2 0 0 0 0 0 0 0 # L_at_Amin_Fem_GP_1
 40 130 93.4011 0 0 0 2 0 0 0 0 0 0 0 # L_at_Amax_Fem_GP_1
 0.01 0.5 0.129805 0 0 0 3 0 0 0 0 0 0 0 # VonBert_K_Fem_GP_1
 0.01 0.5 0.150482 0 0 0 4 0 0 0 0 0 0 0 # CV_young_Fem_GP_1
 0.01 0.5 0.0697104 0 0 0 4 0 0 0 0 0 0 0 # CV_old_Fem_GP_1
 -3 3 3.308e-006 0 0 0 -3 0 0 0 0 0 0 0 # Wtlen_1_Fem
 -3 5 3.248 0 0 0 -3 0 0 0 0 0 0 0 # Wtlen_2_Fem
 -3 100 52.3 0 0 0 -3 0 0 0 0 0 0 0 # Mat50%_Fem
 -5 5 -0.219 0 0 0 -3 0 0 0 0 0 0 0 # Mat_slope_Fem
 -3 3 1 0 0 0 -3 0 0 0 0 0 0 0 # Eggs/kg_inter_Fem
 -3 3 0 0 0 0 -3 0 0 0 0 0 0 0 # Eggs/kg_slope_wt_Fem
 0.15 0.4 0.319169 -1.532 0.438 3 7 0 0 0 0 0 0 0 # NatM_p_1_Mal_GP_1
 10 60 18.1262 0 0 0 2 0 0 0 0 0 0 0 # L_at_Amin_Mal_GP_1
 40 110 83.8073 0 0 0 2 0 0 0 0 0 0 0 # L_at_Amax_Mal_GP_1
 0.01 1 0.16026 0 0 0 3 0 0 0 0 0 0 0 # VonBert_K_Mal_GP_1
 0.01 0.5 0.136656 0 0 0 4 0 0 0 0 0 0 0 # CV_young_Mal_GP_1
 0.01 0.5 0.0874039 0 0 0 4 0 0 0 0 0 0 0 # CV_old_Mal_GP_1
 -3 3 2.179e-006 0 0 0 -3 0 0 0 0 0 0 0 # Wtlen_1_Mal
 -5 5 3.36 0 0 0 -3 0 0 0 0 0 0 0 # Wtlen_2_Mal
 -3 3 0 0 0 0 -4 0 0 0 0 0 0 0 # RecrDist_GP_1
 -3 3 0 0 0 0 -3 0 0 0 0 0 0 0 # RecrDist_Area_1
 0 999 1 0 0 0 -3 0 0 0 0 0 0 0 # RecrDist_month_1
 1 1 1 1 1 0 -1 0 0 0 0 0 0 0 # CohortGrowDev
 1e-006 0.999999 0.5 0 0 0 -3 0 0 0 0 0 0 0 # FracFemale_GP_1
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
             5            15        8.4864             0             0             0          1          0          0          0          0          0          0          0 # SR_LN(R0)
           0.2             1           0.7             0             0             0         -4          0          0          0          0          0          0          0 # SR_BH_steep
             0             2          0.75             0             0             0         -3          0          0          0          0          0          0          0 # SR_sigmaR
            -5             5             0             0             0             0         -5          0          0          0          0          0          0          0 # SR_regime
             0             2             0             0             0             0        -50          0          0          0          0          0          0          0 # SR_autocorr
1 #do_recdev:  0=none; 1=devvector; 2=simple deviations
1965 # first year of main recr_devs; early devs can preceed this era
2015 # last year of main recr_devs; forecast devs start in following year
2 #_recdev phase 
1 # (0/1) to read 13 advanced options
 1889 #_recdev_early_start (0=none; neg value makes relative to recdev_start)
 6 #_recdev_early_phase
 0 #_forecast_recruitment phase (incl. late recr) (0 value resets to maxphase+1)
 1 #_lambda for Fcast_recr_like occurring before endyr+1
 1950 #_last_early_yr_nobias_adj_in_MPD
 2001 #_first_yr_fullbias_adj_in_MPD
 2015 #_last_yr_fullbias_adj_in_MPD
 2017 #_first_recent_yr_nobias_adj_in_MPD
 0.94 #_max_bias_adj_in_MPD (-1 to override ramp and set biasadj=1.0 for all estimated recdevs)
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
#  2.12088e-005 2.48361e-005 2.90582e-005 3.39669e-005 3.96669e-005 4.62777e-005 5.39359e-005 6.27964e-005 7.30354e-005 8.48528e-005 9.84747e-005 0.000114157 0.000132188 0.000152894 0.000176641 0.000203838 0.000234947 0.000270481 0.000311011 0.000357194 0.000409699 0.000469343 0.000536959 0.000613509 0.00069999 0.000797556 0.000907453 0.00103102 0.00116979 0.0013254 0.00149953 0.00169406 0.00191102 0.0021526 0.00242132 0.00272036 0.00305386 0.00342676 0.00384614 0.00432112 0.00486006 0.0054751 0.00618303 0.00698944 0.00792421 0.00898446 0.0102305 0.0116709 0.0133066 0.0151185 0.0170557 0.0190943 0.0211821 0.0232544 0.0253655 0.0277066 0.0308137 0.0355939 0.0437417 0.0576591 0.0798517 0.108638 0.132264 0.132704 0.0968287 0.0431488 0.0175178 -0.0571676 -0.314688 -0.303036 0.00453477 0.218806 0.36011 -0.176478 -0.106791 -0.0836546 -0.119508 0.0430721 0.117906 0.136868 -0.0152239 -0.0347965 -0.149565 0.0898686 0.503394 0.524871 0.225248 0.784525 0.621637 -0.237976 0.743926 -0.146061 -0.421763 -0.448712 0.142928 1.38475 1.11394 0.611666 0.567913 -0.0445181 0.435291 -0.0514981 0.772003 -0.776586 -0.151044 0.38017 -0.556563 0.503299 -0.459391 -0.643238 1.00449 0.423661 0.118172 -0.619267 -0.42168 -1.3895 -1.46568 -1.82608 -1.27735 -0.448689 -0.361738 0.341975 0.22132 0.372112 0.64811 -0.300687 -0.466013 -0.857053 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
# implementation error by year in forecast:  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
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
#2032 2037
# F rates by fleet
# Yr:  1889 1890 1891 1892 1893 1894 1895 1896 1897 1898 1899 1900 1901 1902 1903 1904 1905 1906 1907 1908 1909 1910 1911 1912 1913 1914 1915 1916 1917 1918 1919 1920 1921 1922 1923 1924 1925 1926 1927 1928 1929 1930 1931 1932 1933 1934 1935 1936 1937 1938 1939 1940 1941 1942 1943 1944 1945 1946 1947 1948 1949 1950 1951 1952 1953 1954 1955 1956 1957 1958 1959 1960 1961 1962 1963 1964 1965 1966 1967 1968 1969 1970 1971 1972 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021 2022 2023 2024 2025 2026 2027 2028 2029 2030 2031 2032
# seas:  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
# 1_CA_TRAWL 0 0.000587869 0.00117712 0.0017691 0.00236503 0.00296601 0.00357299 0.00418679 0.00480809 0.00543749 0.00607551 0.00672262 0.00737921 0.00804568 0.00872239 0.0094097 0.0101079 0.0108175 0.0115386 0.0122718 0.0130172 0.0137755 0.0145468 0.0153316 0.0161304 0.0169436 0.0177715 0.0186148 0.0194739 0.0203494 0.0212417 0.0221514 0.0230793 0.0240258 0.0249916 0.0259774 0.026984 0.0280121 0.0290625 0.030136 0.0312351 0.0323632 0.0335218 0.0242022 0.0382816 0.0238656 0.0281551 0.0208101 0.0265889 0.0203869 0.0156172 0.0185142 0.0139768 0.00814904 0.0183982 0.0189306 0.0176569 0.0291785 0.0502278 0.0545238 0.043911 0.0533987 0.052101 0.0410534 0.0415337 0.0416255 0.0291973 0.0390632 0.0495347 0.0463191 0.0417595 0.0408179 0.0437602 0.0344649 0.0373183 0.0270698 0.025634 0.0250343 0.0294813 0.0348511 0.0389784 0.0546626 0.0738088 0.125893 0.158464 0.196926 0.19928 0.222708 0.133496 0.142162 0.226524 0.219905 0.20261 0.243472 0.365497 0.42607 0.382438 0.26357 0.362037 0.343575 0.369134 0.388012 0.380872 0.323007 0.396565 0.318508 0.270061 0.255731 0.313849 0.112025 0.105028 0.0322054 0.0233656 0.028341 0.00927958 0.00959365 0.00979165 0.0120621 0.0234289 0.0213114 0.0240925 0.0162319 0.00215711 0.00517111 0.00662243 0.00850983 0.00832115 0.00673887 0.00496017 0.00494305 0.00257402 0.00255879 0.00259073 0.00264551 0.00269648 0.00272993 0.00272993 0.00272993 0.00272993 0.00272993 0.00272993 0.00272993 0.00272993 0.00272993
# 2_CA_FIX 0 0.000647166 0.0012959 0.00194763 0.0026035 0.00326445 0.00393114 0.00460407 0.0052836 0.00597001 0.00666357 0.00736452 0.00807311 0.00878958 0.00951418 0.0102472 0.0109888 0.0117393 0.012499 0.0132681 0.0140469 0.0148357 0.0156348 0.0164444 0.017265 0.0180967 0.01894 0.0197951 0.0206625 0.0215426 0.0224357 0.0233422 0.0242626 0.0251974 0.0261468 0.0271116 0.0280921 0.0290889 0.0301025 0.0311334 0.0321844 0.0332586 0.034357 0.0242406 0.0446774 0.0212931 0.0269143 0.0235898 0.02542 0.0324366 0.0167659 0.0201675 0.0176089 0.00883639 0.0197377 0.0192814 0.0197608 0.0317669 0.065131 0.0424457 0.0363116 0.0286237 0.0144699 0.0628393 0.0437574 0.0432998 0.00782343 0.0408927 0.0146455 0.0157536 0.0134067 0.00773722 0.0154291 0.0119627 0.0141338 0.0080364 0.00794233 0.00754572 0.00717435 0.00609531 0.00830508 0.00815241 0.0160468 0.0277536 0.0241617 0.0390095 0.0504994 0.0313351 0.0185754 0.0272235 0.0190188 0.0181081 0.0183536 0.0158629 0.0119746 0.0112427 0.0285867 0.0630288 0.0599513 0.0653418 0.126425 0.107079 0.0806077 0.0994541 0.094376 0.0800428 0.101245 0.106106 0.106173 0.050557 0.0372679 0.0134742 0.0172823 0.0251226 0.0179832 0.0168042 0.0127187 0.0109329 0.0114367 0.0125219 0.0101835 0.0118112 0.0163315 0.0206793 0.024394 0.0326393 0.0392506 0.0226853 0.0194338 0.0179888 0.0194878 0.0193725 0.0196143 0.0200291 0.020415 0.0206682 0.0206682 0.0206682 0.0206682 0.0206682 0.0206682 0.0206682 0.0206682 0.0206682
# 3_CA_REC 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.000176435 0.000355967 0.000537702 0.000718624 0.000902617 0.00108761 0.0012616 0.00143449 0.00220964 0.00266771 0.00365527 0.00379926 0.00347697 0.00181773 0.00171622 0.0014031 0.00186425 0.00322325 0.0120613 0.0137315 0.0154012 0.014083 0.0146926 0.0105131 0.00775299 0.0123759 0.0129953 0.0175119 0.0204805 0.0229886 0.018368 0.015872 0.0163713 0.0164084 0.0161895 0.0150368 0.0211431 0.0294136 0.0316749 0.0314527 0.0250034 0.0388774 0.0464902 0.0607492 0.0678651 0.0803244 0.116614 0.134161 0.0958759 0.118539 0.124605 0.181083 0.170856 0.139393 0.100403 0.101724 0.250928 0.294799 0.26686 0.240006 0.217025 0.224683 0.286375 0.349132 0.235498 0.139359 0.136894 0.204756 0.172926 0.157104 0.188002 0.10132 0.0876531 0.203145 0.293387 0.0463664 0.0910141 0.0811588 0.056009 0.0381162 0.0601085 0.0601912 0.135723 0.140542 0.161781 0.157936 0.161055 0.12164 0.105074 0.109899 0.161954 0.160996 0.163005 0.166452 0.169659 0.171763 0.171763 0.171763 0.171763 0.171763 0.171763 0.171763 0.171763 0.171763
#
#_Q_setup
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
         0.001             2      0.045613             0             0             0          2          0          0          0          0          0          0          0  #  Q_extraSD_1_CA_TRAWL(1)
           -15            15     -0.163515             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_4_CA_TRI_Early(4)
           -15            15      0.248616             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_5_CA_TRI_Late(5)
           -15            15       0.17325             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_6_CA_NWFSC(6)
           -15            15      -11.6101             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_7_CA_HookLine(7)
#_no timevary Q parameters
#
#_size_selex_types
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
#_age_selex_types
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
            14           100       60.1524             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P1_1_CA_TRAWL(1)
            -6             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P2_1_CA_TRAWL(1)
            -5            15             7             0             0             0         -3          0          0          0          0          0          3          2  #  SizeSel_P3_1_CA_TRAWL(1)
            -5            15       13.1537             0             0             0          3          0          0          0          0          0          3          2  #  SizeSel_P4_1_CA_TRAWL(1)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  SizeSel_P5_1_CA_TRAWL(1)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P6_1_CA_TRAWL(1)
            10           100       60.4058             0             0             0          4          0          0          0          0          0          2          2  #  Retain_P1_1_CA_TRAWL(1)
           0.1            15             9             0             0             0         -4          0          0          0          0          0          2          2  #  Retain_P2_1_CA_TRAWL(1)
         0.001             1             2             0             0             0         -4          0          0          0          0          0          0          0  #  Retain_P3_1_CA_TRAWL(1)
            -2             2             0             0             0             0         -4          0          0          0          0          0          0          0  #  Retain_P4_1_CA_TRAWL(1)
            -1             1             0             0             0             0         -4          0          0          0          0          0          0          0  #  DiscMort_P1_1_CA_TRAWL(1)
            -1             1        0.0001             0             0             0         -5          0          0          0          0          0          0          0  #  DiscMort_P2_1_CA_TRAWL(1)
         0.001             1           0.5             0             0             0         -6          0          0          0          0          0          0          0  #  DiscMort_P3_1_CA_TRAWL(1)
            -2             2             0             0             0             0         -4          0          0          0          0          0          0          0  #  DiscMort_P4_1_CA_TRAWL(1)
           -30            15      -3.32043             0             0             0          3          0          0          0          0          0          0          0  #  SzSel_Male_Peak_1_CA_TRAWL(1)
           -15            15       3.16906             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Ascend_1_CA_TRAWL(1)
           -15            15      -1.25677             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Descend_1_CA_TRAWL(1)
           -15            15             0             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Final_1_CA_TRAWL(1)
           -15            15             1             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Scale_1_CA_TRAWL(1)
            14           100       85.6044             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P1_2_CA_FIX(2)
            -6             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P2_2_CA_FIX(2)
            -5            15       7.53636             0             0             0          3          0          0          0          0          0          1          2  #  SizeSel_P3_2_CA_FIX(2)
            -5            15        5.6008             0             0             0          3          0          0          0          0          0          1          2  #  SizeSel_P4_2_CA_FIX(2)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  SizeSel_P5_2_CA_FIX(2)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P6_2_CA_FIX(2)
            10           100       51.6048             0             0             0          4          0          0          0          0          0          1          2  #  Retain_P1_2_CA_FIX(2)
           0.1            10       2.36349             0             0             0          4          0          0          0          0          0          1          2  #  Retain_P2_2_CA_FIX(2)
         0.001             1             1             0             0             0         -4          0          0          0          0          0          0          0  #  Retain_P3_2_CA_FIX(2)
            -2             2             0             0             0             0         -6          0          0          0          0          0          0          0  #  Retain_P4_2_CA_FIX(2)
            -1             1             0             0             0             0         -4          0          0          0          0          0          0          0  #  DiscMort_P1_2_CA_FIX(2)
            -1             1        0.0001             0             0             0         -5          0          0          0          0          0          0          0  #  DiscMort_P2_2_CA_FIX(2)
         0.001             1          0.07             0             0             0         -6          0          0          0          0          0          0          0  #  DiscMort_P3_2_CA_FIX(2)
            -2             2             0             0             0             0         -4          0          0          0          0          0          0          0  #  DiscMort_P4_2_CA_FIX(2)
           -30            20           -22             0             0             0         -3          0          0          0          0          0          0          0  #  SzSel_Male_Peak_2_CA_FIX(2)
           -15            15      -1.66309             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Ascend_2_CA_FIX(2)
           -15            15       0.28567             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Descend_2_CA_FIX(2)
           -15            15             0             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Final_2_CA_FIX(2)
           -15            15             1             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Scale_2_CA_FIX(2)
            35           100          62.5             0             0             0         -3          0          0          0          0          0          4          2  #  SizeSel_P1_3_CA_REC(3)
           -16             1           -15             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P2_3_CA_REC(3)
            -1            15           5.8             0             0             0         -3          0          0          0          0          0          4          2  #  SizeSel_P3_3_CA_REC(3)
            -1            15           7.2             0             0             0         -3          0          0          0          0          0          4          2  #  SizeSel_P4_3_CA_REC(3)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P5_3_CA_REC(3)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P6_3_CA_REC(3)
            10           100       38.7585             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P1_4_CA_TRI_Early(4)
            -6             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P2_4_CA_TRI_Early(4)
            -1            15       5.39432             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P3_4_CA_TRI_Early(4)
            -1            15       14.2359             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P4_4_CA_TRI_Early(4)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  SizeSel_P5_4_CA_TRI_Early(4)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P6_4_CA_TRI_Early(4)
            14            70       23.1505             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P1_5_CA_TRI_Late(5)
            -6             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P2_5_CA_TRI_Late(5)
            -5            15      -4.10109             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P3_5_CA_TRI_Late(5)
            -1            15       10.3139             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P4_5_CA_TRI_Late(5)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  SizeSel_P5_5_CA_TRI_Late(5)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P6_5_CA_TRI_Late(5)
             5            30        26.852             0             0             0          2          0          0          0          0          0          0          0  #  SizeSel_P1_6_CA_NWFSC(6)
           -12             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P2_6_CA_NWFSC(6)
            -1            15        4.8011             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P3_6_CA_NWFSC(6)
            -1            15       7.93487             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P4_6_CA_NWFSC(6)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  SizeSel_P5_6_CA_NWFSC(6)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P6_6_CA_NWFSC(6)
            35           100       65.7738             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P1_7_CA_HookLine(7)
            -6             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P2_7_CA_HookLine(7)
            -6            15       5.46662             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P3_7_CA_HookLine(7)
            -6            15        6.8943             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P4_7_CA_HookLine(7)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  SizeSel_P5_7_CA_HookLine(7)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P6_7_CA_HookLine(7)
           -30            40      -9.73646             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Peak_7_CA_HookLine(7)
           -15            15    -0.0904599             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Ascend_7_CA_HookLine(7)
           -15            15      -2.00426             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Descend_7_CA_HookLine(7)
           -15            15             0             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Final_7_CA_HookLine(7)
           -15            15             1             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Scale_7_CA_HookLine(7)
            35           100       91.0741             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P1_8_CA_Lam_Research(8)
            -6             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P2_8_CA_Lam_Research(8)
            -6            15       6.55887             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P3_8_CA_Lam_Research(8)
            -6            15          -5.6             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P4_8_CA_Lam_Research(8)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  SizeSel_P5_8_CA_Lam_Research(8)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P6_8_CA_Lam_Research(8)
           -30            40      -27.4041             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Peak_8_CA_Lam_Research(8)
           -15            15      -1.18923             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Ascend_8_CA_Lam_Research(8)
           -15            15       9.63188             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Descend_8_CA_Lam_Research(8)
           -15            15             0             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Final_8_CA_Lam_Research(8)
           -15            15             1             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Scale_8_CA_Lam_Research(8)
             0             1           0.1           0.1            -1             0         -3          0          0          0          0        0.5          0          0  #  AgeSel_P1_1_CA_TRAWL(1)
             0           101           100           100            -1             0         -3          0          0          0          0        0.5          0          0  #  AgeSel_P2_1_CA_TRAWL(1)
             0             1           0.1           0.1            -1             0         -3          0          0          0          0        0.5          0          0  #  AgeSel_P1_2_CA_FIX(2)
             0           101           100           100            -1             0         -3          0          0          0          0        0.5          0          0  #  AgeSel_P2_2_CA_FIX(2)
             0             1           0.1           0.1            -1             0         -3          0          0          0          0        0.5          0          0  #  AgeSel_P1_3_CA_REC(3)
             0           101           100           100            -1             0         -3          0          0          0          0        0.5          0          0  #  AgeSel_P2_3_CA_REC(3)
             0             1           0.1           0.1            -1             0         -3          0          0          0          0        0.5          0          0  #  AgeSel_P1_4_CA_TRI_Early(4)
             0           101           100           100            -1             0         -3          0          0          0          0        0.5          0          0  #  AgeSel_P2_4_CA_TRI_Early(4)
             0             1           0.1           0.1            -1             0         -3          0          0          0          0        0.5          0          0  #  AgeSel_P1_5_CA_TRI_Late(5)
             0           101           100           100            -1             0         -3          0          0          0          0        0.5          0          0  #  AgeSel_P2_5_CA_TRI_Late(5)
             0             1           0.1           0.1            -1             0         -3          0          0          0          0        0.5          0          0  #  AgeSel_P1_6_CA_NWFSC(6)
             0           101           100           100            -1             0         -3          0          0          0          0        0.5          0          0  #  AgeSel_P2_6_CA_NWFSC(6)
             0             1           0.1           0.1            -1             0         -3          0          0          0          0        0.5          0          0  #  AgeSel_P1_7_CA_HookLine(7)
             0           101           100           100            -1             0         -3          0          0          0          0        0.5          0          0  #  AgeSel_P2_7_CA_HookLine(7)
             0             1           0.1           0.1            -1             0         -3          0          0          0          0        0.5          0          0  #  AgeSel_P1_8_CA_Lam_Research(8)
             0           101           100           100            -1             0         -3          0          0          0          0        0.5          0          0  #  AgeSel_P2_8_CA_Lam_Research(8)
# timevary selex parameters 
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type    PHASE  #  parm_name
            -5            15             7             0             0             0      -4  # SizeSel_P3_1_CA_TRAWL(1)_BLK3repl_1973
            -5            15       7.52965             0             0             0      4  # SizeSel_P3_1_CA_TRAWL(1)_BLK3repl_1983
            -5            15       7.12344             0             0             0      4  # SizeSel_P3_1_CA_TRAWL(1)_BLK3repl_1993
            -5            15       3.36683             0             0             0      4  # SizeSel_P3_1_CA_TRAWL(1)_BLK3repl_2003
            -5            15       2.95329             0             0             0      4  # SizeSel_P3_1_CA_TRAWL(1)_BLK3repl_2011
            -5            15       14.4138             0             0             0      4  # SizeSel_P4_1_CA_TRAWL(1)_BLK3repl_1973
            -5            15       6.26799             0             0             0      4  # SizeSel_P4_1_CA_TRAWL(1)_BLK3repl_1983
            -5            15       6.75754             0             0             0      4  # SizeSel_P4_1_CA_TRAWL(1)_BLK3repl_1993
            -5            15       6.43936             0             0             0      4  # SizeSel_P4_1_CA_TRAWL(1)_BLK3repl_2003
            -5            15       8.01456             0             0             0      4  # SizeSel_P4_1_CA_TRAWL(1)_BLK3repl_2011
            10           100       66.6135             0             0             0      4  # Retain_P1_1_CA_TRAWL(1)_BLK2repl_1998
            10           100       67.3478             0             0             0      4  # Retain_P1_1_CA_TRAWL(1)_BLK2repl_2007
            10           100       56.4088             0             0             0      4  # Retain_P1_1_CA_TRAWL(1)_BLK2repl_2010
            10           100       56.5324             0             0             0      4  # Retain_P1_1_CA_TRAWL(1)_BLK2repl_2011
           0.1            10           3.5             0             0             0      -4  # Retain_P2_1_CA_TRAWL(1)_BLK2repl_1998
           0.1            10       2.88578             0             0             0      4  # Retain_P2_1_CA_TRAWL(1)_BLK2repl_2007
           0.1            10      0.713571             0             0             0      4  # Retain_P2_1_CA_TRAWL(1)_BLK2repl_2010
           0.1            10       1.41804             0             0             0      4  # Retain_P2_1_CA_TRAWL(1)_BLK2repl_2011
            -5            15           8.1             0             0             0      -4  # SizeSel_P3_2_CA_FIX(2)_BLK1repl_1998
            -5            15       5.22402             0             0             0      4  # SizeSel_P3_2_CA_FIX(2)_BLK1repl_2002
            -5            15       6.72637             0             0             0      4  # SizeSel_P3_2_CA_FIX(2)_BLK1repl_2003
            -5            15       6.41674             0             0             0      4  # SizeSel_P3_2_CA_FIX(2)_BLK1repl_2011
            -5            15           6.4             0             0             0      -4  # SizeSel_P4_2_CA_FIX(2)_BLK1repl_1998
            -5            15       6.26523             0             0             0      4  # SizeSel_P4_2_CA_FIX(2)_BLK1repl_2002
            -5            15       4.75298             0             0             0      4  # SizeSel_P4_2_CA_FIX(2)_BLK1repl_2003
            -5            15       4.67845             0             0             0      4  # SizeSel_P4_2_CA_FIX(2)_BLK1repl_2011
            10           100       61.3638             0             0             0      4  # Retain_P1_2_CA_FIX(2)_BLK1repl_1998
            10           100       30.2923             0             0             0      4  # Retain_P1_2_CA_FIX(2)_BLK1repl_2002
            10           100       59.7352             0             0             0      4  # Retain_P1_2_CA_FIX(2)_BLK1repl_2003
            10           100         59.58             0             0             0      4  # Retain_P1_2_CA_FIX(2)_BLK1repl_2011
           0.1            10       2.46814             0             0             0      4  # Retain_P2_2_CA_FIX(2)_BLK1repl_1998
           0.1            10       2.06361             0             0             0      4  # Retain_P2_2_CA_FIX(2)_BLK1repl_2002
           0.1            10      0.963062             0             0             0      4  # Retain_P2_2_CA_FIX(2)_BLK1repl_2003
           0.1            10       1.03191             0             0             0      4  # Retain_P2_2_CA_FIX(2)_BLK1repl_2011
            20           100       67.9819             0             0             0      4  # SizeSel_P1_3_CA_REC(3)_BLK4repl_1959
            20           100       69.8458             0             0             0      4  # SizeSel_P1_3_CA_REC(3)_BLK4repl_1975
            20           100       62.9863             0             0             0      4  # SizeSel_P1_3_CA_REC(3)_BLK4repl_1990
            20           100       62.6268             0             0             0      4  # SizeSel_P1_3_CA_REC(3)_BLK4repl_2004
            -1            15        5.7988             0             0             0      4  # SizeSel_P3_3_CA_REC(3)_BLK4repl_1959
            -1            15       5.60374             0             0             0      4  # SizeSel_P3_3_CA_REC(3)_BLK4repl_1975
            -1            15       3.98566             0             0             0      4  # SizeSel_P3_3_CA_REC(3)_BLK4repl_1990
            -1            15       3.93994             0             0             0      4  # SizeSel_P3_3_CA_REC(3)_BLK4repl_2004
            -1            15       7.11886             0             0             0      4  # SizeSel_P4_3_CA_REC(3)_BLK4repl_1959
            -1            15       6.59035             0             0             0      4  # SizeSel_P4_3_CA_REC(3)_BLK4repl_1975
            -1            15       6.53946             0             0             0      4  # SizeSel_P4_3_CA_REC(3)_BLK4repl_1990
            -1            15       5.85994             0             0             0      4  # SizeSel_P4_3_CA_REC(3)_BLK4repl_2004
# info on dev vectors created for selex parms are reported with other devs after tag parameter section 
#
0   #  use 2D_AR1 selectivity(0/1):  experimental feature
#_no 2D_AR1 selex offset used
#
# Tag loss and Tag reporting parameters go next
0  # TG_custom:  0=no read; 1=read if tags exist
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
1 #_sd_offset
# read 0 changes to default Lambdas (default value is 1.0)
# Like_comp codes:  1=surv; 2=disc; 3=mnwt; 4=length; 5=age; 6=SizeFreq; 7=sizeage; 8=catch; 9=init_equ_catch; 
# 10=recrdev; 11=parm_prior; 12=parm_dev; 13=CrashPen; 14=Morphcomp; 15=Tag-comp; 16=Tag-negbin; 17=F_ballpark
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
#  1 #_init_equ_catch
#  1 #_recruitments
#  1 #_parameter-priors
#  1 #_parameter-dev-vectors
#  1 #_crashPenLambda
#  0 # F_ballpark_lambda
0 # (0/1) read specs for more stddev reporting 
 # 0 1 -1 5 1 5 1 -1 5 # placeholder for selex type, len/age, year, N selex bins, Growth pattern, N growth ages, NatAge_area(-1 for all), NatAge_yr, N Natages
 # placeholder for vector of selex bins to be reported
 # placeholder for vector of growth ages to be reported
 # placeholder for vector of NatAges ages to be reported
999

