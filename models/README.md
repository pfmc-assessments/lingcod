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
2021.s.004.007_revised_WA_rec_CPUE | include revised WA rec CPUE index along with unexpanded commercial comps and other fixes | #52 | 2021.s.002.001_new_fleets | lingcod_model_bridging_newdata.R
2021.n.005.001_initial_ctl_changes | initial default assumptions in the control file | #59 | 2021.n.004.002_new_data | model_bridging_change_ctl.R
2021.s.005.001_initial_ctl_changes | initial default assumptions in the control file | #59 | 2021.s.004.002_new_data | model_bridging_change_ctl.R
2021.n.006.001_next_ctl_changes | continuing control file changes while leaving model 5 results for exploration | #59 | 2021.n.004.002_new_data | model_bridging_change_ctl.R
2021.s.006.001_next_ctl_changes | continuing control file changes while leaving model 5 results for exploration | #59 | 2021.s.004.002_new_data | model_bridging_change_ctl.R
2021.n.007.001_get_tv_selex | use the control.ss_new file to get the automatically generated time-varying selectivity parameters from model 6 | #59 | 2021.n.006.001_next_ctl_changes | model_bridging_change_ctl.R
2021.s.007.001_get_tv_selex | use the control.ss_new file to get the automatically generated time-varying selectivity parameters from model 6 | #59 | 2021.s.006.001_next_ctl_changes | model_bridging_change_ctl.R
2021.n.007.002_DM | apply Dirichlet_Multinomial | #59 | 2021.n.007.001_get_tv_selex | model_bridging_change_ctl.R
2021.s.007.002_DM | apply Dirichlet_Multinomial | #59 | 2021.s.007.001_get_tv_selex | model_bridging_change_ctl.R
2021.n.007.003_Francis | apply Francis tuning | #59 | 2021.n.007.001_get_tv_selex | model_bridging_change_ctl.R
2021.s.007.003_Francis | apply Francis tuning | #59 | 2021.s.007.001_get_tv_selex | model_bridging_change_ctl.R
2021.n.008.001_selblocks | add new blocks for selectivity and retention | #58, #59, #61 | 2021.n.004.007 | model_bridging_change_ctl.R
2021.s.008.001_selblocks | add new blocks for selectivity and retention | #58, #59, #61 | 2021.s.004.007 | model_bridging_change_ctl.R
