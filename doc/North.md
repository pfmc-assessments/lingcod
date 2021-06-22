---
geometry: margin=1in
month: "June"
year: "2021"
preamble: |
output:
  sa4ss::techreport_pdf:
    default
  bookdown::pdf_document2:
    keep_tex: true
lang: en
papersize: a4
params:
  area: north
  model: !r dir("../models/2021.s.005.001_initial_ctl_changes", full.names=TRUE, pattern = "00mod")
  run_data: FALSE
---



<!--chapter:end:00a.Rmd-->

---
author:
  - name: Ian G. Taylor
    code: 1
    first: I
    middle: G
    family: Taylor
  - name: Kelli F. Johnson
    code: 1
    first: K
    middle: F
    family: Johnson
  - name: Brian J. Langseth
    code: 1
    first: B
    middle: J
    family: Langseth
  - name: Andi Stephens
    code: 2
    first: A
    middle: ''
    family: Stephens
  - name: Laurel S. Lam
    code: 3
    first: L
    middle: S
    family: Lam
  - name: Melissa H. Monk
    code: 4
    first: M
    middle: H
    family: Monk
  - name: Alison D. Whitman
    code: 5
    first: A
    middle: D
    family: Whitman
  - name: Melissa A. Haltuch
    code: 1
    first: M
    middle: A
    family: Haltuch
author_list: Taylor, I.G., K.F. Johnson, B.J. Langseth, A. Stephens, L.S. Lam, M.H.
  Monk, A.D. Whitman, M.A. Haltuch
affiliation:
  - code: 1
    address: Northwest Fisheries Science Center, U.S. Department of Commerce, National
      Oceanic and Atmospheric Administration, National Marine Fisheries Service, 2725
      Montlake Boulevard East, Seattle, Washington 98112
  - code: 2
    address: Northwest Fisheries Science Center, U.S. Department of Commerce, National
      Oceanic and Atmospheric Administration, National Marine Fisheries Service, 2032
      Southeast OSU Drive, Newport, Oregon 97365
  - code: 3
    address: Pacific States Marine Fisheries Commission, Northwest Fisheries Science
      Center, U.S. Department of Commerce, National Oceanic and Atmospheric Administration,
      National Marine Fisheries Service, 2725 Montlake Boulevard East, Seattle, Washington
      98112
  - code: 4
    address: Southwest Fisheries Science Center, U.S. Department of Commerce, National
      Oceanic and Atmospheric Administration, National Marine Fisheries Service, 110
      McAllister Way, Santa Cruz, California 95060
  - code: 5
    address: Oregon Department of Fish and Wildlife, 2040 Southeast Marine Science
      Drive, Newport, Oregon 97365
address:
  - ^1^Northwest Fisheries Science Center, U.S. Department of Commerce, National Oceanic
    and Atmospheric Administration, National Marine Fisheries Service, 2725 Montlake
    Boulevard East, Seattle, Washington 98112
  - ^2^Northwest Fisheries Science Center, U.S. Department of Commerce, National Oceanic
    and Atmospheric Administration, National Marine Fisheries Service, 2032 Southeast
    OSU Drive, Newport, Oregon 97365
  - ^3^Pacific States Marine Fisheries Commission, Northwest Fisheries Science Center,
    U.S. Department of Commerce, National Oceanic and Atmospheric Administration,
    National Marine Fisheries Service, 2725 Montlake Boulevard East, Seattle, Washington
    98112
  - ^4^Southwest Fisheries Science Center, U.S. Department of Commerce, National Oceanic
    and Atmospheric Administration, National Marine Fisheries Service, 110 McAllister
    Way, Santa Cruz, California 95060
  - ^5^Oregon Department of Fish and Wildlife, 2040 Southeast Marine Science Drive,
    Newport, Oregon 97365
---

<!--chapter:end:00authorsnorth.Rmd-->

---
bibliography:
- Lingcod.bib
- sa4ss.bib
---

<!--chapter:end:00bibliography.Rmd-->

---
title: Status of lingcod (_Ophiodon elongatus_) along the northern U.S. west coast
  in 2021
---

<!--chapter:end:00titlenorth.Rmd-->

\pagebreak
\pagenumbering{roman}
\setcounter{page}{1}

\renewcommand{\thetable}{\roman{table}}
\renewcommand{\thefigure}{\roman{figure}}


\setlength\parskip{0.5em plus 0.1em minus 0.2em}

<!--chapter:end:01a.Rmd-->


# Executive Summary{-}
## Stock{-}
This assessment reports the status of lingcod (_Ophiodon elongatus_) off the northern U.S. west coast using data through 2020.

## Landings{-}
Replace text.

## Data and Assessment{-}
Replace text.

## Stock Biomass{-}
Replace text.

## Recruitment{-}
Replace text.

## Exploitation Status{-}
Replace text.

## Reference Points{-}
Replace text.

## Management Performance{-}
Replace text.

## Unresolved Problems and Major Uncertainties{-}
Replace text.

## Decision Table{-}
Replace text.

## Research and Data Needs{-}
Replace text.

<!--chapter:end:01executive.Rmd-->

\pagebreak
\setlength{\parskip}{5mm plus1mm minus1mm}
\pagenumbering{arabic}
\setcounter{page}{1}
\renewcommand{\thefigure}{\arabic{figure}}
\renewcommand{\thetable}{\arabic{table}}
\setcounter{table}{0}
\setcounter{figure}{0}

<!--chapter:end:10a.Rmd-->

# Introduction

## Basic Information

This assessment reports the status of lingcod (_Ophiodon elongatus_) off the northern U.S. west coast using data through 2020.


## Life history

### Geography

Lingcod are large opportunistic predators endemic to the North Pacific,
ranging from the Gulf of Alaska to central Baja California, Mexico
[@wilby1937ling; @hart1973pacific].
Typically, the center of abundance can be found off
the coasts of British Columbia and Washington State
[@hart1973pacific].
Lingcod are
demersal on the continental shelf,
display a patchy distribution, and
are most abundant in areas of hard bottom with rocky relief [@rickey1991geographical].
They typically occur at depths less than 200 m but
they are caught in the \Gls{s-wcgbt} up to depths of 450 m.

### Growth and maturity

Lingcod are sexually dimorphic,
with females typically growing faster and
attaining larger asymptotic sizes than males [@richards1990multivariate].
Females also reach maturity at larger sizes [@cass1990lingcod; @miller1973fish]
than males.
Both males and females exhibit a latitudinal trend in
growth, longevity, and size at maturity.
Consequently, individuals from northern waters generally
grow faster, live longer, and mature at larger sizes
than individuals from southern regions
[@richards1990multivariate; @silberberg2001analysis; @lam2019geographic].

Lingcod are iteroparous spawners.
Male lingcod aggregate in late fall and move to rocky habitat in
intertidal waters up to 126 m [@giorgi1981environmental; @o1993submersible]
where they guard areas suitable for spawning.
This movement has been correlated with a decline in the proportion of males
in offshore trawl landings in late fall
off California [@miller1973fish], British Columbia [@cass1990lingcod],
and Washington [@jagielo1994assessment].
Mature females are rarely seen on the spawning grounds and
appear to move from deep-water habitats into spawning areas only for
a brief period to deposit eggs [@giorgi1981environmental].
Larger and older females appear to spawn first [@cass1990lingcod],
depositing up to 500,000 eggs in high current areas [@hart1973pacific; @low1978study].
After fertilization, males guard clutches until the eggs hatch
in six to eight weeks [@king2005male; @withler2004polygamous],
between January and June [@jewell1968scuba; @low1978study].
Recent maturity studies suggest that lingcod are batch spawners with the
ability to spawn year round.
Peak spawning takes place during October through December
(pers. comm., M. Head, \gls{nwfsc}).

At hatching, lingcod larvae are about 12 mm in total length and
are epipelagic for approximately 90 days,
until reaching about 70 mm and settling to soft bottom habitats
[@phillips1977early; @cass1990lingcod; @hart1973pacific].
Epipelagic larvae feed on small copepods and copepod eggs,
shifting to larger copepods and fish larvae as they grow [@phillips1977early].
\Gls{yoy} typically recruit to sandy, low-relief habitat near eelgrass or kelp beds,
staying on soft bottom until they grow to at least 350 mm in length.
After reaching 350 mm, they move into rocky, high-relief substrate,
which is the preferred adult habitat [@petrie2006hunger; @bassett2018lingcod].

Newly settled juveniles are typically found
at depths ranging from 9-55 m
[@phillips1977early; @miller1973fish; @coley1986juvenile].
They often
start in nearshore areas of sandy substrate [@buckley1984enhancement],
move to a wider range of flat bottom areas by September [@cass1990lingcod], and
then move into habitats of similar relief and substrate inhabited by adults
while ages one to two but remain at shallower depths.
Off the coast of California, they tend to initiate this latter move
starting at around 35 cm in length [@miller1973fish].
Whereas, off the coast of Washington, juveniles have been found in
hard bottom shell-cobble habitat near rocks in 9-15 m of water
off the coast of Grays Harbor as soon as October [@coley1986juvenile].

Juvenile density tends to be higher in the south than in the north
[@tolimieri2020SpatioTemporal].
Particularly, in central California shelf waters (50-240 m)
between $34^\circ$ N and $39^\circ$ N
and, just north of Cape Mendocino and Cape Blanco
between $41^\circ$ N and $43^\circ$ N, albeit at smaller densities.
These results are based on the \Gls{s-wcgbt},
which has an inshore limit of 55 m, and thus,
the results do not account for potential differences
in juvenile habitat in the north versus the south.
Off of Washington,
juveniles have been collected from the mouth of the Pysht River
in the Strait of Juan de Fuca, Grays Harbor and Willapa Bay,
and from coastal waters nearshore to these embayments
[@buckley1984enhancement; @jagielo1994assessment].

Juvenile lingcod feed on small fishes [@cass1990lingcod] including
Pacific Herring (*Clupea pallasii*) and
Pacific Sand Lance (*Ammodytes hexapterus*),
flatfishes (*Pleuronectidae*) including
Shiner Perch (*Cymatogaster aggregate*) and
Walleye Pollock (*Theragra chalcograma*), and
an assortment of invertebrates including
shrimps (Neomysis) and prawns (Pandalus).
As juvenile lingcod begin to move into rocky habitats and exceed 30 cm,
other rocky reef bottomfishes become a more prominent component of their diet,
making up 48.8\% of total prey biomass by weight [@beaudreau2007spatial].

Phillips and Barraclough [-@phillips1977early] estimated that \gls{yoy} growth
was approximately 1.3 mm $day^{-1}$.
Buckley et al. [-@buckley1984enhancement] reported \gls{yoy} growth from
June to September in the Strait of Juan de Fuca also averaged 1.3 mm $day^{-1}$.
Samples from the mouth of the Pysht River averaged
96 mm in June,
135 mm in July,
173 mm in August, and
200 mm in September [@jagielo1994assessment].

### Habitat use

<!---  to do - make these numbers dynamic if we are going to keep them -->
Outside of the spawning season,
male and female lingcod are segregated by depth.
Where, females tend to inhabit deeper offshore waters and
males inhabit nearshore rocky reefs.
Consequently, the sexes are vulnerable to different types of fishing gear.
The majority of nearshore males (66.3\%) are caught using
hook-and-line or spearfishing gear, and
the majority of deep water females (62.4\%) are caught using
trawl gear [@miller1973fish].
Fishery and survey data indicate that male lingcod tend to be more abundant
than females in shallow waters and
the size of both sexes increase with depth [@jagielo1994assessment].

The movement and migration of lingcod has been extensively studied
through tag-recapture methods and acoustic arrays.
As adults, lingcod have a high
[e.g., 95\%, Cass et al. -@cass1990lingcod; and 81\%, Jagielo -@jagielo1990movement]
degree of site fidelity and
tend to stay within an 8 km home range.
Movement is apparent between
coastal areas off Washington and southwest Vancouver Island but
there is little interchange between these areas and
the inland marine waters of Puget Sound and the Strait of Georgia
[@cass1990lingcod; @jagielo1990movement].
However, some exceptional movements have been reported.
For example fish tagged off of Cape Flattery, Washington were recaptured
as far north as Queen Charlotte sound (195 km) and
as far south as Cape Falcon (120 km) [@jagielo1990movement].
One fish tagged as a juvenile was recovered
510 km to the south in Oregon.

High site fidelity was also found using acoustic tags
in Alaskan waters [@starr2005use] and
off of Central California [@greenley2009movements].
While lingcod exhibit high site fidelity
with an established location of residence,
they frequently leave for 1-5 days traveling around 2 km to feed,
only to return home for a longer duration.
Large females generally had shorter residency times,
spending more time outside of their tagged site.
Additional acoustic studies in Prince William Sound
reported that 50 cm individuals thought to be 2-4 years old
disperse from nearshore reefs during spawning season,
most likely due to displacement by older and larger spawning individuals
[@bishop2010situ; @stahl2014examinationof].
Overall, residency times varied by sex, size, season, and habitat of residence.

