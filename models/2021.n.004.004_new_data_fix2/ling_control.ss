#V3.30
#C 2021 Lingcod control with renumbered fleets
#C 2021 and catchability parameters added for new indices
#
0 # 0 means do not read wtatage.ss; 1 means read and usewtatage.ss and also read and use growth parameters
1 #_N_Growth_Patterns
1 #_N_platoons_Within_GrowthPattern
4 # recr_dist_method for parameters
1 # not yet implemented; Future usage:Spawner-Recruitment; 1=global; 2=by area
1 # number of recruitment settlement assignments 
0 # unused option
# for each settlement assignment:
#_GPattern	month	area	age
1	1	1	0	#_recr_dist_pattern1
#
#_Cond 0 # N_movement_definitions goes here if N_areas > 1
#_Cond 1.0 # first age that moves (real age at begin of season, not integer) also cond on do_migration>0
#_Cond 1 1 1 2 4 10 # example move definition for seas=1, morph=1, source=1 dest=2, age1=4, age2=10
#
5 #_Nblock_Patterns
2 4 5 1 1 #_blocks_per_pattern
#_begin and end years of blocks
1998 2010 2011 2016
1998 2006 2007 2009 2010 2010 2011 2016
1973 1982 1983 1992 1993 2002 2003 2010 2011 2016
1999 2016
1995 2004
#
# controls for all timevary parameters 
1 #_env/block/dev_adjust_method for all time-vary parms (1=warn relative to base parm bounds; 3=no bound check)
#
# AUTOGEN
1 1 1 1 1 # autogen: 1st element for biology, 2nd for SR, 3rd for Q, 4th reserved, 5th for selex
# where: 0 = autogen all time-varying parms; 1 = read each time-varying parm line; 2 = read then autogen if parm min==-12345
#
# setup for M, growth, maturity, fecundity, recruitment distibution, movement
#
0 #_natM_type:_0=1Parm; 1=N_breakpoints;_2=Lorenzen;_3=agespecific;_4=agespec_withseasinterpolate
#_no additional input for selected M option; read 1P per morph
1 # GrowthModel: 1=vonBert with L1&L2; 2=Richards with L1&L2; 3=age_specific_K_incr; 4=age_specific_K_decr;5=age_specific_K_each; 6=NA; 7=NA; 8=growth cessation
0.5 #_Age(post-settlement)_for_L1;linear growth below this
14 #_Growth_Age_for_L2 (999 to use as Linf)
-999 #_exponential decay for growth above maxage (value should approx initial Z; -999 replicates 3.24; -998 to not allow growth above maxage)
0 #_placeholder for future growth feature
#
0 #_SD_add_to_LAA (set to 0.1 for SS2 V1.x compatibility)
0 #_CV_Growth_Pattern:  0 CV=f(LAA); 1 CV=F(A); 2 SD=F(LAA); 3 SD=F(A); 4 logSD=F(A)
1 #_maturity_option:  1=length logistic; 2=age logistic; 3=read age-maturity matrix by growth_pattern; 4=read age-fecundity; 5=disabled; 6=read length-maturity
1 #_First_Mature_Age
1 #_fecundity option:(1)eggs=Wt*(a+b*Wt);(2)eggs=a*L^b;(3)eggs=a*Wt^b; (4)eggs=a+b*L; (5)eggs=a+b*W
0 #_hermaphroditism option:  0=none; 1=female-to-male age-specific fxn; -1=male-to-female age-specific fxn
1 #_parameter_offset_approach (1=none, 2= M, G, CV_G as offset from female-GP1, 3=like SS2 V1.x)
#
#_growth_parms
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env_var&link	dev_link	dev_minyr	dev_maxyr	dev_PH	Block	Block_Fxn
 5.0e-02	  0.400000	  0.25700000	-1.530	0.438	3	-7	0	0	0	0	0.5	0	0	#_NatM_p_1_Fem_GP_1        
 4.0e+00	 60.000000	 17.59030000	 0.000	0.000	0	 2	0	0	0	0	0.5	0	0	#_L_at_Amin_Fem_GP_1       
 4.0e+01	130.000000	110.00000000	 0.000	0.000	0	-2	0	0	0	0	0.5	0	0	#_L_at_Amax_Fem_GP_1       
 1.0e-02	  0.500000	  0.12797600	 0.000	0.000	0	 3	0	0	0	0	0.5	0	0	#_VonBert_K_Fem_GP_1       
 1.0e-02	  0.500000	  0.13776300	 0.000	0.000	0	 4	0	0	0	0	0.5	0	0	#_CV_young_Fem_GP_1        
 1.0e-02	  0.500000	  0.06437290	 0.000	0.000	0	 4	0	0	0	0	0.0	0	0	#_CV_old_Fem_GP_1          
