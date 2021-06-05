#V3.30.16.02;_2020_09_21;_safe;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.2
#Stock Synthesis (SS) is a work of the U.S. Government and is not subject to copyright protection in the United States.
#Foreign copyrights may apply. See copyright.txt for more information.
#_user_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_user_info_available_at:https://vlab.ncep.noaa.gov/group/stock-synthesis
#C file created using the SS_writectl function in the R package r4ss
#C file write time: 2021-05-26 09:16:12
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
 4 4 5 4 1 #_blocks_per_pattern 
# begin and end years of blocks
 1998 2001 2002 2002 2003 2010 2011 2016
 1998 2006 2007 2009 2010 2010 2011 2016
 1973 1982 1983 1992 1993 2002 2003 2010 2011 2016
 1959 1974 1975 1989 1990 2003 2004 2016
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
 10 60 17.9705 0 0 0 2 0 0 0 0 0 0 0 # L_at_Amin_Fem_GP_1
 40 130 93.1439 0 0 0 2 0 0 0 0 0 0 0 # L_at_Amax_Fem_GP_1
 0.01 0.5 0.132986 0 0 0 3 0 0 0 0 0 0 0 # VonBert_K_Fem_GP_1
 0.01 0.5 0.154816 0 0 0 4 0 0 0 0 0 0 0 # CV_young_Fem_GP_1
 0.01 0.5 0.0680513 0 0 0 4 0 0 0 0 0 0 0 # CV_old_Fem_GP_1
# Sex: 1  BioPattern: 1  WtLen
 -3 3 3.308e-06 0 0 0 -3 0 0 0 0 0 0 0 # Wtlen_1_Fem_GP_1
 -3 5 3.248 0 0 0 -3 0 0 0 0 0 0 0 # Wtlen_2_Fem_GP_1
# Sex: 1  BioPattern: 1  Maturity&Fecundity
 -3 100 52.3 0 0 0 -3 0 0 0 0 0 0 0 # Mat50%_Fem_GP_1
 -5 5 -0.219 0 0 0 -3 0 0 0 0 0 0 0 # Mat_slope_Fem_GP_1
 -3 3 1 0 0 0 -3 0 0 0 0 0 0 0 # Eggs/kg_inter_Fem_GP_1
 -3 3 0 0 0 0 -3 0 0 0 0 0 0 0 # Eggs/kg_slope_wt_Fem_GP_1
# Sex: 2  BioPattern: 1  NatMort
 0.15 0.4 0.312284 -1.532 0.438 3 7 0 0 0 0 0 0 0 # NatM_p_1_Mal_GP_1
# Sex: 2  BioPattern: 1  Growth
 10 60 18.1154 0 0 0 2 0 0 0 0 0 0 0 # L_at_Amin_Mal_GP_1
 40 110 83.7616 0 0 0 2 0 0 0 0 0 0 0 # L_at_Amax_Mal_GP_1
 0.01 1 0.162097 0 0 0 3 0 0 0 0 0 0 0 # VonBert_K_Mal_GP_1
 0.01 0.5 0.138272 0 0 0 4 0 0 0 0 0 0 0 # CV_young_Mal_GP_1
 0.01 0.5 0.0900029 0 0 0 4 0 0 0 0 0 0 0 # CV_old_Mal_GP_1
