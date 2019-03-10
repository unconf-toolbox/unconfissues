
# unconfissues

The goal of `unconfissues` is to provide a central place for R
unconference developers to browse open and available issues, as well as
to celebrate the work done on closed issues.

## Installation

The development version of `unconfissues` is available from GitHub:

``` r
# install.packages("devtools")
devtools::install_github("unconf-toolbox/unconfissues")
```

## Usage

To run the sample [chirunconf19](https://chirunconf.github.io/) app:

``` r
unconfissues::run_app()
```

Note that running the app requires a GitHub Personal Access Token (PAT).
Instructions are available via thr [`projmgr`
package](https://emilyriederer.github.io/projmgr/articles/github-pat.html).

## Example

You can view an example version of this application applied to the
Chicago R Unconference 2019 by visiting
[rpodcast.shinyapps.io/unconfissues](https://rpodcast.shinyapps.io/unconfissues)
