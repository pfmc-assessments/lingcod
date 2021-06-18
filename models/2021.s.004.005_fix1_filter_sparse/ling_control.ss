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
4 4 5 4 1 #_blocks_per_pattern
#_begin and end years of blocks
1998 2001 2002 2002 2003 2010 2011 2016
1998 2006 2007 2009 2010 2010 2011 2016
1973 1982 1983 1992 1993 2002 2003 2010 2011 2016
1959 1974 1975 1989 1990 2003 2004 2016
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
10 #_Growth_Age_for_L2 (999 to use as Linf)
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
 5.0e-02	  0.300000	 0.257000000	-1.530	0.438	3	-7	0	0	0	0	0	0	0	#_NatM_p_1_Fem_GP_1        
 1.0e+01	 60.000000	17.970500000	 0.000	0.000	0	 2	0	0	0	0	0	0	0	#_L_at_Amin_Fem_GP_1       
 4.0e+01	130.000000	93.143900000	 0.000	0.000	0	 2	0	0	0	0	0	0	0	#_L_at_Amax_Fem_GP_1       
 1.0e-02	  0.500000	 0.132986000	 0.000	0.000	0	 3	0	0	0	0	0	0	0	#_VonBert_K_Fem_GP_1       
 1.0e-02	  0.500000	 0.154816000	 0.000	0.000	0	 4	0	0	0	0	0	0	0	#_CV_young_Fem_GP_1        
 1.0e-02	  0.500000	 0.068051300	 0.000	0.000	0	 4	0	0	0	0	0	0	0	#_CV_old_Fem_GP_1          
-3.0e+00	  3.000000	 0.000003308	 0.000	0.000	0	-3	0	0	0	0	0	0	0	#_Wtlen_1_Fem_GP_1         
-3.0e+00	  5.000000	 3.248000000	 0.000	0.000	0	-3	0	0	0	0	0	0	0	#_Wtlen_2_Fem_GP_1         
-3.0e+00	100.000000	52.300000000	 0.000	0.000	0	-3	0	0	0	0	0	0	0	#_Mat50%_Fem_GP_1          
-5.0e+00	  5.000000	-0.219000000	 0.000	0.000	0	-3	0	0	0	0	0	0	0	#_Mat_slope_Fem_GP_1       
-3.0e+00	  3.000000	 1.000000000	 0.000	0.000	0	-3	0	0	0	0	0	0	0	#_Eggs/kg_inter_Fem_GP_1   
-3.0e+00	  3.000000	 0.000000000	 0.000	0.000	0	-3	0	0	0	0	0	0	0	#_Eggs/kg_slope_wt_Fem_GP_1
 1.5e-01	  0.400000	 0.312284000	-1.532	0.438	3	 7	0	0	0	0	0	0	0	#_NatM_p_1_Mal_GP_1        
 1.0e+01	 60.000000	18.115400000	 0.000	0.000	0	 2	0	0	0	0	0	0	0	#_L_at_Amin_Mal_GP_1       
 4.0e+01	110.000000	83.761600000	 0.000	0.000	0	 2	0	0	0	0	0	0	0	#_L_at_Amax_Mal_GP_1       
 1.0e-02	  1.000000	 0.162097000	 0.000	0.000	0	 3	0	0	0	0	0	0	0	#_VonBert_K_Mal_GP_1       
 1.0e-02	  0.500000	 0.138272000	 0.000	0.000	0	 4	0	0	0	0	0	0	0	#_CV_young_Mal_GP_1        
 1.0e-02	  0.500000	 0.090002900	 0.000	0.000	0	 4	0	0	0	0	0	0	0	#_CV_old_Mal_GP_1          