# Sex: 2  BioPattern: 1  WtLen
 -3 3 2.179e-06 0 0 0 -3 0 0 0 0 0 0 0 # Wtlen_1_Mal_GP_1
 -5 5 3.36 0 0 0 -3 0 0 0 0 0 0 0 # Wtlen_2_Mal_GP_1
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
             5            15       8.50799             0             0             0          1          0          0          0          0          0          0          0 # SR_LN(R0)
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
#  1889E 1890E 1891E 1892E 1893E 1894E 1895E 1896E 1897E 1898E 1899E 1900E 1901E 1902E 1903E 1904E 1905E 1906E 1907E 1908E 1909E 1910E 1911E 1912E 1913E 1914E 1915E 1916E 1917E 1918E 1919E 1920E 1921E 1922E 1923E 1924E 1925E 1926E 1927E 1928E 1929E 1930E 1931E 1932E 1933E 1934E 1935E 1936E 1937E 1938E 1939E 1940E 1941E 1942E 1943E 1944E 1945E 1946E 1947E 1948E 1949E 1950E 1951E 1952E 1953E 1954E 1955E 1956E 1957E 1958E 1959E 1960E 1961E 1962E 1963E 1964E 1965R 1966R 1967R 1968R 1969R 1970R 1971R 1972R 1973R 1974R 1975R 1976R 1977R 1978R 1979R 1980R 1981R 1982R 1983R 1984R 1985R 1986R 1987R 1988R 1989R 1990R 1991R 1992R 1993R 1994R 1995R 1996R 1997R 1998R 1999R 2000R 2001R 2002R 2003R 2004R 2005R 2006R 2007R 2008R 2009R 2010R 2011R 2012R 2013R 2014R 2015R 2016F 2017F 2018F 2019F 2020F 2021F
#  1.70032e-05 1.99295e-05 2.33397e-05 2.73091e-05 3.19242e-05 3.72837e-05 4.35007e-05 5.07039e-05 5.90397e-05 6.86748e-05 7.97983e-05 9.26242e-05 0.000107395 0.000124384 0.000143899 0.000166287 0.000191937 0.000221282 0.00025481 0.000293078 0.000336663 0.000386268 0.000442618 0.000506554 0.000578959 0.000660846 0.000753307 0.000857519 0.000974801 0.0011066 0.00125443 0.00142001 0.00160527 0.00181226 0.00204322 0.00230093 0.00258894 0.00291172 0.00327558 0.00368852 0.00415779 0.00469422 0.00531278 0.00601781 0.00683542 0.00776519 0.00885569 0.0101211 0.0115584 0.0131524 0.0148587 0.016659 0.0185162 0.0203786 0.0223143 0.0245324 0.0275742 0.0323492 0.0404814 0.0541208 0.0752353 0.101747 0.122679 0.122099 0.0885639 0.0380284 0.0105129 -0.0672418 -0.320971 -0.317021 -0.0112327 0.199758 0.342157 -0.186767 -0.132545 -0.102662 -0.151473 0.0126269 0.0861613 0.103248 -0.0458854 -0.0543751 -0.168577 0.056735 0.463529 0.479227 0.180298 0.720932 0.615216 -0.262498 0.699247 -0.134891 -0.440254 -0.499817 -0.0267782 1.44902 1.13969 0.295692 0.520713 -0.122916 0.491959 -0.177622 0.844817 -0.860214 -0.115701 0.276633 -0.453197 0.482454 -0.410077 -0.440388 0.990079 0.455066 0.184898 -0.466495 -0.388491 -1.31798 -1.41091 -1.7687 -1.23188 -0.392748 -0.318372 0.395218 0.271661 0.424924 0.717638 -0.258169 -0.439278 -0.840829 0 0 0 0 0
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
# 1_Comm_Trawl 0 0.000567784 0.00113686 0.00170847 0.00228377 0.00286379 0.00344939 0.00404134 0.00464031 0.00524678 0.00586131 0.00648428 0.00711608 0.00775705 0.00840752 0.00906776 0.00973818 0.010419 0.0111106 0.0118133 0.0125274 0.0132532 0.013991 0.0147412 0.0155043 0.0162806 0.0170704 0.0178743 0.0186925 0.0195258 0.0203744 0.0212389 0.0221198 0.0230176 0.023933 0.0248666 0.0258189 0.0267906 0.0277824 0.0287951 0.0298307 0.0308925 0.0319815 0.0230851 0.0365014 0.0227486 0.0268415 0.019843 0.0253596 0.0194469 0.0149034 0.0176782 0.0133533 0.00779236 0.0176065 0.0181232 0.0169105 0.027946 0.0480503 0.0520594 0.0418638 0.0508475 0.0495619 0.0390166 0.0394466 0.0395315 0.0277526 0.0371691 0.0471457 0.0440915 0.0397602 0.0388848 0.0417102 0.0328748 0.035644 0.0259092 0.024598 0.0240772 0.0284093 0.0336466 0.0377097 0.0529966 0.0716876 0.122363 0.153716 0.190466 0.191877 0.213635 0.128195 0.137195 0.219513 0.213365 0.196288 0.235223 0.349824 0.403552 0.357769 0.245409 0.334541 0.316851 0.345878 0.372382 0.36824 0.307788 0.388669 0.305881 0.254852 0.237109 0.285934 0.100625 0.0937634 0.0285102 0.0206258 0.024434 0.00777333 0.0081173 0.00833545 0.0101739 0.019539 0.0177712 0.0201279 0.0136213 0.00181141 0.00434098 0.00554145 0.00710235 0.006912 0.0055734 0 0 0 0 0
# 2_Comm_Fix 0 0.000620982 0.00124342 0.00186861 0.00249766 0.0031314 0.00377047 0.00441531 0.00506627 0.00572361 0.00638757 0.00705838 0.00773629 0.00842142 0.00911408 0.00981454 0.0105229 0.0112394 0.0119645 0.0126981 0.0134408 0.0141925 0.0149536 0.0157245 0.0165052 0.0172963 0.0180978 0.0189102 0.0197338 0.0205688 0.0214157 0.0222748 0.0231465 0.0240311 0.0249291 0.0258408 0.0267668 0.0277073 0.028663 0.0296344 0.0306236 0.0316337 0.0326653 0.0230451 0.0424635 0.0202341 0.0255829 0.0224295 0.0241774 0.0308559 0.0159556 0.0192039 0.0167766 0.00842599 0.0188347 0.0184056 0.0188691 0.0303314 0.0621053 0.0403892 0.0344984 0.0271621 0.0137188 0.0595296 0.0414352 0.0410198 0.00742339 0.0388709 0.0139323 0.0149927 0.0127673 0.00737779 0.0147261 0.0114172 0.0134861 0.00767661 0.00761349 0.00726078 0.00692388 0.00589609 0.00804817 0.00791134 0.0155931 0.0269943 0.0234749 0.0377586 0.0485506 0.0299311 0.0177637 0.0261998 0.0183948 0.0175245 0.0177325 0.0152746 0.0115207 0.0107871 0.0272735 0.0598251 0.0548619 0.0584274 0.115066 0.100189 0.0765554 0.0935065 0.0878605 0.0731403 0.0912096 0.0935749 0.0921568 0.0430976 0.0314801 0.0113183 0.014481 0.0204076 0.0146661 0.0137733 0.0104812 0.00895636 0.00933762 0.0102242 0.00831151 0.00963065 0.0133012 0.0168306 0.019855 0.0265587 0.0318709 0.0183721 0 0 0 0 0
# 3_Rec_WA 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
# 4_Rec_OR 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
# 5_Rec_CA 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.000167401 0.000337647 0.000509881 0.000681442 0.000855749 0.00103103 0.0011963 0.00136059 0.00209635 0.00253121 0.00346958 0.00360802 0.00330347 0.0017283 0.00163273 0.00133517 0.00177445 0.00306779 0.0114664 0.0130329 0.0146024 0.0133437 0.0139161 0.00995488 0.00734337 0.0117328 0.0123393 0.0166452 0.0194651 0.0218416 0.017403 0.0150477 0.0155259 0.0155644 0.0153736 0.0143173 0.0202055 0.028189 0.0304127 0.0302492 0.0240928 0.0375414 0.0449856 0.0588441 0.0656594 0.0774388 0.108925 0.124567 0.0894368 0.111698 0.118083 0.172031 0.162233 0.131743 0.0947886 0.0956905 0.23359 0.269274 0.23641 0.210677 0.19409 0.21542 0.280342 0.33793 0.224516 0.130687 0.125856 0.18366 0.152388 0.13828 0.163125 0.0875759 0.074791 0.169795 0.245087 0.0387932 0.075932 0.066958 0.0461227 0.0314718 0.0497679 0.0499029 0.112494 0.116691 0.134188 0.130935 0.133016 0.100155 0 0 0 0 0
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
         6         1         0         0         0         1  #  6_Surv_TRI
         7         1         0         0         0         1  #  7_Surv_WCGBTS
         8         1         0         0         0         1  #  8_Surv_HookLine
