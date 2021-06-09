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

name | notes | issue | source
-- | -- | -- | --
2017.n.001.001.final_base | 2017 base | #32 | archive
2017.s.001.001.final_base | 2017 base | #32 | archive
2017.s.002.001.SSv3.30.16.02 | testing newer SS version | #32 | models/lingcod_model_bridging_new_exe.R
2019.n.001.001.cou | 2019 base | #32 | archive
2019.n.002.001.SSv3.30.16.02 | testing newer SS version | #32 | models/lingcod_model_bridging_new_exe.R
2019.s.001.001.cou | 2019 base | #32 | archive
2019.s.002.001.SSv3.30.16.02 | testing newer SS version | #32 | models/lingcod_model_bridging_new_exe.R
2019.s.002.002.SSv3.30.16.02_par | testing newer SS version | #32 | models/lingcod_model_bridging_new_exe.R
2019.s.003.001_update_catch_2019_structure | checking impact of new CA catch stream | #41 | from 2019.s.002.001.SSv3.30.16.02_par
2019.n.003.001_update_catch_2019_structure | checking impact of new CA catch stream | #41 | from 2019.n.002.001.SSv3.30.16.02.
2019.n.004.001_DM | apply Dirichlet-Multinomial to update_catch_2019_structure model | #49 | 2019.n.003.001_update_catch_2019_structure
2019.s.004.001_DM | apply Dirichlet-Multinomial to update_catch_2019_structure model | #49 | 2019.n.003.001_update_catch_2019_structure
2021.n.001.001_starting_point | renamed inputs and modified starter | #32 | lingcod_model_bridging_newfleets.R
2021.s.001.001_starting_point | renamed inputs and modified starter | #32 | lingcod_model_bridging_newfleets.R
2021.n.002.001_new_fleets | reorganized fleets | #27 | lingcod_model_bridging_newfleets.R
2021.s.002.001_new_fleets | reorganized fleets | #27 | lingcod_model_bridging_newfleets.R
2021.n.003.001_DM | apply Dirichlet-Multinomial to new_fleets model | #49 | 2021.n.002.001_new_fleets
2021.s.003.001_DM | apply Dirichlet-Multinomial to new_fleets model | #49 | 2021.n.002.001_new_fleets
2021.n.004.001_new_data_test | adding new data, a work in progress | #32 | lingcod_model_bridging_newdata.R
2021.s.004.001_new_data_test | adding new data, a work in progress | #32 | lingcod_model_bridging_newdata.R