-3.0e+00	  3.000000	 0.000002179	 0.000	0.000	0	-3	0	0	0	0	0	0	0	#_Wtlen_1_Mal_GP_1         
-5.0e+00	  5.000000	 3.360000000	 0.000	0.000	0	-3	0	0	0	0	0	0	0	#_Wtlen_2_Mal_GP_1         
 1.0e-01	 10.000000	 1.000000000	 1.000	1.000	0	-1	0	0	0	0	0	0	0	#_CohortGrowDev            
 1.0e-06	  0.999999	 0.500000000	 0.000	0.000	0	-3	0	0	0	0	0	0	0	#_FracFemale_GP_1          
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
 5.0	15	8.50799	0	0	0	  1	0	0	0	0	0	0	0	#_SR_LN(R0)  
 0.2	 1	0.70000	0	0	0	 -4	0	0	0	0	0	0	0	#_SR_BH_steep
 0.0	 2	0.75000	0	0	0	 -3	0	0	0	0	0	0	0	#_SR_sigmaR  
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
1950 #_last_yr_nobias_adj_in_MPD; begin of ramp
2001 #_first_yr_fullbias_adj_in_MPD; begin of plateau
2015 #_last_yr_fullbias_adj_in_MPD
2017 #_end_yr_for_ramp_in_MPD (can be in forecast to shape ramp, but SS sets bias_adj to 0.0 for fcast yrs)
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
    5	1	0	1	0	1	#_5_Rec_CA       
    6	1	0	0	0	1	#_6_Surv_TRI     
    7	1	0	0	0	1	#_7_Surv_WCGBTS  
    8	1	0	0	0	1	#_8_Surv_HookLine
   10	1	0	1	0	1	#_10_CPFV_DebWV  
-9999	0	0	0	0	0	#_terminator     
#_Q_parms(if_any);Qunits_are_ln(q)
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env-var	use_dev	dev_mnyr	dev_mxyr	dev_PH	Block	Blk_Fxn  #  parm_name
-15	15	 -1.5882200	0	0	0	-1	0	0	0	0	0	0	0	#_LnQ_base_1_Comm_Trawl(1)   
  0	 2	  0.0570477	0	0	0	 2	0	0	0	0	0	0	0	#_Q_extraSD_1_Comm_Trawl(1)  
-15	15	 -1.5882200	0	0	0	-1	0	0	0	0	0	0	0	#_LnQ_base_5_Rec_CA(5)       
  0	 2	  0.0570477	0	0	0	 2	0	0	0	0	0	0	0	#_Q_extraSD_5_Rec_CA(5)      
-15	15	 -0.0304018	0	0	0	-1	0	0	0	0	0	5	2	#_LnQ_base_6_Surv_TRI(6)     
-15	15	  0.0280052	0	0	0	-1	0	0	0	0	0	0	0	#_LnQ_base_7_Surv_WCGBTS(7)  
-15	15	-11.7984000	0	0	0	-1	0	0	0	0	0	0	0	#_LnQ_base_8_Surv_HookLine(8)
-15	15	 -1.5882200	0	0	0	-1	0	0	0	0	0	0	0	#_LnQ_base_10_CPFV_DebWV(10) 
  0	 2	  0.0570477	0	0	0	 2	0	0	0	0	0	0	0	#_Q_extraSD_10_CPFV_DebWV(10)
# timevary Q parameters
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE
-15	15	0	0	0	0	-1	#_LnQ_base_6_Surv_TRI(6)_BLK5repl_1995
# info on dev vectors created for Q parms are reported with other devs after tag parameter section
#
#_size_selex_patterns
#_Pattern	Discard	Male	Special
24	2	3	0	#_1 1_Comm_Trawl   
24	2	3	0	#_2 2_Comm_Fix     
 0	0	0	0	#_3 3_Rec_WA       
 0	0	0	0	#_4 4_Rec_OR       
24	0	0	0	#_5 5_Rec_CA       
24	0	0	0	#_6 6_Surv_TRI     
24	0	0	0	#_7 7_Surv_WCGBTS  
24	0	3	0	#_8 8_Surv_HookLine
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
 14.000	100	  59.681400	  0	0	0	 3	0	0	0	0	0	0	0	#_SizeSel_P_1_1_Comm_Trawl(1)         
 -6.000	  4	 -15.000000	  0	0	0	-3	0	0	0	0	0	0	0	#_SizeSel_P_2_1_Comm_Trawl(1)         
 -5.000	 15	   7.000000	  0	0	0	-3	0	0	0	0	0	3	2	#_SizeSel_P_3_1_Comm_Trawl(1)         
 -5.000	 15	  12.865900	  0	0	0	 3	0	0	0	0	0	3	2	#_SizeSel_P_4_1_Comm_Trawl(1)         
 -5.000	  9	-999.000000	  0	0	0	-2	0	0	0	0	0	0	0	#_SizeSel_P_5_1_Comm_Trawl(1)         
 -5.000	  9	-999.000000	  0	0	0	-3	0	0	0	0	0	0	0	#_SizeSel_P_6_1_Comm_Trawl(1)         
 10.000	100	  60.322500	  0	0	0	 4	0	0	0	0	0	2	2	#_SizeSel_PRet_1_1_Comm_Trawl(1)      
  0.100	 15	   9.000000	  0	0	0	-4	0	0	0	0	0	2	2	#_SizeSel_PRet_2_1_Comm_Trawl(1)      