-9999 0 0 0 0 0
#
#_Q_parms(if_any);Qunits_are_ln(q)
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type      PHASE    env-var    use_dev   dev_mnyr   dev_mxyr     dev_PH      Block    Blk_Fxn  #  parm_name
           -15            15      -1.58822             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_1_Comm_Trawl(1)
             0             2     0.0570477             0             0             0          2          0          0          0          0          0          0          0  #  Q_extraSD_1_Comm_Trawl(1)
           -15            15    -0.0304018             0             0             0         -1          0          0          0          0          0          5          2  #  LnQ_base_6_Surv_TRI(6)
           -15            15     0.0280052             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_7_Surv_WCGBTS(7)
           -15            15      -11.7984             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_8_Surv_HookLine(8)
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
 0 0 0 0 # 3 3_Rec_WA
 0 0 0 0 # 4 4_Rec_OR
 24 0 0 0 # 5 5_Rec_CA
 24 0 0 0 # 6 6_Surv_TRI
 24 0 0 0 # 7 7_Surv_WCGBTS
 24 0 3 0 # 8 8_Surv_HookLine
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
            14           100       59.6814             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_peak_1_Comm_Trawl(1)
            -6             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_1_Comm_Trawl(1)
            -5            15             7             0             0             0         -3          0          0          0          0          0          3          2  #  Size_DblN_ascend_se_1_Comm_Trawl(1)
            -5            15       12.8659             0             0             0          3          0          0          0          0          0          3          2  #  Size_DblN_descend_se_1_Comm_Trawl(1)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_1_Comm_Trawl(1)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_1_Comm_Trawl(1)
            10           100       60.3225             0             0             0          4          0          0          0          0          0          2          2  #  Retain_L_infl_1_Comm_Trawl(1)
           0.1            15             9             0             0             0         -4          0          0          0          0          0          2          2  #  Retain_L_width_1_Comm_Trawl(1)
           -10            10             2           -10             0             0         -4          0          0          0          0          0          0          0  #  Retain_L_asymptote_logit_1_Comm_Trawl(1)
            -2             2             0             0             0             0         -4          0          0          0          0          0          0          0  #  Retain_L_maleoffset_1_Comm_Trawl(1)
            -1             1             0             0             0             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_infl_1_Comm_Trawl(1)
            -1             1        0.0001             0             0             0         -5          0          0          0          0          0          0          0  #  DiscMort_L_width_1_Comm_Trawl(1)
         0.001             1           0.5             0             0             0         -6          0          0          0          0          0          0          0  #  DiscMort_L_level_old_1_Comm_Trawl(1)
            -2             2             0             0             0             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_male_offset_1_Comm_Trawl(1)
           -30            15      -3.49438             0             0             0          3          0          0          0          0          0          0          0  #  SzSel_Male_Peak_1_Comm_Trawl(1)
           -15            15        3.3011             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Ascend_1_Comm_Trawl(1)
           -15            15      -1.22492             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Descend_1_Comm_Trawl(1)
           -15            15             0             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Final_1_Comm_Trawl(1)
           -15            15             1             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Scale_1_Comm_Trawl(1)
