# list of lingcod models

This list is used by humans to keep track of our models as well as by 
the function `get_dir_ling()` to find the directory associated with a 
model id of the form `yyyy.[ns].000.000` where the directory names
use the scheme `yyyy.[ns].000.000.shortstring` as described in 
https://github.com/iantaylor-NOAA/Lingcod_2021/issues/32#issuecomment-827549522.

The elements are
- yyyy : the assessment model year
- [ns] : either n or s for north or south area; on Windows case matters; therefore, 
         it would be good if we could all use lower case so that model directories sort 
         similarly on everyone's machines and we do not have to push the shift key
- 000 : the base number
- 000 : the sensitivity number
- shortstring : a short character string without full stops but it can include 
                any other character you desire

# table

name | notes | issue | source_model | script
--   | --    | --    | --           | --
2017.n.001.001.final_base | 2017 base | #32 | archive | 
2017.s.001.001.final_base | 2017 base | #32 | archive | 
2017.s.002.001.SSv3.30.16.02 | testing newer SS version | #32 | 2017.s.001.001.final_base | models/lingcod_model_bridging_new_exe.R
2019.n.001.001.cou | 2019 base | #32 | archive | 
2019.n.002.001.SSv3.30.16.02 | testing newer SS version | #32 | 2019.n.001.001.cou | models/lingcod_model_bridging_new_exe.R
2019.s.001.001.cou | 2019 base | #32 | archive | 
2019.s.002.001.SSv3.30.16.02 | testing newer SS version | #32 | 2019.s.001.001.cou | models/lingcod_model_bridging_new_exe.R
2019.s.002.002.SSv3.30.16.02_par | testing newer SS version | #32 | 2019.s.001.001.cou | models/lingcod_model_bridging_new_exe.R
2019.s.003.001_update_catch_2019_structure | checking impact of new CA catch stream | #41 | 2019.s.002.001.SSv3.30.16.02_par | 
2019.n.003.001_update_catch_2019_structure | checking impact of new CA catch stream | #41 | 2019.n.002.001.SSv3.30.16.02 | 
2019.n.004.001_DM | apply Dirichlet-Multinomial to update_catch_2019_structure model | #49 | 2019.n.003.001_update_catch_2019_structure | 
2019.s.004.001_DM | apply Dirichlet-Multinomial to update_catch_2019_structure model | #49 | 2019.n.003.001_update_catch_2019_structure | 
2021.n.001.001_starting_point | renamed inputs and modified starter | #32 | 2019.s.002.001.SSv3.30.16.02 | lingcod_model_bridging_newfleets.R
2021.s.001.001_starting_point | renamed inputs and modified starter | #32 | 2019.s.002.002.SSv3.30.16.02_par | lingcod_model_bridging_newfleets.R
2021.n.002.001_new_fleets | reorganized fleets | #27 | 2021.n.001.001_starting_point | lingcod_model_bridging_newfleets.R
2021.s.002.001_new_fleets | reorganized fleets | #27 | 2021.s.001.001_starting_point | lingcod_model_bridging_newfleets.R
2021.n.003.001_DM | apply Dirichlet-Multinomial to new_fleets model | #49 | 2021.n.002.001_new_fleets | lingcod_model_bridging_DM.R
2021.s.003.001_DM | apply Dirichlet-Multinomial to new_fleets model | #49 | 2021.s.002.001_new_fleets | lingcod_model_bridging_DM.R
2021.n.004.001_new_data_test | adding new data, a work in progress | #32 | 2021.n.002.001_new_fleets | lingcod_model_bridging_newdata.R
2021.s.004.001_new_data_test | adding new data, a work in progress | #32 | 2021.s.002.001_new_fleets | lingcod_model_bridging_newdata.R
2021.n.004.002_new_data | adding new data after CPUE indices became available | #32, #56 | 2021.n.002.001_new_fleets | lingcod_model_bridging_newdata.R
2021.s.004.002_new_data | adding new data after CPUE indices became available | #32, #56 | 2021.s.002.001_new_fleets | lingcod_model_bridging_newdata.R
2021.n.004.003_new_data_fix1 | fix to marginal age comps added after 004.002 models | #32, #55, #56 | 2021.n.002.001_new_fleets | lingcod_model_bridging_newdata.R
2021.s.004.003_new_data_fix1 | fix to marginal age comps added after 004.002 models | #32, #55, #56 | 2021.s.002.001_new_fleets | lingcod_model_bridging_newdata.R
2021.n.004.004_new_data_fix2 | use unexpanded PacFIN length and marginal age comps | #69 | 2021.n.002.001_new_fleets | lingcod_model_bridging_newdata.R
2021.s.004.004_new_data_fix2 | use unexpanded PacFIN length and marginal age comps | #69 | 2021.s.002.001_new_fleets | lingcod_model_bridging_newdata.R
2021.n.004.005_fix1_filter_sparse | filter small samples with expanded data | #69 | 2021.n.004.003 | lingcod_model_filter_sparse_comps.R
2021.s.004.005_fix1_filter_sparse | filter small samples with expanded data | #69 | 2021.n.004.003 | lingcod_model_filter_sparse_comps.R
2021.n.004.006_fix2_filter_sparse | filter small samples with unexpanded data | #69 | 2021.n.004.004 | lingcod_model_filter_sparse_comps.R
2021.s.004.006_fix2_filter_sparse | filter small samples with unexpanded data | #69 | 2021.n.004.004 | lingcod_model_filter_sparse_comps.R
2021.n.004.007_revised_WA_rec_CPUE | include revised WA rec CPUE index along with unexpanded commercial comps and other fixes | #52 | 2021.n.002.001_new_fleets | lingcod_model_bridging_newdata.R
2021.n.004.008_remove_extra_index | recORCPFV got added by accident | #20, #59 | 2021.n.002.001_new_fleets | lingcod_model_bridging_newdata.R
2021.n.004.009_fix_duplicate_CAAL | CAAL for TW and FG were the same | #80 | 2021.n.002.001_new_fleets | lingcod_model_bridging_newdata.R
2021.s.004.009_fix_duplicate_CAAL | CAAL for TW and FG were the same | #80 | 2021.n.002.001_new_fleets | lingcod_model_bridging_newdata.R
2021.s.004.010_fewer_ages | remove ages for all but WCGBTS |  | 2021.s.004.009 | lingcod_model_bridging_newdata.R, remove_south_ages.R
2021.n.004.011_fewer_ages_scripted | remove ages for all but WCGBTS using the full workflow | #80, #83 | 2021.n.004.009 | lingcod_model_bridging_newdata.R, model_bridging_change_ages.R
2021.s.004.011_fewer_ages_scripted | remove ages for all but WCGBTS using the full workflow | #80, #83 | 2021.s.004.009 | lingcod_model_bridging_newdata.R, model_bridging_change_ages.R
2021.n.004.012_marginal_ages | marginal ages for all but WCGBTS |  | 2021.n.004.009 | lingcod_model_bridging_newdata.R, model_bridging_change_ages.R
2021.s.004.012_marginal_ages | marginal ages for all but WCGBTS |  | 2021.s.004.009 | lingcod_model_bridging_newdata.R, model_bridging_change_ages.R
2021.n.004.013_rec_CAAL | use CAAL for the rec fleets (previous had it marginal) | #80, #83 | 2021.n.002.001 | lingcod_model_bridging_newdata.R
2021.n.004.014_no_fishery_ages | remove fishery ages, all others as CAAL | #87 | 2021.n.004.013 | lingcod_model_bridging_newdata.R, model_bridging_change_ages.R
2021.s.004.014_no_fishery_ages | remove fishery ages, all others as CAAL | #87 | 2021.s.004.009 | lingcod_model_bridging_newdata.R, model_bridging_change_ages.R
2021.n.005.001_initial_ctl_changes | initial default assumptions in the control file | #59 | 2021.n.004.002_new_data | lingcod_model_bridging_change_ctl.R
2021.s.005.001_initial_ctl_changes | initial default assumptions in the control file | #59 | 2021.s.004.002_new_data | lingcod_model_bridging_change_ctl.R
2021.n.006.001_next_ctl_changes | continuing control file changes while leaving model 5 results for exploration | #59 | 2021.n.004.002_new_data | lingcod_model_bridging_change_ctl.R
2021.s.006.001_next_ctl_changes | continuing control file changes while leaving model 5 results for exploration | #59 | 2021.s.004.002_new_data | lingcod_model_bridging_change_ctl.R
2021.n.007.001_get_tv_selex | use the control.ss_new file to get the automatically generated time-varying selectivity parameters from model 6 | #59 | 2021.n.006.001_next_ctl_changes | lingcod_model_bridging_change_ctl.R
2021.s.007.001_get_tv_selex | use the control.ss_new file to get the automatically generated time-varying selectivity parameters from model 6 | #59 | 2021.s.006.001_next_ctl_changes | lingcod_model_bridging_change_ctl.R
2021.n.007.002_DM | apply Dirichlet_Multinomial | #59 | 2021.n.007.001_get_tv_selex | lingcod_model_bridging_change_ctl.R
2021.s.007.002_DM | apply Dirichlet_Multinomial | #59 | 2021.s.007.001_get_tv_selex | lingcod_model_bridging_change_ctl.R
2021.n.007.003_Francis | apply Francis tuning | #59 | 2021.n.007.001_get_tv_selex | lingcod_model_bridging_change_ctl.R
2021.s.007.003_Francis | apply Francis tuning | #59 | 2021.s.007.001_get_tv_selex | lingcod_model_bridging_change_ctl.R
2021.n.008.001_selblocks | add new blocks for selectivity and retention | #58, #59, #61 | 2021.n.004.007 | lingcod_model_bridging_change_ctl.R
2021.s.008.001_selblocks | add new blocks for selectivity and retention | #58, #59, #61 | 2021.s.004.004 | lingcod_model_bridging_change_ctl.R
2021.n.008.002_add_forecast | adding forecast to above models | #59 | 2021.n.008.001 | lingcod_forecast.R
2021.s.008.002_add_forecast | adding forecast to above models | #59 | 2021.s.008.001 | lingcod_forecast.R
2021.n.008.003_fix_error | fix ADMB error by removing extra index, also add forecast | #59 | 2021.n.004.008 | lingcod_forecast.R, lingcod_model_bridging_change_ctl.R
2021.n.008.004_Mbound_no_ret_male_offset | increase M upper bound to 5.0  (should have been 0.5), remove offset for male selectivity | #58, #59 | 2021.n.004.008 | lingcod_model_bridging_change_ctl.R
2021.s.008.004_Mbound | increase M upper bound to 5.0 (should have been 0.5) | #59 | 2021.s.004.004 | lingcod_model_bridging_change_ctl.R
2021.n.008.005_Francis | apply Francis tuning to previous model | #59 | 2021.n.008.004 | lingcod_model_bridging_change_ctl.R
2021.s.008.005_Francis | apply Francis tuning to previous model | #59 | 2021.s.008.004 | lingcod_model_bridging_change_ctl.R
2021.n.008.006_discardSD | increase discard uncertainty by 0.05 | #59 | 2021.n.008.005 | lingcod_model_bridging_change_ctl.R, lingcod_model_discardSD.R
2021.s.008.006_discardSD | increase discard uncertainty by 0.05 | #59 | 2021.s.008.005 | lingcod_model_bridging_change_ctl.R, lingcod_model_discardSD.R
2021.n.008.008_CV_growth1 | change CV_Growth_Pattern from 0 to 1 (with Growth_Age_for_L2 = 14) | #76 | 2021.n.008.005 | lingcod_model_bridging_change_ctl.R
2021.s.008.008_CV_growth1 | change CV_Growth_Pattern from 0 to 1 | #76 | 2021.s.008.005 | lingcod_model_bridging_change_ctl.R
2021.n.008.009_age999_for_L2 | increase Growth_Age_for_L2 to 999 | #76 | 2021.n.008.005 | lingcod_model_bridging_change_ctl.R
2021.s.008.009_age999_for_L2 | increase Growth_Age_for_L2 to 999 | #76 | 2021.n.008.005 | lingcod_model_bridging_change_ctl.R
2021.s.008.010_selex_test | initial_selex | #76 | 2021.n.008.005 | lingcod_model_bridging_change_ctl.R
2021.s.008.011_selex_test2 | initial_selex | #76 | 2021.n.008.005 | lingcod_model_bridging_change_ctl.R
2021.n.008.012_split_TRI_Q | estimate change in tri Q | #59 | 2021.n.008.006 | manual edit to control file
2021.s.008.012_split_TRI_Q | estimate change in tri Q | #59 | 2021.n.008.006 | manual edit to control file
2021.n.009.001_simplify | use 3.30.17.01, turn off a few parameters (remove block on Surv_TRI selex) | #76 | 2021.n.008.005 | lingcod_model_bridging_change_ctl.R, lingcod_forecast.R
2021.s.009.001_simplify | use 3.30.17.01, turn off a few parameters (fix Q_extraSD_10_CPFV_DebWV = 0, remove block on Surv_TRI selex) | #76 | 2021.s.008.005 | lingcod_model_bridging_change_ctl.R, lingcod_forecast.R
2021.n.009.002_applyFrancis | apply Francis tuning to model above | #76 | 2021.n.009.001 | lingcod_model_bridging_change_ctl.R, lingcod_forecast.R, r4ss::SS_tune_comps()
2021.s.009.002_applyFrancis | apply Francis tuning to model above | #76 | 2021.n.009.001 | lingcod_model_bridging_change_ctl.R, lingcod_forecast.R, r4ss::SS_tune_comps()
2021.n.009.003_asymptotic_FG | force fixed-gear selectivity asymptotic | #76 | 2021.n.009.001 | lingcod_model_bridging_change_ctl.R
2021.s.009.003_asymptotic_FG | force fixed-gear selectivity asymptotic | #76 | 2021.n.009.001 | lingcod_model_bridging_change_ctl.R
2021.n.010.001_fix_duplicate_CAAL | failed fix to remove duplicate CAAL from commercial fleets | #80 | 2021.n.004.009 | lingcod_model_bridging_change_ctl.R
2021.s.010.001_fix_duplicate_CAAL | failed fix to remove duplicate CAAL from commercial fleets | #80 | 2021.n.004.009 | lingcod_model_bridging_change_ctl.R
2021.n.010.002_Francis | apply Francis tuning to above models | #80 | 2021.n.010.001 | lingcod_model_bridging_change_ctl.R
2021.s.010.002_Francis | apply Francis tuning to above models | #80 | 2021.n.010.001 | lingcod_model_bridging_change_ctl.R
2021.n.011.001_v2_fix_duplicate_CAAL | FOR REAL remove duplicate CAAL from commercial fleets | #80 | 2021.n.004.009 | lingcod_model_bridging_change_ctl.R
2021.s.011.001_v2_fix_duplicate_CAAL | FOR REAL remove duplicate CAAL from commercial fleets | #80 | 2021.n.004.009 | lingcod_model_bridging_change_ctl.R
2021.n.011.002_v2_Francis | apply Francis tuning to above models | #80 | 2021.n.010.001 | lingcod_model_bridging_change_ctl.R
2021.s.011.002_v2_Francis | apply Francis tuning to above models | #80 | 2021.n.010.001 | lingcod_model_bridging_change_ctl.R
2021.n.011.003_Mprior | divide sd of M prior by 2 | #80 | 2021.n.011.002 | lingcod_model_bridging_change_ctl.R
2021.s.011.003_Mprior | divide sd of M prior by 2 | #80 | 2021.n.011.002 | lingcod_model_bridging_change_ctl.R
2021.n.011.004_Mprior_est_h | divide sd of M prior by 2 and estimate steepness | #80 | 2021.n.011.002 | lingcod_model_bridging_change_ctl.R
2021.s.011.004_Mprior_est_h | divide sd of M prior by 2 and estimate steepness | #80 | 2021.n.011.002 | lingcod_model_bridging_change_ctl.R
2021.n.011.005_Rec_CA_blocks | add blocks to Rec_CA catch and Q | #80 | 2021.n.011.003 | lingcod_model_bridging_change_ctl.R
2021.s.011.005_Rec_CA_blocks | add blocks to Rec_CA catch and Q | #80 | 2021.s.011.003 | lingcod_model_bridging_change_ctl.R
2021.n.011.006_fewer_recdevs | turn off recdevs prior to 1980 | #80 | 2021.n.011.005 | lingcod_model_bridging_change_ctl.R
2021.s.011.006_fewer_recdevs | turn off recdevs prior to 1980 | #80 | 2021.s.011.005 | lingcod_model_bridging_change_ctl.R
2021.n.011.007_DM | apply DM tuning to 011.005 models | #80 | 2021.n.011.005 | lingcod_model_bridging_change_ctl.R
2021.s.011.007_DM | apply DM tuning to 011.005 models | #80 | 2021.s.011.005 | lingcod_model_bridging_change_ctl.R
2021.n.011.008_Francis | apply Francis tuning to 011.005 models |   | 2021.n.011.005 | lingcod_model_bridging_change_ctl.R
2021.s.011.008_Francis | apply Francis tuning to 011.005 models |   | 2021.s.011.005 | lingcod_model_bridging_change_ctl.R
2021.s.011.010_asymptotic_FG | force fixed-gear selectivity asymptotic |   | 2021.s.011.008 | lingcod_model_bridging_change_ctl.R
2021.s.012.001_fewer_ages | remove the CAAL from all but WCGBTS |   | 2021.s.011.008 | lingcod_model_bridging_change_ctl.R, remove_ages_south.R
2021.s.012.002_fewer_ages_fix_oldM | remove the CAAL from all but WCGBTS and fix M at old value |   | 2021.s.012.001 | lingcod_model_bridging_change_ctl.R
2021.s.012.003_fewer_ages_wide_M_prior | remove the CAAL from all but WCGBTS and restore the original 2021 M priors |   | 2021.s.012.001 | lingcod_model_bridging_change_ctl.R, remove_ages_south.R
2021.s.012.004_fewer_ages_wide_M_prior_Francis | Francis tuning to model 2021.s.012.003. |   | 2021.s.012.001 | lingcod_model_bridging_change_ctl.R, remove_ages_south.R
2021.s.012.005_reverse_profiles | same as 12.004 but for runnig profiles in reverse |   | 2021.s.012.004 | lingcod_model_bridging_change_ctl.R
2021.n.014.001_esth | estimate h with prior | #83, #85 | 2021.n.011.008 | lingcod_model_bridging_change_ctl.R, esth.R
2021.s.014.001_esth | estimate h with prior | #83, #85 | 2021.s.012.004 | lingcod_model_bridging_change_ctl.R, esth.R
2021.s.014.010_forecast | adds a forecast to the current base model | #73 | 2021.s.014.001 | lingcod_forecast.R
2021.n.014.002_marginals | sensitivity to including ages as marginals | #80, #83 | 2021.n.004.012 | lingcod_model_bridging_change_ctl.R 
2021.s.014.002_marginals | sensitivity to including ages as marginals | #80, #83 | 2021.s.004.012 | lingcod_model_bridging_change_ctl.R 
2021.n.014.003_fewer_ages | north model equivalent of 2021.s.014.001  | #80, #83 | 2021.n.004.011 | lingcod_model_bridging_change_ctl.R 
2021.s.014.003_fewer_ages | should be identical to 2021.s.014.001 only created with different script  | #80, #83 | 2021.s.004.011 | lingcod_model_bridging_change_ctl.R
2021.n.014.004_no_rec_WA_index | remove WA rec index |  | 2021.n.011.008 | lingcod_model_bridging_change_ctl.R
2021.n.015.001_allCAALages | Rec_WA and Rec_OR as CAAL  | #80, #83 | 2021.n.004.013 | lingcod_model_bridging_change_ctl.R 
2021.n.015.002_allCAALages_no_rec_WA_index | rec as CAAL plus remove WA rec index  | #83 | 2021.n.004.013 | lingcod_model_bridging_change_ctl.R 
2021.n.015.003_Francis | Francis tuning of model with all ages as CAAL  | #83 | 2021.n.015.001 | lingcod_model_bridging_change_ctl.R 
2021.n.015.004_extraSD | turn on extraSD for Tri and float for all indices  | #83 | 2021.n.015.003 | lingcod_model_bridging_change_ctl.R 
2021.n.016.001_tune | tune bias recruitment adjustment settings  | #99 | 2021.n.015.004 | lingcod_model_bridging_change_ctl.R 
2021.n.017.001_no_fishery_ages | make all fishery ages ghost fleets | #87 | 2021.n.004.014 | lingcod_model_bridging_change_ctl.R
2021.n.016.002_tune_sample | Run 90 of 100 from 2021.n.016.001_tune, must start from par | #99 | 2021.n.016.001 | northjittermove.R 
2021.s.014.101_shareM                 | senstivities run on 25 June 2021 | #43 | 2021.s.014.001 | run_sensitivities()
2021.s.014.102_h0.7                   | senstivities run on 25 June 2021 | #43 | 2021.s.014.001 | run_sensitivities()
2021.s.014.103_M0.3_h0.7              | senstivities run on 25 June 2021 | #43 | 2021.s.014.001 | run_sensitivities()
2021.s.014.104_sigmaR0.8              | senstivities run on 25 June 2021 | #43 | 2021.s.014.001 | run_sensitivities()
2021.s.014.105_sigmaR0.4              | senstivities run on 25 June 2021 | #43 | 2021.s.014.001 | run_sensitivities()
2021.s.014.303_no_fishery_indices     | senstivities run on 25 June 2021 | #43 | 2021.s.014.001 | run_sensitivities()
2021.s.014.321_no_fishery_indices_v2     | same as no_fishery_indices but with DebWV index removed | #43 | 2021.s.014.001 | run_sensitivities()
2021.s.014.311_no_Comm_Trawl_index    | senstivities run on 25 June 2021 | #43 | 2021.s.014.001 | run_sensitivities()
2021.s.014.312_no_Comm_Fix_index      | senstivities run on 25 June 2021 | #43 | 2021.s.014.001 | run_sensitivities()
2021.s.014.313_no_Rec_WA_index        | senstivities run on 25 June 2021 | #43 | 2021.s.014.001 | run_sensitivities()
2021.s.014.314_no_Rec_OR_index        | senstivities run on 25 June 2021 | #43 | 2021.s.014.001 | run_sensitivities()
2021.s.014.315_no_Rec_CA_index        | senstivities run on 25 June 2021 | #43 | 2021.s.014.001 | run_sensitivities()
2021.s.014.316_no_Surv_TRI_index      | senstivities run on 25 June 2021 | #43 | 2021.s.014.001 | run_sensitivities()
2021.s.014.317_no_Surv_WCGBTS_index   | senstivities run on 25 June 2021 | #43 | 2021.s.014.001 | run_sensitivities()
2021.s.014.318_no_Surv_HookLine_index | senstivities run on 25 June 2021 | #43 | 2021.s.014.001 | run_sensitivities()
2021.s.014.320_no_CPFV_DebWV_index    | senstivities run on 25 June 2021 | #43 | 2021.s.014.001 | run_sensitivities()
2021.n.016.003_fix_pars_on_bounds | fix some parameters that are on bounds | #99 | 2021.n.016.001 | manual edits
2021.n.016.004_wider_bounds | fix some parameters that are on bounds and widen other bounds | #99 | 2021.n.016.001 | manual edits
2021.n.016.005_wider_bounds_Francis | fix some parameters that are on bounds and widen other bounds | #99 | 2021.n.016.001 | manual edits
2021.n.018.001_refined | scripted version of 2021.n.016.005 | #99 | 2021.n.016.001 | lingcod_model_bridging_change_ctl.R 
2021.n.019.001_fewer_blocks | removing a couple blocks | #99 | 2021.n.016.001 | lingcod_model_bridging_change_ctl.R 
2021.n.019.002_add_asymp_ret | adding parameter for asymptotic retention in the trawl fishery | #99 | 2021.n.019.001 | manual edit
2021.n.019.003_tune_discard_comps | reduce the sample size of the discard comps by 50% | #99 | 2021.n.019.001 | model_tune_discard_comps.R
2021.n.020.001_refined_fixed | like 2021.n.018.001_refined but with 3 sel and ret parameters fixed on bounds | #99 | 2021.n.018.001 | lingcod_model_bridging_change_ctl.R 
2021.n.020.010_forecast | adds a forecast to current base model | #99 | 2021.n.020.001 | lingcod_forecast.R
2021.n.020.101_shareM                  | sensitivities run on 26 June 2021 | #99 | 2021.n.020.001 | run_sensitivities() 
2021.n.020.102_h0.7                    | sensitivities run on 26 June 2021 | #99 | 2021.n.020.001 | run_sensitivities()
2021.n.020.103_M0.3_h0.7               | sensitivities run on 26 June 2021 | #99 | 2021.n.020.001 | run_sensitivities()
2021.n.020.104_sigmaR0.8               | sensitivities run on 26 June 2021 | #99 | 2021.n.020.001 | run_sensitivities()
2021.n.020.105_sigmaR0.4               | sensitivities run on 26 June 2021 | #99 | 2021.n.020.001 | run_sensitivities()
2021.n.020.302_OR_CPFV_index           | sensitivities run on 26 June 2021 | #99 | 2021.n.020.001 | run_sensitivities()
2021.n.020.303_no_fishery_indices      | sensitivities run on 26 June 2021 | #99 | 2021.n.020.001 | run_sensitivities()
2021.n.020.311_no_Comm_Trawl_index     | sensitivities run on 26 June 2021 | #99 | 2021.n.020.001 | run_sensitivities()
2021.n.020.312_no_Comm_Fix_index       | sensitivities run on 26 June 2021 | #99 | 2021.n.020.001 | run_sensitivities()
2021.n.020.313_no_Rec_WA_index         | sensitivities run on 26 June 2021 | #99 | 2021.n.020.001 | run_sensitivities()
2021.n.020.314_no_Rec_OR_index         | sensitivities run on 26 June 2021 | #99 | 2021.n.020.001 | run_sensitivities()
2021.n.020.315_no_Rec_CA_index         | sensitivities run on 26 June 2021 | #99 | 2021.n.020.001 | run_sensitivities()
2021.n.020.316_no_Surv_TRI_index       | sensitivities run on 26 June 2021 | #99 | 2021.n.020.001 | run_sensitivities()
2021.n.020.317_no_Surv_WCGBTS_index    | sensitivities run on 26 June 2021 | #99 | 2021.n.020.001 | run_sensitivities()
2021.n.020.318_no_Surv_HookLine_index  | sensitivities run on 26 June 2021 | #99 | 2021.n.020.001 | run_sensitivities()
2021.n.021.001_more_asymptotic | like 2021.n.020.001_refined_fixed but all asymptotic selex fixed at upper bound | NA | 2021.n.020.001 | lingcod_model_bridging_change_ctl.R, lingcod_forecast.R
2021.n.021.002_more_asymptotic_manual | manual edits that match above model | NA | 2021.n.020.001 | manual edit
2021.n.021.003_more_asymptotic_manual_hess | manual edits that match above model | NA | 2021.n.020.001 | manual edit
2021.n.020.020_refined_fixed_jitterpar | | #111 | |
2021.n.022.001_new_INIT | like 2021.n.021.001 but with new initial values | #111 | 2021.n.021.001 | lingcod_model_bridging_change_ctl.R
2021.s.014.201_all_CAAL_ages  | comp sensitivities run on 27 June 2021 | NA | 2021.s.014.001 | run_sensitivities()
2021.s.014.202_all_marg_ages  | comp sensitivities run on 27 June 2021 | NA | 2021.s.014.001 | run_sensitivities()
2021.s.014.206_combMF		  | comp sensitivities run on 27 June 2021 | NA | 2021.s.014.001 | run_sensitivities()
2021.s.014.207_no_unsexed     | comp sensitivities run on 27 June 2021 | NA | 2021.s.014.001 | run_sensitivities()
2021.s.014.208_DM			  | fixed DM sensitivity | NA | 2021.s.014.001 | run_sensitivities()
2021.n.022.101_shareM                | north sensitivities run on 27 June 2021 | #43 | 2021.n.022.001 | run_sensitivities()
2021.n.022.102_h0.7                  | north sensitivities run on 27 June 2021 | #43 | 2021.n.022.001 | run_sensitivities()
2021.n.022.103_M0.3_h0.7             | north sensitivities run on 27 June 2021 | #43 | 2021.n.022.001 | run_sensitivities()
2021.n.022.104_sigmaR0.8             | north sensitivities run on 27 June 2021 | #43 | 2021.n.022.001 | run_sensitivities()
2021.n.022.105_sigmaR0.4             | north sensitivities run on 27 June 2021 | #43 | 2021.n.022.001 | run_sensitivities()
2021.n.022.204_no_fishery_ages       | north sensitivities run on 27 June 2021 | #43 | 2021.n.022.001 | run_sensitivities()
2021.n.022.206_combMF                | north sensitivities run on 27 June 2021 | #43 | 2021.n.022.001 | run_sensitivities()
2021.n.022.207_no_unsexed            | north sensitivities run on 27 June 2021 | #43 | 2021.n.022.001 | run_sensitivities()
2021.n.022.208_DM            | fixed DM sensitivity | #43 | 2021.n.022.001 | run_sensitivities()
2021.n.022.303_no_fishery_indices    | north sensitivities run on 27 June 2021 | #43 | 2021.n.022.001 | run_sensitivities()
2021.n.022.311_no_Comm_Trawl_index   | north sensitivities run on 27 June 2021 | #43 | 2021.n.022.001 | run_sensitivities()
2021.n.022.312_no_Comm_Fix_index     | north sensitivities run on 27 June 2021 | #43 | 2021.n.022.001 | run_sensitivities()
2021.n.022.313_no_Rec_WA_index       | north sensitivities run on 27 June 2021 | #43 | 2021.n.022.001 | run_sensitivities()
2021.n.022.314_no_Rec_OR_index       | north sensitivities run on 27 June 2021 | #43 | 2021.n.022.001 | run_sensitivities()
2021.n.022.315_no_Rec_CA_index       | north sensitivities run on 27 June 2021 | #43 | 2021.n.022.001 | run_sensitivities()
2021.n.022.316_no_Surv_TRI_index     | north sensitivities run on 27 June 2021 | #43 | 2021.n.022.001 | run_sensitivities()
2021.n.022.317_no_Surv_WCGBTS_index  | north sensitivities run on 27 June 2021 | #43 | 2021.n.022.001 | run_sensitivities()
2021.n.022.302_OR_CPFV_index         | ran sensitivity on 8 July 2021          | #48 | 2021.n.022.001 | lingcod_model_alt_indices.R
2021.s.014.301_CA_CRFSPR_index       | ran sensitivity on 8 July 2021          | #48 | 2021.s.014.001 | lingcod_model_alt_indices.R
2021.s.014.401_asymptotic_FG   |   fixed-gear fishery asymptotic | #43 | 2021.s.014.001 | run_sensitivities(), model_sensitivity_output.R
2021.n.022.402_male_sel_offset   |   male offset sensitivity | #43 | 2021.n.022.001 | run_sensitivities(), model_sensitivity_output.R
2021.s.014.402_male_sel_offset   |   male offset sensitivity | #43 | 2021.s.014.001 | run_sensitivities(), model_sensitivity_output.R
2021.n.022.403_female_sel_offset | female offset sensitivity | #43 | 2021.n.022.001 | run_sensitivities(), model_sensitivity_output.R
2021.s.014.403_female_sel_offset | female offset sensitivity | #43 | 2021.s.014.001 | run_sensitivities(), model_sensitivity_output.R
2021.n.022.404_female_sel_offset | female offset sensitivity (2nd try) | #43 | 2021.n.022.001 | run_sensitivities(), model_sensitivity_output.R
2021.s.014.404_female_sel_offset | female offset sensitivity (2nd try) | #43 | 2021.s.014.001 | run_sensitivities(), model_sensitivity_output.R
2021.n.022.405_female_sel_offset_M0.3 | fix female M = 0.3 and add female offsets to selectivity | #43 | 2021.n.022.001 | run_sensitivities(), model_sensitivity_output.R
2021.s.014.405_female_sel_offset_M0.3 | fix female M = 0.3 and add female offsets to selectivity | #43 | 2021.s.014.001 | run_sensitivities(), model_sensitivity_output.R
2021.n.022.406_less_early_retention | make retention in the early period equal to the recent period | #43 | 2021.n.022.001 | run_sensitivities(), model_sensitivity_output.R
2021.s.014.406_less_early_retention | make retention in the early period equal to the recent period | #43 | 2021.s.014.001 | run_sensitivities(), model_sensitivity_output.R
2021.s.014.803_no_earlyDevs         | remove early recdevs after starting main recdevs in 1955 | #139 | 2021.s.014.001 | lingcod_model_STAR_D1R3_recdevs.R
2021.s.014.804_no_earlyDevs_biasAdj | update bias adjust values | #139 | 2021.s.014.803 | lingcod_model_STAR_D1R3_recdevs.R
2021.s.014.407_female_sel_offset_flattop | STAR request 1 for south: female offsets with flat top for some fleets | #137 | 2021.n.022.001 | run_sensitivities()
2021.n.022.408_female_sel_offset_flattop | STAR request 1 for north: female offsets with flat top for some fleets | #137 | 2021.s.014.001 | run_sensitivities()
2021.s.014.806_recBlock_1972        | block early CA rec ending in 1972 | #143 | 2021.s.014.001 | manual edits
2021.n.023.001_fixWAreccatchhistory        | Fix WA rec discard in catch | #142 | 2021.n.022.001_new_INIT | model_fixWAreccatchhistory.R
2021.s.014.806_esth_removecomp1975adjusted | Remove comps prior to 1975 | #143 | 2021.s.014.001_esth | manual edits
2021.n.023.221_no_fixed-gear_ages|STAR request 8: remove fixed-gear ages | #145 | 2021.n.023.001 | run_sensitivites(), model_STAR_requests.R
2021.n.023.222_no_fixed-gear_ages_1999-2011|STAR request 8: remove fixed-gear ages from 1999-2011 | #145 | 2021.n.023.001 | run_sensitivites(), model_STAR_requests.R
2021.n.023.223_female_sel_offset_no_fixed-gear_ages|STAR request 8: sex-specific selectivity and remove fixed-gear ages | #145 | 2021.n.023.001 | run_sensitivites(), model_STAR_requests.R
2021.n.023.224_female_sel_offset_no_fixed-gear_ages_1999-2011|STAR request 8: sex-specific selectivity and remove fixed-gear ages from 1999-2011 | #145 | 2021.n.023.001 | run_sensitivites(), model_STAR_requests.R
2021.n.023.225_remove_fishery_ages_before_1990|reverse retrospective on commercial ages | #145 | 2021.n.023.001 | run_sensitivites(), model_STAR_requests.R
2021.n.023.226_remove_fishery_ages_before_2000|reverse retrospective on commercial ages | #145 | 2021.n.023.001 | run_sensitivites(), model_STAR_requests.R
2021.n.023.404_female_sel_offset | female offset sensitivity | #118 | 2021.n.023.001 | run_sensitivities(), model_STAR_requests.R
2021.n.023.411_female_sel_offset_fisheries | female offset sensitivity | #118 #151 | 2021.n.023.001 | run_sensitivities(), model_STAR_requests.R
2021.s.015.001_reweight | Reweight Francis weights | #146 | 2021.s.014.806_esth_removecomp1975adjusted | lingcod_model_STAR_R9_reweight.R
2021.s.016.001_triextrasd | Add extra sd to Triennial | #146 | 2021.s.015.001_reweight | manual
2021.s.017.001_triextrasdreweight | Tune comps | #146 | 2021.s.016.001_triextrasd | lingcod_model_STAR_R9_reweight.R
2021.s.017.411_female_sel_offset_fisheries | female offset sensitivity | #118 #151 | 2021.s.017.001 | run_sensitivities(), model_STAR_requests.R
2021.n.023.800_lorenzenm | Lorenzen M Age 7 | #150 | 2021.n.023.001_fixWAreccatchhistory | model_STAR_request_10.R
2021.s.017.800_lorenzenm | Lorenzen M Age 7 | #150 | 2021.s.017.001_triextrasdreweight | model_STAR_request_10.R
2021.n.023.801_lorenzenm | Lorenzen M Age 8 | #150 | 2021.n.023.001_fixWAreccatchhistory | model_STAR_request_10.R
2021.s.017.801_lorenzenm | Lorenzen M Age 8 | #150 | 2021.s.017.001_triextrasdreweight | model_STAR_request_10.R
2021.s.017.802_lorenzenm | Lorenzen M Age 8 free up Tri selectivity | #150 | 2021.s.017.801_lorenzenm | manual
2021.s.017.412_female_sel_offset_fisheriesFixTriSlx | Tri Slx Offset | #150 | 2021.s.017.411_female_sel_offset_fisheries | manual
2021.s.017.803_lorenzenm | Lorenzen M Free Tri Slx Offset | #150 | 2021.s.017.412_female_sel_offset_fisheriesFixTriSlx | model_STAR_request_10.R
2021.n.023.802_offsetLM | female offset sensitivity | #150 #151 | 2021.n.023.411_female_sel_offset_fisheries | run_sensitivities(), model_STAR_requests.R
2021.n.023.901_trawl_discard_rates             | actually a combinationof 902 and 904  | #155 | 2021.n.023.001_fixWAreccatchhistory | lingcod_model_STAR_R14_discard.R
2021.n.023.902_discard_se                      | reduced standard error of discard rates for fleet1            | #155 | 2021.n.023.001_fixWAreccatchhistory | lingcod_model_STAR_R14_discard.R
2021.n.023.903_trawl_rates_discard_se          | less reduced se of discard rates for fleet2 than sens 901     | #155 | 2021.n.023.001_fixWAreccatchhistory | lingcod_model_STAR_R14_discard.R
2021.n.023.904_sample_size                     | downweight sample sizes of discard lengths for fleet1         | #155 | 2021.n.023.001_fixWAreccatchhistory | lingcod_model_STAR_R14_discard.R
2021.s.017.810_cutnuseDM | Tune comps with smaller input | intuition | 2021.s.017.001_triextrasdreweight | lingcod_model_STAR_R9_reweight.R
2021.n.023.413_asymptotic_TW | fix the commercial trawl selectivity to be asymptotic for all blocks | #156 | 2021.n.023.001 | run_sensitivities(), model_STAR_requests.R
2021.s.017.413_asymptotic_TW | fix the commercial trawl selectivity to be asymptotic for all blocks | #156 | 2021.s.017.001 | run_sensitivities(), model_STAR_requests.R
2021.n.023.414_descend_shared_across_blocks | make the descending slope of the selectivity function equal for all blocks | #156 | 2021.n.023.001 | run_sensitivities(), model_STAR_requests.R
2021.s.017.414_descend_shared_across_blocks | make the descending slope of the selectivity function equal for all blocks | #156 | 2021.s.017.001 | run_sensitivities(), model_STAR_requests.R
2021.n.023.415_sex_sel_descend_shared | make the descending slope of the selectivity function sex-specific and equal for all blocks | #156 | 2021.n.023.001 | run_sensitivities(), model_STAR_requests.R
2021.s.017.415_sex_sel_descend_shared | make the descending slope of the selectivity function sex-specific and equal for all blocks | #156 | 2021.s.017.001 | run_sensitivities(), model_STAR_requests.R
2021.n.023.416_descend_shared_rec | make the descending slope of the selectivity function equal for all blocks within the rec fleets | #156 | 2021.n.023.001 | run_sensitivities(), model_STAR_requests.R
2021.s.017.416_descend_shared_rec | make the descending slope of the selectivity function equal for all blocks within the rec fleets | #156 | 2021.s.017.001 | run_sensitivities(), model_STAR_requests.R
2021.n.023.417_sex_sel_descend_shared_rec | make the descending slope of the selectivity function sex-specific and equal for all blocks within the rec fleets | #156 | 2021.n.023.001 | run_sensitivities(), model_STAR_requests.R
2021.s.017.417_sex_sel_descend_shared_rec | make the descending slope of the selectivity function sex-specific and equal for all blocks within the rec fleets | #156 | 2021.s.017.001 | run_sensitivities(), model_STAR_requests.R 
2021.n.023.418_flexible_retention | estimate the retention slope for each block | #156 | 2021.n.023.001 | manual 
2021.n.023.419_sex_sel_descend | make the descending slope of the selectivity function sex-specific | #156 | 2021.n.023.001 | run_sensitivities(), model_STAR_requests.R
2021.s.017.419_sex_sel_descend | make the descending slope of the selectivity function sex-specific | #156 | 2021.s.017.001 | run_sensitivities(), model_STAR_requests.R 
2021.n.023.420_sex_sel_scale_descend_fisheries | make the scale and descending slope of the selectivity function sex-specific for fisheries only | #156 | 2021.n.023.001 | run_sensitivities(), model_STAR_requests.R
2021.s.017.420_sex_sel_scale_descend_fisheries | make the scale and descending slope of the selectivity function sex-specific for fisheries only | #156 | 2021.s.017.001 | run_sensitivities(), model_STAR_requests.R 
2021.n.023.421_sex_sel_peak_descend_fisheries | make the peak and descending slope of the selectivity function sex-specific for fisheries only | #156 | 2021.n.023.001 | run_sensitivities(), model_STAR_requests.R
2021.s.017.421_sex_sel_peak_descend_fisheries | make the peak and descending slope of the selectivity function sex-specific for fisheries only | #156 | 2021.s.017.001 | run_sensitivities(), model_STAR_requests.R 
2021.s.017.422_init_values | test south model sensitivity to initial values | #156 | 2021.s.017.419 | model_STAR_requests.R 
2021.s.017.412_female_sel_offset_fisheriesFixTriSlx | Tri Slx Offset | #150 | 2021.s.017.411_female_sel_offset_fisheries | manual
2021.s.017.803_lorenzenm | Lorenzen M Free Tri Slx Offset | #150 | 2021.s.017.412_female_sel_offset_fisheriesFixTriSlx | manual
2021.n.023.002_tighterM | divide sd of M in half |  | 2021.n.023.001_fixWAreccatchhistory | 
2021.n.913_discard_trawl_rates_se_tighterM | divide sd of M in half |  | 2021.n.023.903_trawl_rates_discard_se | 
2021.n.023.423_sex_sel_descend_shared_recTighterM | divide sd of M in half |  | 2021.n.023.417_sex_sel_descend_shared_rec | 
2021.n.023.003_fixM | fix M at the median of the prior | req 16 | 2021.n.023.001_fixWAreccatchhistory | 
2021.n.023.204_no_fishery_ages | remove fishery-dependent ages, all others as CAAL | req 20 | 2021.n.023.001 | run_sensitivities(), model_STAR_requests.R
2021.n.023.010_forecast | adds a forecast | #99 | 2021.n.023.001 | lingcod_forecast.R
2021.s.018.001_fixTri3 |  |  |  | 
2021.s.018.010_forecast | adds a forecast | #99 | 2021.s.018.001 | lingcod_forecast.R
