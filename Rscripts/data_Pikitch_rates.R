
DiscardExtCatch <- file.path("DiscardMeshExtCatch 16 Jun 2015.RData")

> DiscardExtCatch_Lingcod <- DiscardMeshExtCatch[DiscardMeshExtCatch$Study %in% 'Discard' & DiscardMeshExtCatch$CommonName %in% 'LINGCOD', ]
> headTail(DiscardExtCatch_Lingcod, 3, 3)
      Trip.Haul Year Yrmthday Depth.fm Strategy Gear MeshSize.in SpCode UtilWtExt.lb UtilNumExt DiscWtExt.lb DiscNumExt WhyDiscard   Lat.DD   Long.DD LatLongSource   Study CommonName     ScientificName     SpNameSource Jeans.Assm
14       1.0001 1985   850624       60      NSM   MG         4.5  21910        50.59      16.86            0          0       <NA> 44.74210 -124.3724         Loran Discard    LINGCOD OPHIODON ELONGATUS Discard Database        BRF
31       1.0002 1985   850624       68      NSM   MG         4.5  21910       192.15      16.47            0          0       <NA> 44.70434 -124.4753         Loran Discard    LINGCOD OPHIODON ELONGATUS Discard Database        BRF
76       1.0005 1985   850625       95      NSM   MG         4.5  21910       191.64      15.09            0          0       <NA> 44.28475 -124.8719         Loran Discard    LINGCOD OPHIODON ELONGATUS Discard Database        DWD
18132  138.0002 1987   871212       45      NSM   MG          NA  21910        14.50       1.00            0          0       <NA> 44.31661 -124.3828         Loran Discard    LINGCOD OPHIODON ELONGATUS Discard Database        NSM
18144  138.0003 1987   871213       50      NSM   MG          NA  21910        17.30       1.00            0          0       <NA> 44.21008 -124.4327         Loran Discard    LINGCOD OPHIODON ELONGATUS Discard Database        NSM
18237  139.0003 1987   871213      220      DWD   CB         4.5  21910        13.78       6.26            0          0       <NA> 43.11163 -124.8899         Loran Discard    LINGCOD OPHIODON ELONGATUS Discard Database        NSM
      ARID
14      2C
31      2C
76      2B
18132   2C
18144   2B
18237   2B

Dimension: 374 22 

> Table(DiscardExtCatch_Lingcod$Strategy, DiscardExtCatch_Lingcod$Gear)
     
       CB  MG  MW  RG  S2
  BRF  14   2   0 120   0
  DWD   9  60   0   4   0
  MID   0   0   1   0   0
  NSM   9 115   0   1   0
  SHR   0   0   0   0  39
> # Discard rate for all the Lingcod data
> sum(DiscardExtCatch_Lingcod$DiscWtExt.lb, na.rm = TRUE)/sum(DiscardExtCatch_Lingcod$DiscWtExt.lb + DiscardExtCatch_Lingcod$UtilWtExt.lb, na.rm = TRUE)
[1] 0.008236856
> # Discard rate for Lingcod by Area and Gear
> agg.table(aggregate(list(Discad_Rate = 1:length(DiscardExtCatch_Lingcod$DiscWtExt.lb)), list(ARID = DiscardExtCatch_Lingcod$ARID, Gear = DiscardExtCatch_Lingcod$Gear),
+                   function(index) { sum(DiscardExtCatch_Lingcod$DiscWtExt.lb[index], na.rm = TRUE)/sum(DiscardExtCatch_Lingcod$DiscWtExt.lb + DiscardExtCatch_Lingcod$UtilWtExt.lb, na.rm = TRUE) }))

		 Discad_Rate 

 ARID 			 Gear 

               RG CB        MG MW        S2
2A      0.0000000 NA        NA NA        NA
2B      0.0050041  0 0.0003834  0 0.0000000
2C      0.0000000  0 0.0004155 NA 0.0000000
3A      0.0010770  0 0.0005429 NA 0.0000752
3S_&_3B 0.0000000  0 0.0004028 NA 0.0003359


> # Discard rate for Lingcod by Year and Gear
> agg.table(aggregate(list(Discad_Rate = 1:length(DiscardExtCatch_Lingcod$DiscWtExt.lb)), list(Year = DiscardExtCatch_Lingcod$Year, Gear = DiscardExtCatch_Lingcod$Gear),
+                   function(index) { sum(DiscardExtCatch_Lingcod$DiscWtExt.lb[index], na.rm = TRUE)/sum(DiscardExtCatch_Lingcod$DiscWtExt.lb + DiscardExtCatch_Lingcod$UtilWtExt.lb, na.rm = TRUE) }))

		 Discad_Rate 

 Year 			 Gear 

            MG        RG CB        S2 MW
1985 0.0002019 0.0006112 NA        NA NA
1986 0.0004322 0.0000000  0 0.0003634 NA
1987 0.0011105 0.0054699  0 0.0000477  0


> # Discard rate for Lingcod by Year for Bottom Trawl Only
> DiscardExtCatch_Lingcod_BT_Only <- DiscardMeshExtCatch[DiscardMeshExtCatch$Study %in% 'Discard' & DiscardMeshExtCatch$CommonName %in% 'LINGCOD' & DiscardMeshExtCatch$Gear %in% c("MG", "RG",  "CB"), ]
> aggregate(list(Discad_Rate = 1:length(DiscardExtCatch_Lingcod_BT_Only$DiscWtExt.lb)), list(Year = DiscardExtCatch_Lingcod_BT_Only$Year),
+            function(index) { sum(DiscardExtCatch_Lingcod_BT_Only$DiscWtExt.lb[index], na.rm = TRUE)/sum(DiscardExtCatch_Lingcod_BT_Only$DiscWtExt.lb + DiscardExtCatch_Lingcod_BT_Only$UtilWtExt.lb, na.rm = TRUE) })
  Year  Discad_Rate
1 1985 0.0008339638
2 1986 0.0004433374
3 1987 0.0067498359