### Diet and trophic ecology

Lingcod are top-order predators of the family Hexagrammidae.
Among the Hexagrammidae,
the genus, *Ophiodon*
is ecologically intermediate
between the more littoral genera *Hexagrammos* and *Oxylebius*
and the more pelagic *Pleurogrammus* [@rutenberg1962system].

Being opportunistic predators, lingcod feed on a variety of
fishes (pelagic and demersal), cephalopods, and crustaceans [@wilby1937ling].
Their feeding strategies are known to vary with
depth of occurrence, latitude, sex, and size
(pers. comm., B. Brown, \gls{mlml}).
Geographic variation in trophic level is associated with oceanographic factors
such as sea-surface temperature or chlorophyll-a density that
likely corresponds to shifts in prey availability,
suggesting a similar shift in the predatory role of lingcod in coastal environments.

Male lingcod caught in shallow depths have more diverse diets and consume
more lower-trophic prey items (e.g,. cephalopods)
than females caught in deep depths that have less diverse diets and consume
more higher-trophic prey items (e.g., groundfishes).
Preliminary observations from lingcod stomach contents sampled from
Washington to California in both nearshore and offshore habitats indicate a
higher occurrence of bony fishes in the diet of northern fish than those
collected off of California
(pers. comm., B. Brown, \gls{mlml}).
Fish collected off of California and southern Oregon had a higher occurrence of
cephalopods in their diet than fish collected from more northern waters.
This latitudinal shift in prey composition suggests differences
in feeding behavior and the predatory role of lingcod in coastal environments.
Being opportunistic feeders, it is not a surprise that
rockfish biomass in the lingcod diet increases by three-fold for
lingcod found inside marine reserves compared to those found
outside of reserves [@beaudreau2007spatial].

### Stock delineation

Longo et al. [-@longo2020strong] used
restriction-site associated deoxyribonucleic acid sequencing
techniques and discovered evidence for distinct
north and south genetic clusters
with the presence of admixed individuals in the region of overlap.
Pure northern-cluster individuals represented
over 80\% of the samples at $42.2^\circ$ N and
all sampled sites that were further to the north.
Pure southern-cluster individuals represented
over 80\% of the samples at all sampled sites south of $35.2^\circ$ N.
Only two sites were sampled within the range where most admixed individuals
were found, $38.6^\circ$ N and $39.5^\circ$ N.
Thus, it was difficult to define a clean break between the clusters.
The general results of the occurrence of two distinct genetic clusters
were contrary to previous genetic work using
mitochondrial deoxyribonucleic acid that found no
genetic differentiation in the lingcod population [@marko2007mtdna].

The recent genetic results concurred with results from
recent work demonstrating that lingcod growth, longevity, and timing at maturity
exhibit a latitudinal gradient.
Lingcod from higher latitudes are
larger at age (Figure \@ref(fig:Lam-vbgfcurves)),
live longer, and
reach biological maturity at larger sizes
compared to conspecifics from lower latitudes
[@lam2021geographic; pers. comm., M. Head, \gls{nwfsc}].
<!--- to do - get M. Head figure -->
<!--- to do - change pers. comm. to reference -->

<!--- to do - fix all calls to $\circ$ b/c they are not _accessible -->
This known variability in life-history parameters and genetic structure
led to the reexamination of the previous stock boundary used for lingcod,
located at the California - Oregon border
[@hamel2009lingcod; @haltuch2019lingcod].
A break point at Cape Mendocino, California ($40^\circ 10^\prime$ N) was
chosen for this assessment because it
(1) falls within the mixing zone of the two genetic clusters,
(2) falls in the vicinity of where the greatest difference in
lingcod size-at-age was detected (Figure \@ref(fig:Lam-vbgfcurves)), and
(3) aligns with the federal management boundary for commercial quotas and
a boundary between two \Gls{cdfw} management regions,
which facilitates the
application of assessment results for future management and
separation of historical catch.

## Historical and Current Fishery Information



Lingcod fisheries have a long history.
The earliest evidence of fishing for Lingcod
comes from the remains of 51 archaeological sites
representing the period between 6200 BC and 1830 AD on the
central California coast from San Mateo to San Luis Obispo [@gobalet1995prehistoric].
The commercial fishery off
California dates back more than a century (i.e., 1920s) and
the fishery off of Washington and Oregon dates back nearly as far (i.e., 1940s).
These commercial fishers are largely harvested using trawl and longline gear.
Recreational fisheries are dominated by hook-and-line and spear methods
**todo - fix links to figures**
(see Figures executive summary a and b).

The commercial fishery steadily grew with the rise of the groundfish trawl industry.
Commercial landings peaked in the early 1980s and were followed by decreasing landings
because of management measures implemented due to population declines.
Management largely relied on seasonal closures and size limits to limit landings.
Coastwide, the lingcod fishery was declared overfished in 1999.
With the combination of
a federal rebuilding plan implemented during 2003 and
years of good recruitment,
the population was deemed recovered in 2005,
four years ahead of the projected recovery time.

In California, the recreational lingcod fishery has had substantial landings
that have surpassed that of the commercial fleet operating in California waters
since 1998.
At the peak of the lingcod fishery, in 1980,
the landings were nearly equally divided between the commercial and recreational fleets.
From 1980 to 2008, 95\% to 97\% of lingcod caught were taken by boat-based anglers via
\glspl{cpfv} and private/rental boats.
Private boat landings (including kayaks) were higher than those from \glspl{cpfv}.
A small fraction of landings are from spear fishers using SCUBA or free diving gear [@lynn2008status].

Catches of lingcod in Oregon and Washington have shifted from the commercial trawl fleet,
which accounted for 90\% of landings during its mid-1980s peak,
to a fishery evenly split between commercial and recreational landings in recent years.
Between 1980 and 1996, the majority of lingcod were caught by the bottom trawl fishery (>75\%),
followed by troll and hook-and-line (between 10-20\%),
with a small fraction of additional landings from
pots and traps, nets, and shrimp trawls [@jagielo1997assessment].
From 1999 to 2016, however, the recreational fishery has contributed about half
of all lingcod Oregon and Washington landings, on average, and has continued to grow.

**todo - generate numbers dynamically**

## Summary of Management History and Performance

### Commercial Fishery

Prior to 1977, lingcod stocks in the northeast Pacific were managed by the
Canadian Government within its waters and
by the individual states in waters out to three miles off their coastline.
With the implementation of the \gls{msfcma} in 1976,
primary responsibility for the management of groundfish stocks off
Washington, Oregon, and California shifted from the states to the \gls{pfmc}.
The U.S. west coast \gls{abc} for lingcod  was set at 7,000 mt,
but catch was consistently below this level.
In 1994, a \gls{hg} of 4,000 mt was set.
In 1995, both the \gls{abc} and \gls{hg} were dropped to 2,400 mt
based on a quantitative assessment [@jagielo2000assessment].

In 1995 a minimum size limit for the limited entry fishery was imposed
for the first time that restricted landed lingcod to be at least 22 inches.
This size restriction matched the restriction within the recreational fishery
and trawl-caught lingcod, with a 100 lb exception for the latter.
The minimum size was increased to 24 inches in 1998.
Minimum size across areas diverged in 2000 when the minimum size of
lingcod landed south of 40$\circ 10\prime$ N. latitude in the
limited entry fixed gear fishery increased to 26 inches.
Currently, the minimum size limits for the limited entry fixed gear
and open access commercial fisheries
are 22 and 24 inches north and south of 42$\circ$ N. latitude, respectively,
which corresponds to 18 and 19.5 inches with the head removed.
Trip limits on commercial lingcod catch were first instituted in 1995,
when a 20,000 lbs/month limit was imposed.
In 1998, a two-month cumulative limit of 1,000 lbs was imposed.
Since then, management of the fishery has occurred through
individual-year \gls{abc} and \gls{oy} levels (Table \@ref(tab:management-refpoints)).

The \gls{pfmc} implemented an initial Rebuilding Plan in 2000
with size and seasonal limitations in the recreational fishery and
a change to limited entry and open access sectors in the commercial fishery.
Additionally, the coastwide \gls{abc} was reduced
from 960 mt to 700 mt.
In the commercial fishery sector, \glspl{hg} in 2000 were reduced by over 80\%
from 1998 limits.
To achieve these low harvest goals,
all commercial fishing for lingcod  was closed for six months
(January to April and November to December).
During the open period between April and November,
all commercial vessels were limited to 400 lbs per month and
non-trawl vessels had a minimum size limit of
26 inches south of Cape Mendocino ($40^\circ 10^\prime$ N) and
24 inches to the north of Cape Mendocino.

Between 2000 and 2005, while the fishery was rebuilding,
cumulative trip limits were very low, at 800 lbs bimonthly,
with frequent closures.
After 2006, \glspl{abc} and trip limits were increased,
with a bimonthly limit of 1,200 lbs.
Concurrently, \glspl{mpa} in California,
\glspl{rca}, and the \gls{cca} were established.
In these areas, take of all groundfish is prohibited within specified
depths, habitats, and locations.

**todo - add more information to this paragraph**
Monitoring of this fishery started much earlier compared to some other
groundfish species, where lingcod have almost always been their own
market category for recording and sampling purposes.
Between 2002 and 2011, observed trips were chosen by random stratified sampling.
Since 2011, when the limited entry trawl sector became a catch share program,
the fishery has had 100\% observer coverage.

### Recreational Fishery

Recreational regulations for lingcod were established in 1994 and included
a bag limit of three fish in Washington and Oregon,
a bag limit of five fish in California, and
a minimum size limit of 22 inches in Washington and California.
The 22 inch minimum size limit was adopted in Oregon in 1995 and
increased to 24 inches in all three states in 1998.
In 1998, the bag limit in Washington and California dropped to two fish per day.
Oregon followed suite in 1999, and
the two-fish bag limit largely remained coastwide until 2008.
The minimum size limit for California increased in 2000 to 26 inches.

Between 2000 and 2004,
the California recreational bag limit dropped to 1 fish per day and
the size limit increased from 26 to 30 inches.
Oregon's bag limit fluctuated between one and two fish per day.
Regulations have become less restrictive since the rebuilding period.
In 2015, the bag limit increased to 3 fish per day in California,
while the two-fish bag limit was retained in Oregon and Washington.
A size limit of 22 inches was adopted in all three states.
More recently, the bag limit in California has decreased to 2 fish per day.
In Oregon, there have been multiple recreational groundfish in-season closures
to reduce impacts to overfished rockfish.

## Foreign Fisheries

Alaskan fisheries for lingcod may not be foreign, but given that they
are managed external to the \gls{pfmc}, we summarize them here
along with information regarding Canadian and Mexican fisheries for
lingcod.

Lingcod fisheries in the Gulf of Alaska are managed
in state waters by the State of Alaska Board of Fisheries and
in federal waters by the \gls{npfmc}, though no formal stock
assessment exists for lingcod in Alaskan waters.
Commercial fisheries are restricted by catch and bycatch quotas.
The sport fishery is restricted by daily bag and possession limits.
Lingcod are a non-target species in the subsistence fishery.

Lingcod in western Canada are managed under the \gls{bcigfp}
by \gls{dfo} for take by
First Nations, the commercial sector, and the recreational sector.
Beginning in 1997,
the \gls{bcigfp} implemented an individual vessel quota program
that now incorporates all commercially-caught trawl and hook-and-line groundfish.
Stocks in distinct management areas are regularly assessed,
with the most recent assessment of lingcod
in outer British Columbia waters occurring in 2011 [@lingcodbcstockassessment2011] and
in the Strait of Georgia in 2014 [@lingcodbcstockassessment2016].

The 2011 outer British Columbia assessment [@lingcodbcstockassessment2011]
implemented a
Bayesian surplus production model to assess
the status of lingcod in four assessment areas.
Overall the stock appears to have
remained stable between 1927-1970,
declined until 1980,
increased until 1990, and
has continued to decline since then.
However, at no time has the stock been estimated
to have been below target reference points.

The 2016 assessment [@lingcodbcstockassessment2016]
implemented a two-sex Bayesian statistical catch-at-age model.
The stock was estimated to have declined between 1927 and the late 1980s.
This was followed by a slow increase between 1990 and 2014.
Spawning biomass in 2014 was estimated to be greater than
the spawning biomass at the start of the current management regime during 2006 but
likely still in a precautionary management zone.

