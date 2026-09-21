# lingcod

This readme has been updated for the Lingcod 2027 stock assessment. The previous
version of this repository (previously named lingcod_2021) can be accessed under
the Releases link.

*Note: the assessment reports, model input files, and review panel report from 
the 2021 lingcod assessments are available at 
<https://www.pcouncil.org/stock-assessments-star-reports-stat-reports-rebuilding-analyses-terms-of-reference/groundfish-stock-assessment-documents/> (search for "lingcod").*

To interact with this repository 
  1. clone it to your computer `git clone https://github.com/pfmc-assessments/lingcod.git`, 
  2. open R and set your working directory to the cloned location, 
  3. run `devtools::load_all()`, and 
  4. make magic.

[Overview](#Overview)\
[Repository structure](#Repository-structure)\
[- DESCRIPTION](#DESCRIPTION)\
[- R](#R)\
[- data-raw](#data-raw)\
[- unfit](#unfit)\
[- example structure](#example-structure)\
[Development guidelines](#Development-guidelines)\
[Github issue guidelines](#Github-issues)\
[Modeling workflow](#Modeling-workflow)

## Disclaimer

*These materials do not constitute a formal publication and are for information 
only. They are in a pre-review, pre-decisional state and should not be formally 
cited (or reproduced). They are to be considered provisional and do not 
represent any determination or policy of NOAA or the Department of Commerce.*

## Overview {#overview}

This repository houses information related to the U.S. West Coast 2027 lingcod 
stock assessment, and historically the 2021 lingcod stock assessment. The 
repository is structured as an R package; though, there are additional 
directories that are not typically standard in an R package. There are many 
benefits to using R packages for science [(Vuorre and Crump, 2020)](https://link.springer.com/article/10.3758/s13428-020-01436-x) 
and given we are already familiar with using them for other purposes, it seems 
like a natural extension to use them for stock assessments as well. The structure
follows the [vertical](https://crumplab.github.io/vertical/) philosophy, though
does not apply that package in any scripts, combined with a [Google drive](https://drive.google.com/drive/u/0/folders/1j62p1DqDTnJS1BsdE8ddcyGw8SatbYTL) 
storage model for shared and confidential material.

The premise behind [vertical](https://crumplab.github.io/vertical/) is that 
everything must be portable across users and reproducible. Both of these 
features exist because users can expect a common directory structure when a 
project is designed using vertical. This may seem overly prescriptive at first 
but it should be helpful. While the 2021 version of this repository followed
this framework closely, the 2027 version is more loose in its application. 

## Repository structure {#repository-structure}

The following sections contain descriptive information about potential contents 
and how to interact with files and directories in this repository. Feel free to 
add new files or directories, just be sure to also add information to the 
.gitignore and .Rbuildignore files if you need to.

### DESCRIPTION {#description}

A plain text file that lists all of the necessary packages. Add packages that 
everyone must have to Imports, and `devtools::load_all()` will check that 
imported packages are installed. Add packages that are useful and people should 
install to Suggests, these are packages used for one-of analyses or preparing 
things that will not be touched again. Note that you will still need to use the 
`::` operator unless you add `@import` or `@importFrom`.

### R {#r}

A directory that stores R functions using .R files. All code in this folder 
should be used to create functions, i.e., no scripts or analyses. Files stored 
in this directory will be sourced upon loading the package, e.g., 
`devtools::load_all()` and the resulting R objects will be available to all in 
their workspace. Including functions in a single place facilitates loading 
functions without performing any analyses, the same as when you load the 
ggplot2 package. Other stock assessment teams could even load the lingcod 
package if they want to make use of the epic plotting functions that we **WILL** 
make.

If you have files that are not quite ready for deployment in this directory, 
then please commit them to the [Rscripts](#rscripts) directory and we can always 
move them later.

### data-raw {#data-raw}

A directory that stores 
\* base-level **CONFIDENTIAL** data that is **NOT** committed to the repository, 
\* base-level non-confidential data that is **NOT** committed to the repository, 

Most important, **DO NOT** commit confidential data. The [.gitignore](https://github.com/pfmc-assessments/lingcod/blob/main/.gitignore)
file is now setup to ignore everything in this folder. Previously, this folder
housed R-scripts and processed data that were committed. That is no longer the 
case.

#### data in data-raw

Choosing to not track a data file can be made for multiple reasons other than 
ensuring confidentiality. For example, files might be too large to be tracked, 
not have a tangible structure that can be tracked, be static and unlikely to 
change over time, or have been provided but not currently being used. Thus, 
[Google Drive](https://drive.google.com/drive/u/0/folders/18S_mEE9D1GlNa_VXX5AwyP_4YzPJNFda) is sufficient for their storage.

Because the data-raw folder is not committed, data are placed in the Google Drive
data-raw folder. If you go to the Lingcod_2027 Google Drive folder, you will see
a data-raw folder. Download all of the files at the top level of this directory 
and store into your local data-raw folder within the repository. Files within the
[Rscripts](#rscripts) are used to process data in data-raw, which are then saved
as .rdata files into the [data](#data) folder. 

When you receive an email with data or a contributor wants to provide data, 
add it to one of the following directories within the Google Drive data-raw 
directory: ASHOP, WCGOP, NOAA surveys, State surveys, Commercial, Recreational, 
Biology. Please use only those subfolders to avoid an overly complicated folder
structure. Save only the datasets in data-raw that we will use for processing. If
that file has a separate metadata file, that can be included, but relevant
manuscripts or work ups should not be saved in data-raw. If others provide data 
to you and you upload it to the Google Drive, please do not change 
the file name even if it has spaces in it ... just add it as is to maintain its 
traceability.

An extra step that you can do for fun within Google Drive is to provide 
shortcuts to shared folders, providing that include only files we will use. 
For example, WDFW shared a Google Drive folder with me called Lingcod. I added a 
folder in the Google Drive called data-raw/washington_sharedwithTheresa and 
added a link to her shared folder. Where possible, direct links to individual 
relevant files may be preferrable. This process is largely 
explained in the data-raw [README](https://drive.google.com/file/d/17FoJkkiYFQryskUmI0Ftz6Xl9_MVIKZv/view?usp=sharing).

### Rscripts {#rscripts}

Scripts inside this folder will be used to pull data files from data-raw, and 
create data objects and products to save as .rda files in data. In theory, 
scripts should be developed such that the following code from the top-level 
directory of lingcod_2021 will create all of the stored data objects and save 
them in data as .rda files:

```         
mapply(source, dir("Rscripts", pattern = "\\.R", full.names = TRUE))
```

For example, recreational fisheries catches are constructed from information 
stored in multiple data files within data-raw and code in [lingcod_catch.R](https://github.com/pfmc-assessments/lingcod/blob/bc849648dc94d09ec664e28f64cc849d36ac417a/data-raw/lingcod_catch.R). 
The result, [rec_catch_OR.rda](https://github.com/pfmc-assessments/lingcod/blob/bc849648dc94d09ec664e28f64cc849d36ac417a/data/rec_catch_OR.rda), 
is an R object that is available in everyone's workspace when the R package is 
loaded. This script also stores code to build other catch data frames that will 
be combined to create the time series of catches placed in the data file.

#### scripts in progress 

Previously, developmental R scripts were placed in the unfit folder, which was a 
storage and tracking location for 'unfit' information. We are no longer saving 
developmental code separately. For code that is not yet finished, ever do not commit
or commit to Rscripts and update until complete (to benefit from github tracking
progress).

#### Figures_explore

Use this folder as a holding group for exploratory figures showing results of
data explorations. Files that are a part of dedicated exploratory research should
not go there (place those in [Research_explore](#research)). Rather, this will
house figures generated during data exploration. Final figures used for the 
assessment report should be copied from here, and placed into the report/figures
folder, or saved there directly. Given that we wont know which figures are final
until they are added, it is best to place figures within Figures_explore. 

### Research_explore {#research}

Any files from early exploratory development and ideas are to be go into this
folder. The structure of it is less important, but discussion topics should be
used to organize findings and conclusions from your exploration, and any resultant
decisions should be reflected in the existing package structure using Rscripts 
and data files.

### Models

All developmental model runs should be saved here. Please use the naming 
convention as outlined in the models folder [README](https://github.com/pfmc-assessments/lingcod/blob/main/models/README.md).
Use the model_runs Rscript file to track and run your models, which allows 
reproducibility and allows us not to have to track every model run (as was done
for the 2021 assessment). Moreover, model files are saved within this repository
and no longer need to be saved to the Google Drive. Only the subset of files 
needed to run and read the model are committed to the repository based on the
.gitignore file. 

### Example structure {#example-structure}

The following directory structure should be adhered to when adding new files:

```         
lingcod
|----R
|    |    add_data.R
|    |    plot_ntable.R
|
|----data
|    |    rec_catch_OR.rda
|
|----data-raw
|    |    lingcod_catch.csv
|    |    Lingcod_2021_WCGOP_Discards_Strat1.xls
|
|----report
|    |----north
|    |----south
|    |    sar_USWC_Lingcod_skeleton.qmd
|
|----figures_explore
|
|----inst
|    |----extdata
|
|----man (`devtools::document()`)
|    |----roxygen
|         |----templates
|         |    data.R
|    |    rec_catch_OR.Rd
|
|----models
|
|----research_explore
|    |----stock_structure
|         |----2021.n.023.001_fixWAreccatchhistory
|         |----2021.s.018.001_fixTri3
|
|----tests
|
|    .Rbuildignore (lists directories and files that do not pertain to building the R package)
|    .gitignore (lists untracked directories and files)
|    [DESCRIPTION](#DESCRIPTION) (lists necessary R packages)
|    NAMESPACE (generated by roxgyen)
|    README.md (stores this content you are reading)
```

#### Remnant 2021 data folders

Any folders with the prefix 2021 are holdover folders from the previous stock 
assessment for lingcod, which in our case in the 2021 model. These folders are 
kept so users can see the structure of data and data-raw at that time. These 
folders are for reference only, should not be added to, and ultimately will be 
deleted at the end of the current assessment. 

## Development guidelines {#development-guidelines}

-   Do not commit any confidential data to this repository. Files placed in 
data-raw are ignored by default unless they have the .R extension. Use the 
[Google Drive](https://drive.google.com/drive/u/0/folders/1F5ibAgtjNhefiMF0Trda_PCEar3tQplF) 
folder to share data with team members (in data-raw) or other material (in 
shareable).
-   Hard wrap text at less than 80 characters; consider using a smaller number 
of characters if it leads to logical chunks. Think about how users will edit the
text and use that to guide where you should wrap lines.
-   Use decimal degrees rounded to 2 digits instead of minutes degrees for 
location information.
-   Colors for north and south are blue and red, respectively.
-   Please use a functional spell checker while developing within this 
repository.

## Github issue guidelines

If you think you should write something down, more than likely you should put it
in an issue or discussion. Issues are searchable and a great way to document 
actionable thoughts and volunteer (-told) people to do things. Discussions are 
also searchable and a great way to document non-actionable thoughts. Once a 
discussion becomes actionable, it should be moved to an issue using github's 
functionality. 

## Modeling workflow {#modeling-workflow}

todo: These can (and should) be updated more completely. 

### Examples at the end of [models/lingcod_model_bridging_new_exe.R](https://github.com/pfmc-assessments/lingcod/blob/main/models/lingcod_model_bridging_new_exe.R), and [models/lingcod_model_bridging_newdat.R](https://github.com/pfmc-assessments/lingcod/blob/main/models/lingcod_model_bridging_newdata.R)

) \* Add calls within the modeling script and use the functions 
`r4ss::copy_SS_inputs()`, `get_dir_ling()`, and `get_dir_exe()` to copy model 
files into a new folder. 
\* Use the `get_inputs_ling()` function to read the SS input files into R 
\* Modify the input files within R 
\* Write the modified files using `write_inputs_ling()` 
\* Run the model using either `r4ss::run_SS_models()`, command line commands, or
whatever approach you like 
\* Commit the model results to the repo (most files will be ignored thanks to 
`.gitignore`)

### Tools for looking at model results

-   Read model output and assign to workspace using a command like 
`get_mod(area = "n", num = 22, sens = 1)` **Note:** `get_mod()` is a wrapper 
for `r4ss::SS_output()` which saves you having to figure out the full path for 
the model, but also adds an `$area` element to the resulting list: "n" or "s" 
which is used in the next steps)
-   Make standard r4ss plots with custom colors: `make_r4ss_plots_ling(mod.2021.n.022.001, plot = 1:26)`
-   Make custom plots `make_r4ss_plots_ling(mod.2021.n.022.001, plot = 31:50)`
-   Two panel plot comparing two models `plot_twopanel_comparison(list(mod.2021.n.022.001, mod.2021.n.022.405), print = FALSE)`, just a wrapper for SSsummarize() %\>% SSplotComparisons() with a few extra defaults. Use argument `legendlabels = c("north base", "sensitivity blah blah blah")` if you want more in the key than the model ids.

### Future workflow steps:

-   We could run save the results of `SS_output()` (or `get_mod()`) as an .rda 
file for sensitivities and not just the base model when building the report


### Compiled pdf

-   The compiled pdf may or may not be pushed to github because of its size.

### steps Ian took to compile PDF from bare repo on 2026-08-26

-   clone repo to computer (in my case, this was a clean, new location, separate from the one I used in 2021)
-   add file `data-raw/catch.Rdata` (in <https://drive.google.com/drive/folders/1i1RF3cXyWfyQM7d2gK2nYm-BJXpDzwhr>)
-   add file `data-raw/reccpuewa-everything.RData` (in <https://drive.google.com/drive/folders/1i1RF3cXyWfyQM7d2gK2nYm-BJXpDzwhr>)
-   install {sa4ss}: `remotes::install_github("pfmc-assessments/sa4ss")`
-   install (update?) latex package via terminal command `tlmgr install xltabular`
-   `devtools::load_all()`
-   `compile_ling(dir = "North")`
-   `compile_ling(dir = "South")`

Note: the resulting PDFs are missing some figures and tables due to being excluded as noted in the list below.

### additional changes that have been pushed to github on 2026-08-26 so shouldn't be required by others:

-   push models/2021.n.023.001_fixWAreccatchhistory/CompReport.sso to github so it's available
-   push models/2021.s.018.001_fixTri3/\*.sso output files to github so they are available
-   set verbose = FALSE on line 181 of R/compile_ling.R to fix an error
-   comment out calls to table_ts() in doc/53tables.Rmd to skip dplyr error
-   hardwire "2021" instead of `substr(Sys.Date(),1,4)` in doc/53figures.Rmd
-   remove comma from alt-text in R/add_figure_vast.R
-   ask copilot "debug message: ! LaTeX cmd Error: Command '\AddToDocumentProperties' already defined." which led to modifications of doc/input_accessability.tex with the summary "the project explicitly loads the experimental PDF-management package while the current LaTeX format already provides the same command"
-   ask copilot "please fix another error: "! Package tagpdf Error: PDF resource management is not active! (tagpdf) tagpdf will not work.." which caused it to suggest changes to doc/sa4ss.sty and doc/input_accessability.tex
-   remove bibliography related code in sa4ss.sty which led to error "! Package natbib Error: Bibliography not compatible with author-year citations."