-3.0e+00	  3.000000	  0.00000276	 0.000	0.000	0	-3	0	0	0	0	0.5	0	0	#_Wtlen_1_Fem_GP_1         
-3.0e+00	  5.000000	  3.28000000	 0.000	0.000	0	-3	0	0	0	0	0.5	0	0	#_Wtlen_2_Fem_GP_1         
-3.0e+00	100.000000	 56.70000000	 0.000	0.000	0	-3	0	0	0	0	0.5	0	0	#_Mat50%_Fem_GP_1          
-5.0e+00	  5.000000	 -0.26900000	 0.000	0.000	0	-3	0	0	0	0	0.5	0	0	#_Mat_slope_Fem_GP_1       
-3.0e+00	  3.000000	  1.00000000	 0.000	0.000	0	-3	0	0	0	0	0.5	0	0	#_Eggs/kg_inter_Fem_GP_1   
-3.0e+00	  3.000000	  0.00000000	 0.000	0.000	0	-3	0	0	0	0	0.5	0	0	#_Eggs/kg_slope_wt_Fem_GP_1
 1.5e-01	  0.450000	  0.30838400	-1.532	0.438	3	 7	0	0	0	0	0.5	0	0	#_NatM_p_1_Mal_GP_1        
 1.0e+01	 60.000000	 14.57400000	 0.000	0.000	0	 2	0	0	0	0	0.5	0	0	#_L_at_Amin_Mal_GP_1       
 4.0e+01	110.000000	 76.27370000	 0.000	0.000	0	 2	0	0	0	0	0.5	0	0	#_L_at_Amax_Mal_GP_1       
 1.0e-02	  1.000000	  0.30952500	 0.000	0.000	0	 3	0	0	0	0	0.5	0	0	#_VonBert_K_Mal_GP_1       
 1.0e-02	  0.500000	  0.15220500	 0.000	0.000	0	 4	0	0	0	0	0.5	0	0	#_CV_young_Mal_GP_1        
 1.0e-02	  0.500000	  0.07449600	 0.000	0.000	0	 4	0	0	0	0	0.0	0	0	#_CV_old_Mal_GP_1          
-3.0e+00	  3.000000	  0.00000161	 0.000	0.000	0	-3	0	0	0	0	0.5	0	0	#_Wtlen_1_Mal_GP_1         
-5.0e+00	  5.000000	  3.42000000	 0.000	0.000	0	-3	0	0	0	0	0.5	0	0	#_Wtlen_2_Mal_GP_1         
 1.0e-01	 10.000000	  1.00000000	 1.000	1.000	0	-1	0	0	0	0	0.0	0	0	#_CohortGrowDev            
 1.0e-06	  0.999999	  0.50000000	 0.000	0.000	0	-3	0	0	0	0	0.0	0	0	#_FracFemale_GP_1          
#_no timevary MG parameters
#
#_seasonal_effects_on_biology_parms
0 0 0 0 0 0 0 0 0 0 #_femwtlen1,femwtlen2,mat1,mat2,fec1,fec2,Malewtlen1,malewtlen2,L1,K
#_ LO HI INIT PRIOR PR_SD PR_type PHASE
#_Cond -2 2 0 0 -1 99 -2 #_placeholder when no seasonal MG parameters
#
3 #_Spawner-Recruitment; 2=Ricker; 3=std_B-H; 4=SCAA;5=Hockey; 6=B-H_flattop; 7=survival_3Parm;8=Shepard_3Parm
0 # 0/1 to use steepness in initial equ recruitment calculation
0 # future feature: 0/1 to make realized sigmaR a function of SR curvature
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env-var	use_dev	dev_mnyr	dev_mxyr	dev_PH	Block	Blk_Fxn # parm_name
 5.0	15	9.55216	0	0	0	  1	0	0	0	0	0	0	0	#_SR_LN(R0)  
 0.2	 1	0.70000	0	0	0	 -4	0	0	0	0	0	0	0	#_SR_BH_steep
 0.0	 2	0.55000	0	0	0	 -3	0	0	0	0	0	0	0	#_SR_sigmaR  
