Gear groupings reflect those in the table at
https://pacfin.psmfc.org/pacfin_pub/data_rpts_pub/code_lists/gr.txt
GRID was assigned to geargroup with the following names:

   HKL    MSC    NET    POT    TLS    TWL    TWS 
 26236      5    769   1457    636 101559    106 

There are 0 records for which the state (i.e., 'CA', 'OR', 'WA')
could not be assigned and were labeled as 'UNK'.

   CA    OR    WA 
21941 40810 68299 

SEX recoded from input (rows) to output (columns):
      output
input      F     M     U  <NA>
  F    68609     0     0     0
  M        0 32076     0     0
  U        0     0 30186     0
  <NA>     0     0   179     0

The following length types were kept in the data:
output
    F     T     U 
84659   664 44915 
Lengths range from 198 to 1550 (mm).

Ages ranged from 1 to 35 (years).
The table below includes the number of samples (n) per ageing method.
Each age sequence number, the PacFIN delineation for age read, has its own column.
The number of columns depends on the maximum number of age reads available.
If ANY method for a given fish matches those in keep, then that age will be kept
even if PacFIN did not use the age to create the final fish age.
  AGE_METHOD1 AGE_METHOD2 AGE_METHOD3     n
1           3        <NA>        <NA>     1
2           9        <NA>        <NA>   148
3           B        <NA>        <NA>     8
4           L        <NA>        <NA>     1
5           T           B        <NA>   657
6           T           T        <NA>   642
7           T        <NA>        <NA> 40435
8        <NA>           T        <NA>    16
9        <NA>        <NA>        <NA> 89142

FISH_AGE_YEARS_FINAL matches value(s) for agers 1, 2, ...; NA means no exact match.
agematch
    1     2     3  <NA> 
41207   336     5    44 
Investigate the following SAMPLES for errors because
FISH_AGE_YEARS_FINAL doesn't match the mean of all reads:
       FISH_AGE_CODE_FINAL FISH_AGE_YEARS_FINAL age1 age2 age3
49240                   NA                    5    1   NA   NA
63453                   NA                    6    5    5   NA
63855                   NA                    5    6    6   NA
63983                   NA                    4    6    5   NA
66102                   NA                   11    9   10   NA
66548                   NA                    8    9   10   NA
66744                   NA                    3    5    4   NA
66960                   NA                   12   13   14   NA
67899                   NA                    6    8    7   NA
68320                   NA                    8    7    6   NA
69681                   NA                    8    7    6   NA
69833                   NA                    6    9   NA   NA
70731                   NA                    6    9   NA   NA
75499                   NA                    8    7    6   NA
75547                   NA                   13   10    9   NA
75551                   NA                   13   12   11   NA
75571                   NA                    8    7    6   NA
76400                   NA                   10    9    8   NA
77010                   NA                    7    5    6   NA
77098                   NA                    7    5    5   NA
113494                  NA                   11    1   NA   NA

The table below summarizes the number of records that are outside of
the area that should be included for US West Coast stock assessments
by PSMFC area, or some derivative thereof.
     description
PSMFC  CAN CAN (VNCVR) Sound and Straits
   3D    0        2531                 0
   4A    0           0              2696
   5A 4328           0                 0
   5B 9896           0                 0
   5C  118           0                 0


N SAMPLE_TYPEs changed from M to S for special samples from OR: 0
N not in keep_sample_type (SAMPLE_TYPE): 3901
N with SAMPLE_TYPE of NA: 25
N not in keep_sample_method (SAMPLE_METHOD): 311
N with SAMPLE_NO of NA: 0
N without length: 812
N without Age: 89423
N without length and Age: 89687
N sample weights not available for OR: 231
N records: 131050
N remaining if CLEAN: 108131
N removed if CLEAN: 22919
> sink("cleanPacFIN.txt", split=TRUE)
> test <- PacFIN.Utilities::cleanPacFIN(bds.pacfin,
+                                       CLEAN = TRUE,
+                                       verbose = TRUE)