# 2   2_Comm_Fix LenSelex
            14           100       85.3002             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_peak_2_Comm_Fix(2)
            -6             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_2_Comm_Fix(2)
            -5            15        7.6929             0             0             0          3          0          0          0          0          0          1          2  #  Size_DblN_ascend_se_2_Comm_Fix(2)
            -5            15       5.60634             0             0             0          3          0          0          0          0          0          1          2  #  Size_DblN_descend_se_2_Comm_Fix(2)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_2_Comm_Fix(2)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_2_Comm_Fix(2)
            10           100       51.7181             0             0             0          4          0          0          0          0          0          1          2  #  Retain_L_infl_2_Comm_Fix(2)
           0.1            10       2.34165             0             0             0          4          0          0          0          0          0          1          2  #  Retain_L_width_2_Comm_Fix(2)
           -10            10             1           -10             0             0         -4          0          0          0          0          0          0          0  #  Retain_L_asymptote_logit_2_Comm_Fix(2)
            -2             2             0             0             0             0         -6          0          0          0          0          0          0          0  #  Retain_L_maleoffset_2_Comm_Fix(2)
            -1             1             0             0             0             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_infl_2_Comm_Fix(2)
            -1             1        0.0001             0             0             0         -5          0          0          0          0          0          0          0  #  DiscMort_L_width_2_Comm_Fix(2)
         0.001             1          0.07             0             0             0         -6          0          0          0          0          0          0          0  #  DiscMort_L_level_old_2_Comm_Fix(2)
            -2             2             0             0             0             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_male_offset_2_Comm_Fix(2)
           -30            20           -22             0             0             0         -3          0          0          0          0          0          0          0  #  SzSel_Male_Peak_2_Comm_Fix(2)
           -15            15      -1.70471             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Ascend_2_Comm_Fix(2)
           -15            15      0.241749             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Descend_2_Comm_Fix(2)
           -15            15             0             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Final_2_Comm_Fix(2)
           -15            15             1             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Scale_2_Comm_Fix(2)
