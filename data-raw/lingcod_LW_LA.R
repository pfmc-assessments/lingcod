#######################################
#
#Scripts to explore length and age data for the lingcod_2021 stock assessment from surveys 
#
#Author: Brian Langseth
#Created: March 4, 2021
#
#######################################

#devtools::install_github("nwfsc-assess/nwfscSurvey", build_vignettes = TRUE)
library(plyr)
library(ggplot2)

#######################################################
#Functions used
#######################################################

#Load HNL survey data and save
save_HNL_data <- function(){
  
  #John Harms provided data in email on Feb 9, 2021.
  hnl_full = read.csv(file.path(getwd(),"data-raw", "qryGrandUnifiedThru2019_For2021Assessments_DWarehouse version_01072021.csv"), header = TRUE)
  hnl = hnl_full[hnl_full$common_name == "Lingcod",]
  hnl$Source = "NWFSC_HKL"
  
  #Merge ages from Laurel Lam
  hnl_ages = read.csv(file.path(getwd(),"data-raw","H&L_Lingcod_ages.csv"), header = TRUE)
  hnl_ages$age_code = substr(hnl_ages$SpecimenID, start = nchar(hnl_ages$SpecimenID) - 3, stop = nchar(hnl_ages$SpecimenID)) #last 4 digits (after 'a' or 'A')
  # #Add agecode to length dataset with A or a removed.
  # #Because have one record missing a fin clip number that has an otolith number, use otolith number when no fin clip, and fin clip otherwise
  # length_list[[i]]$age_code = ifelse(length_list[[i]]$fin_clip_number=="", 
  #                                    substr(length_list[[i]]$otolith_number,2,nchar(length_list[[i]]$otolith_number)), 
  #                                    substr(length_list[[i]]$fin_clip_number, 2, nchar(length_list[[i]]$fin_clip_number)))
  # 
  # a = merge(length_list[[i]], hnl_ages, by.x = c("year","vessel","age_code"), 
  #           by.y = c("SurveyYear", "VesselName", "age_code"))
  # #There are 8 records from Laurels database that aren't in the HNL database
  # #Two have age_codes of 9999 and are included based on lengths, weight, year, vessel combinations: just dont have fin/otolith number to link
  
  #Just add Laurel's database as the age database
  hnl_ages$drop_latitude_degrees = as.numeric(substr(hnl_ages$DropLatitude,1,2)) + as.numeric(substr(hnl_ages$DropLatitude,4,nchar(hnl_ages$DropLatitude)))/60
  hnl_ages$drop_longitude_degrees = as.numeric(substr(hnl_ages$DropLongitude,1,3)) + as.numeric(substr(hnl_ages$DropLongitude,5,nchar(hnl_ages$DropLongitude)))/60
  hnl_ages$drop_depth_meters = hnl_ages$VesselDepth * 1.8288 #convert from fathoms to meters
  names(hnl_ages)[c(2,4,5,6,7)] = c("year", "age_years", "length_cm", "weight_kg", "sex")
  
  hnl_ages$Source = "Lam_HKL_Age"
  
  #Save as .rdas. Have to read in unsexed comps because variable only keeps sex3 comps
  bio.HKL = hnl
  bio.HKLage.Lam = hnl_ages
  usethis::use_data(bio.HKL, overwrite = TRUE)
  usethis::use_data(bio.HKLage.Lam, overwrite = TRUE)

}

#Combine survey data into single dataframe
create_survey_data_frame <- function(data_list){
  
  all_data = NA
  for (a in 1:length(data_list)){
    
    if(unique(data_list[[a]]$Source) %in% c("NWFSC_HKL","Lam_HKL_Age")){
      
      tmp  <- data.frame(Year = data_list[[a]]$year,
                       Lat = data_list[[a]]$drop_latitude_degrees,
                       Lon = data_list[[a]]$drop_longitude_degrees,
                       Depth = data_list[[a]]$drop_depth_meters,
                       Sex = data_list[[a]]$sex,
                       Length = data_list[[a]]$length_cm,
                       Weight = data_list[[a]]$weight_kg,
                       Age = data_list[[a]]$age_years,
                       Areas = ifelse(unique(data_list[[a]]$Source) == "NWFSC_HKL", ifelse(data_list[[a]]$cowcod_conservation_area_indicator==0,"non_CCA","CCA"), NA),
                       Region = "South",
                       Source = data_list[[a]]$Source)
      }
    
    if(!unique(data_list[[a]]$Source) %in% c("NWFSC_HKL","Lam_HKL_Age")){
      
      tmp  <- data.frame(Year = data_list[[a]]$Year,
                         Lat = data_list[[a]]$Latitude_dd,
                         Lon = data_list[[a]]$Longitude_dd,
                         Depth = data_list[[a]]$Depth_m,
                         Sex = data_list[[a]]$Sex,
                         Length = data_list[[a]]$Length_cm,
                         Weight = data_list[[a]]$Weight,
                         Age = data_list[[a]]$Age,
                         Areas = NA,
                         Region = ifelse(data_list[[a]]$Latitude_dd >= (40 + 10/60), "North", "South"),
                         Source = data_list[[a]]$Source)      
    
      }
    
    all_data = rbind(all_data, tmp)			
  }
  
  all_data = all_data[!is.na(all_data$Year), ]
  return (all_data)
}