Lingcod are known to inhabit waters off the coast of Baja California,
including Ensenada and Bahia de Todo Santos, as far south as
Punta San Carlos, Baja California
([https://mexican-fish.com/lingcod/](https://mexican-fish.com/lingcod/)).
There are some
[specimens held at Scripps Institute of Oceanography](http://collections.ucsd.edu/mv/fish/act_searchCollection.php?name=Hexagrammidae+Ophiodon+elongatus&sort=&start=40)
that document its distribution along Baja California [@rosales-casian2003] to Bahia San Quintin [@aristapalacios2018] and
the Cedros archipelago [@ramirez-valdex2015].
But, the [National Fisheries Registry](https://www.gob.mx/cms/uploads/attachment/file/334832/DOF_-_CNP_2017.pdf)
that lists fisheries within Mexican waters does not list lingcod.
Multiple researchers reported that lingcod is fished off Baja California using harpoons (pers. comm., H.N. Morzaria Luna, \gls{nwfsc})
but not being recorded at the species level and instead perhaps under a general finfish permit.
Though, it is listed as bycatch of the rockfish (rocotes; scorpinidae) fishery
in the [National Fisheries Charter](https://www.gob.mx/cms/uploads/attachment/file/153374/Carta-Nacional-Pesquera-2012.pdf),
which contains the management framework for species that are commercially fished.
There are no known stock assessments for lingcod off the coast of Mexico.

Southern California recreational fishers have reported fishing in
Mexican waters and landing fish in U.S. ports.
The [Declaration For Entry Into California of Game, Fish, Birds Or Animals](https://wildlife.ca.gov/Enforcement/Entry-Declaration)
represents a potential future source of information for documenting
catches that occur off the coast of Mexico but are landed in California.
Anglers are required to fill out the report prior to entering U.S. waters
but it is not clear if this information is currently included in RecFIN.


<!--chapter:end:11introduction.Rmd-->

# Data

Descriptions of each data source included in the model (Figure \ref{fig:data-plot})
and sources that were explored but not included
are provided below.

## Fishery-Dependent data


<!--- ===================================================================== -->
<!---                               WRITE UP                                -->
<!--- ===================================================================== -->

### Commercial landings

#### Commercial fleet structure

The fleet structure for commercial landings included two fleets,
trawl (TW) and fixed gear (FG).
The former included landings from
bottom trawls, shrimp trawls, net gear, and dredging activities.
Landings from all other gear types, mainly hook and line,
were assigned to FG.
This fleet structure matches the fleet structure used in the
previous assessment.

#### Reconstruction of commercial landings


##### Washington commercial reconstruction

The reconstruction of commercial landings for coastal waters off of Washington
was provided by \gls{wdfw}.
This reconstruction included landings starting in
1889.
Data from the reconstruction was used instead of data in \gls{pacfin} when there was
overlap because
\gls{wdfw} separates landings from each fish ticket by area.
This is important for fish tickets that include landings from
Alaskan, Canadian, Puget Sound, and oceanic waters.
In \gls{pacfin}, it is more than likely that landings from different
areas included on a single fish ticket would be assigned to
just one area and partitioning out these landings to area would require
accessing logbook information as well as fish ticket information, which is
difficult and not part of the current \gls{pacfin} protocols.
The reconstruction should largely match what is in \gls{pacfin} because \gls{pacfin}
does not currently have landings for years prior to 1980 and
Canadian waters have been closed to U.S. fishers
targeting groundfish since 1978.

The reconstruction includes data from many sources, but consistently
recorded data were largely available starting in 1943 from
U.S. Fish Commission reports.
Landings from prior to 1941 were converted to round fish weight using a
conversion factor of 1.431 because it is assumed that reports were of filleted fish.
Linear interpretation between adjacent years was used to fill in years without
landings information. In the 2017 assessment, [@haltuch2019lingcod]
missing years were filled forward rather than linearly interpolated
(Figure \@ref(fig:catch-comm-state)).
These differences were minor, and there were no major changes in the time series
compared to what was used in the previous assessment.


##### Oregon commercial reconstruction

In Oregon, historical commercial landings from
1892 to
1986
were provided by \gls{odfw} [@karnowski2014].
Historical landings began with exclusively longline landings,
which was the primary gear type
until the development of the trawl fishery in the 1940s.
Historical landings exhibited an increasing trend until peaking at
1738 mt in 1983
and averaged 318.2 mt annually.

##### California commercial reconstruction

###### @sette1928

@sette1928 provided information from interviews and state records
on fishing patterns from 1888 to 1926
for eight regions within U.S. waters.
States along the Pacific Coast comprised one region,
though state-specific landings were provided for Washington, Oregon,
and California by species or species groups.
For lingcod, the first positive record was from
1892
and positive landings were documented for
14
years.
We used linear interpolation to fill in years with missing data,
ramping up from zero in
1888
to create a time series of
39
years (Figure \@ref(fig:catch-comm-CA-interpolate-ts)).

Catches by gear type were only available from 1926, and thus,
the calculated proportion of of the landings
caught by FG and TW in 1926 was applied to all years because it was
assumed that ratios were similar across the time series.
Proportionally, FG represented
0.28 and 0.32
of the total catch for the
north and south
areas, respectively.
The Northern California district was
assumed to represent north of 40 degrees ten minutes and
all other districts combined were used to represent the southern area.

Landings from
[California fish market data](https://oceanview.pfeg.noaa.gov/las_fish1/doc/names_describe.html),
available within the
[ERDDAP](https://coastwatch.pfeg.noaa.gov/erddap/tabledap/erdCAMarCatLM.html)
database,
were used to estimate the proportion of early landings that occurred in
the northern area versus the southern area because fish market data were recorded
by region on a yearly basis [@mason2004] within this data set.
Whereas, @sette1928 only contained information on area for a single year.
California fish market data represent a multi-organizational effort,
but most landings are from
fish ticket information collected by \gls{cdfw}.
First, we calculated the yearly proportion of landings that occurred within
the Eureka region north of Point Arena compared to all other regions
(0.24)
from port-specific landings from
1928
to
1933.
Second, the proportion of landings within Eureka region
that occurred north versus south of Cape Mendocino
(0.88)
was calculated from 100-200 block data [@Miller_2014]
starting in 1925 to 1931.
The product of the means of these two proportions
was used to partition data from @sette1928 to area.

###### California fish market landings

[California fish market data](https://oceanview.pfeg.noaa.gov/las_fish1/doc/names_describe.html),
were available from the
[ERDDAP](https://coastwatch.pfeg.noaa.gov/erddap/tabledap/erdCAMarCatLM.html)
database
over many years, but only those years that were missing
between @sette1928 and the California Catch Reconstruction Project
[@NOAA-TM-NMFS-SWFSC-461] were used.
This resulted in keeping data from
1928 to 1930.
<!--- to do: more text on erddap -->

Information on region of landing was available and
provided a means to assign the landings to the northern
and southern areas. Though as previously mentioned,
the Eureka region needed to be partitioned to area.
We used the mean proportion of fish landed in the northern Eureka
region (0.88) from block data [@Miller_2014]
to partition the sum of yearly landings within
the Eureka region between areas.

###### @NOAA-TM-NMFS-SWFSC-461

@NOAA-TM-NMFS-SWFSC-461 represents the effort led by the \gls{swfsc}
to reconstruct groundfish landings for the \gls{pfmc}, which
are seen as the best available data for historical commercial
landings from California ports.
The data includes information on region of landing based on block assignments.
Landings within region nine were assumed to be caught off of Mexico
and were removed.
Landings with a region code of two were partitioned to the northern and southern areas
using the same method used above for California fish market landings.
To check the validity of this assumption, we compared the proportion of
landings assigned to the north versus the south to
proportions calculated from confidential
fish ticket data available in \gls{calcom} that have information on port of landing
for available years between
1951 - 1968
(pers. comm., M. Monk, \gls{swfsc}).
The proportions showed similar trends, though the former were consistently
higher than the latter for all years
(Figure \@ref(fig:catch-comm-CA-proportionnorth)).

The @NOAA-TM-NMFS-SWFSC-461 data also had to be partitioned to
fleet given it does not contain information about gear.
Fish ticket information in \gls{calcom} was used to calculate the
proportion of landings landed by each fleet for the northern
and southern areas separately; thus, partitioning landings by year
into four groups, northern TW, northern FG, southern TW,
and southern FG. Proportions were only available for
the following years:
1951, 1955, 1957, 1960, 1963, 1964, 1965, 1966, 1967, 1968, 1951, 1955, 1957, 1960, 1963, 1964, 1965, 1966, 1967, and 1968,.
Years with no information were back filled using adjacent years.

###### CALCOM landings

Starting in
1969,
commercial landings were available for California by port-group complex
and gear group from \gls{calcom}.
The following gear groups
HKL, FPT, OTH, and UNK
were combined to encompass FG and
TWL and NET
gear groups were combined to encompass TW.

Unfortunately, the port-group complexes did not exactly align with the
north-south split. But, it was assumed that the amount of landings
within the Eureka port-group complex that occurred in the south was
minor, and thus, all landings within the Crescent City
and Eureka port-group complexes were assigned to the northern area
and all other ports were assigned to the southern area.

###### Washington and Oregon catches landed in California

Landings caught off of the coast of Oregon
(414.80 mt)
and Washington
(15.50 mt)
but landed in California during the period
1948 to 1968
were added to the California reconstruction as was done in the previous assessment.
These landings were assigned to the northern area TW fleet.
In the future, the assignment of species and gear should be investigated
more thoroughly for these landings.

###### Missing data

For combinations of year, area, and fleet that were missing
in the reconstruction of California commercial landings,
landings were interpolated based on a linear approximation
between adjacent years with data
(Figure \@ref(fig:catch-comm-CA-interpolate-ts)).
Thus, the reconstruction ramped up from zero starting in
1888
to
16.14
mt in
1892
and all subsequent missing years of data were filled in based on
linear interpolation between missing years
for a given area and fleet combination.

#### \glsentrylong{pacfin} (\glsentryshort{pacfin})

Commercial data were downloaded from the PacFIN database and provided
data on landings for Washington, Oregon, and California since
1981 (Figure \@ref(fig:catch-comm-ts-pacfin)).
These landings were treated as the best available information for
California and for Washington and Oregon since the beginning of
1995 and 1987,
respectively.


Though lingcod are encountered on a wide variety of gear types in Oregon,
most landings are from bottom trawl gear types
(70.1 percent from 1987 - 2020).
Landings from all other gear types are minimal relative to these two gear types and relatively sporadic.
Commercial landings from
1986 - 2020
peaked in
1991
at
1425.72
before declining and fluctuating between
38.03 and 440.14
mt since 2000.

##### Assigning commercial landings to area

Before splitting the commercial landings to area, all landings that
were known to have been caught outside of the U.S. Exclusive Economic Zone
(0.08 mt)
were removed.
These were landings that occurred in
an unknown \gls{inpfc} area noted as XX or \gls{pacfin} area 02 or 4A.

The split at 40 degrees 10 minutes N latitude required finding a method for
splitting data within the Eureka (ERA) port-group complex.
Data with a port of landing of Shelter Cove, a port within ERA were
assigned to the southern model and data from all other ports within ERA, i.e.,
Eureka (1763.49 mt), Fields Landing (645.31 mt), Trinidad (34.95 mt), Humboldt (1.67 mt), Arcata (1.17 mt), Crannell, King Salmon, Loleta, Moonstone Beach, Eureka Area, and Ruth,
were assigned to the northern model.
If landings were not assigned to a port-group complex, then the physical location
of the port of landing was used to assign an area. Lastly, if both
port-group complex and port of landing were unknown, then area was assigned
based on the mean behavior of a given vessel.
For all vessels that had landings
(0.48 mt)
without information on port-group complex or port of landing,
their average port of landing for
lingcod.
catches was used to assign port-group complex and thus area
to these landings with no spatial information.
Specifically, if more than half of a vessel's landings of
lingcod
were in ERA or CCA, then all of their landings without an assigned
area were assigned to the northern area.

For commercial landings from the state of California,
the majority of the commercial FG landings occurred in the southern area and this
has been relatively consistent for all years of data available in \gls{pacfin}
(upper panel of Figure \@ref(fig:catch-comm-CA-gearprop)).
Whereas, the percentage of commercial landings from TW in the South relative to
in the North has, on average,
decreased with time (lower panel of Figure \@ref(fig:catch-comm-CA-gearprop)).

#### Comparisons with previous model

The current time series of commercial catches were aggregated using the previous
model structure, i.e., the northern area included Washington and Oregon and the
southern area included California, for comparison purposes
(Figure \@ref(fig:catch-comm-state)).
This comparison revealed differences in California data for both fleets.
Subsequently, it was determined that in 2017 the trawl fleet included
catches from both fleets. This has since been corrected, and the current catch
stream represents what is known to be the best available data.
Differences in the early reconstructions for the northern model are the result
of linearly interpolating historical data rather than assuming it was equal to
the previous year.
Differences in the early reconstruction for the southern model are the result
of using landings from @sette1928 instead of ramping up catches from zero.

### Recreational landings


##### Washington recreational landings

The time series of recreational catches (numbers of fish)
were provided by \gls{wdfw} and
included information on fishing within Washington's coastal areas sampled by the
Ocean Sampling Program in Marine Areas 1-4.
Catches that were landed within the Strait of Juan de Fuca, i.e.,
Bonilla-Tatoosh line to the mouth of the Sekiu River,
and sampled by the Puget Sound Sampling Program were included in the landings
because they were potentially caught in ocean waters even though they were
landed in coastal waters. Other non-ocean landings were excluded.

First, we calculated the mean length
(696.25 mm).
of fish landed within Washington recreational fishery
(Figure \@ref(fig:catch-rec-tsrecfinmeanlength)) across all years
(2001 to 2020)
and sexes.
Next, we used this mean length in the weight-length relationship
as calculated from the most recent survey data to determine the mean weight.
Finally, weight (mt) was determined from mean weight and numbers.

The scale of the catches is smaller than what was used in the previous
assessment because this assessment only includes information on retained fish
rather than retained and discarded (Figure \@ref(fig:catch-rec-ca-oldts)).


##### Oregon recreational landings

The recreational fishery in Oregon likely began in the early 1950s or 1960s
but data on catches prior to
1974
are not available.
ODFW provided the time series of catches that includes information on
shoreside activities, estuary boats, private ocean boats, and charter ocean boats.

###### Historical ocean boat landings (1974 – 2000)

Recently, \gls{odfw} undertook an effort to comprehensively reconstruct
all marine fish recreational ocean boat landings prior to 2001
(pers. comm., A. Whitman, \gls{odfw}).
Reconstructed catch estimates from \gls{orbs} improve upon estimates
from the federal \gls{mrfss},
which have known biases related to effort estimation and sampling
[@vanvoorhees2000]
that resulted in catch estimates considered implausible by \gls{odfw}.
However, the \gls{orbs} sample estimates are known to lack the
comprehensive spatial and temporal coverage of \gls{mrfss}.
Addressing this coverage issue is a major part of this reconstruction.
In general, the base data and methodology for these reconstructed
estimates are consistent with recent assessments for other nearshore species
[@dick2016china; @dick2018bluedeacon; @haltuch2019lingcod; @cope2019cabezon].

Prior to 2001, \gls{orbs} monitored marine species in
both multi-species categories, such as rockfish, flatfish, and
other miscellaneous fishes, and
as individual species, such as lingcod or halibut.
For this comprehensive reconstruction,
four species categories were selected to reconstruct,
including rockfish, lingcod, flatfish, and miscellaneous,
which constitute the bulk of the managed marine fish species.
Lingcod have been a single species category throughout this time period.

Category-level estimates were expanded to account for gaps in sampling coverage
in two separate pathways.
First, estimates from five major ports were expanded to include unsampled
winter months in years lacking complete coverage.
Expansions were based on available year-round sampling data and
excluded years where regulations may have impacted the temporal distribution of catch.
Second, all other minor port estimates were expanded to include
seasonal estimates in years lacking any sampling based on
the amount of minor port catch as compared to all major port estimates.
A subset of landings were sampled by \gls{orbs}
for species compositions within these categories.
Once category-level landings were comprehensive in space and time,
species compositions were applied for the three multi-species categories,
including rockfish, flatfish, and miscellaneous fish.
Borrowing rules for species compositions were specific to the category and
determined based on a series of regression tree analyses
that detailed the importance of each domain
(year, month, port, and fishing mode) to variability in compositions.

Ocean boat estimates from 1979 – 2000 in numbers of fish of
lingcod from the above described methods were
converted to biomass using biological samples from \gls{mrfss}
(pers. comm., A. Whitman, \gls{odfw}).
\Gls{mrfss} biological data are available from
1980 – 1989 and 1993 – 2000.
An annual average weight was applied to the total annual number of fish
to obtain an annual landings estimate.
Several years missing biological data (1979, 1990 – 1992)
were filled in using neighboring years or interpolation.
Landings from 1974 – 1978 were estimated using similar
methods to the above reconstruction,
but are not currently part of this reconstructed time period,
and were not updated from the 2017 assessment [@haltuch2019lingcod].
Updated landings only include those from 1979 – 2000.
These landings in biomass were provided by \gls{odfw}
and do not include an estimate of discards.
Landings during this time period fluctuate,
with a peak of 237.2 mt in 1993,
and fluctuate between approximately 50 and 200 mt
following that peak (1979 – 2000).

###### Modern ocean boat landings (2001 – 2020)

Recreational landings for ocean boat modes from 2001 – 2020
are available from \gls{recfin} (extracted on 03/19/2021).
Both retained and released estimates of mortality are included,
though retained mortality contributes the vast majority to total mortality.
Release mortality is estimated from angler-reported release rates and
the application of discard mortality rates from the PFMC.
From 2001 – 2020, landings averaged 139.4 mt,
ranging from 60.1 mt in 2001 to 229.1 mt in 2015.
In 2020, Oregon ocean boat landings were 172.5 mt.

###### Shore and estuary landings (1980 – 2020)

\Gls{odfw} provided reconstructed estimates of shore and estuary
landings for copper rockfish from 1980 – 2020,
using methodology similar to recent assessments
[@berger2015kelpgreenling; @dick2018bluedeacon; @cope2019cabezon].
Data sources include \gls{mrfss} and \gls{sebs}.
Numbers of fish were provided by \gls{mrfss}
from 1980 – 1989 and 1993 – June 2003, and
by \gls{sebs} from July 2003 – June 2005.
An annual mode-specific average weight was applied to numbers of
lingcod from 1980 – 1989 and 1993 – 2005.
Separate weights were calculated for shore and estuary boat modes and
excluded extreme outliers and imputed values.
This reconstruction also applied two scaling factors to
remove bias towards freshwater sampling and
underestimation of estuary boats [@dick2018bluedeacon].
To estimate lingcod landings from July – December 2005,
an expansion was developed using the three year average of the ratio between
the first six months of the year and the total annual landings from
\gls{mrfss} and \gls{sebs} landings from 2002 - 2004.
Separate expansions were developed for shore mode and estuary boat modes.

The \gls{odfw} does not currently sample shore and estuary boat fishing trips,
so a 10 year average landing (1996 – 2005; 6.7 mt/year)
was used to estimate shore and estuary boat landings during 2006 – 2020.
Shore and estuary boat landings combined fluctuate but gradually increase
until peaking in 1993 at 16.7 mt.
Shore and estuary boat landings average 6.5 mt annually from 1980 – 2003.
Shore and estuary landings were combined with the ocean boat landings
for the total Oregon recreational landings (1974 – 2020).

##### California recreational landings

###### \glsentrylong{mrfss} (\glsentryshort{mrfss})

California recreational lingcod catches since
1980
are available within the \gls{mrfss} database
(Figure \@ref(fig:catch-rec-CA-ts)) and stored in
the \gls{recfin} database.
The first year of data are typically not used because of the lack
of standardization within the sampling protocols which led to vastly
different estimates of catches compared to later years. Thus,
1981
is used as the first year of \gls{mrfss} data.
Data were provided by John Field for years prior to
1981
and these data have been unchanged since the
2009 assessment of lingcod [@hamel2009].

For this assessment, we had to split the historical data provided by
John Field and \gls{mrfss} to area. This was accomplished using data from
Albin et al. (1993) that includes county-specific estimates of landings.
Area-specific landings were informative about the proportion
of landings in Del Norte and Humboldt county
relative to the rest of the California coast.
A catch-weighted mean proportion for the years
1981, 1982, 1983, 1984, 1985, and 1986
was used to split coast-wide recreational landings to area.

Between 1990 and 1992, the \gls{mrfss} sampling program ceased
because of budgetary limitations.
Additionally, there was a transition year between \gls{mrfss}
and \gls{crfs} without data.
Thus, linear interpolation was used to provide proxy estimates for
1990, 1991, 1992, and 2004
(Figure \@ref(fig:catch-rec-CA-ts)).

###### \glsentrylong{crfs} (\glsentryshort{crfs})

Sampling under \gls{crfs} started in January of
2001
and data are still currently being collected.
Information includes data on port group
that was used to partition landings to area.
Redwood was assigned to the northern area for all years since 2005,
even though Redwood in 2005 through 2007 also contained landings from
Shelter Cove.
This time series also includes landings from from Mexico and Canada
that were excluded from this analysis.

#### Recreational fleet structure

Recreational data were first compiled to the state level as a single fleet
with all gear types. Then, data from northern California was added to the northern
model as its own fleet rather than being combined with Oregon recreational data
because each fishery is subject to unique regulations that affect selectivity
(Figure \@ref(fig:catch-rec-ts)).
The remaining data from California was used to model recreational fisheries
in the southern area as a single fleet.

### \Glsentrylong{cpue} (\glsentryshort{cpue})


#### Oregon nearshore logbook index

\Gls{odfw} has required nearshore commercial fishers
(both nearshore permitted vessels and open access vessels)
to submit fishing logbooks since 2004.
Compliance is generally high, averaging around 80\%, but has varied through
time, ranging from 65\% in 2007 to greater than 90\% in recent years. Although
required to provide all requested information in the logbook per fishing
gear set, there has been substantial variation in the quantity and quality
of information reported in logbooks. The logbook database contains
information on catch by species (number or pounds of retained and released
fish), effort (hook hours), sample location (port), date, vessel, fishing
depth, fishing gear, fishing permit, number of fishers, and harvest trip
limits.

##### Data preparation, filtering, and sample sizes

Logbook information went through multiple data-quality filters to attain the
best possible consistent and representative data set through time to estimate
a relative abundance trend (Table \@ref(tab:cpue-commercialfixed-gear-filter)).
Individual observations of catch and effort were at the trip level,
where multi-set trips were aggregated to the trip level.
CPUE was calculated for each trip, where total
catch was defined as the total of all reported retained catch (in weight) and
released catch (numbers converted to weight by applying a median catch
weight) and total effort was defined by hook-hours (number of hooks used
multiplied by the number of hours fished). The full dataset included data
from 38,350 trips from 2004 – 2020. Encounter rates are relatively high in
this dataset with lingcod. In general, data filters that were applied
included eliminating records with missing or unrealistic values, including
permitted trips using only hook and line jig gear from ports with appreciable
data, and using only vessels that fished in at least three years over the
logbook history. Vessel operators may have changed through time as the filter
was tied to the vessel name only. Gear type was restricted to hook-and-line
only (excluding longline gear) because this gear type accounts for the vast
majority of trips for lingcod (approximately 78.5\% of unfiltered dataset).
Ports retained in the dataset were Port Orford, Gold Beach and Brookings as
these ports are where most commercially caught lingcod are landed. With the
exception of the vessel fishing for a minimum of three years and the
abnormally deep trips, these filters are consistent with the most recent
lingcod assessment [@haltuch2019lingcod]. These two filters were used for
development of the Oregon nearshore logbook index in the most recent cabezon
assessment [@cope2019cabezon] and were retained here at the recommendation of
ODFW staff.

##### Standardization: model selection, fits, and diagnostics

Covariates considered included month, vessel, port, depth, and people.
Two-month periods associated with commercial trip limits were also considered
but were excluded due to multicollinearity with month. All covariates were
specified as factors, except depth was a continuous variable. Depth was
included to account for general differences in bathymetry and fishing depth
restrictions. People were included to try to control for the potential
oversaturation of hooks at a given fishing location and the interaction that
multi-crew trips (number of fishers onboard) may have on fishing efficiency.
Accounting for vessel also accounts for variability in fishing capacity. 

CPUE was modeled using a delta-GLM approach, where the catch occurrence
(binomial) component was modeled using a logit link function and the log of
the positive catch component was modeled according to a Gaussian distribution
with an identity link function. The selection of covariates included in final
models were evaluated using standard information criterion for relative
goodness of fit (AIC and BIC), where a covariate remained in the model if
model fit was improved relative to an otherwise identical model without the
covariate (Table \@ref(tab:OR_COMM_NSLOG_CPUE_model_selection)). Model selection of all
main effects identified the full model with covariates month, vessel, port,
depth and people as the best fit to the data, along with the year factor of
interest for the index. Residuals from the binomial component of the delta
model are not expected to be normally distributed, so quantile residuals were
simulated [@dunn1996] using the R package DHARMa [@hartig2021]. A
quantile-quantile (QQ) plot of the simulated residuals suggests that the
binomial component of the delta-model is a reasonable approximation of the
data (Figure \@ref(fig:ScaledQQplot_bin)).
However, as observed with the Oregon ORBS
CPUE index, there were issues noted in the DHARMa simulated residuals,
including curvature and significant outlier tests, for the positive component
of the model (Figure \@ref(fig:ScaledQQplot_pos)). These were confirmed with standard
diagnostic tools for GLMs.  Despite filtering procedures described above, it
was noted that there are a wide range of positive CPUE values, which results
in a heavy left skew in the log(CPUE) values. Multiple alternative
distributions and more parsimonious models for the positive model were
explored, as well as aggressive filter for outlier CPUE values, but did not
substantially improve diagnostics. There was insufficient time to fully
resolve these diagnostic issues and alternative approaches may need to be
explored for future assessments.

To estimate the uncertainty in the final index of abundance, it is necessary
to account for the correlation structure between parameters within the
binomial and lognormal components of the model, as well as with the combined
(binomial and lognormal components) delta-model. The rstanarm package in R
was used to replicate the best models using diffuse prior distributions that
replicated point estimates from the maximum likelihood fits [rstanarm2020].
The advantage of this approach is that the calculation of the index
(summing relevant model parameters and combining model components) can be
applied to posterior draws, preserving the correlation structure and
propagating uncertainty into the final index
(Figure \@ref(fig:)). As
an additional diagnostic, replicate datasets were generated from the
posterior predictive distribution, and compared the \gls{mle}
from the model components to the median estimates from the
posterior distribution. As expected with the above diagnostics, the binomial
model closely matches the distribution from replicate datasets; however,
there are some deviations with the positive model. \Gls{mle} were virtually
identical to the medians of the posterior distributions in both cases,
however.



#### Washington recreational index

```
pdf 
  2 
```

The Washington dockside sampling program (Ocean Sampling Program
and Puget Sound Baseline Sampling Program) is supported by
\gls{wdfw} and collects biological as well as catch data.
The coastal portion of this program is largely sampled at three major ports,
Westport, La Push, and Neah Bay. Lingcod are one of three rockfish
species that are highly targeting by recreational fishers, and thus,
have been recorded to the species level since the beginning of the program.

Information on retained lingcod from dockside interviews
were available from \gls{wdfw} between
1981 and 2020.
Recent data also included information on discarded fish,
but this information was not used for this analysis because
(1) it was not available for the entire time series and
(2) the composition data that are associated with this index only include retained fish.
Information from dockside interviews are thought to be more reliable than
information contained in the \gls{mrfss} database, and thus, \gls{mrfss}
data were not explored with respect to Washington recreational \gls{cpue}.

The dockside data were filtered prior to being fit to models to
identify the best subset of the available data that are likely to be
consistent over the time series and provide a reliable index of abundance
once standardized (Table \@ref(tab:reccpuewa_filtersummary)).
Depth was not recorded for the entire time period, and thus was not included
as a filter or a subsequent covariate.
The filtering procedure led to a final positive rate of
57.73\%.

Stephens-MacCall [-@stephens2004] filtering approach was explored to
predict the probability of catching lingcod based on
the species composition of the sampler-observed catch in a given trip.
Prior to applying the Stephens-MacCall filter, we identified potentially
informative predictor species, i.e., species with sufficient sample sizes and
temporal coverage (at least 1.5 \% of all trips)
to inform the binomial \gls{glm} used in the Stephens-MacCall approach.
Thus, the remaining species all co-occurred with
lingcod in at least one trip
and were retained for the Stephens-MacCall logistic regression.
Estimated coefficients from the Stephens-MacCall analysis are
positive for species that are likely to co-occur with the target species and
negative for species that are likely to not co-occur with the target species.
The top five species with high probability of
co-occurrence with lingcod included 
halibut, yelloweye, vermilion, canary, and yellowtail
(Figure \@ref(fig:reccpuewa-filterSMcoef)),
all of which are associated with rocky reef and kelp habitats.
The species with the lowest probability of co-occurrence with lingcod was
blue.
Given the high positivity rate of lingcod prior to the Stephens-MacCall filtering
(Table \@ref(tab:reccpuewa-n)),
we choose to not use this additional filtering process.

The filtered data were used to fit Bayesian delta-\glspl{glm} using the rstanarm R package.
Posterior predictive checks of the Bayesian model fit for all models
regardless of the distributional assumptions used to fit the data were similar (results not shown).
The Gamma distribution was chosen going forward given a better match of the
theoretical quantiles to the data quantiles (Figure \@ref(fig:reccpuewa-ScaledQQplot_pos))
than the lognormal.

Based on the the negative binomial model were reasonable
(Figures \@ref(fig:fig-posterior-mean-ORAtSea) and \@ref(fig:fig-posterior-sd-ORAtSea)). The negative binomial model generated data sets with the proportion zeros similar to the
41%
zeroes in the observed data 
(Figure \@ref(fig:fig-propzero-ORAtSea)). The predicted marginal effects from 
the negative binomial models can be found in (Figure \@ref(fig:fig-Dnbin-marginal-ORAtSea)). The 
final index (Table \@ref(tab:tab-index-ORAtSea)) 
represents a similar trend to the arithmetic mean of the annual CPUE (Figure \@ref(fig:fig-cpue-ORAtSea)).

#### \Glsentrylong{orbs} index

Trip-level catch-per-unit-effort data from \gls{orbs} dockside sampling was
obtained from \gls{odfw} on 04/15/2021. To mitigate the confounding of hourly
effort associated with these trips with travel, the travel time was
subtracted from the hours fished. Travel time was stratified by boat type
(charter and private) and was calculated as boat type-specific speeds (13 mph
for charter boat trips and 18 mph for private boat trips) multiplied by twice
the distance between the port of origin and the reef that was fished. CPUE,
expressed in terms of fish per angler-hour, was calculated by multiplying the
number of anglers and the adjusted travel time. The database contains
information on catch by species (number of retained fish), effort
(angler hours), sample location (port where data were collected), date, bag
limits, boat type (charter or private), and trip type (e.g., bottom
associated fish).

##### Data preparation, filtering, and sample sizes

The unfiltered data set contained 411,528 trips. Multiple standardized filters
are applied to \gls{orbs} trip-level data in order to remove outliers and
data unsuitable for an index (Table \@ref(tab:cpue-recreationalOregon-filter)).
These filters include trips with incorrect interview times, which impact
calculation of effort, unreasonably long or short trips, and retaining only
trips targeting bottom fish. Further filters were utilized for fishing closures
(i.e., temporal or spatial closures) and catches exceeding bag limits, which
would presumably impact catch rates. Trips from several ports with extremely
small sample sizes were also excluded and, finally, trips that met criteria
for irrational effort reporting (i.e., implausible values) or extreme catch
rates were excluded as well. Also, all trips from private vessels were removed
and only trips from charter boats were retained to increase the positivity
rate of lingcod encounters.
As described below, this filter was one of several explored to
improve model fit. To identify trips that were likely to catch lingcod,
Stephens and MacCall [@stephens2004] filtering was used to
predict the probability of catching a
lingcod given the occurrence of other species in the catch.
This filter was recently used in the development of an
\gls{orbs} \gls{cpue} index of abundance for
the 2019 Cabezon assessment [@cope2019cabezon]. However, there was some
question about whether it was appropriate for use with lingcod.
Thus, the model was estimated using data that was both filtered and
not filtered with the Stephens-MacCall filter.
Filtering the data did not change the model diagnostics, and thus, it
was not utilized for the final data set.

##### Standardization: model selection, fits, and diagnostics

A delta-\gls{glm} approach was used to model \gls{cpue}. Apart
from differences in catch rate among years, we also considered changes
associated with month, mega-region (north and south coasts, divided at the
port of Florence on the central Oregon coast), port, season (summer and
winter), the bag limit for lingcod, and the depths available to the
recreational fleet for fishing (Figure “ORBS_DataSummary”). The binomial
component for catch occurrence was modeled using a logit link function while
the log of positive \gls{cpue} was modeled with a Gaussian distribution and an
identity link function. Based on the Akaike Information Criterion
(AIC), Bayesian Information Criterion (BIC) and other factors described
below, the binomial model selected as the best predictor of \gls{orbs} catch
rates included year, port, month and open depths available to fishing
(Table “OR_ORBS_CPUE_model_selection”). Season and mega-region were also
evaluated but not included in the stepwise progression due to collinearity
with other factors (month and port, respectively). Interactions between year
and port, month and open depths were also evaluated.  Models with
interactions between year and port or month did not converge due to missing
trips in some strata and these were excluded from consideration.  Residuals
from the binomial component of the delta-model are not expected to be
normally distributed, so quantile residuals were simulated using the R
package DHARMa [@hartig2021]. A quantile-quantile (QQ) plot of the simulated
residuals suggests that the binomial component of the delta-model is a
reasonable approximation of the data (Figure “ScaledQQplot_bin”, right
panel); however, there was some curvature seen in the residuals
(left panel of Figure \@ref(fig:cpue-recreationalOregonqqbin)).
These diagnostics were
substantially improved by excluding the year:open depths interaction and the
removal of the private boat trips from the dataset. The positive model
selected, again based on AIC, BIC and other considerations, included year,
port, month and open depths available to fishing
(Table \@ref(tab:OR_ORBS_CPUE_model_selection)).
Again, there were issues noted in
the DHARMa simulated residuals, including curvature and significant outlier
tests (Figure \@ref(fig:cpue-recreationalOregonqqpos)).
However, as noted with the binomial
model, these were improved slightly, though not resolved, by exclusion of
any interaction terms and the removal of the private vessel trips. There was
insufficient time to fully resolve these diagnostic issues and alternative
approaches may need to be explored for future assessments. Given that
mega-region was not included in this model selection procedure, an
area-weighted model was not utilized for lingcod, as has been used for other
nearshore species in recent assessments, such as cabezon [@cope2019cabezon]
or blue rockfish [@dick2018bluedeacon].

To estimate the uncertainty in the final index of abundance, it is necessary
to account for the correlation structure between parameters within the
binomial and lognormal components of the model, as well as with the combined
(binomial and lognormal components) delta-model.
The rstanarm package in R [@rstanarm2020]
was used to replicate the best models using diffuse prior distributions that
replicated point estimates from the \gls{mle}. The advantage of
this approach is that the calculation of the index (summing relevant model
parameters and combining model components) can be applied to posterior draws,
preserving the correlation structure and propagating uncertainty into the
final index (Figure \@ref(fig:)). As an
additional diagnostic, replicate datasets were generated from the posterior
predictive distribution, and compared the \glspl{mle}
from the model components to the median estimates from the posterior
distribution. As expected with the above diagnostics, the binomial model
closely matches the distribution from replicate datasets; however, there are
some deviations with the positive model. \Gls{mle} were virtually identical to the
medians of the posterior distributions in both cases, however.

### Recreational age- and length-composition data


<!--- RECREATIONAL COMP INFORMATION STARTS HERE -->

Recreational fishery length (Figures \ref{fig:wa-lencomp-sexed}, \ref{fig:wa-lencomp-unsexed}, \ref{fig:or-lencomp-sexed}, \ref{fig:or-lencomp-unsexed}, \ref{fig:ca-lencomp-sexed}, and \ref{fig:ca-lencomp-unsexed}) and age compositions (Figures \ref{fig:wa-agecomp-sexed}, \ref{fig:wa-agecomp-unsexed}, \ref{fig:or-agecomp-sexed}, \ref{fig:or-agecomp-unsexed}) were obtained directly from WDFW and ODFW, and from MRFSS for years 1980 - 2003 and from CRFS for years 2004 - 2020 from the RecFIN website for California. Note that, in consultation with WDFW and ODFW representatives, it was determined that the state databases were more reliable so the data were not obtained via RecFIN (MRFSS) for Washington and Oregon. Lengths fron WDFW with designation of total length (n = 591) were converted to fork length using the converstions of @Laidig_conversion. Lengths of fish in California, measured by samplers onboard Commercial Passenger Fishing Vessels (CPFV) prior to being released (Type 3d data) were also obtained from 2003 to 2020. Annual recreational length- and age-frequency distributions were developed for each state for which observations were available, following the same bin structure as was used for data from fishery-independent sources. Length and age compositions were applied for male, female, and unsexed fish, though the number of samples of unsexed aged fish was small. Many of these composition data lack information on the number of fish sampled out of those landed in a given trip, and therefore composition data are used without expansion to the sample level. Unexpanded recreational composition data are commonly used in West Coast stock assessments for the above reason. Sample sizes used in the model were therefore set at the number of fish sampled for each year and data set. Table \ref{tab:sample-size-length} show the sample sizes for lengths, and Table \ref{tab:sample-size-age} the sample sizes for ages. Conditional-length-at-age distributions were also applied for the recreational fleets for Washington and Oregon and explored within the model as a sensitivity.  

Only landed fish were included in composition data. Fish designated as released were excluded from the length and age compositions. This occurred for 2,920 samples, which represent approximately 2 percent of the total samples.  

In Oregon the minimum size limits for lingcod have changed from 22 inches during 1995 to 1997 and 2006 to present, but were 24 inches during 1998 to 2006. It has also been reported that recreational fishers in Oregon sometimes release large, assumed to be female fish, so that they can spawn. However other anglers tend to target and retain these large fish. Recreational length samples from ODFW were obtained from three sources: MRFSS, RecFIN (ORBS) and ODFW special project sampling. From 1980 – 1989 and from 1993 – 2000, the MRFSS program collected samples from ocean areas only (n = 8,769). ODFW provided MRFSS samples with the addition of a column that flagged length values imputed from weights to allow for selection of directly measured values; however, sample size was limited and therefore, imputed lengths were used. From 1980 – 1989, total lengths (mm) were collected by MRFSS, which were converted to fork length. From 1993 – 2000, fork length (mm) was collected. Length samples from 2001 – 2020 from the ORBS sampling program are available on RecFIN (n =105,197). All ORBS samples are by fork length (mm). All samples are from ocean trips. Special projects samples collected by ODFW staff from the recreational fishery are provided from 2001 (n = 72) but were not used in the length compositions for the assessment model. There were 8,491 Oregon recreational age samples available from 1999 – 2008 and 2012 – 2019 on RecFIN (extracted on 04/14/2021). Approximately, 50.5% of samples were males (n = 4,288) and 49.4% were females (n = 4,193).  There were 10 unsexed samples (0.1%). The majority of these samples are from the central Oregon coast (n = 4,440), including Newport (18.7%), Garibaldi (18.6%) and Depoe Bay (15.0%), followed by Brookings on the south coast (27.3%, n = 2,321).



### Unused fishery-dependent data


#### Fin rays from \glsentrylong{cdfw}

The \gls{cdfw} collected lingcod fin rays from the
commercial and recreational fisheries in recent years and cleaned them in
preparation for ageing, but restrictions on access to ageing laboratories to
use saws to thin section and mount them for ageing prevented their inclusion
in this assessment.
\Gls{cdfw} conducted a commercial sampling project
from February through June 2019 to acquire samples for priority species from
Crescent City to Santa Barbara, resulting in 113 lingcod fin
rays for ageing. The majority of samples were landed utilizing hook-and-line
gear, though some trawl-caught samples were also obtained. In addition to age
structures, meta data includes port of landing, gear type, length,
weight, sex, and maturity. In 2017, \gls{cdfw} began opportunistically collecting
groundfish carcasses from the recreational fishery to increase recreational
biological data by collecting filleted groundfish carcasses from partnering
\gls{cpfv} operators and at public fillet stations, launch ramps, and piers.
Current efforts have been primarily focused in the Crescent City and Monterey Bay
port complexes as well as samples from south of Point Conception in
collaboration with the Sportfishing Association of California, yielding a
total of 324 lingcod fin rays.  In addition to age
structures, meta data includes port of landing, carcass length, and sex
when it can be determined from the filleted carcass. A graduate student at
California Polytechnic University, San Luis Obispo is working on a study of
total length to carcass length for recreational species, including rockfish
and lingcod, results of which will help inform the best
treatment of length information attained from carcasses. These samples may
be used to inform growth, create conditional-age-at-length data, or to supplement
samples from other sampling programs used to represent age composition
directly in future assessments.

## Fishery-Independent data

### **to do - Need a header name**

### \acrlong{s-wcgbt}

The \Gls{s-wcgbt} is based on a random-grid design;
covering the coastal waters from a depth of 55 - 1,280 m [@bradburn_2003_2011].
This design generally uses four industry-chartered vessels per year assigned to a roughly equal number of randomly selected grid cells and divided into two 'passes' of the coast.
Two vessels fish from north to south during each pass between late May to early October.
This design therefore incorporates both vessel-to-vessel differences in catchability,
as well as variance associated with selecting a relatively small number (approximately 700) of possible cells from a very large set of possible cells spread from the Mexican to the Canadian borders.

Three sources of information are produced from the \Gls{s-wcgbt}: an index of relative
abundance, length-frequency distributions, and age-frequency distributions. Length-weight 
parameters were also estimated from data collected from the \Gls{s-wcgbt}, and details are
described in Section {\ref biology}.

#### Index

[enter in index information here]

#### Length-frequency data

The length frequency of survey catches in each year was summarized using length bins in 
2 cm increments from 10 to 130 cm. The first bin includes all observations less than 10 cm, 
and the last bin includes all fish larger than 130 cm. The observed length compositions were 
expanded to account for subsampling of tows, and the expansion was stratified by depth. Depth 
strata of 55 - 183 m and 183 - 400m were selected, based on the sampling design of the survey (@kelleretal_survey_2017). Depth strata were capped at 400 m because catches of lingcod in 
the \Gls{s-wcgbt} occur infrequency beyond 400m (Figure \ref{fig:wcgbts-presAbs}). Samples were
often sexed, so only male and female length frequencies were used. The few unsexed individuals 
were assigned as male or female according to the sex ratio of the respective length bin. An 
assumed sex ratio of 0.5 was applied for unsexed fish in length bin less than 40 cm, as sex 
of smaller sized lingcod is harder to differentiate. A bin of 40 cm was chosen as this is the
length bin at which the length-weight relationship starts to diverge for males and females, 
and therefore equal assigment is not influenced by sex-specific size differences. Figure \ref{fig:wcgbts-lenComp} shows the length frequency distributions for the \Gls{s-wcgbt}. 
Table \ref{tab:sample-size-length} shows sample sizes.

The input sample sizes for length and marginal age-composition data for all 
fishery-independent surveys were calculated according to 
Stewart and Hamel [-@stewart_bootstrapping_2014], which determined that the 
approximate realized sample size for species in the "others" category 
(which included lingcod) was $2.38*N_{\text{tow}}$.

#### Age-frequency data

Age-frequency data from the \Gls{s-wcgbt} (Figure \ref{fig:wcgbts-ageComp}) were 
included in the model as conditional age-at-length (CAAL) distributions by sex 
(male and female) and year, and therefore were not expanded. The numbers of fish 
are used without any adjustment. The age distribution of survey catches in each year 
was summarized using age bins from 0 to 20 years, in increments of one year. The last bin 
includes all fished aged to be greater than 20 years. 

Individual length- and age-observations can be thought 
of as entries in an age-length key (matrix), with age across the columns and length 
down the rows. The CAAL approach consists of tabulating the sums within rows as the 
standard length-frequency distribution and, instead of also tabulating the sums to 
the age margin , the distribution of ages in each row of the age-length key is 
treated as a separate observation, conditioned on the row (length) from which it came. 

The CAAL approach has several benefits for analysis above the standard use of marginal age 
compositions. First, age structures are generally collected as a subset of the fish 
that have been measured. If the ages are to be used to create an external age-length 
key to transform the lengths to ages, then the uncertainty due to sampling and missing 
data in the key are not included in the resulting age-compositions used in the stock 
assessment. If the marginal age compositions are used with the length compositions 
in the assessment, the information content on sex-ratio and year class strength is 
largely double-counted as the same fish are contributing to likelihood components 
that are assumed to be independent. Using conditional age distributions for each 
length bin allows only the additional information provided by the limited age data 
(relative to the generally far more numerous length observations) to be captured, 
without creating a ‘double-counting’ of the data in the total likelihood. The second 
major benefit of using conditional age-composition observations is that in addition 
to being able to estimate the basic growth parameters ($LminAge$, $LmaxAge$, $K$) inside 
the assessment model, the distribution of lengths at a given age, governed by two 
parameters for the standard deviation of length at a young age and the standard 
deviation at an older age, is also quite reliably estimated. This information could 
only be derived from marginal age-composition observations where very strong and 
well-separated cohorts existed and where they were quite accurately aged and measured; 
rare conditions at best. By fully estimating the growth specifications within the 
stock assessment model, this major source of uncertainty is included in the assessment 
results, and bias in the observation of length-at-age is avoided. 

The CAAL apporach was only applied for male and female lingcod and so unsexed fish were excluded. 


This results in 60 unsexed fish excluded from the CAAL distributions, or approximately
one percent of the aged fish.



Table \ref{tab:sample-size-age} show sample sizes. Sensitivities to using the CAAL
approach were explored by replacing with marginal age distributions. 


### \acrlong{s-tri}

The \gls{s-tri} was first conducted by the \gls{afsc} in 1977, and the survey continued until 2004 [@weinberg_2001_2002].
Its basic design was a series of equally-spaced east-to-west transects across the continential shelf from which searches for tows in a specific depth range were initiated.
The survey design changed slightly over time.
In general, all of the surveys were conducted in the mid summer through early fall.
The 1977 survey was conducted from early July through late September.
The surveys from 1980 through 1989 were conducted from mid-July to late September.
The 1992 survey was conducted from mid July through early October.
The 1995 survey was conducted from early June through late August.
The 1998 survey was conducted from early June through early August.
Finally, the 2001 and 2004 surveys were conducted from May to July.

Haul depths ranged from 91-457 m during the 1977 survey with no hauls shallower than 91 m.
Due to haul performance issues and truncated sampling with respect to depth, the data from 1977 were omitted from this analysis.
The surveys in 1980, 1983, and 1986 covered the US West Coast south to 36.8\textdegree N latitude and a depth range of 55-366 m.
The surveys in 1989 and 1992 covered the same depth range but extended the southern range to 34.5\textdegree N (near Point Conception).
From 1995 through 2004, the surveys covered the depth range 55-500 m and surveyed south to 34.5\textdegree N.
In 2004, the final year of the \gls{s-tri} series, the \gls{nwfsc} \gls{fram} conducted the survey following similar protocols to earlier years.

The triennial data have historically been split into early (1980-1992) 
and late (1995-2004) survey time series and treated independently, however
for this assessment we combined across time series into a single fleet.
Splitting the triennial survey into two time series was explored as a 
sensitivity. 

#### Index

[enter in index information here]

#### Length-frequency data

Length data preparation followed the same methods as applied to the WCBTS data,
but depth strata of 55 - 183 m and 183 - 350m were used for expanding the
length comps for subsampling of tows. A depth split of 183 m was used because
sampling appeared less intense after this depth, and raw catch per unit effort 
more variable (Figure \ref{fig:tri-depthSplit}). A maximum
depth of 350 m was used because lingcod were infrequently caught at depths 
greater than 350 m (Figure \ref{fig:tri-depthSplit}). 
Figure \ref{fig:tri-lenComp} shows the length frequency distributions for the \gls{s-tri}. 
Table \ref{tab:sample-size-length} shows the sample sizes.

#### Age-frequency data

Age data preparation follow the same methods as the WCBTS length data. 
The \gls{s-tri} age-frequency data were included in the model 
as CAAL, and marginal age compositions were explored as sensitivities.
Figure \ref{fig:tri-ageComp} shows the age frequency data for the \gls{s-tri}.
Table \ref{tab:sample-size-age} shows sample sizes.




### \acrlong{s-ccfrp}

Since 2007, the \Gls{s-ccfrp} has monitored several areas in California to evaluate the performance of \Gls{mpa}s and understand nearshore fish populations
[@Wendt2009; @Starr2015].
In 2017, the survey expanded beyond the four \Gls{mpa}s in central California
(A&ntilde;o Nuevo, Point Lobos, Point Buchon, and Piedras Blancas)
to include the entire California coast.
Fish are collected by volunteer anglers aboard \Gls{cpfv}s guided by one of the following academic institutions based on proximity to fishing location:
Humboldt State University;
Bodega Marine Laboratories;
Moss Landing Marine Laboratories;
Cal Poly San Luis Obispo;
University of California, Santa Barbara; and
Scripps Institution of Oceanography.

Surveys consist of fishing with hook-and-line gear for 30-45 minutes within randomly chosen 500 by 500 m grid cells within and outside \Gls{mpa}s.
Prior to 2017, all fish were measured for length and release or descended to depth;
since then, some were sampled for otoliths and fin clips.


[THESE APPEARS SOLELY FOCUSED ON INDEX. I INCLDUE THE SEEMINGLY SIMILAR WRITEUPS FOR COMP
DATA WITHIN THE REC (FISHERY-DEPENDENT) SECTIONS]


### Lam Research

In collaboration with the NWFSC and Moss Landing Marine Labs, lingcod in nearshore 
and offshore rocky reef habitats were collected between January 2016 and January 
2017 via hook and line on chartered CPFVs (@Lam-thesis). Sixteen latitudinal distinct sampling 
sites, or ports, were chosen from northern Washington to southern California. 85 
to 120 individuals were caught per port (N = 1,784, 922 Males, 862 Females) using 
methods identical to those used by the onboard recreational lingcod fishery 
except that shorts were retained (individuals smaller than the legal-size limit 
of 22 inches) and areas closed to recreational harvest were occasionally utilized 
(CDFW Permit #SC-6477, ODFW Permit #20237, WDFW Permit ID Samhouri 16-138). 
This was to ensure an even distribution of size and age classes from each port 
for purposes of comparing lingcod von Bertalanffy growth curves by spatially 
explicit regions. Of the total fish samples, 32 were sampled on CCFRP trips and so to avoid double 
counting were excluded. Four addition samples had no year associated with them, and
were excluded. Length compositions from this survey were used as numbers of fish, 
and were not expanded. Lengths were measured in total length, and were converted to
fork length following conversions from Laidig et al. @Laidig_conversions. Total
and fork lengths for lingcod were generally very similar given the tail shape 
of lingcod. 
Figure \ref{fig:lam-lenComp} shows the length frequency distributions. 
Table \ref{tab:sample-size-length} shows sample sizes.


A random stratified subsample by size and sex was selected per region for ageing and genetics analysis. 
The age composition data are therefore used as CAAL, and are not expanded.
Figure \ref{fig:lam-ageComp} shows the age frequency distributions. 
Table \ref{tab:sample-size-length} shows sample sizes.


### \acrlong{s-aslope}


The \gls{s-aslope} operated during the months of October to November aboard the R/V _Miller Freeman_.
Partial survey coverage of the US west coast occurred during the years 1988-1996 and complete coverage (north of 34\textdegree 30\textquotesingle S) during the years 1997 and 1999-2001.
Typically, only these four years that are seen as complete surveys are included in assessments.

Sample sizes of lingcod were low during these four complete years, with 119 samples across
55 tows coastwide. Given that lingcod are primarily a shelf species, data from this
survey was not included in the model. 

The NWFSC also operated a slope survey during the years 1998-2002. Coastwide, 184
lingcod were sampled across 64 tows. Data from this survey were not included in
the model for the same reasons why data from the \gls{s-aslope} were not included. 

### Unused fishery-independent data


#### Lander data

\Gls{odfw} provided density estimates and a range of estimated population
abundances from underwater video lander data for
lingcod.
The lander data was collected over nine years by \gls{odfw}
[@rasmuson2020]. The data includes information from
ten independent studies carried out in both nearshore rocky reefs
coastwide, as well as select reef structures offshore of the central coast of
Oregon. Underwater video landers are stationary platforms consisting of one
to three video cameras. Landers used in deeper water employ advanced
lighting systems for optimal viewing of fish and benthic habitat. Ambient
light is used in shallow surveys. The variability in detection range by
depth is an important factor to consider when deriving fish density from
lander data. Therefore, a series of abundance estimates were provided to
inform this assessment. Methods are summarized below and a more detailed
document is available by \gls{odfw} upon request.

Variability in range, and therefore area viewed, directly influences fish
abundance. Thus, density estimates were calculated using five
estimates of range. These include the average range, the range +/- one
standard deviation from the mean, and the maximum and minimum ranges. The
area viewed is calculated using both the range and the horizontal field of
view. This viewed area was then combined with fish-count data to generate
fish densities. Count data were provided from Rasmuson et al. [-@rasmuson2020].
As expected, the viewed range has a large effect on the calculated density,
with larger ranges resulting in a lower density of fish. There is
no way to know which range model most accurately reflects the true density of
fish, and thus, multiple range estimates were combined into a single density
estimate using a weighted arithmetic mean. Although the arithmetic mean is
simpler and more intuitive, the fact that the area viewed increases
exponentially suggests a geometric mean may be more appropriate. As an
alternative to the arithmetic mean, the geometric mean density was calculated
three ways to address the zeros in the data. Abundance
estimates (numbers of fish) were calculated by multiplying the density
estimate by an estimate of the habitat area. Coastwide habitat area was
limited to primary or secondary habitat containing hard substrate. The
western boundary was defined as the 200 m contour based on the depth of the
continental shelf-break. The eastern boundary was based on the shallowest
lander observation for each species. Lingcod were
observed on lander video in water as shallow as 4 m; therefore, the 0 m
contour was used. It should be noted that, while the depth range of the
lander surveys conducted by \gls{odfw} extends to 212 m, the majority of
lander surveys have been conducted in either nearshore rocky reefs or at
Stonewall Bank \gls{rca} on the central Oregon coast.

Abundance estimates for the coastwide survey area are provided for
lingcod derived from each of the nine density estimates; five
range models, the weighted arithmetic mean, and three weighted geometric mean
methods. For lingcod, density estimates ranged from
0.020 ± 0.052 (no. fish / m2 ± SD) from the maximum range method to
0.793 ± 1.850 for the third geometric mean method.
The estimated habitat area was 1,940 thousands of km2.
Abundance estimates ranged from 38.8 ± 100.8 (millions of fish ± SD)
to 1,537 ± 3,585. Estimates of abundance from the five range
models produced similar results to the weighted arithmetic mean, ranging from
38.8 ± 100.8 (millions of fish ± SD) for the maximum range to 170.5 ± 472.8
for the minimum range. These were generally considered more plausible than
the results based on the geometric means. Caveats to this abundance
estimate are provided in the detailed document, as well as
considerations for using the lander data and the estimation of habitat area.

#### Oregon hook and line survey in marine reserves

The Marine Reserve Program in the \gls{odfw} has routinely monitored state
marine reserves and associated comparison areas since 2011.
Surveys in 2011 and 2012 only visited Redfish Rocks marine reserve.
Surveys from 2013 – 2019 include reserves and
comparison areas from four marine reserves,
Redfish Rocks, Cape Falcon, Cape Perpetua, and Cascade Head
(Table \@ref(tab:fi-index-ormarres-mr)).
Each of these marine reserves has one to three associated comparison areas.
Comparison areas are specifically selected for each
marine reserve to be similar in location, habitat, and depth to the reserve but
are subject to fishing pressure. 
Not all sites are sampled in each year because of
the gradual implementation of the reserve network and availability of
staff to execute surveys.

A 500 meter square grid overlaid on the area defines the sampling units or
cells. Cells are randomly selected within a marine reserve or comparison area
for each sampling event. Three replicate drifts are executed in each cell.
The specific location of the drifts within the cell is selected by the
captain. Over time, cells without appropriate habitat for the focus species,
mainly groundfish, have been removed from the selection procedures, and
information from all inactive cells is removed from the data prior to any
analyses being conducted.
The number of cells visited in a day ranges from three to five cells.
Data are aggregated to the cell-day level.

Of the 940 total cell-days at 14 areas, 626 (66.6\%) of those
had positive lingcod catches
(Table \@ref(tab:fi-index-ormarres-N)). The number of
lingcod caught ranged from 0 to 34 fish in a cell-day
(Figure \@ref(fig:fi-index-ormarres-HistogramofPositiveCatchesLing)).
Areas differ in both geographic location and the
level of fishing pressure experienced or allowed. Staff from the Marine
Reserves Program suggested that the treatment (reserve vs. comparison area)
may not be a delineating factor for the catch of lingcod due to the recent
implementation of the reserves. It was suggested that data could be
aggregated to the site level, functioning at the level of a reef complex, to
examine patterns at different locations along the coast. However, this may
not be possible with the sample size available at some sites.
\Gls{cpue} was calculated using the number of fish per angler hour, where
the number of anglers and hooks are standardized for each survey.
Angler hours have been adjusted for non-fishing time (i.e., travel time, etc.).

Additional filtering may not be necessary, as the filtering for active cells
has already likely removed any unsuitable sampling units, based on habitat,
depth, and local knowledge. Based on the annual proportion of positive
cell-days and the relatively high encounter rate of lingcod in this survey,
there could be enough data to move forward with a time series at a coastwide
level. Additionally, Redfish Rocks has been sampled yearly since 2011,
except for 2018, making it the best single reserve complex to monitor
inter-annual trends.
\Gls{cpue} at this site shows a relatively stable trend since
2011 for lingcod (Figure \@ref(fig:fi-index-ormarres-BoxplotLingcodCPUERedfish)).
Coastwide, lingcod \gls{cpue} appears to be oscillating around
the long-term mean, with the last two years being below average
(Figure \@ref(fig:fi-index-ormarres-RelativemeanLingcodCPUE95CI)).




<!--chapter:end:20data.Rmd-->

\clearpage

# References
<!-- If you want to references to appear somewhere before the end, add: -->
<div id="refs"></div>
<!-- where you want it to appear -->
<!-- The following sets the appropriate indentation for the references
  but it cannot be used with bookdown and the make file because it leads
  to a bad pdf.
\noindent
\vspace{-2em}
\setlength{\parindent}{-0.2in}
\setlength{\leftskip}{0.2in}
\setlength{\parskip}{8pt}
 -->

<!--chapter:end:49bibliography.Rmd-->

\clearpage
<!--
to do onboarding sa4ss - move this to sa4ss.sty so everyone's figures hold their order
https://stackoverflow.com/questions/29696172/how-to-hold-figure-position-with-figure-caption-in-pdf-output-of-knitr
-->
\floatplacement{table}{H}
# Tables

<!-- Need tab:management-refpoints
label = "tab:management-refpoints",
caption = "Recent trends in landings and total catch (mt) relative to management guidelines. Total dead catch represents the total landings plus the model estimated dead discard biomass. Note that the model estimated total dead catch may not be the same as the \gls{wcgop} estimates of total mortality [@somers2017], which are the "official" records for determining whether the \gls{acl} has been exceeded."
-->


\begin{longtable}[t]{l>{\raggedright\arraybackslash}p{6cm}rr}
\caption{\label{tab:cpue-commercialfixed-gear-filter}Filtering criteria for commercial fixed-gear data and the resulting number (N) and percent positive (pos) records remaining after filtering.}\\
\toprule
Filter & Criteria & N pos & \% pos\\
\midrule
All Data & Full data set aggregated to trip & 31464 & 81.7\\
Depth min & Ensure depth = 1 fathom & 28890 & 81.8\\
Fishermen & Ensure fishermen > 0 & 28294 & 81.9\\
Gear ID & Gear ID is present & 27995 & 81.9\\
Secondary Gear ID & Secondary Gear ID is present & 26968 & 81.7\\
\addlinespace
CPUE calculation & CPUE data are present & 26179 & 81.3\\
Gear & Hook and line gear only & 20216 & 78.5\\
Port & Port Orford south only & 15410 & 81.7\\
CPUE outliers & Remove outlier values above 99 percentile & 14619 & 81.1\\
Vessel & Vessel fished at least 3 years & 13530 & 81.3\\
\addlinespace
Depth & Remove abnormally deep trips & 13443 & 81.6\\
\bottomrule
\end{longtable}


\begin{longtable}[t]{l>{\raggedright\arraybackslash}p{6cm}rr}
\caption{\label{tab:cpue-recreationalOregon-filter}Filtering criteria for recreational Oregon data and the resulting number (N) and percent positive (pos) records remaining after filtering.}\\
\toprule
Filter & Criteria & No. pos & \% pos\\
\midrule
All Data & Full data set aggregated to trip & 85494 & 20.8\\
Bottomfish trips & Retain bottomfish trips only & 70672 & 52.8\\
Trip time length & Remove exceedingly long or short trips (< 1 hr or > 12 hrs) & 70442 & 53.5\\
Interview time & Remove trips with interviews within one minute & 62633 & 53.5\\
Closed Season & Remove trips during closed season & 62633 & 54.2\\
\addlinespace
Outside 40fm & Remove trips outside of 40 fm (closed depths) & 61900 & 53.6\\
Catches above boat limits & Remove trips above the catch limit & 51049 & 51.7\\
Ports with rare catch encounters & Removed trips from Ports 30, 32 and 38 & 50888 & 48.9\\
Negative effort & Remove trips with negative effort when accounting for travel time & 50779 & 49.0\\
Anomalously high catch rates & Removes catch rates above the 97.5 percentile & 48194 & 47.7\\
\addlinespace
Charter vessels only & Removes private vessel trips & 17977 & 74.8\\
\bottomrule
\end{longtable}


\begin{longtable}[t]{lllr}
\caption{\label{tab:fi-index-ormarres-mr}Summary of marine reserves sampled within the Oregon hook and line survey by the Marine Reserve Program.}\\
\toprule
Site & Area & Years Sampled & Total Years Sampled\\
\midrule
Redfish Rocks & Humbug CA & 2011 - 2019 & 8\\
Redfish Rocks & Redfish Rocks MR & 2011 - 2019 & 8\\
Redfish Rocks & Orford Reef CA & 2014, 2015, 2017, 2019 & 4\\
Cape Falcon & CA Adjacent to Cape Falcon MR & 2014, 2015, 2017, 2019 & 4\\
Cape Falcon & Cape Falcon MR & 2014, 2015, 2017, 2019 & 4\\
\addlinespace
Cape Falcon & Cape Meares CA & 2014, 2015, 2017, 2019 & 4\\
Cape Falcon & Three Arch Rocks CA & 2014, 2015, 2017, 2019 & 4\\
Cape Perpetua & CA Outside Cape Perpetua MR & 2016, 2018 & 2\\
Cape Perpetua & Cape Perpetua MR & 2013, 2014, 2017, 2018 & 4\\
Cape Perpetua & Postage Stamp CA & 2013, 2014, 2017, 2018 & 4\\
\addlinespace
Cascade Head & Cape Foulweather CA & 2015, 2016, 2018 & 3\\
Cascade Head & Cascade Head MR & 2013 - 2016, 2018 & 5\\
Cascade Head & Cavalier CA & 2013, 2015, 2016, 2018 & 4\\
Cascade Head & Schooner Creek CA & 2013 - 2016, 2018 & 5\\
\bottomrule
\end{longtable}


\begin{longtable}[t]{lrrr}
\caption{\label{tab:fi-index-ormarres-N}Number (N) and percent positive (pos.) cell-days and N caught across all cell-days for the Oregon hook and line survey inside marine reserves. Data were aggregated across sets within a cell for a given day (cell-day).}\\
\toprule
Year & N pos. cell-days & \% pos. cell-days & N caught\\
\midrule
\midrule
2011 & 24 & 54.5 & 61\\
2012 & 25 & 48.1 & 39\\
2013 & 66 & 68.0 & 190\\
2014 & 115 & 81.6 & 572\\
2015 & 118 & 70.7 & 534\\
\addlinespace
2016 & 80 & 71.4 & 477\\
2017 & 71 & 68.9 & 252\\
2018 & 69 & 59.5 & 244\\
2019 & 58 & 53.7 & 131\\
Total & 626 & 66.6 & 2500\\
\bottomrule
\end{longtable}

<!--chapter:end:52tables.Rmd-->

\clearpage
<!--
to do onboarding sa4ss - move this to sa4ss.sty so everyone's figures hold their order
https://stackoverflow.com/questions/29696172/how-to-hold-figure-position-with-figure-caption-in-pdf-output-of-knitr
-->
\floatplacement{figure}{H}
# Figures


![Map of the investigated area. The dashed line and colors delineate the northern (blue) from the southern (red) assessed area.\label{fig:map}](../figures/map_of_stock_boundaries_40-10.png){width=100% height=100% alt="Outline of U.S. west coast split at forty degrees ten minutes north latitude."}

![Length (cm) versus age (year) and associated von Bertalanffy growth curves (lines) by latitude (color). Models were fit to data from Lam research samples and West Coast Groundfish Bottom Trawl Survey data.\label{fig:Lam-vbgfcurves}](../figures/Lam-vbgfcurves.pdf){width=100% height=100% alt="Size-at-age increases with increasing latitude."}

![Estimated smoother of latitude (decimal degrees) for age-7 female fish when fitting length-at-age data.\label{fig:Lam-kapurage7latitude}](../figures/Lam-kapurage7latitude.png){width=100% height=100% alt="Change point was estimated at 38 degrees N latitude."}


![Summary of data sources used in the base model.\label{fig:data-plot}](../models/2021.s.005.001_initial_ctl_changes/plots/data_plot.png){width=100% height=100% alt="Dots for each year a source of data is available."}


![Comparison of commercial catch time series from this model (dashed line) and the previous assessment model (solid line). Fixed gear (FG; dark blue) and trawl (TW; light blue) are shown for both the northern (top panel; Oregon and Washington) and southern (bottom panel; California) as defined in the previous assessment model.\label{fig:catch-comm-state}](../figures/catch-comm-state.png){width=100% height=100% alt="Time series of commercial catches are less in the early years for the new southern model than the previous assessment."}

![Reconstructed commercial landings for the state of California by fleet (fixed gear, FG, circles; trawl gear, TW, triangles) and area (northern region, blue; southern region, red). Dashed line indicates data were interpolated across years.\label{fig:catch-comm-CA-interpolate-ts}](../figures/catch-comm-CA-interpolate-ts.png){width=100% height=100% alt="NA."}

![Yearly proportion of California (CA) commercial catch landed in the the northern region (i.e., north of forty degrees ten minutes latitude) of all CA commercial catches from two data sources, the Raltson et al. (2010) catch reconstruction effort (open circles) and fish ticket data in CALCOM, the database used by the California Cooperative Groundfish Survey to store and manage commercial market sample data, (filled circles).\label{fig:catch-comm-CA-proportionnorth}](../figures/catch-comm-CA-proportionnorth.png){width=100% height=100% alt="Proportions largely agree between both data sets."}

![Yearly commercial landings (mt) from the PacFIN database since 1981  by area (panel and color) and fleet (shading). Trawl gear (TW) includes all trawl, nets, and dredging. Fixed gear (FG) includes all other gear types.\label{fig:catch-comm-ts-pacfin}](../figures/catch-comm-ts-pacfin.png){width=100% height=100% alt="NA."}

![Percentage of California commercial catch by area within each fleet (fixed gear, FG, upper panel; trawl, TW, lower panel)since 1981. Darker shades represent the northern area and lighter shades represent the southern area.\label{fig:catch-comm-CA-gearprop}](../figures/catch-comm-CA-gearprop.png){width=100% height=100% alt="NA."}

![Mean length (mm) of released (top) and retained (bottom) fish from the recreational fishery for Washington (squares and dashed line), Oregon (triangles and dash-dot line), and California (circles and solid line)  by sex (columns). The average of retained fish across all years was used to translate numbers to weight for Washington.\label{fig:catch-rec-tsrecfinmeanlength}](../figures/catch-rec-tsrecfinmeanlength.png){width=100% height=100% alt="NA."}

![Comparison of recreational landings from this assessment (dashed line) versus the previous assessment (solid line) for each state (colors).\label{fig:catch-rec-ca-oldts}](../figures/catch-rec-ca-oldts.png){width=100% height=100% alt="NA."}

![Time series of California recreational landings (mt) for the northern (darker color) and southern (lighter color) areas. The shape of the points indicates the information source (California Recreational Fisheries Survey, CRFS; linear interpolation, interpolate; Marine Recreational Fisheries Statistics Survey, MRFSS; old Stock Synthesis, SS, model).\label{fig:catch-rec-CA-ts}](../figures/catch-rec-CA-ts.png){width=100% height=100% alt="NA."}

![Time series of recreational landings by state and area.\label{fig:catch-rec-ts}](../figures/catch-rec-ts.png){width=100% height=100% alt="NA."}


![Scaled quantile-quantile plot (left) and rank-transformed versus standardized residuals (right) for the binomial model of the commercial fixed-gear index.\label{fig:cpue-commercialfixed-gearqqbin}](../figures/cpue-commercialfixed-gearqqbin.png){width=100% height=100% alt="Residuals follow one to one line for the binomial model of the commercial fixed-gear index."}

![Scaled quantile-quantile plot (left) and rank-transformed versus standardized residuals (right) for the positive model of the commercial fixed-gear index.\label{fig:cpue-commercialfixed-gearqqpos}](../figures/cpue-commercialfixed-gearqqpos.png){width=100% height=100% alt="Residuals follow one to one line for the positive model of the commercial fixed-gear index."}

![Scaled quantile-quantile plot (left) and rank-transformed versus standardized residuals (right) for the binomial model of the recreational Oregon index.\label{fig:cpue-recreationalOregonqqbin}](../figures/cpue-recreationalOregonqqbin.png){width=100% height=100% alt="Residuals follow one to one line for the binomial model of the recreational Oregon index."}

![Scaled quantile-quantile plot (left) and rank-transformed versus standardized residuals (right) for the positive model of the recreational Oregon index.\label{fig:cpue-recreationalOregonqqpos}](../figures/cpue-recreationalOregonqqpos.png){width=100% height=100% alt="Residuals follow one to one line for the positive model of the recreational Oregon index."}


<!-- ====================================================================== -->
<!-- ******************     20Data figures     **************************** --> 
<!-- ====================================================================== -->

<!-- WCGBTS -->


![Presence/absence of lingcod in the WCGBTS by 25 m depth increments.\label{fig:wcgbts-presAbs}](../figures/WCGBTS_presence_absence_by_depth_bin.png){width=100% height=100% alt=""}


![Length frequency for male and females in the WCGBTS.\label{fig:wcgbts-lenComp}](../figures/WCGBTS - North _Length_Frequency.png){width=100% height=100% alt=""}




![Length frequency for male and females in the WCGBTS.\label{fig:wcgbts-ageComp}](../figures/WCGBTS - North _Age_Frequency.png){width=100% height=100% alt=""}




<!-- Triennial -->




![Length frequency for male and females in the Triennial survey.\label{fig:tri-lenComp}](../figures/Triennial - North _Length_Frequency.png){width=100% height=100% alt=""}




![Length frequency for male and females in the Triennial survey.\label{fig:tri-ageComp}](../figures/Triennial - North _Length_Frequency.png){width=100% height=100% alt=""}




<!-- Hook and Line -->








<!-- Lam research -->


![Length frequency for male and females from Lam research data.\label{fig:lam-lenComp}](../figures/Lam Thesis lengths Male-Female North_Length_Frequency.png){width=100% height=100% alt=""}




![Age frequency for male and females from Lam research data.\label{fig:lam-ageComp}](../figures/Lam Thesis ages Male-Female South_Age_Frequency.png){width=100% height=100% alt=""}



<!--- Oregon hook and line in marine reserves, index not used -->

```r
# Use figures-fi-index-ormarres.csv to bring in ordered set of figures
ignore <- apply(
  utils::read.csv(file.path("..", "figures", "figures-fi-index-ormarres.csv")),
  1,
  function(x) do.call(sa4ss::add_figure, args = as.list(x))
)
```


![\Glsentrylong{cpue} (\glsentryshort{cpue}) of positive, lingcod records within the Oregon hook and line survey within marine reserves.\label{fig:fi-index-ormarres-HistogramofPositiveCatchesLing}](../figures/fi-index-ormarres-HistogramofPositiveCatches_Ling.png){width=100% height=100% alt="Flat index with large uncertainty in recent years."}

![Frequency of positive catches of, lingcod across all years for the Oregon hook and line survey within marine reserves.\label{fig:fi-index-ormarres-BoxplotLingcodCPUERedfish}](../figures/fi-index-ormarres-Boxplot_LingcodCPUE_Redfish.png){width=100% height=100% alt="Large number of records with few `r spp`."}

![Relative mean \Glsentrylong{cpue} (\glsentryshort{cpue}), i.e., number of positive records per angler hour, for lingcod in the Oregon hook and line survey within marine reserves.\label{fig:fi-index-ormarres-RelativemeanLingcodCPUE95CI}](../figures/fi-index-ormarres-Relativemean_LingcodCPUE_95CI.png){width=100% height=100% alt="Index is centered around zero."}

<!-- ====================================================================== -->
<!-- ******************     Biology Figures     **************************** --> 
<!-- ====================================================================== -->


![Weight-length relationship for males and females from the WCGBTS.\label{fig:len-weight}](../figures/biology_exploration/Length_Weight_Combo_North.png){width=100% height=100% alt=""}




<!-- ====================================================================== -->
<!-- ******************     Recreational Length and Age Comps    ********** --> 
<!-- ====================================================================== -->


![Length distributions for the Washington recreational fleet for males and females.\label{fig:wa-lencomp-sexed}](../figures/WA Recreational - Sexed_Length_Frequency.png){width=100% height=100% alt=""}

![Length distributions for the Washington recreational fleet for unsexed fish.\label{fig:wa-lencomp-unsexed}](../figures/WA Recreational - Unsexed_Length_Frequency.png){width=100% height=100% alt=""}

![Length distributions for the Oregon recreational fleet for males and females.\label{fig:or-lencomp-sexed}](../figures/OR Recreational - Sexed_Length_Frequency.png){width=100% height=100% alt=""}

![Length distributions for the Oregon recreational fleet for unsexed fish.\label{fig:or-lencomp-unsexed}](../figures/OR Recreational - Unsexed_Length_Frequency.png){width=100% height=100% alt=""}

![Length distributions for the California recreational fleet north of 40 degrees 10 minuts N lattidue for males and females.\label{fig:ca-lencomp-sexed}](../figures/CA North Recreational - Sexed_Length_Frequency.png){width=100% height=100% alt=""}

![Length distributions for the California recreational fleet north of 40 degrees 10 minuts N lattidue for unsexed fish.\label{fig:ca-lencomp-unsexed}](../figures/CA North Recreational - Unsexed_Length_Frequency.png){width=100% height=100% alt=""}

![Age distributions for the Washington recreational fleet for males and females.\label{fig:wa-agecomp-sexed}](../figures/WA Recreational - Sexed_Age_Frequency.png){width=100% height=100% alt=""}

![Age distributions for the Washington recreational fleet for unsexed fish.\label{fig:wa-agecomp-unsexed}](../figures/WA Recreational - Unsexed_Age_Frequency.png){width=100% height=100% alt=""}

![Age distributions for the Oregon recreational fleet for males and females.\label{fig:or-agecomp-sexed}](../figures/OR Recreational - Sexed_Age_Frequency.png){width=100% height=100% alt=""}

![Age distributions for the Oregon recreational fleet for unsexed fish.\label{fig:or-agecomp-unsexed}](../figures/OR Recreational - Unsexed_Age_Frequency.png){width=100% height=100% alt=""}






<!--chapter:end:53Figures.Rmd-->