# 3   3_Rec_WA LenSelex
# 4   4_Rec_OR LenSelex
# 5   5_Rec_CA LenSelex
            35           100          62.5             0             0             0         -3          0          0          0          0          0          4          2  #  Size_DblN_peak_5_Rec_CA(5)
           -16             1           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_5_Rec_CA(5)
            -1            15           5.8             0             0             0         -3          0          0          0          0          0          4          2  #  Size_DblN_ascend_se_5_Rec_CA(5)
            -1            15           7.2             0             0             0         -3          0          0          0          0          0          4          2  #  Size_DblN_descend_se_5_Rec_CA(5)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_start_logit_5_Rec_CA(5)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_5_Rec_CA(5)
# 6   6_Surv_TRI LenSelex
            10           100       38.8285             0             0             0          3          0          0          0          0          0          5          2  #  Size_DblN_peak_6_Surv_TRI(6)
            -6             4           -15             0             0             0         -3          0          0          0          0          0          5          2  #  Size_DblN_top_logit_6_Surv_TRI(6)
            -1            15       5.35501             0             0             0          3          0          0          0          0          0          5          2  #  Size_DblN_ascend_se_6_Surv_TRI(6)
            -1            15       10.2719             0             0             0          3          0          0          0          0          0          5          2  #  Size_DblN_descend_se_6_Surv_TRI(6)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          5          2  #  Size_DblN_start_logit_6_Surv_TRI(6)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          5          2  #  Size_DblN_end_logit_6_Surv_TRI(6)
# 7   7_Surv_WCGBTS LenSelex
             5            30       26.4856             0             0             0          2          0          0          0          0          0          0          0  #  Size_DblN_peak_7_Surv_WCGBTS(7)
           -12             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_7_Surv_WCGBTS(7)
            -1            15       4.73955             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_ascend_se_7_Surv_WCGBTS(7)
            -1            15       7.87997             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_descend_se_7_Surv_WCGBTS(7)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_7_Surv_WCGBTS(7)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_7_Surv_WCGBTS(7)
# 8   8_Surv_HookLine LenSelex
            35           100       65.4813             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_peak_8_Surv_HookLine(8)
            -6             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_8_Surv_HookLine(8)
            -6            15       5.46617             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_ascend_se_8_Surv_HookLine(8)
            -6            15       6.88126             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_descend_se_8_Surv_HookLine(8)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_8_Surv_HookLine(8)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_8_Surv_HookLine(8)
           -30            40      -10.2955             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Peak_8_Surv_HookLine(8)
           -15            15      -0.15293             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Ascend_8_Surv_HookLine(8)
           -15            15      -1.93348             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Descend_8_Surv_HookLine(8)
           -15            15             0             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Final_8_Surv_HookLine(8)
           -15            15             1             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Scale_8_Surv_HookLine(8)