#Clean data
clean_lingcod_survey_biodata <- function(dir = NULL, data){
  
  #Remove any data without valid lengths
  print(paste("Removed",sum(is.na(data$Length)), "records without any length"))
  data = data[!is.na(data$Length),]
  
  par(mfrow = c(3,2))
  for(s in unique(data$Source)){
    plot(data[data$Source == s, "Length"], data[data$Source == s, "Weight"], main = s, 
         xlim = c(0, 120), ylim = c(0,16), xlab = 'Length (cm)', ylab = 'Weight (kg)')
  }
  #Data seem reasonable based on valid length-weight combinations with exception of one female in the Combo survey. 
  
  #Remove outlier
  print(paste("Removed 1 record with smaller than expected weight"))
  data = data[-which(data$Length>95 & data$Weight < 5),]
  
  #What about single length or weight values
  ##-------------------------------------
  #Check lengths
  ##-------------------------------------
  #Lengths seem reasonable
  summary(data$Length) 
  #Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
  #10.50   33.00   48.00   49.44   63.50  113.00
  
  ##-------------------------------------
  #Check weights
  ##-------------------------------------
  #There are a lot of very small fish, but no real indication that its wrong
  summary(data$Weight) 
  #Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
  #0.010   0.260   0.980   1.654   2.400  15.750   17994 
  
  ##-------------------------------------
  #Check ages
  ##-------------------------------------
  #Ages seem reasonable
  summary(data$Age)
  #Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
  #0.000   1.000   3.000   3.119   4.000  15.000   20284
  
  ##-------------------------------------
  #Check length-age relationship
  ##-------------------------------------
  #Double check appearance of age-length relationships
  plot(x = data[data$Sex == "F",]$Age, y = data[data$Sex == "F",]$Length, col = 2, pch = 19)
  points(x = data[data$Sex == "M",]$Age, y = data[data$Sex == "M",]$Length, col = 4, pch = 19)
  points(x = data[data$Sex == "U",]$Age, y = data[data$Sex == "U",]$Length, col = 1, pch = 19)
  
  
  #######################################
  #Trends over time
  #######################################
  
  # What area and gear are the ages coming from? 
  table(data$Source, data$Region, is.na(data$Age))
  #, ,  = FALSE
  
  #North South
  #AFSC.Slope        0     0
  #NWFSC.Combo    4655  2905
  #NWFSC.Slope       0     0
  #NWFSC_HKL         0     0
  #Triennial         0     0
  #Triennial_Age  1732   802
  
  return(data)
}

