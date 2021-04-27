#V3.30.03.07-opt
#_data_and_control_files: Ling.dat // Ling.ctl
#_SS-V3.30.03.07-opt;_2017_05_19;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_11.6
#_SS-V3.30.03.07-opt;user_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_SS-V3.30.03.07-opt;user_info_available_at:https://vlab.ncep.noaa.gov/group/stock-synthesis
0  # 0 means do not read wtatage.ss; 1 means read and use wtatage.ss and also read and use growth parameters
1  #_N_Growth_Patterns
1 #_N_platoons_Within_GrowthPattern
#_Cond 1 #_Morph_between/within_stdev_ratio (no read if N_morphs=1)
#_Cond  1 #vector_Morphdist_(-1_in_first_val_gives_normal_approx)
#
2 # recr_dist_method for parameters:  1=like 3.24; 2=main effects for GP, Settle timing, Area; 3=each Settle entity; 4=none when N_GP*Nsettle*pop==1
1 # Recruitment: 1=global; 2=by area (future option)
1 #  number of recruitment settlement assignments
0 # year_x_area_x_settlement_event interaction requested (only for recr_dist_method=1)
#GPat month  area age (for each settlement assignment)
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
1 1 1 1 1 # autogen
# where: 0 = autogen all time-varying parms; 1 = read each time-varying parm line; 2 = read then autogen if min=-12345
# 1st element for biology, 2nd for SR, 3rd for Q, 5th for selex, 4th reserved
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
 10 60 18.0447 0 0 0 2 0 0 0 0 0 0 0 # L_at_Amin_Fem_GP_1
 40 130 93.3872 0 0 0 2 0 0 0 0 0 0 0 # L_at_Amax_Fem_GP_1
 0.01 0.5 0.130148 0 0 0 3 0 0 0 0 0 0 0 # VonBert_K_Fem_GP_1
 0.01 0.5 0.154506 0 0 0 4 0 0 0 0 0 0 0 # CV_young_Fem_GP_1
 0.01 0.5 0.0666821 0 0 0 4 0 0 0 0 0 0 0 # CV_old_Fem_GP_1
 -3 3 3.308e-006 0 0 0 -3 0 0 0 0 0 0 0 # Wtlen_1_Fem
 -3 5 3.248 0 0 0 -3 0 0 0 0 0 0 0 # Wtlen_2_Fem
 -3 100 52.3 0 0 0 -3 0 0 0 0 0 0 0 # Mat50%_Fem
 -5 5 -0.219 0 0 0 -3 0 0 0 0 0 0 0 # Mat_slope_Fem
 -3 3 1 0 0 0 -3 0 0 0 0 0 0 0 # Eggs/kg_inter_Fem
 -3 3 0 0 0 0 -3 0 0 0 0 0 0 0 # Eggs/kg_slope_wt_Fem
 0.15 0.4 0.312427 -1.532 0.438 3 7 0 0 0 0 0 0 0 # NatM_p_1_Mal_GP_1
 10 60 18.2082 0 0 0 2 0 0 0 0 0 0 0 # L_at_Amin_Mal_GP_1
 40 110 84.4198 0 0 0 2 0 0 0 0 0 0 0 # L_at_Amax_Mal_GP_1
 0.01 1 0.155461 0 0 0 3 0 0 0 0 0 0 0 # VonBert_K_Mal_GP_1
 0.01 0.5 0.138404 0 0 0 4 0 0 0 0 0 0 0 # CV_young_Mal_GP_1
 0.01 0.5 0.0887253 0 0 0 4 0 0 0 0 0 0 0 # CV_old_Mal_GP_1
 -3 3 2.179e-006 0 0 0 -3 0 0 0 0 0 0 0 # Wtlen_1_Mal
 -5 5 3.36 0 0 0 -3 0 0 0 0 0 0 0 # Wtlen_2_Mal
 -3 3 0 0 0 0 -4 0 0 0 0 0 0 0 # RecrDist_GP_1
 -3 3 0 0 0 0 -3 0 0 0 0 0 0 0 # RecrDist_Area_1
 0 999 1 0 0 0 -3 0 0 0 0 0 0 0 # RecrDist_Bseas_1
 0 0 0 0 0 0 -4 0 0 0 0 0 0 0 # CohortGrowDev
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
#             5            15       8.45375             0             0             0          1          0          0          0          0          0          0          0 # SR_LN(R0)
             5            15       8.7             0             0             0          1          0          0          0          0          0          0          0 # SR_LN(R0)
           0.2             1           0.7             0             0             0         -4          0          0          0          0          0          0          0 # SR_BH_steep
             0             2           0.75             0             0             0         -3          0          0          0          0          0          0          0 # SR_sigmaR
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
1950   #_last_early_yr_nobias_adj_in_MPD
2001   #_first_yr_fullbias_adj_in_MPD
2015   #_last_yr_fullbias_adj_in_MPD
2017   #_first_recent_yr_nobias_adj_in_MPD
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
#  1889E 1890E 1891E 1892E 1893E 1894E 1895E 1896E 1897E 1898E 1899E 1900E 1901E 1902E 1903E 1904E 1905E 1906E 1907E 1908E 1909E 1910E 1911E 1912E 1913E 1914E 1915E 1916E 1917E 1918E 1919E 1920E 1921E 1922E 1923E 1924E 1925E 1926E 1927E 1928E 1929E 1930E 1931E 1932E 1933E 1934E 1935E 1936E 1937E 1938E 1939E 1940E 1941E 1942E 1943E 1944E 1945E 1946E 1947E 1948E 1949E 1950E 1951E 1952E 1953E 1954E 1955E 1956E 1957E 1958E 1959E 1960E 1961E 1962E 1963E 1964E 1965R 1966R 1967R 1968R 1969R 1970R 1971R 1972R 1973R 1974R 1975R 1976R 1977R 1978R 1979R 1980R 1981R 1982R 1983R 1984R 1985R 1986R 1987R 1988R 1989R 1990R 1991R 1992R 1993R 1994R 1995R 1996R 1997R 1998R 1999R 2000R 2001R 2002R 2003R 2004R 2005R 2006R 2007R 2008R 2009R 2010R 2011R 2012R 2013R 2014R 2015R 2016F 2017F 2018F 2019F 2020F 2021F 2022F 2023F 2024F 2025F 2026F
#  2.0824e-005 2.4388e-005 2.85369e-005 3.33612e-005 3.89642e-005 4.54637e-005 5.29937e-005 6.17066e-005 7.17755e-005 8.33968e-005 9.67936e-005 0.000112218 0.000129953 0.000150318 0.00017367 0.000200411 0.000230991 0.00026591 0.000305723 0.000351067 0.000402596 0.000461109 0.000527414 0.000602462 0.000687227 0.000782842 0.000890512 0.00101153 0.00114733 0.0012995 0.00146963 0.00165957 0.00187132 0.00210703 0.00236907 0.00266038 0.00298488 0.00334753 0.00375533 0.00421702 0.00474026 0.00533705 0.00602447 0.00680675 0.00771332 0.00874121 0.00994957 0.0113468 0.0129334 0.0146929 0.0165751 0.018556 0.0205832 0.0225937 0.0246342 0.0268846 0.0298449 0.0343379 0.0418666 0.0544907 0.0742957 0.0991946 0.12034 0.12274 0.0945718 0.0495237 0.0242954 -0.0505883 -0.286647 -0.277074 0.0102169 0.222497 0.352553 -0.143176 -0.0892492 -0.0659511 -0.0946363 0.0592118 0.134218 0.149759 0.00711739 -0.0162328 -0.121007 0.0968942 0.482147 0.515506 0.262267 0.662656 0.535367 -0.174432 0.683684 -0.155655 -0.442724 -0.439797 0.112462 1.30656 1.04011 0.594476 0.488026 -0.0650014 0.374637 -0.0952299 0.686215 -0.755064 -0.135683 0.259562 -0.455357 0.455865 -0.441799 -0.463087 0.952247 0.402749 0.109987 -0.534846 -0.44106 -1.35158 -1.42834 -1.74912 -1.22717 -0.43359 -0.337305 0.342742 0.262098 0.409265 0.669413 -0.265668 -0.430845 -0.727972 0 0 0 0 0 0 0 0 0 0
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
#_initial_F_parms; count = 0
#_ LO HI INIT PRIOR PR_SD  PR_type  PHASE
#2026 2037
# F rates by fleet
# Yr:  1889 1890 1891 1892 1893 1894 1895 1896 1897 1898 1899 1900 1901 1902 1903 1904 1905 1906 1907 1908 1909 1910 1911 1912 1913 1914 1915 1916 1917 1918 1919 1920 1921 1922 1923 1924 1925 1926 1927 1928 1929 1930 1931 1932 1933 1934 1935 1936 1937 1938 1939 1940 1941 1942 1943 1944 1945 1946 1947 1948 1949 1950 1951 1952 1953 1954 1955 1956 1957 1958 1959 1960 1961 1962 1963 1964 1965 1966 1967 1968 1969 1970 1971 1972 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021 2022 2023 2024 2025 2026
# seas:  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
# 1_CA_TRAWL 0 0.000587506 0.0011764 0.00176804 0.00236365 0.00296434 0.00357107 0.00418466 0.00480583 0.00543516 0.00607319 0.00672039 0.00737717 0.00804392 0.00872102 0.00940883 0.0101077 0.010818 0.01154 0.0122741 0.0130208 0.0137803 0.0145532 0.0153397 0.0161403 0.0169555 0.0177858 0.0186316 0.0194934 0.0203719 0.0212675 0.0221808 0.0231125 0.0240633 0.0250337 0.0260246 0.0270366 0.0280705 0.0291273 0.0302076 0.0313143 0.0324505 0.033618 0.0242748 0.0384018 0.0239442 0.0282492 0.0208804 0.0266791 0.0204568 0.0156707 0.0185765 0.014023 0.00817485 0.018454 0.0189866 0.0177083 0.0292643 0.0503918 0.054733 0.044103 0.0536605 0.0523859 0.0413109 0.0418483 0.0420136 0.0295213 0.0395531 0.0502049 0.0469488 0.0422949 0.0412714 0.0441301 0.0346403 0.0373822 0.0270466 0.0255628 0.0249133 0.0292612 0.0344766 0.0384138 0.0536562 0.0721533 0.122483 0.153287 0.188897 0.189181 0.209415 0.124989 0.133275 0.213682 0.209635 0.194908 0.235364 0.358482 0.41641 0.370274 0.253458 0.350858 0.335653 0.36079 0.377432 0.368013 0.309604 0.388472 0.31127 0.263552 0.247369 0.300035 0.111711 0.104101 0.0316412 0.0227353 0.0270724 0.00876098 0.00914708 0.00935662 0.0114362 0.0215983 0.0196504 0.0222231 0.0145681 0.00195413 0.00466415 0.00595125 0.00762531 0.00738363 0.00593454 0.00957718 0.00882628 0.00345588 0.00330712 0.00322657 0.00320191 0.00319833 0.0031979 0.00319547 0.00319182
# 2_CA_FIX 0 0.00066584 0.00133332 0.0020039 0.00267881 0.003359 0.00404515 0.00473777 0.00543724 0.00614384 0.00685784 0.0075795 0.00830907 0.00904681 0.00979299 0.0105479 0.0113117 0.0120847 0.0128673 0.0136596 0.0144621 0.0152748 0.0160983 0.0169327 0.0177785 0.0186359 0.0195053 0.0203871 0.0212817 0.0221895 0.0231108 0.0240462 0.024996 0.0259608 0.026941 0.0279372 0.0289498 0.0299795 0.0310269 0.0320924 0.033179 0.03429 0.0354264 0.0249952 0.0460721 0.0219594 0.0277532 0.024323 0.0262082 0.0334436 0.0172857 0.0207903 0.0181511 0.00910684 0.0203393 0.01987 0.0203655 0.032746 0.0671866 0.0438245 0.0375108 0.0295785 0.0149554 0.0649916 0.0453283 0.044952 0.00813751 0.0425847 0.0152544 0.0163894 0.013922 0.00801168 0.0159125 0.0122828 0.0144545 0.00820057 0.00809155 0.00767106 0.00727545 0.00616072 0.00836058 0.0081732 0.0160256 0.0275979 0.0238913 0.0382696 0.0490741 0.0302764 0.017936 0.0262531 0.0185286 0.0179719 0.0183599 0.0158912 0.0120194 0.0112907 0.0285693 0.0623146 0.0594577 0.065381 0.12651 0.106881 0.0800656 0.09802 0.0923287 0.078397 0.0990815 0.102357 0.101597 0.0476582 0.0348634 0.0125312 0.0159546 0.0226905 0.0162954 0.015344 0.0116783 0.0100043 0.0104349 0.011407 0.00925153 0.0106748 0.0146275 0.0183937 0.0216178 0.0289238 0.0345663 0.0198238 0.0260389 0.0248506 0.0258689 0.0247553 0.0241524 0.0239678 0.023941 0.0239378 0.0239196 0.0238922
# 3_CA_REC 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.000178934 0.000361077 0.000545525 0.00072916 0.000915985 0.00110389 0.00128045 0.00145589 0.00224251 0.00270744 0.00370954 0.00385519 0.00352774 0.00184389 0.00174059 0.00142294 0.00189058 0.00326912 0.0122397 0.0139466 0.015654 0.0143244 0.0149565 0.0107169 0.00792136 0.0126765 0.0133335 0.0179735 0.021003 0.0235298 0.0187359 0.0161327 0.0165676 0.0165398 0.0162819 0.015111 0.0212197 0.0294385 0.0315864 0.0312378 0.0247346 0.0383273 0.0456875 0.0594657 0.0660622 0.077611 0.112733 0.128945 0.0921065 0.114059 0.120949 0.178772 0.170497 0.139271 0.100342 0.101588 0.249045 0.289719 0.262773 0.238309 0.215992 0.225132 0.285646 0.345176 0.231338 0.137029 0.135073 0.198766 0.165757 0.150344 0.177581 0.0952341 0.0811781 0.185499 0.269727 0.0428517 0.0839591 0.074215 0.0510625 0.0347003 0.0545132 0.0541346 0.121195 0.125436 0.144709 0.141181 0.142492 0.106935 0.129625 0.12854 0.214333 0.205107 0.200111 0.198582 0.19836 0.198333 0.198183 0.197956
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
           -15            15      -1.56334             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_1_CA_TRAWL(1)
         0.001             2     0.0453203             0             0             0          2          0          0          0          0          0          0          0  #  Q_extraSD_1_CA_TRAWL(1)
           -15            15     -0.173425             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_4_CA_TRI_Early(4)
           -15            15      0.197159             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_5_CA_TRI_Late(5)
           -15            15     0.0769686             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_6_CA_NWFSC(6)
           -15            15       -12.608             0             0             0         -1          0          0          0          0          0          0          0  #  LnQ_base_7_CA_HookLine(7)
