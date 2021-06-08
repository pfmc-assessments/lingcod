#' Generate CAAL compositions from any dataset
#'
#' Generate CAAL compositions from any data, e.g., Laurel Lam's thesis data.
#'
#' @param Data A data frame with columns for "Year", "Sex", "Len_Bin_FL",
#' and "Ages"
#' @param agebin A vector of lower and upper age bins, i.e., the range.
#' @param lenbin A vector of lower and upper length bins, i.e., the range.
#' @param wd The directory where you want the output saved.
#' @param append A character value supplying text that will be appened to the
#' beginning of a standard file name.
#' @param seas A numeric value supplying the season for this fleet.
#' @param fleet An integer value for the fleet.
#' @param partition An integer value supplying the partition.
#' @param ageEr An integer value supplying the ageing error matrix to use
#' for this fleet.
#'
#' @author Brian J. Langseth modified code from Chatel R. Wetzel
#' @export
#'
create_caal_nonsurvey <- function(
  Data,
  agebin,
  lenbin,
  wd,
  append,
  seas,
  fleet,
  partition,
  ageEr
){
  
  #Exclude NAs from the age columns
  Data = Data[!is.na(Data$Ages),]
  
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
          Row = c('Year'=YearSet[YearI], 'Seas'=seas, 'Fleet'= fleet, 'Gender' = GenderI, 'Partition'=partition, 'AgeError'=ageEr, 'LbinLo'=LbinSet[LbinI], 
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
    utils::write.csv(Results, file=file.path(getwd(),wd,paste0(append,"_CAAL_",out_gender[GenderI],"_Bins_",lenbin[1],"_",lenbin[2],"_",agebin[1],"_",agebin[2],".csv")), row.names = FALSE)

    out[[GenderI]] = Results

  } # GenderI loop

  return(out)
}