#Estimate length age using nls. Must have either l0 (estimates the standard parameterization with t0) or t0 null (estimates the SS3 parameterization with l0).
#Does do unsexed fish separately when paired with either or both of Source and Region, only male and female, due to small sample sizes
#Modified from Chantel Wetzel's data moderate code
estimate_length_age <- function(data, grouping = "all", linf = NULL, l0 = NULL, t0 = NULL, k = NULL){
  
  keep <- which(!is.na(data$Age))
  data <- data[keep, ]
  
  # Check for NA lengths from the aged fish and remove these
  keep <- which(!is.na(data$Length))
  data <- data[keep, ]
  
  n_sex <- unique(data$Sex)
  n_state <- unique(data$State)
  n_source <- unique(data$Source)
  
  # dynamically determine reasonable parameters. Defaults to keeping t0 as NULL
  if (is.null(linf)) { linf <- quantile(data$Length, 0.90) }
  if (is.null(l0) & is.null(t0))   { l0   <- ifelse(linf > 30, 10, 5) }
  if (is.null(k)) { k    <- 0.10 }
  
  len_age_list <- list()
  nm <- NULL
  
  if(is.null(l0)){
    len_age_list[[1]] <- coef(nls(length~linf*(1-exp(-k*(age-t0))), data=list(length = data$Length, age = data$Age), 
                           start=list(linf = linf, k = k, t0 = t0), list(reltol=0.0000000001)))
  }
  if(is.null(t0)){
    len_age_list[[1]] <- coef(nls(length~linf-(linf - l0)*exp(-age*k), data=list(length = data$Length, age = data$Age), 
                             start=list(linf = linf, k = k, l0 = l0), list(reltol=0.0000000001)))
  }
  
  nm <- "all"
  t <- 1
  for (a in unique(data$Sex)){
    if (sum(data$Sex == a) > 0){
      t = t + 1
      tmp = data[data$Sex == a, ]
      if(is.null(l0)){
        len_age_list[[t]] <- coef(nls(length~linf*(1-exp(-k*(age-t0))), data=list(length = tmp$Length, age = tmp$Age), 
                                      start=list(linf = linf, k = k, t0 = t0), list(reltol=0.0000000001)))
      }
      if(is.null(t0)){
        len_age_list[[t]] <- coef(nls(length~linf-(linf - l0)*exp(-age*k), data=list(length = tmp$Length, age = tmp$Age), 
                                      start=list(linf = linf, k = k, l0 = l0), list(reltol=0.0000000001)))
      }
      nm = c(nm, paste0("all_", a))	
    }
  }
  
  
  for(a in unique(data$Source)){
    t = t + 1
    tmp = data[data$Source == a, ]
    if(is.null(l0)){
      len_age_list[[t]] <- coef(nls(length~linf*(1-exp(-k*(age-t0))), data=list(length = tmp$Length, age = tmp$Age), 
                                    start=list(linf = linf, k = k, t0 = t0), list(reltol=0.0000000001)))
    }
    if(is.null(t0)){
      len_age_list[[t]] <- coef(nls(length~linf-(linf - l0)*exp(-age*k), data=list(length = tmp$Length, age = tmp$Age), 
                                    start=list(linf = linf, k = k, l0 = l0), list(reltol=0.0000000001)))
    }
    nm = c(nm, a)		
  }
  
  for(a in unique(data$State)){		
    check = data[data$State == a, c("Length", "Age")]
    if( sum(is.na(check$Length)) != dim(check)[1] & sum(is.na(check$Age)) != dim(check)[1] ){
      t = t +1
      tmp = data[data$State == a, ]
      if(is.null(l0)){
        len_age_list[[t]] <- coef(nls(length~linf*(1-exp(-k*(age-t0))), data=list(length = tmp$Length, age = tmp$Age), 
                                      start=list(linf = linf, k = k, t0 = t0), list(reltol=0.0000000001)))
      }
      if(is.null(t0)){
        len_age_list[[t]] <- coef(nls(length~linf-(linf - l0)*exp(-age*k), data=list(length = tmp$Length, age = tmp$Age), 
                                      start=list(linf = linf, k = k, l0 = l0), list(reltol=0.0000000001)))
      }
      nm = c(nm, a)
    }		
  }
  
  for(a in unique(data$State)){
    for (b in unique(data$Source)){
      check = data[data$State == a & data$Source == b, c("Length", "Age")]
      if( sum(is.na(check$Length)) != dim(check)[1] & sum(is.na(check$Age)) != dim(check)[1] ){
        t = t +1
        tmp = data[data$State == a & data$Source == b, ]
        if(is.null(l0)){
          len_age_list[[t]] <- coef(nls(length~linf*(1-exp(-k*(age-t0))), data=list(length = tmp$Length, age = tmp$Age), 
                                        start=list(linf = linf, k = k, t0 = t0), list(reltol=0.0000000001)))
        }
        if(is.null(t0)){
          len_age_list[[t]] <- coef(nls(length~linf-(linf - l0)*exp(-age*k), data=list(length = tmp$Length, age = tmp$Age), 
                                        start=list(linf = linf, k = k, l0 = l0), list(reltol=0.0000000001)))
        }
        nm = c(nm, paste0(a, "_", b))	
      }		
    }
  }
  
  
  for (b in unique(data$Source)){
    for(s in c("F","M")){ #only do source by male and female
      check = data[data$Source == b & data$Sex == s, c("Length", "Age")]
      if( sum(is.na(check$Length)) != dim(check)[1] & sum(is.na(check$Age)) != dim(check)[1] ){
        t = t +1
        tmp = data[data$Source == b & data$Sex == s, ]
        if(is.null(l0)){
          len_age_list[[t]] <- coef(nls(length~linf*(1-exp(-k*(age-t0))), data=list(length = tmp$Length, age = tmp$Age), 
                                        start=list(linf = linf, k = k, t0 = t0), list(reltol=0.0000000001)))
        }
        if(is.null(t0)){
          len_age_list[[t]] <- coef(nls(length~linf-(linf - l0)*exp(-age*k), data=list(length = tmp$Length, age = tmp$Age), 
                                        start=list(linf = linf, k = k, l0 = l0), list(reltol=0.0000000001)))
        }
        nm = c(nm, paste0(b, "_", s))	
      }		
    }
  }
  
  for(a in unique(data$State)){
    for(s in c("F","M")){ #only do state by male and female
      check = data[data$State == a & data$Sex == s, c("Length", "Age")]
      if( sum(is.na(check$Length)) != dim(check)[1] & sum(is.na(check$Age)) != dim(check)[1] ){
        t = t +1
        tmp = data[data$State == a & data$Sex == s, ]
        if(is.null(l0)){
          len_age_list[[t]] <- coef(nls(length~linf*(1-exp(-k*(age-t0))), data=list(length = tmp$Length, age = tmp$Age), 
                                        start=list(linf = linf, k = k, t0 = t0), list(reltol=0.0000000001)))
        }
        if(is.null(t0)){
          len_age_list[[t]] <- coef(nls(length~linf-(linf - l0)*exp(-age*k), data=list(length = tmp$Length, age = tmp$Age), 
                                        start=list(linf = linf, k = k, l0 = l0), list(reltol=0.0000000001)))
        }
        nm = c(nm, paste0(a, "_", s))	
      }		
    }
  }
  
  for(a in unique(data$State)){
    for (b in unique(data$Source)){
      for(s in c("F","M")){ #only do state and source by male and female
        check = data[data$State == a & data$Source == b & data$Sex == s, c("Length", "Age")]
        if( sum(is.na(check$Length)) != dim(check)[1] & sum(is.na(check$Age)) != dim(check)[1] ){
          t = t +1
          tmp = data[data$State == a & data$Source == b & data$Sex == s, ]
          if(is.null(l0)){
            len_age_list[[t]] <- coef(nls(length~linf*(1-exp(-k*(age-t0))), data=list(length = tmp$Length, age = tmp$Age), 
                                          start=list(linf = linf, k = k, t0 = t0), list(reltol=0.0000000001)))
          }
          if(is.null(t0)){
            len_age_list[[t]] <- coef(nls(length~linf-(linf - l0)*exp(-age*k), data=list(length = tmp$Length, age = tmp$Age), 
                                          start=list(linf = linf, k = k, l0 = l0), list(reltol=0.0000000001)))
          }
          nm = c(nm, paste0(a, "_", b, "_", s))	
        }		
      }
    }
  }
  
  names(len_age_list) <- nm
  return(len_age_list)
}

