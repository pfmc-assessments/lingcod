#######################################
#
#Scripts to pull length and age data for the lingcod_2021 stock assessment from surveys
#and create expanded length, age, and CAAL comps. 
#
#Lingcod only present in the combo, triennial, and slope surveys so only use these surveys
#Ages only available in combo and triennial. 
#
#Author: Brian Langseth
#Created: February 9, 2021
#
#######################################

##There are a few remaining tasks
#1. Need to redefine depth strata and latitude strata (right now WCGBTS and Triennial specific). DONE
#2. Need to define length bins (currently set to min/max of each dataset with binsize of 2). DONE
#3. Will need to specify survey timing (month 7), sex (currently 3 and 0), fleet number (triennial = 6, WCGBTS = 7) DONE
#4. For CAAL, nwfscSurvey functions dont do unsexed. Do we ignore unsexed? Yes DONE
#5. For CAAL can do expanded comps, but Im not doing (not standard to do so). Do we want to use expanded CAAL? No DONE
#6. Combine unsexed into sexed, using minimum sizes below which to assume 50:50 sex ratio based on L-A and L-W relationships

##------------------------------------Scripts----------------------------------------##

#Read in data from the data warehouse using function below
#Saves .rda files for each specified survey
#No longer needed due to new repository structure
#readin_survey_data(surveys)   #########Dont need to do this again unless need new data##########

#Plot depth by cpue for triennial to assess whether an additional strata would be worthwhile
plot(catch.Triennial[which(catch.Triennial$cpue_kg_km2!=0),]$Depth_m, log(catch.Triennial[which(catch.Triennial$cpue_kg_km2!=0),]$cpue_kg_km2))
abline(v=183) #Previous assessments used this. Seems to be a break. Use again. 

#Generate length comps using function below
#Saves comps and plots for each specified survey 
survey_lcomps(info_surveynames)


#Generate age comps using function below. Option for CAAL in addition to conditional age comps
#Saves comps and plots for surveys with age data (only WCGBTS and Triennial)
survey_acomps(info_surveynames, CAAL = TRUE)
