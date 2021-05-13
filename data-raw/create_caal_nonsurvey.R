######
# Code to generate CAAL compositions from any dataset. 
# Used specifically to generate CAAL comps from Laurel Lam's thesis data
# Standard scripts from nwfscSurvey package not conducive to doing this
#
# Developed and provided by Chantel Wetzel from past applications. 
# Modified to this purpose by Brian Langseth.
#
# Data to read in
# agebin is vector of lower and upper age bins
# lenbin is vector of lower and upper length bins
# wd is location where you want output saved
# append is text to add to beginning of output file name
######

create_caal_nonsurvey <- function(Data,agebin,lenbin,wd,append){
  # Define years in the data
  YearSet = min(Data[Data$Year!="9999",'Year']):max(Data[Data$Year!="9999",'Year']) #9999 used to acount for added dummy year to Lam thesis data
  # Age bins
  AgeSet = agebin[1]:agebin[2]
  MinusAge = agebin[1]
  PlusAge = agebin[2]
  # Length bins
  LbinSet = seq(lenbin[1], lenbin[2], 2)
 
  # List of outputs to return
  out=list("female" = NA, "male" = NA)
  out_gender = c("Female","Male") #to output full gender, not just F and M
  
  #Loop across F then M
  for(GenderI in 1:2){
    # Start matrix to save results by gender
    Results = NULL

    Gender = c("F","M")[GenderI]

    # Loop across years
    for(YearI in 1:length(YearSet)){
      
      ########## CONDITIONAL
      # Loop across Length-bins
      for(LbinI in 1:length(LbinSet)){

        # Identify relevant rows
        Which = which(Data[,'Sex']==Gender & Data[,'Year']==YearSet[YearI] & Data[,'Len_Bin_FL']==LbinSet[LbinI])

        # Skip this year unless there are rows
        if(length(Which)>0){
          # Format reference stuff
          Row = c('Year'=YearSet[YearI], 'Seas'=1, 'Fleet'= NA, 'Gender' = GenderI, 'Partition'=2, 'AgeError'=NA, 'LbinLo'=LbinSet[LbinI], 
                'LbinHi'=LbinSet[LbinI], 'nSamps'= "NA")
          # Loop across age bins
          for(AgeI in 1:length(AgeSet)){
            # Subset to relevant rows
            if(AgeSet[AgeI]==MinusAge) Which2 = Which[which(Data[Which,'Ages']<=AgeSet[AgeI])]
            if(AgeSet[AgeI]==PlusAge)  Which2 = Which[which(Data[Which,'Ages']>=AgeSet[AgeI])]
            if(AgeSet[AgeI]!=MinusAge & AgeSet[AgeI]!=PlusAge) Which2 = Which[which(Data[Which,'Ages']==AgeSet[AgeI])]
            # Sum to effective sample size by length_bin x Gender x Year
            Row = c(Row, nrow(Data[Which2,]))
          } # End AgeI loop
          if((nrow(Data[Which[!is.na(Data[Which,"Ages"])],])-sum(as.numeric(Row[-c(1:9)])))>0.1) stop(paste0("Missing sample: Conditional. Length bin number = ",LbinI))
          
          # Add to results matrix
          Results = rbind(Results, Row)
        } # length(Which)
      } # LbinI loop
    } #Year loop
      
    # Explore results
    #if(FALSE){
    #  colSums(matrix(as.numeric(Results[which(Results[,'Year']=="1980"),-c(1:9)]),ncol=PlusAge))
    #  matrix(as.numeric(ResultsMarginal[1,-c(1:9)]),ncol=PlusAge) / sum(matrix(as.numeric(ResultsMarginal[1,-c(1:9)]),ncol=PlusAge))
    #}
  
    # Add headers
    Results = data.frame(Results, row.names=NULL)
    colnames(Results)[-c(1:9)] = paste("Age_",AgeSet,sep="")

    # Check for missing data
    N1 = sum(apply(Results[,paste("Age_",AgeSet,sep="")], MARGIN=2, FUN=as.numeric))
    N0 = nrow(Data[which(Data[,'Sex']==Gender & !is.na(Data[,"Ages"])  & Data$Year %in% YearSet),])
    
    if( (N1-N0) > 0.1 ){
     stop("Missing sample in fleet")
    }
    
    #Add number of samples
    Results$nSamps = rowSums(apply(Results[,paste("Age_",AgeSet,sep="")], MARGIN=2, FUN=as.numeric))
    
    # Write to file
    write.csv(Results, file=file.path(getwd(),wd,paste0(append,"_CAAL_",out_gender[GenderI],"_Bins_",lenbin[1],"_",lenbin[2],"_",agebin[1],"_",agebin[2],".csv")))
  
    out[[GenderI]] = Results
    
  } # GenderI loop
  
  return(out)
}