#Estimate length weight using nls. Includes unsexed fish 
#Modified from Chantel Wetzel's data moderate code
estimate_length_weight <- function(data, grouping = "all"){
  
  remove = NULL
  # Determine if all data sources have lengths & weights
  for (s in unique(data$Source)){
    check_len  <- check <- sum( !is.na( data[data$Source == s, "Length"])) == 0
    check_wght <- sum( !is.na( data[data$Source == s, "Weight"])) == 0
    if (check_len | check_wght) {remove <- c(remove, s)}
  }
  
  data <- data[!data$Source %in% remove, ]
  n_sex <- unique(data$Sex)
  n_state <- unique(data$State)
  n_source <- unique(data$Source)
  
  len_weight_list <- list()
  nm = NULL
  len_weight_list[[1]] <- coef(nls(weight ~ a*(length)^b, data=list(weight = data$Weight, length = data$Length), 
      start=list(a=0.00001,b=3), list(reltol=0.0000000001)))
  nm = "all"
  
  t = 1
  for (a in unique(data$Sex)){
    if (sum(data$Sex == a) > 0){
      t = t + 1
      len_weight_list[[t]] <- coef(nls(weight ~ a*(length)^b, data=list(weight = data[data$Sex == a,]$Weight, length = data[data$Sex == a,]$Length), 
                                       start=list(a=0.00001,b=3), list(reltol=0.0000000001)))  
      nm = c(nm, paste0("all_", a))	
      
    }
  }
  
  for(a in unique(data$Source)){
    t = t + 1
    len_weight_list[[t]] <- coef(nls(weight ~ a*(length)^b, data=list(weight = data[data$Source == a,]$Weight, length = data[data$Source == a,]$Length), 
                                     start=list(a=0.00001,b=3), list(reltol=0.0000000001)))  
    nm = c(nm, a)		
  }
  
  for(a in unique(data$State)){
    
    check = data[data$State == a, c("Length", "Weight")]
    if( sum(is.na(check$Length)) != dim(check)[1] & sum(is.na(check$Weight)) != dim(check)[1] ){
      t = t +1
      len_weight_list[[t]] <- coef(nls(weight ~ a*(length)^b, data=list(weight = data[data$State == a,]$Weight, length = data[data$State == a,]$Length), 
                                       start=list(a=0.00001,b=3), list(reltol=0.0000000001)))  
      nm = c(nm, a)
    }		
  }
  
  for(a in unique(data$State)){
    for (b in unique(data$Source)){
      check = data[data$State == a & data$Source == b, c("Length", "Weight")]
      if( sum(is.na(check$Length)) != dim(check)[1] & sum(is.na(check$Weight)) != dim(check)[1] ){
        t = t +1
        len_weight_list[[t]] <- coef(nls(weight ~ a*(length)^b, data=list(weight = data[data$State == a & data$Source == b,]$Weight, length = data[data$State == a & data$Source == b,]$Length), 
                                         start=list(a=0.00001,b=3), list(reltol=0.0000000001)))  
        nm = c(nm, paste0(a, "_", b))	
      }		
    }
  }
  
  
  for (b in unique(data$Source)){
    for(s in unique(data$Sex)){
      check = data[data$Source == b & data$Sex == s, c("Length", "Weight")]
      if( sum(is.na(check$Length)) != dim(check)[1] & sum(is.na(check$Weight)) != dim(check)[1] ){
        t = t +1
        len_weight_list[[t]] <- coef(nls(weight ~ a*(length)^b, data=list(weight = data[data$Source == b & data$Sex == s,]$Weight, length = data[data$Source == b & data$Sex == s,]$Length), 
                                         start=list(a=0.00001,b=3), list(reltol=0.0000000001)))  
        nm = c(nm, paste0(b, "_", s))	
      }		
    }
  }
  
  
  for(a in unique(data$State)){
    for (b in unique(data$Source)){
      for(s in unique(data$Sex)){
        check = data[data$State == a & data$Source == b & data$Sex == s, c("Length", "Weight")]
        if( sum(is.na(check$Length)) != dim(check)[1] & sum(is.na(check$Weight)) != dim(check)[1] ){
          t = t +1
          len_weight_list[[t]] <- coef(nls(weight ~ a*(length)^b, data=list(weight = data[data$State == a & data$Source == b & data$Sex == s,]$Weight, length = data[data$State == a & data$Source == b & data$Sex == s,]$Length), 
                                           start=list(a=0.00001,b=3), list(reltol=0.0000000001)))  
          nm = c(nm, paste0(a, "_", b, "_", s))	
        }		
      }
    }
  }
  
  names(len_weight_list) <- nm
  return(len_weight_list)
}

