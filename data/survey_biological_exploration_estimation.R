#######################################
#
#Scripts to explore length and age data for the lingcod_2021 stock assessment from surveys 
#
#Author: Brian Langseth
#Created: March 4, 2021
#
#######################################

#devtools::install_github("nwfsc-assess/nwfscSurvey", build_vignettes = TRUE)
devtools::load_all("U:/Stock assessments/dataModerate_2021")
library(plyr)
library(ggplot2)

#######################################################
#Functions used
#######################################################

#Load data for warehouse and HNL surveys
load_survey_data <- function(sname){
  
  length_list = age_list = catch_list = list()
  
  for(i in 1:length(sname)){
    
    if(sname[i] %in% c("NWFSC_HKL")){
      #John Harms provided data in email on Feb 9, 2021.
      hnl_full = read.csv("qryGrandUnifiedThru2019_For2021Assessments_DWarehouse version_01072021.csv", header = TRUE)
      length_list[[i]] = hnl_full[hnl_full$common_name == "Lingcod",]
      length_list[[i]]$Source = sname[i]
      
      #Merge ages from Laurel Lam
      hnl_ages = read.csv("H&L_Lingcod_ages.csv", header = TRUE)
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
      
      age_list[[i]] = hnl_ages
      age_list[[i]]$Source = sname[i]
      catch_list[[i]] = NA
      print(paste("Done loading bio and catch for", sname[i]))
      next 
    }
    
    #Read biological data and catch data generated from read_surveys() in "survey_comps_datawarehouse.R" 
    load(paste0("Bio_All_", sname[i], "_2021-02-08.rda"))
    length_list[[i]] =  Data
    length_list[[i]]$Source = sname[i]
    age_list[[i]] = length_list[[i]]
    
    #Adjust for format differences for some surveys
    if(sname[i] %in% c("Triennial", "AFSC.Slope")) {
      length_list[[i]] = Data[[1]] 
      length_list[[i]]$Source = sname[i]
      age_list[[i]] = length_list[[i]]
      if(sname[i] %in% "Triennial"){ #AFSC.Slope has no ages
        age_list[[i]] = Data[[2]]
        age_list[[i]]$Source = sname[i]
      }
    }
    
    load(paste0("Catch__", sname[i], "_2021-02-08.rda"))
    catch_list[[i]] = Out
    
    print(paste("Done loading bio and catch for", sname[i]))
  }
  
  return(c("length" = length_list, "age" = age_list, "catch" = catch_list))
}