-5.0	 5	0.00000	0	0	0	 -5	0	0	0	0	0	0	0	#_SR_regime  
 0.0	 2	0.00000	0	0	0	-50	0	0	0	0	0	0	0	#_SR_autocorr
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
#Fishing Mortality info
0.1 # F ballpark
-2001 # F ballpark year (neg value to disable)
3 # F_Method:  1=Pope; 2=instan. F; 3=hybrid (hybrid is recommended)
4 # max F or harvest rate, depends on F_Method
5 # N iterations for tuning F in hybrid method (recommend 3 to 7)
#
#_initial_F_parms; count = 0
#
#_Q_setup for fleets with cpue or survey data
#_fleet	link	link_info	extra_se	biasadj	float  #  fleetname
    1	1	0	1	0	1	#_1_Comm_Trawl 
    2	1	0	1	0	1	#_2_Comm_Fix   
    3	1	0	1	0	1	#_3_Rec_WA     
    4	1	0	1	0	1	#_4_Rec_OR     
    5	1	0	1	0	1	#_5_Rec_CA     
    6	1	0	0	0	1	#_6_Surv_TRI   
    7	1	0	0	0	1	#_7_Surv_WCGBTS
-9999	0	0	0	0	0	#_terminator   
#_Q_parms(if_any);Qunits_are_ln(q)
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env-var	use_dev	dev_mnyr	dev_mxyr	dev_PH	Block	Blk_Fxn  #  parm_name
-15	15	 -1.1038600	0	0	0	-1	0	0	0	0	0	0	0	#_LnQ_base_1_Comm_Trawl(1) 
  0	 2	  0.0654107	0	0	0	 2	0	0	0	0	0	0	0	#_Q_extraSD_1_Comm_Trawl(1)
-15	15	 -7.6489700	0	0	0	-1	0	0	0	0	0	0	0	#_LnQ_base_2_Comm_Fix(2)   
  0	 2	  0.1208220	0	0	0	 2	0	0	0	0	0	0	0	#_Q_extraSD_2_Comm_Fix(2)  
-15	15	 -9.0971400	0	0	0	-1	0	0	0	0	0	0	0	#_LnQ_base_3_Rec_WA(3)     
  0	 2	  0.2559350	0	0	0	 2	0	0	0	0	0	0	0	#_Q_extraSD_3_Rec_WA(3)    
-15	15	-11.5844000	0	0	0	-1	0	0	0	0	0	0	0	#_LnQ_base_4_Rec_OR(4)     
  0	 2	  0.1995250	0	0	0	 2	0	0	0	0	0	0	0	#_Q_extraSD_4_Rec_OR(4)    
-15	15	-11.5844000	0	0	0	-1	0	0	0	0	0	0	0	#_LnQ_base_5_Rec_CA(4)     
  0	 2	  0.1995250	0	0	0	 2	0	0	0	0	0	0	0	#_Q_extraSD_5_Rec_CA(4)    
-15	15	 -1.2331900	0	0	0	-1	0	0	0	0	0	5	2	#_LnQ_base_6_Surv_TRI(6)   
-15	15	 -0.8532360	0	0	0	-1	0	0	0	0	0	0	0	#_LnQ_base_7_Surv_WCGBTS(7)
# timevary Q parameters
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE
-15	15	0	0	0	0	-1	#_LnQ_base_6_Surv_TRI(6)_BLK5repl_1995
# info on dev vectors created for Q parms are reported with other devs after tag parameter section
#
#_size_selex_patterns
#_Pattern	Discard	Male	Special
24	2	3	0	#_1 1_Comm_Trawl   
24	2	3	0	#_2 2_Comm_Fix     
24	0	3	0	#_3 3_Rec_WA       
24	0	0	0	#_4 4_Rec_OR       
 0	0	0	0	#_5 5_Rec_CA       