#Check residual patterns for length-weight and length-age for latitdue, region, and depth
#following appraoch from 2017 stock assessment
checkresids <- function(data = data, method = c("lw", "la")){
  
  if("lw" %in% method){
    writeLines("Analyzing residuals for length - weight \n")
    
    ltwt = data[!is.na(data$Weight),]
    fit.ltwt <- nls(Weight~a*(Length)^b, data=ltwt, 
                    start=list(a=0.00001,b=3), list(reltol=0.0000000001))
    coef <- coef(fit.ltwt)
    ltwt$Resids <- residuals(fit.ltwt)  
    
    #-------------------Latitude-------------------------#
    writeLines("-----------------------By latitude ------------------------\n")
    
    #Residual pattern by latitude and sex (with lowess by Region)
    plot(ltwt$Lat, ltwt$Resids,
         ylim=c(-3,3),
         pch=16,cex=0.5,col=factor(ltwt$Sex), xlab="Latitude", ylab="Residual Lt-Wt", main = "Grouped by sex")
    plot(ltwt$Lat, ltwt$Resids,
         ylim=c(-3,3),
         pch=16,cex=0.5,col=factor(ltwt$Sex), xlab="Latitude", ylab="Residual Lt-Wt", type = "n", main = "Lowess by Region and Sex")
    lines(lowess(ltwt$Lat[which(ltwt$Sex=="F" & ltwt$Lat > (40+10/60))],ltwt$Resids[which(ltwt$Sex=="F" & ltwt$Lat > (40+10/60))]), col=rgb(1,0,0,0.75),lwd=3)
    lines(lowess(ltwt$Lat[which(ltwt$Sex=="F" & ltwt$Lat < (40+10/60))],ltwt$Resids[which(ltwt$Sex=="F" & ltwt$Lat < (40+10/60))]), col=rgb(1,0,0,0.25),lwd=3)
    lines(lowess(ltwt$Lat[which(ltwt$Sex=="M" & ltwt$Lat > (40+10/60))],ltwt$Resids[which(ltwt$Sex=="M" & ltwt$Lat > (40+10/60))]), col=rgb(0,0,1,0.75),lwd=3)
    lines(lowess(ltwt$Lat[which(ltwt$Sex=="M" & ltwt$Lat < (40+10/60))],ltwt$Resids[which(ltwt$Sex=="M" & ltwt$Lat < (40+10/60))]), col=rgb(0,0,1,0.25),lwd=3)
    lines(lowess(ltwt$Lat[which(ltwt$Sex=="U" & ltwt$Lat > (40+10/60))],ltwt$Resids[which(ltwt$Sex=="U" & ltwt$Lat > (40+10/60))]), col=rgb(0,0,0,0.75),lwd=3)
    lines(lowess(ltwt$Lat[which(ltwt$Sex=="U" & ltwt$Lat < (40+10/60))],ltwt$Resids[which(ltwt$Sex=="U" & ltwt$Lat < (40+10/60))]), col=rgb(0,0,0,0.25),lwd=3)
    abline(h=0,col="grey",lty=3)                                # lty=3 dotted line (1 solid)
    legend(x=min(ltwt$Lat),y=-1.75,legend=c("Female S Lowess","Male S Lowess","Unsexed S Lowess"),col=c(rgb(1,0,0,0.25),rgb(0,0,1,0.25),rgb(0,0,0,0.25)),lty=1,lwd=3,pch=16,bty="n")
    legend(x=min(ltwt$Lat)+10,y=-1.75,legend=c("Female N Lowess","Male N Lowess","Unsexed N Lowess"),col=c(rgb(1,0,0,0.75),rgb(0,0,1,0.75),rgb(0,0,0,0.75)),lty=1,lwd=3,pch=16,bty="n")
    
    #Is effect of depth significant
    writeLines("Slope for continuous latitude -------------------\n")
    print(summary(lm(Resids ~ Lat, data = ltwt)))
    
    #What about by depth regions (as defined in "Lingcod 2017 dataprep.R" in archives)
    RegionFit <- aov(Resids ~ Region, data=ltwt)
    writeLines("Anova with region as factor ---------------------\n")
    print(anova(RegionFit))
    writeLines("TukeyHSD with region as factor -----------------------\n")
    print(TukeyHSD(RegionFit))
    
    #-------------------Depth-------------------------#
    writeLines("---------------By depth --------------------\n")
    
    ltwt$dpthbin <- ifelse(ltwt$Depth > 183,"DEEP",
                           ifelse(ltwt$Depth > 140,"MDEEP",
                                  ifelse(ltwt$Depth > 110,"MID",
                                         ifelse(ltwt$Depth > 85,"MSHAL",
                                                "SHAL"))))
    #Residual pattern by Depth and sex (with lowess by Region)
    plot(ltwt$Depth, ltwt$Resids,
         ylim=c(-3,3),
         pch=16,cex=0.5,col=factor(ltwt$Sex), xlab="Depth", ylab="Residual Lt-Wt", main = "Grouped by sex")
    plot(ltwt$Depth, ltwt$Resids,
         ylim=c(-3,3),
         pch=16,cex=0.5,col=factor(ltwt$Sex), xlab="Depth", ylab="Residual Lt-Wt", type = "n", main = "Lowess by Region and Sex")
    lines(lowess(ltwt$Depth[which(ltwt$Sex=="F" & ltwt$Lat > (40+10/60))],ltwt$Resids[which(ltwt$Sex=="F" & ltwt$Lat > (40+10/60))]), col=rgb(1,0,0,0.75),lwd=3)
    lines(lowess(ltwt$Depth[which(ltwt$Sex=="F" & ltwt$Lat < (40+10/60))],ltwt$Resids[which(ltwt$Sex=="F" & ltwt$Lat < (40+10/60))]), col=rgb(1,0,0,0.25),lwd=3)
    lines(lowess(ltwt$Depth[which(ltwt$Sex=="M" & ltwt$Lat > (40+10/60))],ltwt$Resids[which(ltwt$Sex=="M" & ltwt$Lat > (40+10/60))]), col=rgb(0,0,1,0.75),lwd=3)
    lines(lowess(ltwt$Depth[which(ltwt$Sex=="M" & ltwt$Lat < (40+10/60))],ltwt$Resids[which(ltwt$Sex=="M" & ltwt$Lat < (40+10/60))]), col=rgb(0,0,1,0.25),lwd=3)
    lines(lowess(ltwt$Depth[which(ltwt$Sex=="U" & ltwt$Lat > (40+10/60))],ltwt$Resids[which(ltwt$Sex=="U" & ltwt$Lat > (40+10/60))]), col=rgb(0,0,0,0.75),lwd=3)
    lines(lowess(ltwt$Depth[which(ltwt$Sex=="U" & ltwt$Lat < (40+10/60))],ltwt$Resids[which(ltwt$Sex=="U" & ltwt$Lat < (40+10/60))]), col=rgb(0,0,0,0.25),lwd=3)
    abline(h=0,col="grey",lty=3)                                # lty=3 dotted line (1 solid)
    legend(x=min(ltwt$Depth),y=-1.75,legend=c("Female S Lowess","Male S Lowess","Unsexed S Lowess"),col=c(rgb(1,0,0,0.25),rgb(0,0,1,0.25),rgb(0,0,0,0.25)),lty=1,lwd=3,pch=16,bty="n")
    legend(x=min(ltwt$Depth)+400,y=-1.75,legend=c("Female N Lowess","Male N Lowess","Unsexed N Lowess"),col=c(rgb(1,0,0,0.75),rgb(0,0,1,0.75),rgb(0,0,0,0.75)),lty=1,lwd=3,pch=16,bty="n")
    
    #Is effect of depth significant
    writeLines("Slope for continuous latitude --------------------\n")
    print(summary(lm(Resids ~ Depth, data = ltwt)))
    
    #What about by depth regions (as defined in "Lingcod 2017 dataprep.R" in archives)
    DepthFit <- aov(Resids ~ dpthbin, data=ltwt)
    writeLines("Anova with Depth as factor ----------------------\n")
    print(anova(DepthFit))
    writeLines("TukeyHSD with Depth as factor --------------------\n")
    print(TukeyHSD(DepthFit))
    
  }
  
  if("la" %in% method){
    
    writeLines("Analyzing residuals for length - age \n")
    
    ltag = data[!is.na(data$Age),]
    fit.ltag <- nls(Length~Linf*(1-exp(-k*(Age-t0))), data=ltag, 
                    start=list(Linf=max(ltag$Length), k=0.2, t0=0), list(reltol=0.0000000001))
    coef <- coef(fit.ltag)
    ltag$Resids <- residuals(fit.ltag)  
    
    #-------------------Latitude-------------------------#
    writeLines("-------------------By latitude ------------------------\n")
    
    #Residual pattern by latitude and sex (with lowess by Region)
    plot(ltag$Lat, ltag$Resids,
         ylim=c(-40,40),
         pch=16,cex=0.5,col=factor(ltag$Sex), xlab="Latitude", ylab="Residual Lt-Wt", main = "Grouped by sex")
    plot(ltag$Lat, ltag$Resids,
         ylim=c(-40,40),
         pch=16,cex=0.5,col=factor(ltag$Sex), xlab="Latitude", ylab="Residual Lt-Wt", type = "n", main = "Lowess by Region and Sex")
    lines(lowess(ltag$Lat[which(ltag$Sex=="F" & ltag$Lat > (40+10/60))],ltag$Resids[which(ltag$Sex=="F" & ltag$Lat > (40+10/60))]), col=rgb(1,0,0,0.75),lwd=3)
    lines(lowess(ltag$Lat[which(ltag$Sex=="F" & ltag$Lat < (40+10/60))],ltag$Resids[which(ltag$Sex=="F" & ltag$Lat < (40+10/60))]), col=rgb(1,0,0,0.25),lwd=3)
    lines(lowess(ltag$Lat[which(ltag$Sex=="M" & ltag$Lat > (40+10/60))],ltag$Resids[which(ltag$Sex=="M" & ltag$Lat > (40+10/60))]), col=rgb(0,0,1,0.75),lwd=3)
    lines(lowess(ltag$Lat[which(ltag$Sex=="M" & ltag$Lat < (40+10/60))],ltag$Resids[which(ltag$Sex=="M" & ltag$Lat < (40+10/60))]), col=rgb(0,0,1,0.25),lwd=3)
    lines(lowess(ltag$Lat[which(ltag$Sex=="U" & ltag$Lat > (40+10/60))],ltag$Resids[which(ltag$Sex=="U" & ltag$Lat > (40+10/60))]), col=rgb(0,0,0,0.75),lwd=3)
    lines(lowess(ltag$Lat[which(ltag$Sex=="U" & ltag$Lat < (40+10/60))],ltag$Resids[which(ltag$Sex=="U" & ltag$Lat < (40+10/60))]), col=rgb(0,0,0,0.25),lwd=3)
    abline(h=0,col="grey",lty=3)                                # lty=3 dotted line (1 solid)
    legend(x=min(ltag$Lat),y=-20.75,legend=c("Female S Lowess","Male S Lowess","Unsexed S Lowess"),col=c(rgb(1,0,0,0.25),rgb(0,0,1,0.25),rgb(0,0,0,0.25)),lty=1,lwd=3,pch=16,bty="n")
    legend(x=min(ltag$Lat)+10,y=-20.75,legend=c("Female N Lowess","Male N Lowess","Unsexed N Lowess"),col=c(rgb(1,0,0,0.75),rgb(0,0,1,0.75),rgb(0,0,0,0.75)),lty=1,lwd=3,pch=16,bty="n")
    
    #Is effect of depth significant
    writeLines("Slope for continuous latitude --------------------\n")
    print(summary(lm(Resids ~ Lat, data = ltag)))
    
    #What about by depth regions (as defined in "Lingcod 2017 dataprep.R" in archives)
    RegionFit <- aov(Resids ~ Region, data=ltag)
    writeLines("Anova with region as factor --------------------\n")
    print(anova(RegionFit))
    writeLines("TukeyHSD with region as factor -----------------------\n")
    print(TukeyHSD(RegionFit))
    
    #-------------------Depth-------------------------#
    writeLines("---------------By depth -------------------\n")
    
    ltag$dpthbin <- ifelse(ltag$Depth > 183,"DEEP",
                           ifelse(ltag$Depth > 140,"MDEEP",
                                  ifelse(ltag$Depth > 110,"MID",
                                         ifelse(ltag$Depth > 85,"MSHAL",
                                                "SHAL"))))
    #Residual pattern by Depth and sex (with lowess by Region)
    plot(ltag$Depth, ltag$Resids,
         ylim=c(-40,40),
         pch=16,cex=0.5,col=factor(ltag$Sex), xlab="Depth", ylab="Residual Lt-Wt", main = "Grouped by sex") 
    plot(ltag$Depth, ltag$Resids,
         ylim=c(-40,40),
         pch=16,cex=0.5,col=factor(ltag$Sex), xlab="Depth", ylab="Residual Lt-Wt", type = "n", main = "Lowess by Region and Sex")
    lines(lowess(ltag$Depth[which(ltag$Sex=="F" & ltag$Lat > (40+10/60))],ltag$Resids[which(ltag$Sex=="F" & ltag$Lat > (40+10/60))]), col=rgb(1,0,0,0.75),lwd=3)
    lines(lowess(ltag$Depth[which(ltag$Sex=="F" & ltag$Lat < (40+10/60))],ltag$Resids[which(ltag$Sex=="F" & ltag$Lat < (40+10/60))]), col=rgb(1,0,0,0.25),lwd=3)
    lines(lowess(ltag$Depth[which(ltag$Sex=="M" & ltag$Lat > (40+10/60))],ltag$Resids[which(ltag$Sex=="M" & ltag$Lat > (40+10/60))]), col=rgb(0,0,1,0.75),lwd=3)
    lines(lowess(ltag$Depth[which(ltag$Sex=="M" & ltag$Lat < (40+10/60))],ltag$Resids[which(ltag$Sex=="M" & ltag$Lat < (40+10/60))]), col=rgb(0,0,1,0.25),lwd=3)
    lines(lowess(ltag$Depth[which(ltag$Sex=="U" & ltag$Lat > (40+10/60))],ltag$Resids[which(ltag$Sex=="U" & ltag$Lat > (40+10/60))]), col=rgb(0,0,0,0.75),lwd=3)
    lines(lowess(ltag$Depth[which(ltag$Sex=="U" & ltag$Lat < (40+10/60))],ltag$Resids[which(ltag$Sex=="U" & ltag$Lat < (40+10/60))]), col=rgb(0,0,0,0.25),lwd=3)
    abline(h=0,col="grey",lty=3)                                # lty=3 dotted line (1 solid)
    legend(x=min(ltag$Depth),y=-20.75,legend=c("Female S Lowess","Male S Lowess","Unsexed S Lowess"),col=c(rgb(1,0,0,0.25),rgb(0,0,1,0.25),rgb(0,0,0,0.25)),lty=1,lwd=3,pch=16,bty="n")
    legend(x=min(ltag$Depth)+200,y=-20.75,legend=c("Female N Lowess","Male N Lowess","Unsexed N Lowess"),col=c(rgb(1,0,0,0.75),rgb(0,0,1,0.75),rgb(0,0,0,0.75)),lty=1,lwd=3,pch=16,bty="n")
    
    #Is effect of depth significant
    writeLines("Slope for continuous latitude ---------------------\n")
    print(summary(lm(Resids ~ Depth, data = ltag)))
    
    #What about by depth regions (as defined in "Lingcod 2017 dataprep.R" in archives)
    DepthFit <- aov(Resids ~ dpthbin, data=ltag)
    writeLines("Anova with Depth as factor ---------------------\n")
    print(anova(DepthFit))
    writeLines("TukeyHSD with Depth as factor ---------------------\n")
    print(TukeyHSD(DepthFit))
  }
  
}


