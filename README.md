# lingcod_2021

## Overview

A place to gather stuff related to the U.S. West Coast 2021 lingcod stock assessment.
The repository is structured as an R package; though,
there are additional directories that are not typically standard in an R package.
The structure is designed using the
[vertical](crumplab.github.io/vertical/) philosophy.
We will also use Google drive for sharing
large resources that do not need version control,
such as peer-reviewed references and historical assessment documents,
and
interactive documents, such as meeting notes.

To interact with this repository
(1) clone it to your computer,
(2) open R and navigate to the repository location,
(3) run `devtools::load_all()`, and
(4) make magic.

## Repository structure

The following directory structure should be adhered to when adding new files:
```
lingcod_2021
|----R
|    |    utils-pipe.R
|
|----data
|
|----data-raw
|    |    template.R
|
|----figures
|
|----inst
|    |----extdata
|
|----man
|
|----sa
|
|----slides
|
|----tables
|
|----tests
|
|----vignettes
|
|    .Rbuildignore
|    .gitignore
|    DESCRIPTION
|    NAMESPACE
|    README.md
```

When developing the package, edit the following files or add to these directories
while adhering to the suggested guidelines:
* .gitignore: Add names of files or directories that you do not want tracked to this file.
* .Rbuildignore: Add names of files or directories that are not a part of the package to this file.
* DESCRIPTION: A plain text file that lists all of the necessary packages.
Add packages that everyone must have to Imports, and
`devtools::load_all()` will check that imported packages are installed.
Add packages that are useful and people should install to Suggests,
these are packages used for one-of analyses or preparing things that will not be touched again.
Note that you will still need to use the `::` operator unless you add `@import` or `@importFrom`.
* data-raw/:
  * .R files to process data and turn them into R objects that are available within the package.
  * Pre-processed or raw data files that are not tracked by version control.
  Not tracking these files may be because
  they are too large to version,
  maintaining vessel confidentiality would be compromised,
  not all information in the original file is applicable to this analysis,
  etc.
  These files are available on the network or in the Google drive.
  Consider downloading copies of the files on the Google drive for your local use to this folder.
  For confidential data, consider using `"\\\\nwcfile\\Assessments\\"` or something similar
  to access the network files without needing to place them on your personal machine.
  For some code, the use of the network in this manner is not functional,
  though I cannot remember when or why. Instead, mapping the network worked for me.
* R/: A directory that stores functions using .R files.
All code in this folder should be source-able or self contained regardless of your
computing environment, i.e., no scripts or analyses ... only functions.
Files stored in this directory will be sourced when users run `devtools::load_all()` and
the resulting R objects will be available to all in their workspace.
Formally including functions in the package in this manner will increase reproducibility.
Think about how difficult it can be to come back to an analysis years later when functions
are littered throughout the code; including all functions in a single place allows
functions to be loaded without performing any analyses.
* sa/: A directory to hold [sa4ss](github.com/nwfsc-assess/sa4ss) directories.
* slides/: A directory to hold slide decks.
Slide decks can also be stored on the Google drive if interactive development is needed.
For example, the slide deck for the pre-assessment workshop is available in
Lingcod_2021/meetings/pre-assessment_workshop/Lingcod data workshop presentation.
* vignettes/: This directory holds documents to teach others about lingcod.
All vignettes are built when compiling the package and viewable if we were to create a website.
You can create a new vignette using 
`usethis::use_vignette(name = "lingcod_myvignette"), title = "My vignette")`
* tests/:
* Do not manually edit the following files or directories
  * NAMESPACE: Resulting plain text file from running `devtools::document()`.
  * data/: Resulting .rda files from running
  `mapply(source, dir("data-raw", pattern = "\\.R", full.names = TRUE))`.
  * figures/:
  * man/: Resulting .Rd files from running `devtools::document()`.
  * tables/:

## Development guide lines

* Do not commit any confidential data to this repository.
Files placed in data-raw are ignored by default unless they have the .R extension.
Use the network to store confidential data or
the google drive folder to share data with team members that do not have access to the network.
* Hard wrap text at less than 80 characters;
consider using a smaller number of characters if it leads to logical chunks.
Think about how users will edit the text and use that to guide where you should wrap lines.
* Use decimal degrees rounded to 2 digits instead of minutes degrees for location information.
* Colors for north and south are blue and red, respectively.
* Please have use a functional spell checker while developing within this repository.