Gear groupings reflect those in the table at
https://pacfin.psmfc.org/pacfin_pub/data_rpts_pub/code_lists/gr.txt
GRID was assigned to geargroup with the following names:

   HKL    MSC    NET    POT    TLS    TWL    TWS 
 26236      5    769   1457    636 101559    106 

There are 0 records for which the state (i.e., 'CA', 'OR', 'WA')
could not be assigned and were labeled as 'UNK'.

   CA    OR    WA 
21941 40810 68299 

SEX recoded from input (rows) to output (columns):
      output
input      F     M     U  <NA>
  F    68609     0     0     0
  M        0 32076     0     0
  U        0     0 30186     0
  <NA>     0     0   179     0

The following length types were kept in the data:
output
    F     T     U 
84659   664 44915 
Lengths range from 198 to 1550 (mm).

Ages ranged from 1 to 35 (years).
The table below includes the number of samples (n) per ageing method.
Each age sequence number, the PacFIN delineation for age read, has its own column.
The number of columns depends on the maximum number of age reads available.
If ANY method for a given fish matches those in keep, then that age will be kept
even if PacFIN did not use the age to create the final fish age.
  AGE_METHOD1 AGE_METHOD2 AGE_METHOD3     n
1           3        <NA>        <NA>     1
2           9        <NA>        <NA>   148
3           B        <NA>        <NA>     8
4           L        <NA>        <NA>     1
5           T           B        <NA>   657
6           T           T        <NA>   642
7           T        <NA>        <NA> 40435
8        <NA>           T        <NA>    16
9        <NA>        <NA>        <NA> 89142

FISH_AGE_YEARS_FINAL matches value(s) for agers 1, 2, ...; NA means no exact match.
agematch
    1     2     3  <NA> 
41207   336     5    44 
Investigate the following SAMPLES for errors because
FISH_AGE_YEARS_FINAL doesn't match the mean of all reads:
       FISH_AGE_CODE_FINAL FISH_AGE_YEARS_FINAL age1 age2 age3
49240                   NA                    5    1   NA   NA
63453                   NA                    6    5    5   NA
63855                   NA                    5    6    6   NA
63983                   NA                    4    6    5   NA
66102                   NA                   11    9   10   NA
66548                   NA                    8    9   10   NA
66744                   NA                    3    5    4   NA
66960                   NA                   12   13   14   NA
67899                   NA                    6    8    7   NA
68320                   NA                    8    7    6   NA
69681                   NA                    8    7    6   NA
69833                   NA                    6    9   NA   NA
70731                   NA                    6    9   NA   NA
75499                   NA                    8    7    6   NA
75547                   NA                   13   10    9   NA
75551                   NA                   13   12   11   NA
75571                   NA                    8    7    6   NA
76400                   NA                   10    9    8   NA
77010                   NA                    7    5    6   NA
77098                   NA                    7    5    5   NA
113494                  NA                   11    1   NA   NA

The table below summarizes the number of records that are outside of
the area that should be included for US West Coast stock assessments
by PSMFC area, or some derivative thereof.
     description
PSMFC  CAN CAN (VNCVR) Sound and Straits
   3D    0        2531                 0
   4A    0           0              2696
   5A 4328           0                 0
   5B 9896           0                 0
   5C  118           0                 0


N SAMPLE_TYPEs changed from M to S for special samples from OR: 0
N not in keep_sample_type (SAMPLE_TYPE): 3901
N with SAMPLE_TYPE of NA: 25
N not in keep_sample_method (SAMPLE_METHOD): 311
N with SAMPLE_NO of NA: 0
N without length: 812
N without Age: 89423
N without length and Age: 89687
N sample weights not available for OR: 231
N records: 131050
N remaining if CLEAN: 108131
N removed if CLEAN: 22919