#######################################################
#Set up
#######################################################

#Using only NWFSC.Combo, Triennial, and NWFSC_HKL datasets

#Load and save HKL biodata and ages from HKL aged by Laurel Lam
save_HNL_data()

#Combine data already in package into single dataframe
#Slope surveys have no weights or ages
#Triennial has weights in its age dataset, so use that dataset for age and weight
#HKL has ages in its age dataset, but weights in its length, so use lengths for l-w, ages for l-a
bio.WCGBTS$Source = "NWFSC.Combo"
bio.Triennial$Lengths$Source = "Triennial"
bio.Triennial$Ages$Source = "Triennial_Age"
out = create_survey_data_frame(list(bio.WCGBTS, bio.Triennial$Lengths, bio.Triennial$Ages, bio.HKL, bio.HKLage.Lam))


#######################################################
#Summarize and check values 
#######################################################
#Values by year and source
table(out[!is.na(out$Length),"Year"], out[!is.na(out$Length),"Source"], out[!is.na(out$Length),"Region"])
table(out[!is.na(out$Weight),"Year"], out[!is.na(out$Weight),"Source"], out[!is.na(out$Weight),"Region"])
table(out[!is.na(out$Age),"Year"], out[!is.na(out$Age),"Source"], out[!is.na(out$Age),"Region"])

