
<!-- README.md is generated from README.Rmd. Please edit that file -->

# qOpsTools

<!-- badges: start -->
<!-- badges: end -->

qOpsTools provides a few helper functions for GOI workflow with R,
including standard folder structures and some simple functions.

## Installation

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("goiops/qOpsTools")
```

## Example

The most common use of qOpsTools is to create a standard project folder
directory setup. The code will also add some simple boilerplate,
intended to reduce the amount of overhead in setting up a new analysis.

You can create a standard, simple folder structure using:

``` r
qOpsTools::init_project()
```

More than likely you’ll want to use the “ems” or “teradata” settings -
either will add extra boilerplate to speed up work:

``` r
qOpsTools::init_project("teradata")
qOpsTools::init_project("ems")
```

If you know ahead of time additional packages you’re probably going to
use, you can add them to the 00 Functions file using:

``` r
qOpsTools::init_project(additional_packages = "mgcv")
```