-10.000	 10	   2.000000	-10	0	0	-4	0	0	0	0	0	0	0	#_SizeSel_PRet_3_1_Comm_Trawl(1)      
 -2.000	  2	   0.000000	  0	0	0	-4	0	0	0	0	0	0	0	#_SizeSel_PRet_4_1_Comm_Trawl(1)      
 -1.000	  1	   0.000000	  0	0	0	-4	0	0	0	0	0	0	0	#_SizeSel_PDis_1_1_Comm_Trawl(1)      
 -1.000	  1	   0.000100	  0	0	0	-5	0	0	0	0	0	0	0	#_SizeSel_PDis_2_1_Comm_Trawl(1)      
  0.001	  1	   0.500000	  0	0	0	-6	0	0	0	0	0	0	0	#_SizeSel_PDis_3_1_Comm_Trawl(1)      
 -2.000	  2	   0.000000	  0	0	0	-4	0	0	0	0	0	0	0	#_SizeSel_PDis_4_1_Comm_Trawl(1)      
-30.000	 15	  -3.494380	  0	0	0	 3	0	0	0	0	0	0	0	#_SizeSel_PMalOff_1_1_Comm_Trawl(1)   
-15.000	 15	   3.301100	  0	0	0	 4	0	0	0	0	0	0	0	#_SizeSel_PMalOff_2_1_Comm_Trawl(1)   
-15.000	 15	  -1.224920	  0	0	0	 4	0	0	0	0	0	0	0	#_SizeSel_PMalOff_3_1_Comm_Trawl(1)   
-15.000	 15	   0.000000	  0	0	0	-4	0	0	0	0	0	0	0	#_SizeSel_PMalOff_4_1_Comm_Trawl(1)   
-15.000	 15	   1.000000	  0	0	0	-4	0	0	0	0	0	0	0	#_SizeSel_PMalOff_5_1_Comm_Trawl(1)   
 14.000	100	  85.300200	  0	0	0	 3	0	0	0	0	0	0	0	#_SizeSel_P_1_2_Comm_Fix(2)           
 -6.000	  4	 -15.000000	  0	0	0	-3	0	0	0	0	0	0	0	#_SizeSel_P_2_2_Comm_Fix(2)           
 -5.000	 15	   7.692900	  0	0	0	 3	0	0	0	0	0	1	2	#_SizeSel_P_3_2_Comm_Fix(2)           
 -5.000	 15	   5.606340	  0	0	0	 3	0	0	0	0	0	1	2	#_SizeSel_P_4_2_Comm_Fix(2)           
 -5.000	  9	-999.000000	  0	0	0	-2	0	0	0	0	0	0	0	#_SizeSel_P_5_2_Comm_Fix(2)           
 -5.000	  9	-999.000000	  0	0	0	-3	0	0	0	0	0	0	0	#_SizeSel_P_6_2_Comm_Fix(2)           
 10.000	100	  51.718100	  0	0	0	 4	0	0	0	0	0	1	2	#_SizeSel_PRet_1_2_Comm_Fix(2)        
  0.100	 10	   2.341650	  0	0	0	 4	0	0	0	0	0	1	2	#_SizeSel_PRet_2_2_Comm_Fix(2)        