#Clean data - returns cleaned dataset (which is only NA lengths removed)
out_clean = clean_lingcod_survey_biodata(data = out)

#Estimate length-age and length-weight parameters
# Separates by state, so set Region to equal to State
out_clean$State = out_clean$Region
la_ests <- estimate_length_age(data = out_clean, grouping = "all", linf = 85, l0 = 20, k = 0.2, t0 = NULL)
lw_ests <- estimate_length_weight(data = out_clean, grouping = "all")
#Apply only to the WCGBTS
la_ests_combo <- estimate_length_age(data = out_clean[out_clean$Source == "NWFSC.Combo",], grouping = "all", linf = 85, l0 = 20, k = 0.2, t0 = NULL)
lw_ests_combo <- estimate_length_weight(data = out_clean[out_clean$Source == "NWFSC.Combo",], grouping = "all")

#Check residuals for lw relationship from Combo survey only
checkresids(data = out_clean[out_clean$Source == "NWFSC.Combo",], method = "lw")
#By latitude and region: No real visual residual pattern by latitude...however...there is a statistical effect of latitude (continuous) on residuals
#This is supported by differences in residuals by specific regions which are significantly different
#By depth: No visual residual pattern by depth...however...there is a weakly statistical effect of depth (continuous) on residuals
#This is not supported by depth bin as there is no statistical differences in specific bins