# 9   9_Research_Lam LenSelex
            35           100       90.9409             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_peak_9_Research_Lam(9)
            -6             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_9_Research_Lam(9)
            -6            15       6.57956             0             0             0          3          0          0          0          0          0          0          0  #  Size_DblN_ascend_se_9_Research_Lam(9)
            -6            15          -5.6             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_descend_se_9_Research_Lam(9)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  Size_DblN_start_logit_9_Research_Lam(9)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  Size_DblN_end_logit_9_Research_Lam(9)
           -30            40      -27.4041             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Peak_9_Research_Lam(9)
           -15            15      -1.19061             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Ascend_9_Research_Lam(9)
           -15            15       9.62766             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Descend_9_Research_Lam(9)
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
            -5            15             7             0             0             0      -4  # Size_DblN_ascend_se_1_Comm_Trawl(1)_BLK3repl_1973
            -5            15       7.88177             0             0             0      4  # Size_DblN_ascend_se_1_Comm_Trawl(1)_BLK3repl_1983
            -5            15       6.74428             0             0             0      4  # Size_DblN_ascend_se_1_Comm_Trawl(1)_BLK3repl_1993
            -5            15       3.22239             0             0             0      4  # Size_DblN_ascend_se_1_Comm_Trawl(1)_BLK3repl_2003
            -5            15       2.79792             0             0             0      4  # Size_DblN_ascend_se_1_Comm_Trawl(1)_BLK3repl_2011
            -5            15       14.4736             0             0             0      4  # Size_DblN_descend_se_1_Comm_Trawl(1)_BLK3repl_1973
            -5            15       6.37403             0             0             0      4  # Size_DblN_descend_se_1_Comm_Trawl(1)_BLK3repl_1983
            -5            15        6.7172             0             0             0      4  # Size_DblN_descend_se_1_Comm_Trawl(1)_BLK3repl_1993
            -5            15       6.44458             0             0             0      4  # Size_DblN_descend_se_1_Comm_Trawl(1)_BLK3repl_2003
            -5            15       7.93518             0             0             0      4  # Size_DblN_descend_se_1_Comm_Trawl(1)_BLK3repl_2011
            10           100       66.6685             0             0             0      4  # Retain_L_infl_1_Comm_Trawl(1)_BLK2repl_1998
            10           100        67.328             0             0             0      4  # Retain_L_infl_1_Comm_Trawl(1)_BLK2repl_2007
            10           100        56.452             0             0             0      4  # Retain_L_infl_1_Comm_Trawl(1)_BLK2repl_2010
            10           100       56.5152             0             0             0      4  # Retain_L_infl_1_Comm_Trawl(1)_BLK2repl_2011
           0.1            10           3.5             0             0             0      -4  # Retain_L_width_1_Comm_Trawl(1)_BLK2repl_1998
           0.1            10       2.88985             0             0             0      4  # Retain_L_width_1_Comm_Trawl(1)_BLK2repl_2007
           0.1            10      0.718992             0             0             0      4  # Retain_L_width_1_Comm_Trawl(1)_BLK2repl_2010
           0.1            10       1.41442             0             0             0      4  # Retain_L_width_1_Comm_Trawl(1)_BLK2repl_2011
            -5            15           8.1             0             0             0      -4  # Size_DblN_ascend_se_2_Comm_Fix(2)_BLK1repl_1998
            -5            15       5.21465             0             0             0      4  # Size_DblN_ascend_se_2_Comm_Fix(2)_BLK1repl_2002
            -5            15       6.73704             0             0             0      4  # Size_DblN_ascend_se_2_Comm_Fix(2)_BLK1repl_2003
            -5            15        6.4303             0             0             0      4  # Size_DblN_ascend_se_2_Comm_Fix(2)_BLK1repl_2011
            -5            15           6.4             0             0             0      -4  # Size_DblN_descend_se_2_Comm_Fix(2)_BLK1repl_1998
            -5            15       6.32463             0             0             0      4  # Size_DblN_descend_se_2_Comm_Fix(2)_BLK1repl_2002
            -5            15       4.77439             0             0             0      4  # Size_DblN_descend_se_2_Comm_Fix(2)_BLK1repl_2003
            -5            15       4.69575             0             0             0      4  # Size_DblN_descend_se_2_Comm_Fix(2)_BLK1repl_2011
            10           100       61.1565             0             0             0      4  # Retain_L_infl_2_Comm_Fix(2)_BLK1repl_1998
            10           100       30.3654             0             0             0      4  # Retain_L_infl_2_Comm_Fix(2)_BLK1repl_2002
            10           100       59.7286             0             0             0      4  # Retain_L_infl_2_Comm_Fix(2)_BLK1repl_2003
            10           100       59.5833             0             0             0      4  # Retain_L_infl_2_Comm_Fix(2)_BLK1repl_2011
           0.1            10       2.38799             0             0             0      4  # Retain_L_width_2_Comm_Fix(2)_BLK1repl_1998
           0.1            10       2.06189             0             0             0      4  # Retain_L_width_2_Comm_Fix(2)_BLK1repl_2002
           0.1            10      0.967701             0             0             0      4  # Retain_L_width_2_Comm_Fix(2)_BLK1repl_2003
           0.1            10       1.03191             0             0             0      4  # Retain_L_width_2_Comm_Fix(2)_BLK1repl_2011
            20           100       67.4769             0             0             0      4  # Size_DblN_peak_5_Rec_CA(5)_BLK4repl_1959
            20           100       68.8929             0             0             0      4  # Size_DblN_peak_5_Rec_CA(5)_BLK4repl_1975
            20           100       62.8516             0             0             0      4  # Size_DblN_peak_5_Rec_CA(5)_BLK4repl_1990
            20           100       62.4726             0             0             0      4  # Size_DblN_peak_5_Rec_CA(5)_BLK4repl_2004
            -1            15       5.77725             0             0             0      4  # Size_DblN_ascend_se_5_Rec_CA(5)_BLK4repl_1959
            -1            15       5.59441             0             0             0      4  # Size_DblN_ascend_se_5_Rec_CA(5)_BLK4repl_1975
            -1            15       3.97367             0             0             0      4  # Size_DblN_ascend_se_5_Rec_CA(5)_BLK4repl_1990
            -1            15        3.9229             0             0             0      4  # Size_DblN_ascend_se_5_Rec_CA(5)_BLK4repl_2004
            -1            15       7.14334             0             0             0      4  # Size_DblN_descend_se_5_Rec_CA(5)_BLK4repl_1959
            -1            15       6.72523             0             0             0      4  # Size_DblN_descend_se_5_Rec_CA(5)_BLK4repl_1975
            -1            15       6.46699             0             0             0      4  # Size_DblN_descend_se_5_Rec_CA(5)_BLK4repl_1990
            -1            15       5.83227             0             0             0      4  # Size_DblN_descend_se_5_Rec_CA(5)_BLK4repl_2004
            14            70       23.1593             0             0             0      3  # Size_DblN_peak_6_Surv_TRI(6)_BLK5repl_1995
            -6             4           -15             0             0             0      -3  # Size_DblN_top_logit_6_Surv_TRI(6)_BLK5repl_1995
            -5            15      -4.02921             0             0             0      3  # Size_DblN_ascend_se_6_Surv_TRI(6)_BLK5repl_1995
            -1            15       10.0947             0             0             0      3  # Size_DblN_descend_se_6_Surv_TRI(6)_BLK5repl_1995
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
#      3     3     1     5     2     0     0     0     0     0     0     0
#      5     3     2     3     2     0     0     0     0     0     0     0
#      5     4     7     3     2     0     0     0     0     0     0     0
#      5     7    12     2     2     0     0     0     0     0     0     0
#      5     8    16     2     2     0     0     0     0     0     0     0
#      5    22    20     1     2     0     0     0     0     0     0     0
#      5    23    24     1     2     0     0     0     0     0     0     0
#      5    26    28     1     2     0     0     0     0     0     0     0
#      5    27    32     1     2     0     0     0     0     0     0     0
#      5    39    36     4     2     0     0     0     0     0     0     0
#      5    41    40     4     2     0     0     0     0     0     0     0
#      5    42    44     4     2     0     0     0     0     0     0     0
#      5    45    48     5     2     0     0     0     0     0     0     0
#      5    46    49     5     2     0     0     0     0     0     0     0
#      5    47    50     5     2     0     0     0     0     0     0     0
#      5    48    51     5     2     0     0     0     0     0     0     0
#      5    49    52     5     2     0     0     0     0     0     0     0
#      5    50    53     5     2     0     0     0     0     0     0     0
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
      4      5  0.024608
      4      6   1.84359
      4      7  0.125107
      4      8  0.210389
      4      9      0.89
      5      6   0.31992
      5      7   0.29841
      5      9      0.34
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
#  0 #_CPUE/survey:_4
#  0 #_CPUE/survey:_5
#  1 #_CPUE/survey:_6
#  1 #_CPUE/survey:_7
#  1 #_CPUE/survey:_8
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
#  0 #_lencomp:_3
#  0 #_lencomp:_4
#  1 #_lencomp:_5
#  1 #_lencomp:_6
#  1 #_lencomp:_7
#  1 #_lencomp:_8
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
