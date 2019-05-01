
<!-- README.md is generated from README.Rmd. Please edit that file -->

# steward

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The goal of **steward** is to make it easier to import, manage, and
publish the metadata associated with data frames. This might be useful
for:

  - [documenting a
    dataset](https://r-pkgs.org/data.html#documenting-data) for a
    package
  - publishing a data dictionary in an R Markdown document

Our current defintion of metadata includes the name, description and
source of a dataset, as well as the name, type, and description of each
of the variables in the dataset.

The name, steward, is an homage to the [Data
Stewardship](http://agron590-isu.github.io/) class taught by [Andee
Kaplan](https://github.com/andeek) and [Ranae
Dietzel](https://github.com/ranae) (also an author of this package) at
Iowa State University in Fall 2016.

## Installation

You can install the development version of steward from
[GitHub](https://github.com/uncoast-unconf/steward) with:

``` r
# install.packages("devtools")
devtools::install_github("uncoast-unconf/steward")
```

## Usage

``` r
library("steward")
```

### Current capabilities

You can read about these capabilities in the [getting started
article](https://uncoast-unconf.github.io/steward/articles/steward.html):

  - read from YAML
  - read from CSV
  - write to YAML
  - write to roxygen
  - write to [gt table](https://gt.rstudio.com)

Here are the first lines of a YAML file containing metadata from
[ggplot2](http://ggplot2.tidyverse.org)’s `diamonds` dataset, which is
available as:

``` r
system.file("metadata/diamonds.yml", package = "steward")
```

    name: diamonds
    title: Prices of 50,000 round cut diamonds
    description: |
     A dataset containing the prices and other attributes of almost 54,000 diamonds.
    n_row: 53940
    n_col: 10
    source: <http://www.diamondse.info/>
    dictionary:
        - name: price
          type: double
          description: price in US dollars ($326--$18,823)
    ...

You can read this YAML file using `stw_read_yaml()`:

``` r
diamonds_meta <-
  stw_read_yaml(system.file("metadata/diamonds.yml", package = "steward"))

print(diamonds_meta)
```

    List of 7
     $ name       : chr "diamonds"
     $ title      : chr "Prices of 50,000 round cut diamonds"
     $ description: chr "A dataset containing the prices and other attributes of almost 54,000 diamonds."
     $ source     : chr "<http://www.diamondse.info/>"
     $ n_row      : int 53940
     $ n_col      : int 10
     $ dictionary :Classes 'stw_dict' and 'data.frame': 10 obs. of  3 variables:
      ..$ name       : chr [1:10] "price" "carat" "cut" "color" ...
      ..$ type       : chr [1:10] "double" "double" "character" "character" ...
      ..$ description: chr [1:10] "price in US dollars ($326--$18,823)" "weight of diamond (0.2--5.01)" "quality of the cut (Fair, Good, Very Good, Premium, Ideal)" "diamond color, from D (best) to J (worst)" ...
     - attr(*, "class")= chr "stw_meta"

To get a roxygen string from metadata, you can use the
`stw_to_roxygen()` function:

``` r
cat(stw_to_roxygen(diamonds_meta))
```

    #' Prices of 50,000 round cut diamonds
    #' 
    #' A dataset containing the prices and other attributes of almost 54,000 diamonds.
    #' 
    #' @format A data frame with 53940 rows and 10 variables:
    #' 
    #' \describe{ 
    #'   \item{price}{price in US dollars ($326--$18,823)}
    #'   \item{carat}{weight of diamond (0.2--5.01)}
    #'   \item{cut}{quality of the cut (Fair, Good, Very Good, Premium, Ideal)}
    #'   \item{color}{diamond color, from D (best) to J (worst)}
    #'   \item{clarity}{a measurement of how clear the diamond is (I1 (worst), SI2, SI1, VS2, VS1, VVS2, VVS1, IF (best))}
    #'   \item{x}{length in mm (0--10.74)}
    #'   \item{y}{width in mm (0--58.9)}
    #'   \item{z}{depth in mm (0--31.8)}
    #'   \item{depth}{total depth percentage = z / mean(x, y) = 2 * z / (x + y) (43--79)}
    #'   \item{table}{width of top of diamond relative to widest point (43--95)}
    #' }
    #' @source <http://www.diamondse.info/>
    "diamonds"

You may also be interested in the related functions: `stw_use_roxygen()`
and `stw_write_roxygen()`.

### Future capabilities

Soon, we hope to add additional capabilities:

  - [combine metadata with
    dataset](https://github.com/uncoast-unconf/steward/issues/36)
      - [read and write combined
        dataset](https://github.com/uncoast-unconf/steward/issues/41)
        from/to flat files
  - take into account [timezone as column
    metadata](https://github.com/uncoast-unconf/steward/issues/39)
  - [build metadata from
    package-documentation](https://github.com/uncoast-unconf/steward/issues/43)
    (`.Rd` file)

## Related work

The [codebook](https://rubenarslan.github.io/codebook/) package can help
you manage dataset metadata.