24	0	0	0	#_6 6_Surv_TRI     
24	0	0	0	#_7 7_Surv_WCGBTS  
 0	0	0	0	#_8 8_Surv_HookLine
24	0	3	0	#_9 9_Research_Lam 
 0	0	0	0	#_10 10_CPFV_DebWV 
#
#_age_selex_patterns
#_Pattern	Discard	Male	Special
0	0	0	0	#_1 1_Comm_Trawl   
0	0	0	0	#_2 2_Comm_Fix     
0	0	0	0	#_3 3_Rec_WA       
0	0	0	0	#_4 4_Rec_OR       
0	0	0	0	#_5 5_Rec_CA       
0	0	0	0	#_6 6_Surv_TRI     
0	0	0	0	#_7 7_Surv_WCGBTS  
0	0	0	0	#_8 8_Surv_HookLine
0	0	0	0	#_9 9_Research_Lam 
0	0	0	0	#_10 10_CPFV_DebWV 
#
#_SizeSelex
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env-var	use_dev	dev_mnyr	dev_mxyr	dev_PH	Block	Blk_Fxn  #  parm_name
 14.000	120	  64.589900	  0	0	0	 3	0	0	0	0	0.0	0	0	#_SizeSel_P_1_1_Comm_Trawl(1)        
-20.000	  4	 -15.000000	  0	0	0	-3	0	0	0	0	0.0	0	0	#_SizeSel_P_2_1_Comm_Trawl(1)        
 -1.000	 15	   6.000000	  0	0	0	-3	0	0	0	0	0.0	0	0	#_SizeSel_P_3_1_Comm_Trawl(1)        
 -1.000	 15	  14.000000	  0	0	0	-3	0	0	0	0	0.0	3	2	#_SizeSel_P_4_1_Comm_Trawl(1)        
 -5.000	  9	 -10.000000	  0	0	0	-2	0	0	0	0	0.0	0	0	#_SizeSel_P_5_1_Comm_Trawl(1)        
 -5.000	  9	-999.000000	  0	0	0	-3	0	0	0	0	0.0	0	0	#_SizeSel_P_6_1_Comm_Trawl(1)        
 10.000	100	  85.525300	  0	0	0	 4	0	0	0	0	0.0	2	2	#_SizeSel_PRet_1_1_Comm_Trawl(1)     
  0.100	 12	  10.379100	  0	0	0	 4	0	0	0	0	0.0	2	2	#_SizeSel_PRet_2_1_Comm_Trawl(1)     
-10.000	 10	   0.120167	-10	0	0	 4	0	0	0	0	0.0	2	2	#_SizeSel_PRet_3_1_Comm_Trawl(1)     
-10.000	 10	   0.505441	  0	0	0	 4	0	0	0	0	0.0	0	0	#_SizeSel_PRet_4_1_Comm_Trawl(1)     
 -1.000	  1	   0.000000	  0	0	0	-4	0	0	0	0	0.0	0	0	#_SizeSel_PDis_1_1_Comm_Trawl(1)     
 -1.000	  1	   0.000100	  0	0	0	-5	0	0	0	0	0.0	0	0	#_SizeSel_PDis_2_1_Comm_Trawl(1)     
  0.001	  1	   0.500000	  0	0	0	-6	0	0	0	0	0.0	0	0	#_SizeSel_PDis_3_1_Comm_Trawl(1)     
 -2.000	  2	   0.000000	  0	0	0	-4	0	0	0	0	0.0	0	0	#_SizeSel_PDis_4_1_Comm_Trawl(1)     