-10.000	 10	   1.000000	-10	0	0	-4	0	0	0	0	0	0	0	#_SizeSel_PRet_3_2_Comm_Fix(2)        
 -2.000	  2	   0.000000	  0	0	0	-6	0	0	0	0	0	0	0	#_SizeSel_PRet_4_2_Comm_Fix(2)        
 -1.000	  1	   0.000000	  0	0	0	-4	0	0	0	0	0	0	0	#_SizeSel_PDis_1_2_Comm_Fix(2)        
 -1.000	  1	   0.000100	  0	0	0	-5	0	0	0	0	0	0	0	#_SizeSel_PDis_2_2_Comm_Fix(2)        
  0.001	  1	   0.070000	  0	0	0	-6	0	0	0	0	0	0	0	#_SizeSel_PDis_3_2_Comm_Fix(2)        
 -2.000	  2	   0.000000	  0	0	0	-4	0	0	0	0	0	0	0	#_SizeSel_PDis_4_2_Comm_Fix(2)        
-30.000	 20	 -22.000000	  0	0	0	-3	0	0	0	0	0	0	0	#_SizeSel_PMalOff_1_2_Comm_Fix(2)     
-15.000	 15	  -1.704710	  0	0	0	 4	0	0	0	0	0	0	0	#_SizeSel_PMalOff_2_2_Comm_Fix(2)     
-15.000	 15	   0.241749	  0	0	0	 4	0	0	0	0	0	0	0	#_SizeSel_PMalOff_3_2_Comm_Fix(2)     
-15.000	 15	   0.000000	  0	0	0	-4	0	0	0	0	0	0	0	#_SizeSel_PMalOff_4_2_Comm_Fix(2)     
-15.000	 15	   1.000000	  0	0	0	-4	0	0	0	0	0	0	0	#_SizeSel_PMalOff_5_2_Comm_Fix(2)     
 35.000	100	  62.500000	  0	0	0	-3	0	0	0	0	0	4	2	#_SizeSel_P_1_5_Rec_CA(5)             
-16.000	  1	 -15.000000	  0	0	0	-3	0	0	0	0	0	0	0	#_SizeSel_P_2_5_Rec_CA(5)             
 -1.000	 15	   5.800000	  0	0	0	-3	0	0	0	0	0	4	2	#_SizeSel_P_3_5_Rec_CA(5)             
 -1.000	 15	   7.200000	  0	0	0	-3	0	0	0	0	0	4	2	#_SizeSel_P_4_5_Rec_CA(5)             
 -5.000	  9	-999.000000	  0	0	0	-3	0	0	0	0	0	0	0	#_SizeSel_P_5_5_Rec_CA(5)             
 -5.000	  9	-999.000000	  0	0	0	-3	0	0	0	0	0	0	0	#_SizeSel_P_6_5_Rec_CA(5)             
 10.000	100	  38.828500	  0	0	0	 3	0	0	0	0	0	5	2	#_SizeSel_P_1_6_Surv_TRI(6)           
 -6.000	  4	 -15.000000	  0	0	0	-3	0	0	0	0	0	5	2	#_SizeSel_P_2_6_Surv_TRI(6)           
 -1.000	 15	   5.355010	  0	0	0	 3	0	0	0	0	0	5	2	#_SizeSel_P_3_6_Surv_TRI(6)           
 -1.000	 15	  10.271900	  0	0	0	 3	0	0	0	0	0	5	2	#_SizeSel_P_4_6_Surv_TRI(6)           
 -5.000	  9	-999.000000	  0	0	0	-2	0	0	0	0	0	5	2	#_SizeSel_P_5_6_Surv_TRI(6)           
 -5.000	  9	-999.000000	  0	0	0	-3	0	0	0	0	0	5	2	#_SizeSel_P_6_6_Surv_TRI(6)           
  5.000	 30	  26.485600	  0	0	0	 2	0	0	0	0	0	0	0	#_SizeSel_P_1_7_Surv_WCGBTS(7)        