#_no timevary Q parameters
#
#_size_selex_types
#discard_options:_0=none;_1=define_retention;_2=retention&mortality;_3=all_discarded_dead
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
            14           100        60.039             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P1_1_CA_TRAWL(1)
            -6             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P2_1_CA_TRAWL(1)
            -5            15             7             0             0             0         -3          0          0          0          0          0          3          2  #  SizeSel_P3_1_CA_TRAWL(1)
            -5            15       13.4219             0             0             0          3          0          0          0          0          0          3          2  #  SizeSel_P4_1_CA_TRAWL(1)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  SizeSel_P5_1_CA_TRAWL(1)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P6_1_CA_TRAWL(1)
            10           100       59.8001             0             0             0          4          0          0          0          0          0          2          2  #  Retain_P1_1_CA_TRAWL(1)
           0.1            15             9             0             0             0         -4          0          0          0          0          0          2          2  #  Retain_P2_1_CA_TRAWL(1)
         0.001             1             2             0             0             0         -4          0          0          0          0          0          0          0  #  Retain_P3_1_CA_TRAWL(1)
            -2             2             0             0             0             0         -4          0          0          0          0          0          0          0  #  Retain_P4_1_CA_TRAWL(1)
            -1             1             0             0             0             0         -4          0          0          0          0          0          0          0  #  DiscMort_P1_1_CA_TRAWL(1)
            -1             1        0.0001             0             0             0         -5          0          0          0          0          0          0          0  #  DiscMort_P2_1_CA_TRAWL(1)
         0.001             1           0.5             0             0             0         -6          0          0          0          0          0          0          0  #  DiscMort_P3_1_CA_TRAWL(1)
            -2             2             0             0             0             0         -4          0          0          0          0          0          0          0  #  DiscMort_P4_1_CA_TRAWL(1)
           -30            15      -2.83449             0             0             0          3          0          0          0          0          0          0          0  #  SzSel_Male_Peak_1_CA_TRAWL(1)
           -15            15       3.21655             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Ascend_1_CA_TRAWL(1)
           -15            15      -1.32394             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Descend_1_CA_TRAWL(1)
           -15            15             0             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Final_1_CA_TRAWL(1)
           -15            15             1             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Scale_1_CA_TRAWL(1)
            14           100        85.488             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P1_2_CA_FIX(2)
            -6             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P2_2_CA_FIX(2)
            -5            15       7.55873             0             0             0          3          0          0          0          0          0          1          2  #  SizeSel_P3_2_CA_FIX(2)
            -5            15       5.57109             0             0             0          3          0          0          0          0          0          1          2  #  SizeSel_P4_2_CA_FIX(2)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  SizeSel_P5_2_CA_FIX(2)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P6_2_CA_FIX(2)
            10           100       51.5493             0             0             0          4          0          0          0          0          0          1          2  #  Retain_P1_2_CA_FIX(2)
           0.1            10       2.35376             0             0             0          4          0          0          0          0          0          1          2  #  Retain_P2_2_CA_FIX(2)
         0.001             1             1             0             0             0         -4          0          0          0          0          0          0          0  #  Retain_P3_2_CA_FIX(2)
            -2             2             0             0             0             0         -6          0          0          0          0          0          0          0  #  Retain_P4_2_CA_FIX(2)
            -1             1             0             0             0             0         -4          0          0          0          0          0          0          0  #  DiscMort_P1_2_CA_FIX(2)
            -1             1        0.0001             0             0             0         -5          0          0          0          0          0          0          0  #  DiscMort_P2_2_CA_FIX(2)
         0.001             1          0.07             0             0             0         -6          0          0          0          0          0          0          0  #  DiscMort_P3_2_CA_FIX(2)
            -2             2             0             0             0             0         -4          0          0          0          0          0          0          0  #  DiscMort_P4_2_CA_FIX(2)
           -30            20           -22             0             0             0         -3          0          0          0          0          0          0          0  #  SzSel_Male_Peak_2_CA_FIX(2)
           -15            15      -1.68512             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Ascend_2_CA_FIX(2)
           -15            15      0.253946             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Descend_2_CA_FIX(2)
           -15            15             0             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Final_2_CA_FIX(2)
           -15            15             1             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Scale_2_CA_FIX(2)
            35           100          62.5             0             0             0         -3          0          0          0          0          0          4          2  #  SizeSel_P1_3_CA_REC(3)
           -16             1           -15             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P2_3_CA_REC(3)
            -1            15           5.8             0             0             0         -3          0          0          0          0          0          4          2  #  SizeSel_P3_3_CA_REC(3)
            -1            15           7.2             0             0             0         -3          0          0          0          0          0          4          2  #  SizeSel_P4_3_CA_REC(3)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P5_3_CA_REC(3)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P6_3_CA_REC(3)
            10           100       38.6758             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P1_4_CA_TRI_Early(4)
            -6             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P2_4_CA_TRI_Early(4)
            -1            15       5.39541             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P3_4_CA_TRI_Early(4)
            -1            15       14.1362             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P4_4_CA_TRI_Early(4)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  SizeSel_P5_4_CA_TRI_Early(4)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P6_4_CA_TRI_Early(4)
            14            70       23.1553             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P1_5_CA_TRI_Late(5)
            -6             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P2_5_CA_TRI_Late(5)
            -5            15      -4.13293             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P3_5_CA_TRI_Late(5)
            -1            15       10.0945             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P4_5_CA_TRI_Late(5)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  SizeSel_P5_5_CA_TRI_Late(5)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P6_5_CA_TRI_Late(5)
             5            30       27.8087             0             0             0          2          0          0          0          0          0          0          0  #  SizeSel_P1_6_CA_NWFSC(6)
           -12             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P2_6_CA_NWFSC(6)
            -1            15       5.01911             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P3_6_CA_NWFSC(6)
            -1            15        7.8768             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P4_6_CA_NWFSC(6)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  SizeSel_P5_6_CA_NWFSC(6)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P6_6_CA_NWFSC(6)
            35           100        65.204             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P1_7_CA_HookLine(7)
            -6             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P2_7_CA_HookLine(7)
            -6            15        5.4075             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P3_7_CA_HookLine(7)
            -6            15       6.88136             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P4_7_CA_HookLine(7)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  SizeSel_P5_7_CA_HookLine(7)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P6_7_CA_HookLine(7)
           -30            40      -8.81778             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Peak_7_CA_HookLine(7)
           -15            15    -0.0209894             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Ascend_7_CA_HookLine(7)
           -15            15      -2.07065             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Descend_7_CA_HookLine(7)
           -15            15             0             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Final_7_CA_HookLine(7)
           -15            15             1             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Scale_7_CA_HookLine(7)
            35           100        91.073             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P1_8_CA_Lam_Research(8)
            -6             4           -15             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P2_8_CA_Lam_Research(8)
            -6            15       6.57731             0             0             0          3          0          0          0          0          0          0          0  #  SizeSel_P3_8_CA_Lam_Research(8)
            -6            15          -5.6             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P4_8_CA_Lam_Research(8)
            -5             9          -999             0             0             0         -2          0          0          0          0          0          0          0  #  SizeSel_P5_8_CA_Lam_Research(8)
            -5             9          -999             0             0             0         -3          0          0          0          0          0          0          0  #  SizeSel_P6_8_CA_Lam_Research(8)
           -30            40      -27.4041             0             0             0         -4          0          0          0          0          0          0          0  #  SzSel_Male_Peak_8_CA_Lam_Research(8)
           -15            15      -1.18948             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Ascend_8_CA_Lam_Research(8)
           -15            15       9.59386             0             0             0          4          0          0          0          0          0          0          0  #  SzSel_Male_Descend_8_CA_Lam_Research(8)
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
            -5            15       7.34417             0             0             0      4  # SizeSel_P3_1_CA_TRAWL(1)_BLK3repl_1983
            -5            15       6.87383             0             0             0      4  # SizeSel_P3_1_CA_TRAWL(1)_BLK3repl_1993
            -5            15       3.34065             0             0             0      4  # SizeSel_P3_1_CA_TRAWL(1)_BLK3repl_2003
            -5            15       2.92415             0             0             0      4  # SizeSel_P3_1_CA_TRAWL(1)_BLK3repl_2011
            -5            15       14.4587             0             0             0      4  # SizeSel_P4_1_CA_TRAWL(1)_BLK3repl_1973
            -5            15       6.30307             0             0             0      4  # SizeSel_P4_1_CA_TRAWL(1)_BLK3repl_1983
            -5            15       6.70914             0             0             0      4  # SizeSel_P4_1_CA_TRAWL(1)_BLK3repl_1993
            -5            15       6.42484             0             0             0      4  # SizeSel_P4_1_CA_TRAWL(1)_BLK3repl_2003
            -5            15       7.97683             0             0             0      4  # SizeSel_P4_1_CA_TRAWL(1)_BLK3repl_2011
            10           100       66.9835             0             0             0      4  # Retain_P1_1_CA_TRAWL(1)_BLK2repl_1998
            10           100       67.2427             0             0             0      4  # Retain_P1_1_CA_TRAWL(1)_BLK2repl_2007
            10           100       55.4801             0             0             0      4  # Retain_P1_1_CA_TRAWL(1)_BLK2repl_2010
            10           100       56.4478             0             0             0      4  # Retain_P1_1_CA_TRAWL(1)_BLK2repl_2011
           0.1            10           3.5             0             0             0      -4  # Retain_P2_1_CA_TRAWL(1)_BLK2repl_1998
           0.1            10       2.82238             0             0             0      4  # Retain_P2_1_CA_TRAWL(1)_BLK2repl_2007
           0.1            10      0.421862             0             0             0      4  # Retain_P2_1_CA_TRAWL(1)_BLK2repl_2010
           0.1            10       1.42124             0             0             0      4  # Retain_P2_1_CA_TRAWL(1)_BLK2repl_2011
            -5            15           8.1             0             0             0      -4  # SizeSel_P3_2_CA_FIX(2)_BLK1repl_1998
            -5            15       5.22521             0             0             0      4  # SizeSel_P3_2_CA_FIX(2)_BLK1repl_2002
            -5            15       6.72623             0             0             0      4  # SizeSel_P3_2_CA_FIX(2)_BLK1repl_2003
            -5            15       6.42531             0             0             0      4  # SizeSel_P3_2_CA_FIX(2)_BLK1repl_2011
            -5            15           6.4             0             0             0      -4  # SizeSel_P4_2_CA_FIX(2)_BLK1repl_1998
            -5            15       6.27276             0             0             0      4  # SizeSel_P4_2_CA_FIX(2)_BLK1repl_2002
            -5            15       4.76146             0             0             0      4  # SizeSel_P4_2_CA_FIX(2)_BLK1repl_2003
            -5            15        4.6878             0             0             0      4  # SizeSel_P4_2_CA_FIX(2)_BLK1repl_2011
            10           100       61.3545             0             0             0      4  # Retain_P1_2_CA_FIX(2)_BLK1repl_1998
            10           100       30.3236             0             0             0      4  # Retain_P1_2_CA_FIX(2)_BLK1repl_2002
            10           100       59.7349             0             0             0      4  # Retain_P1_2_CA_FIX(2)_BLK1repl_2003
            10           100       59.5658             0             0             0      4  # Retain_P1_2_CA_FIX(2)_BLK1repl_2011
           0.1            10       2.45302             0             0             0      4  # Retain_P2_2_CA_FIX(2)_BLK1repl_1998
           0.1            10       2.06428             0             0             0      4  # Retain_P2_2_CA_FIX(2)_BLK1repl_2002
           0.1            10      0.967027             0             0             0      4  # Retain_P2_2_CA_FIX(2)_BLK1repl_2003
           0.1            10       1.03008             0             0             0      4  # Retain_P2_2_CA_FIX(2)_BLK1repl_2011
            20           100        67.901             0             0             0      4  # SizeSel_P1_3_CA_REC(3)_BLK4repl_1959
            20           100       69.4891             0             0             0      4  # SizeSel_P1_3_CA_REC(3)_BLK4repl_1975
            20           100       62.9236             0             0             0      4  # SizeSel_P1_3_CA_REC(3)_BLK4repl_1990
            20           100       62.5491             0             0             0      4  # SizeSel_P1_3_CA_REC(3)_BLK4repl_2004
            -1            15       5.79424             0             0             0      4  # SizeSel_P3_3_CA_REC(3)_BLK4repl_1959
            -1            15       5.58586             0             0             0      4  # SizeSel_P3_3_CA_REC(3)_BLK4repl_1975
            -1            15       3.98131             0             0             0      4  # SizeSel_P3_3_CA_REC(3)_BLK4repl_1990
            -1            15       3.93179             0             0             0      4  # SizeSel_P3_3_CA_REC(3)_BLK4repl_2004
            -1            15       7.12666             0             0             0      4  # SizeSel_P4_3_CA_REC(3)_BLK4repl_1959
            -1            15       6.56023             0             0             0      4  # SizeSel_P4_3_CA_REC(3)_BLK4repl_1975
            -1            15       6.48809             0             0             0      4  # SizeSel_P4_3_CA_REC(3)_BLK4repl_1990
            -1            15       5.84472             0             0             0      4  # SizeSel_P4_3_CA_REC(3)_BLK4repl_2004
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
4	1	0.2161884	#	1_CA_TRAWL
4	2	0.3665255	#	2_CA_FIX
4	3	0.024608	#	3_CA_REC
4	4	0.98500575	#	4_CA_TRI_Early
4	5	2.70218	#	5_CA_TRI_Late
4	6	0.1251068	#	6_CA_NWFSC
4	7	0.21038892	#	7_CA_HookLine
4	8	0.89	#	8_CA_Lam_Research
5	5	0.31992
5	6	0.29841
5	8	0.34
 -9999   1    0  # terminator
#
1 #_maxlambdaphase
1 #_sd_offset
# read 12 changes to default Lambdas (default value is 1.0)
# Like_comp codes:  1=surv; 2=disc; 3=mnwt; 4=length; 5=age; 6=SizeFreq; 7=sizeage; 8=catch; 9=init_equ_catch;
# 10=recrdev; 11=parm_prior; 12=parm_dev; 13=CrashPen; 14=Morphcomp; 15=Tag-comp; 16=Tag-negbin; 17=F_ballpark
#like_comp fleet  phase  value  sizefreq_method
-9999  1  1  1  1  #  terminator
#
0 # (0/1) read specs for more stddev reporting
 # 0 1 -1 5 1 5 1 -1 5 # placeholder for selex type, len/age, year, N selex bins, Growth pattern, N growth ages, NatAge_area(-1 for all), NatAge_yr, N Natages
 # placeholder for vector of selex bins to be reported
 # placeholder for vector of growth ages to be reported
 # placeholder for vector of NatAges ages to be reported
999