-30.000	 15	  -1.392190	  0	0	0	-3	0	0	0	0	0.0	0	0	#_SizeSel_PMalOff_1_1_Comm_Trawl(1)  
-15.000	 15	   0.186783	  0	0	0	 4	0	0	0	0	0.0	0	0	#_SizeSel_PMalOff_2_1_Comm_Trawl(1)  
-15.000	 15	  -2.710550	  0	0	0	 4	0	0	0	0	0.0	0	0	#_SizeSel_PMalOff_3_1_Comm_Trawl(1)  
-15.000	 15	   0.000000	  0	0	0	-4	0	0	0	0	0.0	0	0	#_SizeSel_PMalOff_4_1_Comm_Trawl(1)  
-15.000	 15	   1.000000	  0	0	0	-4	0	0	0	0	0.0	0	0	#_SizeSel_PMalOff_5_1_Comm_Trawl(1)  
 14.000	100	  85.408100	  0	0	0	 3	0	0	0	0	0.0	0	0	#_SizeSel_P_1_2_Comm_Fix(2)          
-20.000	 10	 -15.000000	  0	0	0	-3	0	0	0	0	0.0	0	0	#_SizeSel_P_2_2_Comm_Fix(2)          
-10.000	  9	   6.562760	  0	0	0	 3	0	0	0	0	0.0	0	0	#_SizeSel_P_3_2_Comm_Fix(2)          
 -1.000	  9	   5.204410	  0	0	0	 3	0	0	0	0	0.0	0	0	#_SizeSel_P_4_2_Comm_Fix(2)          
 -5.000	  9	-999.000000	  0	0	0	-2	0	0	0	0	0.0	0	0	#_SizeSel_P_5_2_Comm_Fix(2)          
 -5.000	  9	-999.000000	  0	0	0	-3	0	0	0	0	0.0	0	0	#_SizeSel_P_6_2_Comm_Fix(2)          
 10.000	100	  58.613000	  0	0	0	 4	0	0	0	0	0.0	0	0	#_SizeSel_PRet_1_2_Comm_Fix(2)       
  0.100	 10	   6.637100	  0	0	0	 5	0	0	0	0	0.0	1	2	#_SizeSel_PRet_2_2_Comm_Fix(2)       
-10.000	 10	   6.256950	-10	0	0	 5	0	0	0	0	0.0	1	2	#_SizeSel_PRet_3_2_Comm_Fix(2)       
 -2.000	  6	  -1.300000	  0	0	0	-4	0	0	0	0	0.0	0	0	#_SizeSel_PRet_4_2_Comm_Fix(2)       
 -1.000	  1	   0.000000	  0	0	0	-4	0	0	0	0	0.0	0	0	#_SizeSel_PDis_1_2_Comm_Fix(2)       
 -1.000	  1	   0.000100	  0	0	0	-5	0	0	0	0	0.0	0	0	#_SizeSel_PDis_2_2_Comm_Fix(2)       
  0.001	  1	   0.070000	  0	0	0	-6	0	0	0	0	0.0	0	0	#_SizeSel_PDis_3_2_Comm_Fix(2)       
 -2.000	  2	   0.000000	  0	0	0	-4	0	0	0	0	0.0	0	0	#_SizeSel_PDis_4_2_Comm_Fix(2)       
-30.000	 20	 -28.000000	  0	0	0	-3	0	0	0	0	0.0	0	0	#_SizeSel_PMalOff_1_2_Comm_Fix(2)    
-15.000	 15	  -1.438780	  0	0	0	 4	0	0	0	0	0.0	0	0	#_SizeSel_PMalOff_2_2_Comm_Fix(2)    
-15.000	 15	   1.804040	  0	0	0	 4	0	0	0	0	0.0	0	0	#_SizeSel_PMalOff_3_2_Comm_Fix(2)    
-15.000	 15	   0.000000	  0	0	0	-4	0	0	0	0	0.0	0	0	#_SizeSel_PMalOff_4_2_Comm_Fix(2)    
-15.000	 15	   1.000000	  0	0	0	-4	0	0	0	0	0.0	0	0	#_SizeSel_PMalOff_5_2_Comm_Fix(2)    
 35.000	100	  71.985100	  0	0	0	 3	0	0	0	0	0.0	0	0	#_SizeSel_P_1_3_Rec_WA(3)            