#Check residuals for la relationship from Combo survey only
checkresids(data = out_clean[out_clean$Source == "NWFSC.Combo",], method = "la")
#By latitude and region: Some residual patterns in lowess by latitude and there is a statistical effect of latitude (continuous) on residuals
#Supported by differences in residuals by region which are significantly different
#By depth: Residual pattern in lowess by depth and there is a statistical effect of depth (continuous) on residuals
#Also supported by statistical differences in specific depth bins 

lw.WCGBTS = lw_ests_combo
la.WCGBTS = la_ests_combo
usethis::use_data(lw.WCGBTS, overwrite = TRUE)
usethis::use_data(la.WCGBTS, overwrite = TRUE)


#Plot lw relationship on single figure by Area (for combo)
plot(out_clean[out_clean$Source %in% "NWFSC.Combo" & out_clean$Sex == "F", "Length"], out_clean[out_clean$Source %in% "NWFSC.Combo" & out_clean$Sex == "F", "Weight"], 
     xlab = "Length (cm)", ylab = "Weight (kg)", main = "", 
     ylim = c(0, max(out_clean$Weight, na.rm = TRUE)), xlim = c(0, max(out_clean$Length, na.rm = TRUE)), 
     pch = 16, col = alpha("black", 0.20)) 
points(out_clean[out_clean$Source %in% "NWFSC.Combo" & out_clean$Sex == "M", "Length"], out_clean[out_clean$Source %in% "NWFSC.Combo" & out_clean$Sex == "M", "Weight"], pch = 16, col = alpha("gray", 0.20))
lens = 1:max(out_clean$Length,na.rm = TRUE)
lines(lens, lw_ests$NWFSC.Combo_F[1] * lens ^ lw_ests$NWFSC.Combo_F[2], col = 1, lwd = 2, lty = 1)
lines(lens, lw_ests$NWFSC.Combo_M[1] * lens ^ lw_ests$NWFSC.Combo_M[2], col = 1, lwd = 2, lty = 2)
lines(lens, lw_ests$South_NWFSC.Combo_F[1] * lens ^ lw_ests$South_NWFSC.Combo_F[2], col = 2, lwd = 2, lty = 1)
lines(lens, lw_ests$South_NWFSC.Combo_M[1] * lens ^ lw_ests$South_NWFSC.Combo_M[2], col = 2, lwd = 2, lty = 2)
lines(lens, lw_ests$North_NWFSC.Combo_F[1] * lens ^ lw_ests$North_NWFSC.Combo_F[2], col = 4, lwd = 2, lty = 1)
lines(lens, lw_ests$North_NWFSC.Combo_M[1] * lens ^ lw_ests$North_NWFSC.Combo_M[2], col = 4, lwd = 2, lty = 2)
# #Last assessments values
#lines(lens, 0.00000276 * lens^3.28, col = 3, lwd=4, lty=1) #Female from last assessment North of Pt. Conception
#lines(lens, 0.00000161 * lens^3.42, col = 3, lwd=4, lty=2) #Male from last assessment North of Pt. Conception
#lines(lens, 0.000003308 * lens^3.248, col = 5, lwd=4, lty=1) #Female from last assessment South of Pt. Conception
#lines(lens, 0.000002179 * lens^3.36, col = 5, lwd=4, lty=2) #Male from last assessment South of Pt. Conception
leg = c(paste0("Combo F: a = ", signif(lw_ests$NWFSC.Combo_F[1], digits = 4)," b = ", round(lw_ests$NWFSC.Combo_F[2], 3)),
        paste0("Combo M: a = ", signif(lw_ests$NWFSC.Combo_M[1], digits = 4)," b = ", round(lw_ests$NWFSC.Combo_M[2], 3)),
        paste0("Combo South F: a = ", signif(lw_ests$South_NWFSC.Combo_F[1], digits = 4)," b = ", round(lw_ests$South_NWFSC.Combo_F[2], 3)),
        paste0("Combo South M: a = ", signif(lw_ests$South_NWFSC.Combo_M[1], digits = 4)," b = ", round(lw_ests$South_NWFSC.Combo_M[2], 3)),
        paste0("Combo North F: a = ", signif(lw_ests$North_NWFSC.Combo_F[1], digits = 4)," b = ", round(lw_ests$North_NWFSC.Combo_F[2], 3)),
        paste0("Combo North M: a = ", signif(lw_ests$North_NWFSC.Combo_M[1], digits = 4)," b = ", round(lw_ests$North_NWFSC.Combo_M[2], 3)))
legend("topleft", bty = 'n', legend = leg, lty = c(1,2,1,2,1,2), col = c(1,1,2,2,4,4), lwd = 2)