-12.000	  4	 -15.000000	  0	0	0	-3	0	0	0	0	0	0	0	#_SizeSel_P_2_7_Surv_WCGBTS(7)        
 -1.000	 15	   4.739550	  0	0	0	 3	0	0	0	0	0	0	0	#_SizeSel_P_3_7_Surv_WCGBTS(7)        
 -1.000	 15	   7.879970	  0	0	0	 3	0	0	0	0	0	0	0	#_SizeSel_P_4_7_Surv_WCGBTS(7)        
 -5.000	  9	-999.000000	  0	0	0	-2	0	0	0	0	0	0	0	#_SizeSel_P_5_7_Surv_WCGBTS(7)        
 -5.000	  9	-999.000000	  0	0	0	-3	0	0	0	0	0	0	0	#_SizeSel_P_6_7_Surv_WCGBTS(7)        
 35.000	100	  65.481300	  0	0	0	 3	0	0	0	0	0	0	0	#_SizeSel_P_1_8_Surv_HookLine(8)      
 -6.000	  4	 -15.000000	  0	0	0	-3	0	0	0	0	0	0	0	#_SizeSel_P_2_8_Surv_HookLine(8)      
 -6.000	 15	   5.466170	  0	0	0	 3	0	0	0	0	0	0	0	#_SizeSel_P_3_8_Surv_HookLine(8)      
 -6.000	 15	   6.881260	  0	0	0	 3	0	0	0	0	0	0	0	#_SizeSel_P_4_8_Surv_HookLine(8)      
 -5.000	  9	-999.000000	  0	0	0	-2	0	0	0	0	0	0	0	#_SizeSel_P_5_8_Surv_HookLine(8)      
 -5.000	  9	-999.000000	  0	0	0	-3	0	0	0	0	0	0	0	#_SizeSel_P_6_8_Surv_HookLine(8)      
-30.000	 40	 -10.295500	  0	0	0	 4	0	0	0	0	0	0	0	#_SizeSel_PMalOff_1_8_Surv_HookLine(8)
-15.000	 15	  -0.152930	  0	0	0	 4	0	0	0	0	0	0	0	#_SizeSel_PMalOff_2_8_Surv_HookLine(8)
-15.000	 15	  -1.933480	  0	0	0	 4	0	0	0	0	0	0	0	#_SizeSel_PMalOff_3_8_Surv_HookLine(8)
-15.000	 15	   0.000000	  0	0	0	-4	0	0	0	0	0	0	0	#_SizeSel_PMalOff_4_8_Surv_HookLine(8)
-15.000	 15	   1.000000	  0	0	0	-4	0	0	0	0	0	0	0	#_SizeSel_PMalOff_5_8_Surv_HookLine(8)
 35.000	100	  90.940900	  0	0	0	 3	0	0	0	0	0	0	0	#_SizeSel_P_1_9_Research_Lam(9)       
 -6.000	  4	 -15.000000	  0	0	0	-3	0	0	0	0	0	0	0	#_SizeSel_P_2_9_Research_Lam(9)       
 -6.000	 15	   6.579560	  0	0	0	 3	0	0	0	0	0	0	0	#_SizeSel_P_3_9_Research_Lam(9)       
 -6.000	 15	  -5.600000	  0	0	0	-3	0	0	0	0	0	0	0	#_SizeSel_P_4_9_Research_Lam(9)       
 -5.000	  9	-999.000000	  0	0	0	-2	0	0	0	0	0	0	0	#_SizeSel_P_5_9_Research_Lam(9)       
 -5.000	  9	-999.000000	  0	0	0	-3	0	0	0	0	0	0	0	#_SizeSel_P_6_9_Research_Lam(9)       