-20.000	 10	 -15.000000	  0	0	0	-3	0	0	0	0	0.0	0	0	#_SizeSel_P_2_3_Rec_WA(3)            
 -1.000	  9	   4.861570	  0	0	0	 3	0	0	0	0	0.0	0	0	#_SizeSel_P_3_3_Rec_WA(3)            
 -1.000	  9	   6.251400	  0	0	0	 3	0	0	0	0	0.0	0	0	#_SizeSel_P_4_3_Rec_WA(3)            
 -5.000	  9	-999.000000	  0	0	0	-2	0	0	0	0	0.0	0	0	#_SizeSel_P_5_3_Rec_WA(3)            
 -5.000	  9	-999.000000	  0	0	0	-3	0	0	0	0	0.0	0	0	#_SizeSel_P_6_3_Rec_WA(3)            
-15.000	 15	  -8.193490	  0	0	0	 3	0	0	0	0	0.0	0	0	#_SizeSel_PMalOff_1_3_Rec_WA(3)      
-15.000	 15	  -0.448462	  0	0	0	 4	0	0	0	0	0.0	0	0	#_SizeSel_PMalOff_2_3_Rec_WA(3)      
-15.000	 15	  -0.145975	  0	0	0	-4	0	0	0	0	0.0	0	0	#_SizeSel_PMalOff_3_3_Rec_WA(3)      
-15.000	 15	   0.000000	  0	0	0	-4	0	0	0	0	0.0	0	0	#_SizeSel_PMalOff_4_3_Rec_WA(3)      
-15.000	 15	   1.000000	  0	0	0	-4	0	0	0	0	0.0	0	0	#_SizeSel_PMalOff_5_3_Rec_WA(3)      
 35.000	100	  58.614400	  0	0	0	 3	0	0	0	0	0.0	0	0	#_SizeSel_P_1_4_Rec_OR(4)            
-20.000	  4	 -15.000000	  0	0	0	-3	0	0	0	0	0.0	0	0	#_SizeSel_P_2_4_Rec_OR(4)            
 -4.000	  9	   4.662950	  0	0	0	 3	0	0	0	0	0.0	4	2	#_SizeSel_P_3_4_Rec_OR(4)            
 -1.000	  9	   7.881850	  0	0	0	 3	0	0	0	0	0.0	4	2	#_SizeSel_P_4_4_Rec_OR(4)            
 -5.000	  9	-999.000000	  0	0	0	-2	0	0	0	0	0.0	0	0	#_SizeSel_P_5_4_Rec_OR(4)            
 -5.000	  9	-999.000000	  0	0	0	-3	0	0	0	0	0.0	0	0	#_SizeSel_P_6_4_Rec_OR(4)            
 14.000	120	  92.487800	  0	0	0	 3	0	0	0	0	0.5	5	2	#_SizeSel_P_1_6_Surv_TRI(6)          
-20.000	  4	 -15.000000	  0	0	0	-3	0	0	0	0	0.0	5	2	#_SizeSel_P_2_6_Surv_TRI(6)          
 -1.000	  9	   6.981370	  0	0	0	 3	0	0	0	0	0.0	5	2	#_SizeSel_P_3_6_Surv_TRI(6)          
 -1.000	  9	   6.000000	  0	0	0	-2	0	0	0	0	0.0	5	2	#_SizeSel_P_4_6_Surv_TRI(6)          
 -5.000	  9	-999.000000	  0	0	0	-2	0	0	0	0	0.0	5	2	#_SizeSel_P_5_6_Surv_TRI(6)          
 -5.000	  9	-999.000000	  0	0	0	-3	0	0	0	0	0.0	5	2	#_SizeSel_P_6_6_Surv_TRI(6)          
 35.000	120	  59.596600	  0	0	0	 3	0	0	0	0	0.0	0	0	#_SizeSel_P_1_7_Surv_WCGBTS(7)       
