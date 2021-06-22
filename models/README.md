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
--   | --    | --    | --	        | --
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
2021.s.004.010_fewer_ages | remove ages for all but WCGBTS |  | 2021.n.004.009 | lingcod_model_bridging_newdata.R, remove_south_ages.R
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
