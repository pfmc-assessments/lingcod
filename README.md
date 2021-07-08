# lingcod_2021

To interact with this repository
1. clone it to your computer `git clone https://github.com/iantaylor-NOAA/Lingcod_2021.git`,
2. open R and set your working directory to the cloned location,
3. run `devtools::load_all()`, and
4. make magic.

[Overview](#Overview)  
[Repository structure](#Repository-structure)  
[  - DESCRIPTION](#DESCRIPTION)  
[  - R](#R)  
[  - data-raw](#data-raw)  
[  - unfit](#unfit)  
[  - example structure](#example-structure)  
[Development guidelines](#Development-guidelines)  
[Github issue guidelines](#Github-issues)  
[Modeling workflow](#Modeling-workflow)  

## Disclaimer
_These materials do not constitute a formal publication and
are for information only. They are in a pre-review, pre-decisional state and
should not be formally cited (or reproduced). They are to be considered
provisional and do not represent any determination or policy of NOAA or the
Department of Commerce._

## Overview

This repository houses information related to the U.S. West Coast 2021 lingcod stock assessment.
The repository is structured as an R package; though,
there are additional directories that are not typically standard in an R package.
There are many benefits to using R packages for science
[(Vuorre and Crump, 2020)](https://link.springer.com/article/10.3758/s13428-020-01436-x) and
given we are already familiar with using them for other purposes,
it seems like a natural extension to use them for stock assessments as well.
The structure follows the [vertical][] philosophy combined with a
[Google drive](https://drive.google.com/drive/u/1/folders/1v6iw1IsV2bK5pm-Kke7QXtImvuetZ9B9)
with unlimited storage.

The premise behind [vertical][] is that everything must be
portable across users and reproducible.
Both of these features exist because users can expect a common
directory structure when a project is designed using vertical.
This may seem overly prescriptive at first but it should be helpful.

## Repository structure

The following sections contain descriptive information about
potential contents and how to interact with files and directories in this repository.
Feel free to add new files or directories, just be sure to also add information to
the .gitignore and .Rbuildignore files if you need to.

### DESCRIPTION

A plain text file that lists all of the necessary packages.
Add packages that everyone must have to Imports, and
`devtools::load_all()` will check that imported packages are installed.
Add packages that are useful and people should install to Suggests,
these are packages used for one-of analyses or preparing things that will not be touched again.
Note that you will still need to use the `::` operator unless you add `@import` or `@importFrom`.

### R

A directory that stores R functions using .R files.
All code in this folder should be used to create functions,
i.e., no scripts or analyses.
Files stored in this directory will be sourced upon loading the package,
e.g., `devtools::load_all()` and
the resulting R objects will be available to all in their workspace.
Including functions in a single place facilitates loading functions
without performing any analyses, the same as when you load the ggplot2 package.
Other stock assessment teams could even load the lingcod package
if they want to make use of the epic plotting functions that we **WILL** make.

If you have files that are not quite ready for deployment in this directory,
then please commit them to the [unfit](#unfit) directory and
we can always move them later.

### data-raw

A directory that stores
  * **CONFIDENTIAL** data that is **NOT** committed to the repository,
  * non-confidential data that is **NOT** committed to the repository,
  * other non-confidential data that is committed to the repository,
  * scripts to transform data-raw objects to data objects, and
  * other useful data-like files.

Most important, **DO NOT** commit confidential data.
The [.gitignore](https://github.com/iantaylor-NOAA/Lingcod_2021/blob/bc849648dc94d09ec664e28f64cc849d36ac417a/.gitignore)
file is setup to help you not commit confidential data by
only suggesting that you commit .R files that are saved within data-raw.
For example, when you add a new file called `test.csv` to data-raw
and run `git status` the output to the console will not include test.csv under
Untracked files; but, if you add `test.R` to data-raw,
`git status` will list the new file under Untracked files.

#### data in data-raw

Choosing to not track a data file can be made for multiple reasons other than
ensuring confidentiality. For example, files might
be too large to be tracked,
not have a tangible structure that can be tracked,
be static and unlikely to change over time, or
have been provided but not currently being used.
Thus, [Google Drive][] is sufficient for their storage.

If you go to the Lingcod_2021 Google Drive folder, you will see [data-raw][Google drive].
Download all of the files at the top level of this directory
if you want to run the scripts inside the repository version of data-raw.
Do not worry about downloading the directories stored within data-raw/
if you do not want to.
When you receive an email with data or a contributor wants to provide data,
think about adding it to a directory within the Google Drive data-raw directory.
If others provide data to you and you upload it to the Google Drive,
please do not change the file name even if it has spaces in it ...
just add it as is to maintain its traceability.

An extra step that you can do for fun within Google Drive is to provide
shortcuts to shared folders. For example, WDFW shared a Google Drive folder
with me called Lingcod. I added a folder in the Google Drive called
data-raw/washington_sharedwithTheresa and added a link to her shared folder
[here](https://drive.google.com/drive/folders/1C5vB3qmZQ2ENViJdtEhiADSwEcsIMb7e?usp=sharing).
I also added a link to the [actual catch file](https://drive.google.com/file/d/1N8GlCsdoLs4U2eLEKQKjdOqPHrer0VXf/view?usp=sharing)
she provided in data-raw/ rather than copying the file.
This process is largely explained in the data-raw
[README](https://drive.google.com/file/d/17FoJkkiYFQryskUmI0Ftz6Xl9_MVIKZv/view?usp=sharing).

#### scripts in data-raw

Scripts inside this folder will be used to create data objects and products.
In theory, scripts should be developed such that the following code
from the top-level directory of lingcod_2021 will create
all of the stored data objects and save them in data\ as .rda files:
```
mapply(source, dir("data-raw", pattern = "\\.R", full.names = TRUE))
```

For example, recreational fisheries catches are constructed from
information stored in multiple data files within data-raw and
code in [lingcod_catch.R](https://github.com/iantaylor-NOAA/Lingcod_2021/blob/bc849648dc94d09ec664e28f64cc849d36ac417a/data-raw/lingcod_catch.R).
The result, [rec_catch_OR.rda](https://github.com/iantaylor-NOAA/Lingcod_2021/blob/bc849648dc94d09ec664e28f64cc849d36ac417a/data/rec_catch_OR.rda),
is an R object that is available in everyone's workspace when the R package is loaded.
This script also stores code to build other catch data frames that will be combined
to create the time series of catches placed in the data file.

todo: more information about types of scripts and
where would you put a script that uses output?

### unfit

A storage and tracking location for 'unfit' information.
This could be scripts that were exploratory.
Feel free to add anything here that you want tracked but it
does not fit into the 'vertical' structure outlined by the 'rules' above.

### Example structure

The following directory structure should be adhered to when adding new files:
```
lingcod_2021
|----R
|    |    data.R
|    |    plot_ntable.R
|
|----data
|    |    rec_catch_OR.rda
|
|----data-raw
|    |    lingcod_catch.R
|    |    template.R
|
|----doc
|    |----north
|    |----south
|    |    lingcod_21f_rec_00.R
|
|----figures
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
|----slides
|
|----tables
|
|----tests
|
|----unfit
|
|    .Rbuildignore (lists directories and files that do not pertain to building the R package)
|    .gitignore (lists untracked directories and files)
|    [DESCRIPTION](#DESCRIPTION) (lists necessary R packages)
|    NAMESPACE (generated by roxgyen)
|    README.md (stores this content you are reading)
```

## Development guidelines

* Do not commit any confidential data to this repository.
Files placed in data-raw are ignored by default unless they have the .R extension.
Use the [Google Drive][] folder to share data with team members.
* Hard wrap text at less than 80 characters;
consider using a smaller number of characters if it leads to logical chunks.
Think about how users will edit the text and use that to guide where you should wrap lines.
* Use decimal degrees rounded to 2 digits instead of minutes degrees for location information.
* Colors for north and south are blue and red, respectively.
* Please have use a functional spell checker while developing within this repository.

## Github issue guidelines

If you think you should write something down, more than likely you should put it in an issue.
Issues are searchable and a great way to document thoughts and voluntold people to do things.

todo: provide information on how to use github issues for this repository

[Google drive]: https://drive.google.com/drive/folders/1i1RF3cXyWfyQM7d2gK2nYm-BJXpDzwhr?usp=sharing
[vertical]: https://crumplab.github.io/vertical/

## Modeling workflow

### [updated Friday, June 4]: examples at the end of [models/lingcod_model_bridging_new_exe.R](https://github.com/iantaylor-NOAA/Lingcod_2021/blob/main/models/lingcod_model_bridging_new_exe.R), and  [models/lingcod_model_bridging_newdat.R](https://github.com/iantaylor-NOAA/Lingcod_2021/blob/main/models/lingcod_model_bridging_newdata.R)
)
* Add rows to models/README.md for each model, including placeholders as needed
* Add a script with name like `models/lingcod_model_..._.R` which is focused on the
particular modeling task, and note the script name in the README file.
* Within the script, use the functions `r4ss::copy_SS_inputs()`, `get_dir_ling()`, 
and `get_dir_exe()` to copy model files into a new folder.
* Use the `get_inputs_ling()` function to read the SS input files into R
* Modify the input files within R
* Write the modified files using `write_inputs_ling()`
* Run the model using either `r4ss::run_SS_models()`, command line commands, 
or whatever approach you like
* Commit the model results to the repo (most files will be ignored 
thanks to `.gitignore`)

### Future workflow steps:
* For models with results that will be referenced in the table, we should run
`r4ss::SS_output()` and save the results as an .rda file
* If the repo is getting too big we can delete most of the .sso files from the repo
and rely on Google Drive to pass these back and forth

### Compiled pdf

* The compiled pdf can be found on
[google drive](https://drive.google.com/drive/folders/10-AZ7J51LoQ-YIFPLPKnyH_X2gu4lFZF?usp=sharing)
and is not always pushed to github because of its size.