-20.000	  4	 -15.000000	  0	0	0	-3	0	0	0	0	0.0	0	0	#_SizeSel_P_2_7_Surv_WCGBTS(7)       
 -1.000	  9	   6.383230	  0	0	0	 3	0	0	0	0	0.0	0	0	#_SizeSel_P_3_7_Surv_WCGBTS(7)       
 -1.000	  9	   7.120130	  0	0	0	 3	0	0	0	0	0.0	0	0	#_SizeSel_P_4_7_Surv_WCGBTS(7)       
 -5.000	  9	-999.000000	  0	0	0	-2	0	0	0	0	0.0	0	0	#_SizeSel_P_5_7_Surv_WCGBTS(7)       
 -5.000	  9	-999.000000	  0	0	0	-3	0	0	0	0	0.0	0	0	#_SizeSel_P_6_7_Surv_WCGBTS(7)       
 35.000	100	  82.429900	  0	0	0	 3	0	0	0	0	0.0	0	0	#_SizeSel_P_1_9_Research_Lam(9)      
-20.000	  4	 -15.000000	  0	0	0	-3	0	0	0	0	0.0	0	0	#_SizeSel_P_2_9_Research_Lam(9)      
 -1.000	  9	   5.835010	  0	0	0	 3	0	0	0	0	0.0	0	0	#_SizeSel_P_3_9_Research_Lam(9)      
 -1.000	  9	   5.500450	  0	0	0	 3	0	0	0	0	0.0	0	0	#_SizeSel_P_4_9_Research_Lam(9)      
 -5.000	  9	-999.000000	  0	0	0	-2	0	0	0	0	0.0	0	0	#_SizeSel_P_5_9_Research_Lam(9)      
 -5.000	  9	-999.000000	  0	0	0	-3	0	0	0	0	0.0	0	0	#_SizeSel_P_6_9_Research_Lam(9)      
-30.000	 40	 -19.149700	  0	0	0	 4	0	0	0	0	0.0	0	0	#_SizeSel_PMalOff_1_9_Research_Lam(9)
-15.000	 15	  -1.021730	  0	0	0	 4	0	0	0	0	0.0	0	0	#_SizeSel_PMalOff_2_9_Research_Lam(9)
-15.000	 15	  -1.405820	  0	0	0	 4	0	0	0	0	0.0	0	0	#_SizeSel_PMalOff_3_9_Research_Lam(9)
-15.000	 15	   0.000000	  0	0	0	-4	0	0	0	0	0.0	0	0	#_SizeSel_PMalOff_4_9_Research_Lam(9)
-15.000	 15	   1.000000	  0	0	0	-4	0	0	0	0	0.0	0	0	#_SizeSel_PMalOff_5_9_Research_Lam(9)
#_AgeSelex
#_No age_selex_parm
# timevary selex parameters 
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE
 -1.000	 15	  10.000000	0	0	0	-5	#_SizeSel_P_4_1_Comm_Trawl(1)_BLK3repl_1973   
 -1.000	 15	   6.821100	0	0	0	 5	#_SizeSel_P_4_1_Comm_Trawl(1)_BLK3repl_1983   
 -1.000	 15	   6.242020	0	0	0	 5	#_SizeSel_P_4_1_Comm_Trawl(1)_BLK3repl_1993   
 -1.000	 15	   6.303780	0	0	0	 5	#_SizeSel_P_4_1_Comm_Trawl(1)_BLK3repl_2003   
 -1.000	 15	   8.258400	0	0	0	 5	#_SizeSel_P_4_1_Comm_Trawl(1)_BLK3repl_2011   
 10.000	100	  82.114700	0	0	0	 5	#_SizeSel_PRet_1_1_Comm_Trawl(1)_BLK2repl_1998
 10.000	100	  72.871200	0	0	0	 5	#_SizeSel_PRet_1_1_Comm_Trawl(1)_BLK2repl_2007
 10.000	100	  60.134000	0	0	0	 5	#_SizeSel_PRet_1_1_Comm_Trawl(1)_BLK2repl_2010
 10.000	100	  55.244300	0	0	0	 5	#_SizeSel_PRet_1_1_Comm_Trawl(1)_BLK2repl_2011
  0.100	 12	   7.580080	0	0	0	-5	#_SizeSel_PRet_2_1_Comm_Trawl(1)_BLK2repl_1998
  0.100	 12	   5.145230	0	0	0	 5	#_SizeSel_PRet_2_1_Comm_Trawl(1)_BLK2repl_2007
  0.100	 12	   4.245350	0	0	0	 5	#_SizeSel_PRet_2_1_Comm_Trawl(1)_BLK2repl_2010
  0.100	 12	   2.213680	0	0	0	 5	#_SizeSel_PRet_2_1_Comm_Trawl(1)_BLK2repl_2011
  0.001	 12	   7.000000	0	0	0	-5	#_SizeSel_PRet_3_1_Comm_Trawl(1)_BLK2repl_1998
  0.001	 12	   1.636900	0	0	0	 5	#_SizeSel_PRet_3_1_Comm_Trawl(1)_BLK2repl_2007
  0.001	 12	   9.910660	0	0	0	 5	#_SizeSel_PRet_3_1_Comm_Trawl(1)_BLK2repl_2010
  0.001	 12	  11.448700	0	0	0	 5	#_SizeSel_PRet_3_1_Comm_Trawl(1)_BLK2repl_2011
  0.100	 10	   1.653840	0	0	0	 5	#_SizeSel_PRet_2_2_Comm_Fix(2)_BLK1repl_1998  
  0.100	 10	   1.434140	0	0	0	 5	#_SizeSel_PRet_2_2_Comm_Fix(2)_BLK1repl_2011  
  0.001	  6	   0.648244	0	0	0	 5	#_SizeSel_PRet_3_2_Comm_Fix(2)_BLK1repl_1998  
  0.001	  6	   0.777026	0	0	0	 5	#_SizeSel_PRet_3_2_Comm_Fix(2)_BLK1repl_2011  
 -4.000	  9	   2.068100	0	0	0	 5	#_SizeSel_P_3_4_Rec_OR(4)_BLK4repl_1999       
 -1.000	  9	   6.742970	0	0	0	 5	#_SizeSel_P_4_4_Rec_OR(4)_BLK4repl_1999       
 14.000	110	  53.947600	0	0	0	 3	#_SizeSel_P_1_6_Surv_TRI(6)_BLK5repl_1995     
