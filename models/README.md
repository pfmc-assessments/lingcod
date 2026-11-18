# info for lingcod models

Model directories use the scheme `yyyy.[ns].000.000.shortstring` where the elements are

- yyyy : the assessment model year
- [ns] : either n or s for north or south area; on Windows case matters; therefore, 
         it would be good if we could all use lower case so that model directories sort 
         similarly on everyone's machines and we do not have to push the shift key
- 000 : the base number
- 000 : the sensitivity number
- shortstring : a short character string without full stops but it can include 
                any other character you desire

The majority of the model files from previous years are not stored in the repo and instead
stored in this Google Drive folder:
https://drive.google.com/drive/folders/1xkIZznTkVXHjhjWJOYJrMQO93qfD-O3V
Please contact @iantaylor-NOAA or @brianlangseth-NOAA for access if you need it.

# the models retained in this repo from previous years, which are within the "models from previous years" folder include

name | description  
--   | --    
2017.n.001.001.final_base | 2017 north base 
2017.s.001.001.final_base | 2017 south base 
2019.n.001.001.cou | 2019 north base
2019.s.001.001.cou | 2019 south base
2021.n.023.001_fixWAreccatchhistory   | 2021 north base used throughout report
2021.n.023.010_forecast | 2021 north base with corrected forecast
2021.s.018.001_fixTri3 | 2021 south base used throughout report
2021.s.018.010_forecast | 2021 south base with corrected forecast


# Models added for the 2027 cycle are in the "north" and "south" subfolders. 

To accommodate different modeling preferences for the north models, models 
updated manually are stored in the "models/north" Google Drive folder: 
https://drive.google.com/drive/folders/1B3F3pxhQEJYKn1MVbbbuv4y5Nc1GKctW
and are tracked using the "README_run.log.xlsx" file in that Drive folder.
Models that are used as part of the modeling flow will be copied to the github repo. 

Models that are run with R are saved in the github repo and are tracked
using model_runs_north.R or model_runs_south.R, and do not need to be logged or 
placed on Google Drive. 