-30.000	 40	 -27.404100	  0	0	0	-4	0	0	0	0	0	0	0	#_SizeSel_PMalOff_1_9_Research_Lam(9) 
-15.000	 15	  -1.190610	  0	0	0	 4	0	0	0	0	0	0	0	#_SizeSel_PMalOff_2_9_Research_Lam(9) 
-15.000	 15	   9.627660	  0	0	0	 4	0	0	0	0	0	0	0	#_SizeSel_PMalOff_3_9_Research_Lam(9) 
-15.000	 15	   0.000000	  0	0	0	-4	0	0	0	0	0	0	0	#_SizeSel_PMalOff_4_9_Research_Lam(9) 
-15.000	 15	   1.000000	  0	0	0	-4	0	0	0	0	0	0	0	#_SizeSel_PMalOff_5_9_Research_Lam(9) 
#_AgeSelex
#_No age_selex_parm
# timevary selex parameters 
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE
-5.0	 15	   7.000000	0	0	0	-4	#_SizeSel_P_3_1_Comm_Trawl(1)_BLK3repl_1973   
-5.0	 15	   7.881770	0	0	0	 4	#_SizeSel_P_3_1_Comm_Trawl(1)_BLK3repl_1983   
-5.0	 15	   6.744280	0	0	0	 4	#_SizeSel_P_3_1_Comm_Trawl(1)_BLK3repl_1993   
-5.0	 15	   3.222390	0	0	0	 4	#_SizeSel_P_3_1_Comm_Trawl(1)_BLK3repl_2003   
-5.0	 15	   2.797920	0	0	0	 4	#_SizeSel_P_3_1_Comm_Trawl(1)_BLK3repl_2011   
-5.0	 15	  14.473600	0	0	0	 4	#_SizeSel_P_4_1_Comm_Trawl(1)_BLK3repl_1973   
-5.0	 15	   6.374030	0	0	0	 4	#_SizeSel_P_4_1_Comm_Trawl(1)_BLK3repl_1983   
-5.0	 15	   6.717200	0	0	0	 4	#_SizeSel_P_4_1_Comm_Trawl(1)_BLK3repl_1993   
-5.0	 15	   6.444580	0	0	0	 4	#_SizeSel_P_4_1_Comm_Trawl(1)_BLK3repl_2003   
-5.0	 15	   7.935180	0	0	0	 4	#_SizeSel_P_4_1_Comm_Trawl(1)_BLK3repl_2011   
10.0	100	  66.668500	0	0	0	 4	#_SizeSel_PRet_1_1_Comm_Trawl(1)_BLK2repl_1998
10.0	100	  67.328000	0	0	0	 4	#_SizeSel_PRet_1_1_Comm_Trawl(1)_BLK2repl_2007
10.0	100	  56.452000	0	0	0	 4	#_SizeSel_PRet_1_1_Comm_Trawl(1)_BLK2repl_2010
10.0	100	  56.515200	0	0	0	 4	#_SizeSel_PRet_1_1_Comm_Trawl(1)_BLK2repl_2011
 0.1	 10	   3.500000	0	0	0	-4	#_SizeSel_PRet_2_1_Comm_Trawl(1)_BLK2repl_1998
 0.1	 10	   2.889850	0	0	0	 4	#_SizeSel_PRet_2_1_Comm_Trawl(1)_BLK2repl_2007
 0.1	 10	   0.718992	0	0	0	 4	#_SizeSel_PRet_2_1_Comm_Trawl(1)_BLK2repl_2010
 0.1	 10	   1.414420	0	0	0	 4	#_SizeSel_PRet_2_1_Comm_Trawl(1)_BLK2repl_2011
-5.0	 15	   8.100000	0	0	0	-4	#_SizeSel_P_3_2_Comm_Fix(2)_BLK1repl_1998     
-5.0	 15	   5.214650	0	0	0	 4	#_SizeSel_P_3_2_Comm_Fix(2)_BLK1repl_2002     
-5.0	 15	   6.737040	0	0	0	 4	#_SizeSel_P_3_2_Comm_Fix(2)_BLK1repl_2003     
-5.0	 15	   6.430300	0	0	0	 4	#_SizeSel_P_3_2_Comm_Fix(2)_BLK1repl_2011     
-5.0	 15	   6.400000	0	0	0	-4	#_SizeSel_P_4_2_Comm_Fix(2)_BLK1repl_1998     
-5.0	 15	   6.324630	0	0	0	 4	#_SizeSel_P_4_2_Comm_Fix(2)_BLK1repl_2002     
-5.0	 15	   4.774390	0	0	0	 4	#_SizeSel_P_4_2_Comm_Fix(2)_BLK1repl_2003     
-5.0	 15	   4.695750	0	0	0	 4	#_SizeSel_P_4_2_Comm_Fix(2)_BLK1repl_2011     
10.0	100	  61.156500	0	0	0	 4	#_SizeSel_PRet_1_2_Comm_Fix(2)_BLK1repl_1998  
10.0	100	  30.365400	0	0	0	 4	#_SizeSel_PRet_1_2_Comm_Fix(2)_BLK1repl_2002  
10.0	100	  59.728600	0	0	0	 4	#_SizeSel_PRet_1_2_Comm_Fix(2)_BLK1repl_2003  
10.0	100	  59.583300	0	0	0	 4	#_SizeSel_PRet_1_2_Comm_Fix(2)_BLK1repl_2011  
 0.1	 10	   2.387990	0	0	0	 4	#_SizeSel_PRet_2_2_Comm_Fix(2)_BLK1repl_1998  
 0.1	 10	   2.061890	0	0	0	 4	#_SizeSel_PRet_2_2_Comm_Fix(2)_BLK1repl_2002  
 0.1	 10	   0.967701	0	0	0	 4	#_SizeSel_PRet_2_2_Comm_Fix(2)_BLK1repl_2003  
 0.1	 10	   1.031910	0	0	0	 4	#_SizeSel_PRet_2_2_Comm_Fix(2)_BLK1repl_2011  