-20.000	  4	 -15.000000	0	0	0	-3	#_SizeSel_P_2_6_Surv_TRI(6)_BLK5repl_1995     
 -1.000	  9	   5.986260	0	0	0	 3	#_SizeSel_P_3_6_Surv_TRI(6)_BLK5repl_1995     
 -1.000	 15	   8.000000	0	0	0	-2	#_SizeSel_P_4_6_Surv_TRI(6)_BLK5repl_1995     
 -5.000	  9	-999.000000	0	0	0	-2	#_SizeSel_P_5_6_Surv_TRI(6)_BLK5repl_1995     
 -5.000	  9	-999.000000	0	0	0	-3	#_SizeSel_P_6_6_Surv_TRI(6)_BLK5repl_1995     
# info on dev vectors created for selex parms are reported with other devs after tag parameter section
#
0 #  use 2D_AR1 selectivity(0/1):  experimental feature
#_no 2D_AR1 selex offset used
# Tag loss and Tag reporting parameters go next
0 # TG_custom:  0=no read; 1=read if tags exist
#_Cond -6 6 1 1 2 0.01 -4 0 0 0 0 0 0 0  #_placeholder if no parameters
#
# Input variance adjustments factors: 
#_Factor	Fleet	Value
    4	1	0.1868720	#_Variance_adjustment_list1 
    4	2	0.2122190	#_Variance_adjustment_list2 
    4	3	0.1617610	#_Variance_adjustment_list3 
    4	4	0.0171895	#_Variance_adjustment_list4 
    4	6	0.8395220	#_Variance_adjustment_list5 
    4	7	0.2223120	#_Variance_adjustment_list6 
    4	9	0.2300000	#_Variance_adjustment_list7 
    5	6	0.3052280	#_Variance_adjustment_list8 
    5	7	0.2232240	#_Variance_adjustment_list9 
    5	9	0.1800000	#_Variance_adjustment_list10
-9999	0	0.0000000	#_terminator                
#
1 #_maxlambdaphase
1 #_sd_offset; must be 1 if any growthCV, sigmaR, or survey extraSD is an estimated parameter
# read 0 changes to default Lambdas (default value is 1.0)
-9999 0 0 0 0 # terminator
#
0 # 0/1 read specs for more stddev reporting
#
999
