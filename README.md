
<!-- README.md is generated from README.Rmd. Please edit that file -->

# steward

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R build
status](https://github.com/uncoast-unconf/steward/workflows/R-CMD-check/badge.svg)](https://github.com/uncoast-unconf/steward)
<!-- badges: end -->

The goal of **steward** is to make it easier to import, manage, and
publish the metadata associated with data frames. This might be useful
for:

  - [documenting a
    dataset](https://r-pkgs.org/data.html#documenting-data) for a
    package
  - publishing a data-dictionary [table](https://gt.rstudio.com) in an R
    Markdown document

Our current defintion of metadata includes the name, description and
source of a dataset, as well as the name, type, and description of each
of the variables in the dataset.

The name, steward, is an homage to the [Data
Stewardship](http://agron590-isu.github.io/) class taught by [Andee
Kaplan](https://github.com/andeek) and [Ranae
Dietzel](https://github.com/ranae) (also an author of this package) at
Iowa State University in Fall 2016.

This package was first built collaborativey at the [Uncoast
Unconf](https://uuconf.rbind.io), held at Des Moines in April 2019.

## Installation

You can install the development version of steward from
[GitHub](https://github.com/uncoast-unconf/steward) with:

``` r
# install.packages("devtools")
devtools::install_github("uncoast-unconf/steward")
```

## Usage

In our [getting started
article](https://uncoast-unconf.github.io/steward/articles/steward.html),
we describe some common tasks:

  - create a “steward” dataset.
  - write a dataset to a package, with documentation.
  - create a [gt table](https://gt.rstudio.com).

### Future development

We plan to release this package to CRAN as soon as the
[gt](https://gt.rstudio.com) package is released there.

Some of the capabilities we plan to develop:

  - take into account [timezone as column
    metadata](https://github.com/uncoast-unconf/steward/issues/39)
  - [build metadata from
    package-documentation](https://github.com/uncoast-unconf/steward/issues/43)
    (`.Rd` file)

## Related work

The [codebook](https://rubenarslan.github.io/codebook) package can help
you manage dataset metadata.

## Code of conduct

Please note that the {steward} project is released with a [Contributor
Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this project,
you agree to abide by its terms.