#Combine survey data into single dataframe
create_survey_data_frame <- function(data_list){
  
  all_data = NA
  for (a in 1:length(data_list)){
    
    if(unique(data_list[[a]]$Source) %in% c("NWFSC_HKL","NWFSC_HKL_Age")){
      
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
    
    if(!unique(data_list[[a]]$Source) %in% c("NWFSC_HKL","NWFSC_HKL_Age")){
      
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

#Output summary of amount of data by Region, Year, Source 
summarize_data <- function(dir = NULL, data, file.amend = NULL){
  
  summary_list <- list()
  summary_list$sources <- unique(data$Source) 
  summary_list$sample_yrs <- table(data$Year, data$Source)
  summary_list$sample_by_region <- table(data$Year, data$Region)
  
  if(sum(is.na(data$Region)) != dim(data)[1]){
    tmp = aggregate(Length ~ Region + Source + Year, data = data, FUN = function(x) sum(!is.na(x)))
    summary_list$region_source_year = tmp[sort(tmp$Region, index.return = TRUE)$ix,]
  }
  
  
  place = 1
  data_sum <- list()
  for(s in sort(unique(data$Source))){
    yrs = sort(unique(data[data$Source == s, "Year"]))
    mat = matrix(NA, length(yrs), 3)
    rownames(mat) = yrs
    colnames(mat) = c("Length", 'Weight', 'Age')
    ind = 1
    for( y in yrs){
      mat[ind,] = c(sum(!is.na(data[data$Source == s & data$Year == y, "Length"])), 
                    sum(!is.na(data[data$Source == s & data$Year == y, "Weight"])),
                    sum(!is.na(data[data$Source == s & data$Year == y, "Age"])) )	
      ind = ind + 1
    }
    data_sum[[place]] = mat
    place = place + 1
  }
  names(data_sum) = sort(unique(data$Source))
  summary_list$BySource = data_sum
  print("Done with Source")
  
  
  place = 1
  data_sum <- list()
  for(t in sort(unique(data$Region))){
    yrs = sort(unique(data[data$Region == t, "Year"]))
    mat = matrix(NA, length(yrs), 3)
    rownames(mat) = yrs
    colnames(mat) = c("Length", 'Weight', 'Age')
    ind = 1
    for( y in yrs){
      mat[ind,] = c(sum(!is.na(data[data$Region == t & data$Year == y, "Length"])), 
                    sum(!is.na(data[data$Region == t & data$Year == y, "Weight"])),
                    sum(!is.na(data[data$Region == t & data$Year == y, "Age"])) )	
      ind = ind + 1
    }
    data_sum[[place]] = mat
    place = place + 1
  }
  names(data_sum) = sort(unique(data$Region))
  summary_list$ByRegion = data_sum
  print("Done with Region")
  
  place = 1; nm = NULL
  data_sum <- list()
  for(a in sort(unique(data$Region))){
    tmp = 0
    yrs = sort(unique(data[data$Region == a, "Year"]))
    mat_len = mat_age = matrix(NA, length(yrs), length(unique(data$Source)))
    rownames(mat_len) = rownames(mat_age) = yrs
    colnames(mat_len) = colnames(mat_age) = sort(unique(data$Source))
    for(t in sort(unique(data$Source))){
      tmp = tmp + 1
      ind = 1
      for( y in yrs){
        get = which(data$Source == t & data$Region == a & data$Year == y)
        if(length(get) > 0){
          mat_len[ind, tmp] = sum(!is.na(data[get, "Length"])) 	
          mat_age[ind, tmp] = sum(!is.na(data[get, "Age"]))
        }
        ind = ind + 1
      }
    }
    data_sum[[place]] = mat_len
    data_sum[[place + 1]] = mat_age
    place = place + 2
    nm = c(nm,  c(paste0(a, "_length"), paste0(a, "_age")))
  }
  names(data_sum) = nm 
  summary_list$BySource_ByRegion = data_sum	
  print("Done with Source and Region")
  
  
  if(!is.null(dir)){ 
    if(!is.null(file.amend)){
      cat(capture.output(print(summary_list), file = file.path(dir, paste0("data_summary",file.amend,".txt"))))
    }else{
      cat(capture.output(print(summary_list), file = file.path(dir, "data_summary.txt")))
    }
  }
  
  return(summary_list)
}

#Compare length frequencies by sex and depth 
length_by_depth_plot <- function(dir, data, xlim = NULL, ylim = NULL){
  
  dir.create(file.path(dir, "plots"), showWarnings = FALSE)
  
  remove <- which(is.na(data$Length) | is.na(data$Depth))
  
  if(length(remove) > 0) { 
    sub_data <- data[-remove, ]
  }else{
    sub_data <- data
  }
  
  sources = unique(sub_data$Source)
  
  if (length(sources) > 3){
    panels = c(ceiling(length(sources) / 2), 2)
  }else{
    panels = c(length(sources), 1)
  }
  
  colvec <- c(rgb(1, 0, 0, alpha = 0.2), 
              rgb(0, 0, 1, alpha = 0.2),
              rgb(0, 0, 0, alpha = 0.2))
  
  if(is.null(xlim)) { 
    xlim = c(floor(min(sub_data[,"Depth"], na.rm = TRUE)), ceiling(max(sub_data[,"Depth"], na.rm = TRUE) ))
  }
  
  if(is.null(ylim)) { 
    ylim = c(floor(min(sub_data[,"Length"], na.rm = TRUE)), ceiling(max(sub_data[,"Length"], na.rm = TRUE) ))
  }
  
  pngfun(wd = file.path(dir, "plots"), file = "Length_by_Depth_by_Source.png", w = 7, h = 7, pt = 12)
  
  par(mfrow = panels)	
  
  # empty plot for legend	
  for (s in sources) 
  {
    plot(sub_data[sub_data$Source == s & sub_data$Sex == "F", "Depth"], 
         sub_data[sub_data$Source == s & sub_data$Sex == "F", "Length"],
         main = s, xlim = xlim, ylim = ylim, xlab = "Depth (m)", ylab = "Length (m)", 
         type = 'p', pch = 16, col = colvec[1])
    
    ind = 2
    for( g in c("M", "U")){
      if(dim(sub_data[sub_data$Source == s & sub_data$Sex == g, ])[1] > 0){
        points(sub_data[sub_data$Source == s & sub_data$Sex == g, "Depth"], 
               sub_data[sub_data$Source == s & sub_data$Sex == g, "Length"],
               pch = 16, col = colvec[ind])
        ind = ind + 1
      }
    } # sex
    legend("right", legend = c("F","M","U"), bty = "n", col = c(2,4,1), pch = 19)
  } # source
  
  dev.off()
  
}

#Basic exploratory plots
exploratory_plots_survey_biodata <- function(dir = NULL, data){
  
  library(plyr)
  library(ggplot2)
  
  # Double check the distribution of all lengths vs. the aged lengths
  pngfun(wd = dir, file = "Compare_Lengths_for_Aged_Unaged_Fish.png", w = 7, h = 7, pt = 12)
  par(mfrow = c(2,3))
  for(sex in c("F", "M", "U")){
    hist(data[data$Sex == sex & (!data$Source %in% c("Triennial_Age", "NWFSC_HKL_Age")), "Length"], xlim = c(0, 120),  xlab = "Length (cm)", 
         col = ifelse(sex == "F", alpha('red', 0.65), alpha('blue', 0.5)), main = paste0("All Fish Lengths: ", sex))
    abline(v = median(data[data$Sex == sex & (!data$Source %in% c("Triennial_Age", "NWFSC_HKL_Age")), "Length"], na.rm = TRUE), lty = 2, lwd = 3, col = 1)
    mtext(side = 3, line = -1, adj = 0, paste("N =",length(data[data$Sex == sex & (!data$Source %in% c("Triennial_Age", "NWFSC_HKL_Age")), "Length"])))
  }
  for(sex in c("F", "M", "U")){
    find = which(!is.na(data$Age) & data$Sex == sex)
    hist(data[find, "Length"], xlim = c(0, 120), xlab = "Length (cm)", 
         col = ifelse(sex == "F", alpha('red', 0.65), alpha('blue', 0.5)), main = paste0("Aged Fish Lengths: ", sex))
    abline(v = median(data[find, "Length"], na.rm = TRUE), lty = 2, lwd = 3, col = 1)
    mtext(side = 3, line = -1, adj = 0, paste("N =",length(data[find, "Length"])))
  }
  dev.off()
  
  #Plot age-length relationships
  pngfun(wd = dir, file = "Age_by_Sex.png", w = 7, h = 7, pt = 12)
  plot(x = data[data$Sex == "F",]$Age, y = data[data$Sex == "F",]$Length, col = 2, pch = 19, ylab = "Length (cm)", xlab = "Age")
  points(x = data[data$Sex == "M",]$Age, y = data[data$Sex == "M",]$Length, col = 4, pch = 19)
  points(x = data[data$Sex == "U",]$Age, y = data[data$Sex == "U",]$Length, col = 1, pch = 19)
  legend("bottomright", c("F","M", "U"), col = c(2, 4, 1), pch = 19, bty = "n")
  dev.off()
  
  pngfun(wd = dir, file = "Age_by_Source.png", w = 7, h = 7, pt = 12)
  plot(x = data[data$Source == "NWFSC.Combo",]$Age, y = data[data$Source == "NWFSC.Combo",]$Length, col = 2, pch = 19, ylab = "Length (cm)", xlab = "Age")
  points(x = data[data$Source == "Triennial_Age",]$Age, y = data[data$Source == "Triennial_Age",]$Length, col = 4, pch = 19)
  points(x = data[data$Source == "NWFSC_HKL_Age",]$Age, y = data[data$Source == "NWFSC_HKL_Age",]$Length, col = 1, pch = 19)
  legend("bottomright", c("Combo","Triennial","HKL"), col = c(2, 4, 1), pch = 19, bty = "n")
  dev.off()
  
  
  #Plot length by latitude
  data$lat_bin = plyr::round_any(data$Lat, 0.5)
  pngfun(wd = dir, file = "Length_by_Latitude.png", w = 7, h = 7, pt = 12)
  par(mfrow = c(3, 1), mar = c(4,4,2,2), oma = c(1,1,1,1))
  for (ss in c("F", "M", "U")){
    find = which(data$Sex == ss & data$Source %in% unique(data[!is.na(data$Lat),"Source"]) & !data$Source %in% c("Triennial_Age", "NWFSC_HKL_Age"))
    col = ifelse(ss == "F", alpha('red', 0.6), ifelse(ss == "M", alpha('blue', 0.6), "grey"))
    boxplot(data$Length[find] ~ data$lat_bin[find],  col = col, ylim = c(0, 115),
            ylab = "Length (cm)", xlab = "Latitude", main = ss)
    mtext(side = 3, adj = 1, line = -1, paste("N =",length(data$Length[find])))
  }
  dev.off()
  
  #Is increase in size at lower latitudes due to increase in depth....No?
  #There are 4 records at 674.9 m that Im not plotting here
  pngfun(wd = dir, file = "Depth_by_Latitude.png", w = 7, h = 7, pt = 12)
  par(mfrow = c(3, 1), mar = c(4,4,2,2), oma = c(1,1,1,1))
  for (ss in c("F", "M", "U")){
    find = which(data$Sex == ss & data$Source %in% unique(data[!is.na(data$Lat),"Source"]) & !data$Source %in% c("Triennial_Age", "NWFSC_HKL_Age"))
    col = ifelse(ss == "F", alpha('red', 0.6), ifelse(ss == "M", alpha('blue', 0.6), "grey"))
    boxplot(data$Depth[find] ~ data$lat_bin[find],  col = col, ylim = c(450, 0),
            ylab = "Depth (m)", xlab = "Latitude", main = ss)
    mtext(side = 3, adj = 1, line = -1, paste("N =",length(data$Length[find])))
  }
  dev.off()
  
  #Difference is actually due to HKL survey catching larger fish and being between 32 and 35 degrees exclusively
  pngfun(wd = dir, file = "Length_by_Latitude_JustCombo.png", w = 7, h = 7, pt = 12)
  par(mfrow = c(3, 1), mar = c(4,4,2,2), oma = c(1,1,1,1))
  for (ss in c("F", "M", "U")){
    find = which(data$Sex == ss & data$Source %in% c("NWFSC.Combo"))
    col = ifelse(ss == "F", alpha('red', 0.6), ifelse(ss == "M", alpha('blue', 0.6), "grey"))
    boxplot(data$Length[find] ~ data$lat_bin[find],  col = col, ylim = c(0, 115),
            ylab = "Length (cm)", xlab = "Latitude", main = ss)
    mtext(side = 3, adj = 1, line = -1, paste("N =",length(data$Length[find])))
  }
  dev.off()
  
  #Plot ages distribution by data source
  data$region_source = paste0(data$Source, "_", data$Region)
  pngfun(wd = dir, file = "Age_Density_by_Source.png", w = 7, h = 7, pt = 12)
  #Need to use print here since ggplot doesn't plot within a function call
  print(ggplot(data, aes(Age, fill = region_source, color = region_source)) +
          #facet_wrap(facets = c("Region")) +
          geom_bar(alpha = 0.4, lwd = 0.8))
  dev.off()
  
  #Plot ages distribution by sex
  pngfun(wd = dir, file = "Age_Density_by_Sex.png", w = 7, h = 7, pt = 12)
  #Need to use print here since ggplot doesn't plot within a function call
  print(ggplot(data, aes(Age, fill = Sex, color = Sex)) +
          #facet_wrap(facets = c("Region")) +
          geom_density(alpha = 0.4, lwd = 0.8, adjust = 1.5))
  dev.off()
  
  #Plot length distribution by data source
  pngfun(wd = dir, file = "Length_Density_by_Source.png", w = 7, h = 7, pt = 12)
  #Need to use print here since ggplot doesn't plot within a function call
  print(ggplot(data[!data$Source %in% c("Triennial_Age", "NWFSC_HKL_Age"),], aes(Length, fill = Source, color = Source)) +
          #facet_wrap(facets = c("Region")) +
          geom_density(alpha = 0.4, lwd = 0.8))
  dev.off()
  
  #Plot length distribution by sex
  pngfun(wd = dir, file = "Length_Density_by_Sex.png", w = 7, h = 7, pt = 12)
  #Need to use print here since ggplot doesn't plot within a function call
  print(ggplot(data[!data$Source %in% c("Triennial_Age", "NWFSC_HKL_Age"),], aes(Length, fill = Sex, color = Sex)) +
          #facet_wrap(facets = c("Region")) +
          geom_density(alpha = 0.4, lwd = 0.8, adjust = 1.5))
  dev.off()
  
  # What is the trend in length and age and weight across time
  # This figure includes all data -- which may be biased due to selectivity
  pngfun(wd = file.path(getwd(), "plots"), file = "Data_Summary_Len_Age_Weight_by_Year.png", w = 7, h = 7, pt = 12)
  par(mfrow = c(3, 1), mar = c(4,4,2,2), oma = c(1,1,1,1))
  plot(data[!data$Source %in% c("Triennial_Age", "NWFSC_HKL_Age"),]$Year, data[!data$Source %in% c("Triennial_Age", "NWFSC_HKL_Age"),]$Length, ylab = "Length (cm)", xlab = "Year", ylim = c(0, max(data$Length, na.rm = TRUE)))
  tmp = aggregate (Length ~ Year + Region, data[!data$Source %in% c("Triennial_Age", "NWFSC_HKL_Age"),], FUN = median)
  lines(tmp[tmp$Region=="North",]$Year, tmp[tmp$Region=="North",]$Length, lty = 1, col = 'red', lwd = 3)
  lines(tmp[tmp$Region=="South",]$Year, tmp[tmp$Region=="South",]$Length, lty = 1, col = 'blue', lwd = 3)
  plot(data$Year, data$Age, ylab = "Age", xlab = "Year", ylim = c(0, max(data$Age, na.rm = TRUE)))
  tmp = aggregate (Age ~ Year + Region, data, FUN = median)
  lines(tmp[tmp$Region=="North",]$Year, tmp[tmp$Region=="North",]$Age, lty = 1, col = 'red', lwd = 3)
  lines(tmp[tmp$Region=="South",]$Year, tmp[tmp$Region=="South",]$Age, lty = 1, col = 'blue', lwd = 3)
  legend("left", c("Median North", "Median South"), lty=1, col=c("red","blue"), lwd=3, bty = "n")
  plot(data[!data$Source %in% c("NWFSC_HKL_Age"),]$Year, data[!data$Source %in% c("NWFSC_HKL_Age"),]$Weight, ylab = "Weight", xlab = "Year", ylim = c(0, max(data$Weight, na.rm = TRUE)))
  tmp = aggregate (Weight ~ Year + Region, data[!data$Source %in% c("NWFSC_HKL_Age"),], FUN = median)
  lines(tmp[tmp$Region=="North",]$Year, tmp[tmp$Region=="North",]$Weight, lty = 1, col = 'red', lwd = 3)
  lines(tmp[tmp$Region=="South",]$Year, tmp[tmp$Region=="South",]$Weight, lty = 1, col = 'blue', lwd = 3)
  dev.off()
  
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

#Working directory where files will be saved
setwd("U:/Stock assessments/lingcod_2021/surveys")

#Surveys to use 
surveys = c("NWFSC.Combo", "Triennial", "AFSC.Slope", "NWFSC.Slope", "NWFSC_HKL")

#Load data already downloaded
survey_data = load_survey_data(surveys)

#Combine into single dataframe
#Slope surveys have no weights or ages
#Triennial has weights in its age dataset, so use that dataset for age and weight
#HKL has ages in its age dataset, but weights in its length, so use lengths for l-w, ages for l-a
survey_data$age2$Source = "Triennial_Age"
survey_data$age5$Source = "NWFSC_HKL_Age"
out = create_survey_data_frame(survey_data[c("length1","length2","length3","length4","length5","age2","age5")])


#######################################################
#Summarize and check values 
#######################################################
#Values by year and source
table(out[!is.na(out$Length),"Year"], out[!is.na(out$Length),"Source"], out[!is.na(out$Length),"Region"])
table(out[!is.na(out$Weight),"Year"], out[!is.na(out$Weight),"Source"], out[!is.na(out$Weight),"Region"])
table(out[!is.na(out$Age),"Year"], out[!is.na(out$Age),"Source"], out[!is.na(out$Age),"Region"])

#Clean data - returns cleaned dataset (which is only NA lengths removed)
out_clean = clean_lingcod_survey_biodata(data = out)

#Summarize data. 
#Triennial_Age is the subset of Triennial lengths with ages (and weights)
#NWFSC_HKL_Age is the subset of NWFSC_HKL lengths and weights with ages
summarize_data(file.path(getwd(),"plots"), out_clean, file.amend = NULL)

#Estimate length-age and length-weight parameters
# Separates by state, so set Region to equal to State
out_clean$State = out_clean$Region
la_ests <- estimate_length_age(data = out_clean, grouping = "all", linf = 85, l0 = 20, k = 0.2)
lw_ests <- estimate_length_weight(data = out_clean, grouping = "all")

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


#######################################################
#Plot various outputs
#######################################################

#Plot sample sizes
pngfun(wd = file.path(getwd(), "plots"), file = "Length_Samples.png", w = 7, h = 3, pt = 12)
ggplot(out_clean[!out_clean$Source %in% c("Triennial_Age", "NWFSC_HKL_Age"),], aes(Year, fill = Source, color = Source)) +
  facet_wrap(facets = c("Region")) +
  geom_bar(alpha = 0.4, lwd = 0.8, width = 0.8) +
  ggtitle("Survey Lengths")
dev.off()
#exclude the slope surveys
pngfun(wd = file.path(getwd(), "plots"), file = "Length_Samples_noslope.png", w = 7, h = 3, pt = 12)
ggplot(out_clean[!out_clean$Source %in% c("Triennial_Age", "NWFSC_HKL_Age", "AFSC.Slope","NWFSC.Slope"),], aes(Year, fill = Source, color = Source)) +
  facet_wrap(facets = c("Region")) +
  geom_bar(alpha = 0.4, lwd = 0.8, width = 0.8) +
  ggtitle("Survey Lengths")
dev.off()

pngfun(wd = file.path(getwd(), "plots"), file = "Weight_Samples.png", w = 7, h = 3, pt = 12)
temp = out_clean[!out_clean$Source %in% c("Triennial", "NWFSC_HKL_Age"),] #Change so "triennial" shows up in legend
temp[temp$Source == "Triennial_Age","Source"] = "Triennial"
ggplot(temp[!is.na(temp$Weight),], aes(Year, fill = Source, color = Source)) +
  facet_wrap(facets = c("Region")) +
  geom_bar(alpha = 0.4, lwd = 0.8, width = 0.8) +
  ggtitle("Survey Weights")
dev.off()

pngfun(wd = file.path(getwd(), "plots"), file = "Age_Samples.png", w = 7, h = 3, pt = 12)
temp = out_clean[!out_clean$Source %in% c("Triennial"),] #Change so "triennial" shows up in legend
temp[temp$Source == "Triennial_Age","Source"] = "Triennial"
temp[temp$Source == "NWFSC_HKL_Age","Source"] = "NWFSC_HKL"
ggplot(temp[!is.na(temp$Age),], aes(Year, fill = Source, color = Source)) +
  facet_wrap(facets = c("Region")) +
  geom_bar(alpha = 0.4, lwd = 0.8, width = 0.8) +
  ggtitle("Survey Ages")
dev.off()

#Basic exploratory plots
exploratory_plots_survey_biodata(dir = file.path(getwd(), "plots"), data = out_clean)

#Specific length by depth plot - plots into the "plots" folder in dir
length_by_depth_plot(dir = getwd(), data = out_clean[!out_clean$Source %in% c("Triennial_Age", "NWFSC_HKL_Age"),], xlim = NULL, ylim = NULL)

#	Plot length frequency plots by source - plots into the "plots" folder in dir
length_freq_plot(dir = getwd(), data = out_clean[!out_clean$Source %in% c("Triennial_Age", "NWFSC_HKL_Age"),], xlim = NULL, ylim = c(0,0.1))

# Plot length-age and length-weight relationships
# Since set Region to equal to State above, can plot plots 3 and 4
# Since plotting weight and age, will only use triennial lengths from the Triennial_Age dataset
length_age_plot(dir = file.path(getwd()), splits = NA, data = out_clean, nm_append = NULL, ests = la_ests, plots = 1:4)
length_weight_plot(dir = file.path(getwd()), splits = NA, data = out_clean[!out_clean$Source %in% c("NWFSC_HKL_Age"),], nm_append = NULL, ests = lw_ests, plots = 1:4)

#Plot la relationship on single figure by Source
pngfun(wd = file.path(getwd(), "plots"), file = "Length_Age_Combo_byRegion.png", w = 7, h = 7, pt = 12)
plot(out_clean[!out_clean$Source %in% "Triennial" & out_clean$Sex == "F", "Age"], out_clean[!out_clean$Source %in% "Triennial" & out_clean$Sex == "F", "Length"], 
     xlab = "Age", ylab = "Length (cm)", main = "", 
     ylim = c(0, max(out_clean$Length, na.rm = TRUE)), xlim = c(0, max(out_clean$Age, na.rm = TRUE)), 
     pch = 16, col = alpha("red", 0.20)) 
points(out_clean[!out_clean$Source %in% "Triennial" & out_clean$Sex == "M", "Age"], out_clean[!out_clean$Source %in% "Triennial" & out_clean$Sex == "M", "Length"], pch = 16, col = alpha("blue", 0.20))
lens = 0:max(out_clean$Age,na.rm = TRUE)
lines(lens, vb_fn(age = lens, Linf = la_ests$South_NWFSC.Combo_F[1], L0 = la_ests$South_NWFSC.Combo_F[2], k = la_ests$South_NWFSC.Combo_F[3]), col = "red", lwd = 2, lty = 1)
lines(lens, vb_fn(age = lens, Linf = la_ests$South_NWFSC.Combo_M[1], L0 = la_ests$South_NWFSC.Combo_M[2], k = la_ests$South_NWFSC.Combo_M[3]), col = "blue", lwd = 2, lty = 1)
lines(lens, vb_fn(age = lens, Linf = la_ests$North_NWFSC.Combo_F[1], L0 = la_ests$North_NWFSC.Combo_F[2], k = la_ests$North_NWFSC.Combo_F[3]), col = "red", lwd = 2, lty = 2)
lines(lens, vb_fn(age = lens, Linf = la_ests$North_NWFSC.Combo_M[1], L0 = la_ests$North_NWFSC.Combo_M[2], k = la_ests$North_NWFSC.Combo_M[3]), col = "blue", lwd = 2, lty = 2)
#lines(lens, vb_fn(age = lens, Linf = la_ests$NWFSC.Combo_F[1], L0 = la_ests$NWFSC.Combo_F[2], k = la_ests$NWFSC.Combo_F[3]), col = "red", lwd = 2, lty = 1)
#lines(lens, vb_fn(age = lens, Linf = la_ests$NWFSC.Combo_M[1], L0 = la_ests$NWFSC.Combo_M[2], k = la_ests$NWFSC.Combo_M[3]), col = "blue", lwd = 2, lty = 1)
leg = c(#paste0("Combo F: Linf = ", signif(la_ests$NWFSC.Combo_F[1], digits = 3), " L0 = ", round(la_ests$NWFSC.Combo_F[2],1), " K = ", round(la_ests$NWFSC.Combo_F[3], 2)),
        #paste0("Combo M: Linf = ", signif(la_ests$NWFSC.Combo_M[1], digits = 3), " L0 = ", round(la_ests$NWFSC.Combo_M[2],1), " K = ", round(la_ests$NWFSC.Combo_M[3], 2)),
        paste0("South Combo F: Linf = ", signif(la_ests$South_NWFSC.Combo_F[1], digits = 3), " L0 = ", round(la_ests$South_NWFSC.Combo_F[2],1), " K = ", round(la_ests$South_NWFSC.Combo_F[3], 2)),
        paste0("South Combo M: Linf = ", signif(la_ests$South_NWFSC.Combo_M[1], digits = 3), " L0 = ", round(la_ests$South_NWFSC.Combo_M[2],1), " K = ", round(la_ests$South_NWFSC.Combo_M[3], 2)),
        paste0("North Combo F: Linf = ", signif(la_ests$North_NWFSC.Combo_F[1], digits = 3), " L0 = ", round(la_ests$North_NWFSC.Combo_F[2],1), " K = ", round(la_ests$North_NWFSC.Combo_F[3], 2)),
        paste0("North Combo M: Linf = ", signif(la_ests$North_NWFSC.Combo_M[1], digits = 3), " L0 = ", round(la_ests$North_NWFSC.Combo_M[2],1), " K = ", round(la_ests$North_NWFSC.Combo_M[3], 2)))
legend("bottomright", bty = 'n', legend = leg, lty = c(1,1,2,2), col = c("red","blue"), lwd = 2)
dev.off()  

#Plot combined la relationship by source on one figure
pngfun(wd = file.path(getwd(), "plots"), file = "Length_Age_by_Source_onefigure.png", w = 7, h = 7, pt = 12)
plot(out_clean[!out_clean$Source %in% "Triennial", "Age"], out_clean[!out_clean$Source %in% "Triennial", "Length"], 
     xlab = "Age", ylab = "Length (cm)", main = "", 
     ylim = c(0, max(out_clean$Length, na.rm = TRUE)), xlim = c(0, max(out_clean$Age, na.rm = TRUE)), 
     pch = 16, col = alpha("grey", 0.20)) 
lens = 0:max(out_clean$Age,na.rm = TRUE)
lines(lens, vb_fn(age = lens, Linf = la_ests$NWFSC.Combo_F[1], L0 = la_ests$NWFSC.Combo_F[2], k = la_ests$NWFSC.Combo_F[3]), col = "red", lwd = 2, lty = 1)
lines(lens, vb_fn(age = lens, Linf = la_ests$NWFSC.Combo_M[1], L0 = la_ests$NWFSC.Combo_M[2], k = la_ests$NWFSC.Combo_M[3]), col = "blue", lwd = 2, lty = 1)
lines(lens, vb_fn(age = lens, Linf = la_ests$NWFSC_HKL_Age_F[1], L0 = la_ests$NWFSC_HKL_Age_F[2], k = la_ests$NWFSC_HKL_Age_F[3]), col = "red", lwd = 2, lty = 2)
lines(lens, vb_fn(age = lens, Linf = la_ests$NWFSC_HKL_Age_M[1], L0 = la_ests$NWFSC_HKL_Age_M[2], k = la_ests$NWFSC_HKL_Age_M[3]), col = "blue", lwd = 2, lty = 2)
lines(lens, vb_fn(age = lens, Linf = la_ests$Triennial_Age_F[1], L0 = la_ests$Triennial_Age_F[2], k = la_ests$Triennial_Age_F[3]), col = "red", lwd = 2, lty = 3)
lines(lens, vb_fn(age = lens, Linf = la_ests$Triennial_Age_M[1], L0 = la_ests$Triennial_Age_M[2], k = la_ests$Triennial_Age_M[3]), col = "blue", lwd = 2, lty = 3)
leg = c(paste0("Combo F: Linf = ", signif(la_ests$NWFSC.Combo_F[1], digits = 3), " L0 = ", round(la_ests$NWFSC.Combo_F[2],1), " K = ", round(la_ests$NWFSC.Combo_F[3], 2)),
        paste0("Combo M: Linf = ", signif(la_ests$NWFSC.Combo_M[1], digits = 3), " L0 = ", round(la_ests$NWFSC.Combo_M[2],1), " K = ", round(la_ests$NWFSC.Combo_M[3], 2)),
        paste0("HKL F: Linf = ", signif(la_ests$NWFSC_HKL_Age_F[1], digits = 3), " L0 = ", round(la_ests$NWFSC_HKL_Age_F[2],1), " K = ", round(la_ests$NWFSC_HKL_Age_F[3], 2)),
        paste0("HKL M: Linf = ", signif(la_ests$NWFSC_HKL_Age_M[1], digits = 3), " L0 = ", round(la_ests$NWFSC_HKL_Age_M[2],1), " K = ", round(la_ests$NWFSC_HKL_Age_M[3], 2)),
        paste0("Triennial F: Linf = ", signif(la_ests$Triennial_Age_F[1], digits = 3), " L0 = ", round(la_ests$Triennial_Age_F[2],1), " K = ", round(la_ests$Triennial_Age_F[3], 2)),
        paste0("Triennial M: Linf = ", signif(la_ests$Triennial_Age_M[1], digits = 3), " L0 = ", round(la_ests$Triennial_Age_M[2],1), " K = ", round(la_ests$Triennial_Age_M[3], 2)))
legend("bottomright", bty = 'n', legend = leg, lty = c(1,1,2,2,3,3), col = c("red","blue"), lwd = 2)
dev.off()  


#Plot lw relationship on single figure by Area (for combo)
pngfun(wd = file.path(getwd(), "plots"), file = "Length_Weight_Combo_byRegion.png", w = 7, h = 7, pt = 12)
plot(out_clean[!out_clean$Source %in% "Triennial" & out_clean$Sex == "F", "Length"], out_clean[!out_clean$Source %in% "Triennial" & out_clean$Sex == "F", "Weight"], 
     xlab = "Length (cm)", ylab = "Weight (kg)", main = "", 
     ylim = c(0, max(out_clean$Weight, na.rm = TRUE)), xlim = c(0, max(out_clean$Length, na.rm = TRUE)), 
     pch = 16, col = alpha("red", 0.20)) 
points(out_clean[!out_clean$Source %in% "Triennial" & out_clean$Sex == "M", "Length"], out_clean[!out_clean$Source %in% "Triennial" & out_clean$Sex == "M", "Weight"], pch = 16, col = alpha("blue", 0.20))
lens = 1:max(out_clean$Length,na.rm = TRUE)
#lines(lens, lw_ests$NWFSC.Combo_F[1] * lens ^ lw_ests$NWFSC.Combo_F[2], col = "red", lwd = 2, lty = 1)
#lines(lens, lw_ests$NWFSC.Combo_M[1] * lens ^ lw_ests$NWFSC.Combo_M[2], col = "blue", lwd = 2, lty = 1)
lines(lens, lw_ests$South_NWFSC.Combo_F[1] * lens ^ lw_ests$South_NWFSC.Combo_F[2], col = "red", lwd = 2, lty = 1)
lines(lens, lw_ests$South_NWFSC.Combo_M[1] * lens ^ lw_ests$South_NWFSC.Combo_M[2], col = "blue", lwd = 2, lty = 1)
lines(lens, lw_ests$North_NWFSC.Combo_F[1] * lens ^ lw_ests$North_NWFSC.Combo_F[2], col = "red", lwd = 2, lty = 2)
lines(lens, lw_ests$North_NWFSC.Combo_M[1] * lens ^ lw_ests$North_NWFSC.Combo_M[2], col = "blue", lwd = 2, lty = 2)
# #Last assessments values
#lines(lens, 0.00000276 * lens^3.28, col = "darkgray", lwd=3, lty=2) #Female from last assessment North of Pt. Conception
#lines(lens, 0.00000161 * lens^3.42, col = "black", lwd=3, lty=2) #Male from last assessment North of Pt. Conception
#lines(lens, 0.000003308 * lens^3.248, col = "darkgray", lwd=3, lty=1) #Female from last assessment South of Pt. Conception
#lines(lens, 0.000002179 * lens^3.36, col = "black", lwd=3, lty=1) #Male from last assessment South of Pt. Conception
leg = c(#paste0("Combo F: a = ", signif(lw_ests$NWFSC.Combo_F[1], digits = 4)," b = ", round(lw_ests$NWFSC.Combo_F[2], 3)),
        #paste0("Combo M: a = ", signif(lw_ests$NWFSC.Combo_M[1], digits = 4)," b = ", round(lw_ests$NWFSC.Combo_M[2], 3)),
        paste0("Combo South F: a = ", signif(lw_ests$South_NWFSC.Combo_F[1], digits = 4)," b = ", round(lw_ests$South_NWFSC.Combo_F[2], 3)),
        paste0("Combo South M: a = ", signif(lw_ests$South_NWFSC.Combo_M[1], digits = 4)," b = ", round(lw_ests$South_NWFSC.Combo_M[2], 3)),
        paste0("Combo North F: a = ", signif(lw_ests$North_NWFSC.Combo_F[1], digits = 4)," b = ", round(lw_ests$North_NWFSC.Combo_F[2], 3)),
        paste0("Combo North M: a = ", signif(lw_ests$North_NWFSC.Combo_M[1], digits = 4)," b = ", round(lw_ests$North_NWFSC.Combo_M[2], 3)))
legend("topleft", bty = 'n', legend = leg, lty = c(1,1,2,2), col = c("red","blue"), lwd = 2)
dev.off()   


#Plot lw relationship by source on single figure
pngfun(wd = file.path(getwd(), "plots"), file = "Length_Weight_by_Source_oneFigure.png", w = 7, h = 7, pt = 12)
plot(out_clean[!out_clean$Source %in% "Triennial", "Length"], out_clean[!out_clean$Source %in% "Triennial", "Weight"], 
     xlab = "Length (cm)", ylab = "Weight (kg)", main = "", 
     ylim = c(0, max(out_clean$Weight, na.rm = TRUE)), xlim = c(0, max(out_clean$Length, na.rm = TRUE)), 
     pch = 16, col = alpha("gray", 0.20)) 
lens = 1:max(out_clean$Length,na.rm = TRUE)
lines(lens, lw_ests$NWFSC.Combo_F[1] * lens ^ lw_ests$NWFSC.Combo_F[2], col = "red", lwd = 2, lty = 1)
lines(lens, lw_ests$NWFSC.Combo_M[1] * lens ^ lw_ests$NWFSC.Combo_M[2], col = "blue", lwd = 2, lty = 1)
lines(lens, lw_ests$NWFSC_HKL_F[1] * lens ^ lw_ests$NWFSC_HKL_F[2], col = "red", lwd = 2, lty = 2)
lines(lens, lw_ests$NWFSC_HKL_M[1] * lens ^ lw_ests$NWFSC_HKL_M[2], col = "blue", lwd = 2, lty = 2)
lines(lens, lw_ests$Triennial_Age_F[1] * lens ^ lw_ests$Triennial_Age_F[2], col = "red", lwd = 2, lty = 3)
lines(lens, lw_ests$Triennial_Age_M[1] * lens ^ lw_ests$Triennial_Age_M[2], col = "blue", lwd = 2, lty = 3)
leg = c(paste0("Combo F: a = ", signif(lw_ests$NWFSC.Combo_F[1], digits = 4)," b = ", round(lw_ests$NWFSC.Combo_F[2], 3)),
        paste0("Combo M: a = ", signif(lw_ests$NWFSC.Combo_M[1], digits = 4)," b = ", round(lw_ests$NWFSC.Combo_M[2], 3)),
        paste0("HKL F: a = ", signif(lw_ests$NWFSC_HKL_F[1], digits = 4)," b = ", round(lw_ests$NWFSC_HKL_F[2], 3)),
        paste0("HKL M: a = ", signif(lw_ests$NWFSC_HKL_M[1], digits = 4)," b = ", round(lw_ests$NWFSC_HKL_M[2], 3)),
        paste0("Triennial F: a = ", signif(lw_ests$Triennial_Age_F[1], digits = 4)," b = ", round(lw_ests$Triennial_Age_F[2], 3)),
        paste0("Triennial M: a = ", signif(lw_ests$Triennial_Age_M[1], digits = 4)," b = ", round(lw_ests$Triennial_Age_M[2], 3)))
legend("topleft", bty = 'n', legend = leg, lty = c(1,1,2,2,3,3), col = c("red","blue"), lwd = 2)
dev.off()  