20.0	100	  67.476900	0	0	0	 4	#_SizeSel_P_1_5_Rec_CA(5)_BLK4repl_1959       
20.0	100	  68.892900	0	0	0	 4	#_SizeSel_P_1_5_Rec_CA(5)_BLK4repl_1975       
20.0	100	  62.851600	0	0	0	 4	#_SizeSel_P_1_5_Rec_CA(5)_BLK4repl_1990       
20.0	100	  62.472600	0	0	0	 4	#_SizeSel_P_1_5_Rec_CA(5)_BLK4repl_2004       
-1.0	 15	   5.777250	0	0	0	 4	#_SizeSel_P_3_5_Rec_CA(5)_BLK4repl_1959       
-1.0	 15	   5.594410	0	0	0	 4	#_SizeSel_P_3_5_Rec_CA(5)_BLK4repl_1975       
-1.0	 15	   3.973670	0	0	0	 4	#_SizeSel_P_3_5_Rec_CA(5)_BLK4repl_1990       
-1.0	 15	   3.922900	0	0	0	 4	#_SizeSel_P_3_5_Rec_CA(5)_BLK4repl_2004       
-1.0	 15	   7.143340	0	0	0	 4	#_SizeSel_P_4_5_Rec_CA(5)_BLK4repl_1959       
-1.0	 15	   6.725230	0	0	0	 4	#_SizeSel_P_4_5_Rec_CA(5)_BLK4repl_1975       
-1.0	 15	   6.466990	0	0	0	 4	#_SizeSel_P_4_5_Rec_CA(5)_BLK4repl_1990       
-1.0	 15	   5.832270	0	0	0	 4	#_SizeSel_P_4_5_Rec_CA(5)_BLK4repl_2004       
14.0	 70	  23.159300	0	0	0	 3	#_SizeSel_P_1_6_Surv_TRI(6)_BLK5repl_1995     
-6.0	  4	 -15.000000	0	0	0	-3	#_SizeSel_P_2_6_Surv_TRI(6)_BLK5repl_1995     
-5.0	 15	  -4.029210	0	0	0	 3	#_SizeSel_P_3_6_Surv_TRI(6)_BLK5repl_1995     
-1.0	 15	  10.094700	0	0	0	 3	#_SizeSel_P_4_6_Surv_TRI(6)_BLK5repl_1995     
-5.0	  9	-999.000000	0	0	0	-2	#_SizeSel_P_5_6_Surv_TRI(6)_BLK5repl_1995     
-5.0	  9	-999.000000	0	0	0	-3	#_SizeSel_P_6_6_Surv_TRI(6)_BLK5repl_1995     
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
    4	1	0.216188	#_Variance_adjustment_list1 
    4	2	0.366526	#_Variance_adjustment_list2 
    4	5	0.024608	#_Variance_adjustment_list3 
    4	6	1.843590	#_Variance_adjustment_list4 
    4	7	0.125107	#_Variance_adjustment_list5 
    4	8	0.210389	#_Variance_adjustment_list6 
    4	9	0.890000	#_Variance_adjustment_list7 
    5	6	0.319920	#_Variance_adjustment_list8 
    5	7	0.298410	#_Variance_adjustment_list9 
    5	9	0.340000	#_Variance_adjustment_list10
-9999	0	0.000000	#_terminator                
#
1 #_maxlambdaphase
1 #_sd_offset; must be 1 if any growthCV, sigmaR, or survey extraSD is an estimated parameter
# read 0 changes to default Lambdas (default value is 1.0)
-9999 0 0 0 0 # terminator
#
0 # 0/1 read specs for more stddev reporting
#
999
