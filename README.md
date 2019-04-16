
<!-- README.md is generated from README.Rmd. Please edit that file -->

# steward

<!-- badges: start -->

<!-- badges: end -->

The goal of steward is to enable a package developer to embed a data
dictionary within their package using the Roxygen syntax. This results
in users being able to pull up the data dictionary using the helper
function and view the appropriate help document.

In the past, the developer would have to code by hand using Roxygen
syntax the data dictionary. This can lead to increased development time
and frustration. However, the Steward package aims to take a data
dictionary in either a YAML or CSV format and automatically create a
Roxygen output for the data dictionary contents.

## Class

The steward package is equipped with its own S3 class (called
`"stw_meta"`) that enables it to seamlessly read in either a YAML or CSV
file and convert to a Roxygen syntax.

## Installation

You can install the development version of steward from
[GitHub](https://github.com/uncoast-unconf/steward) with:

## Example: Read YAML

This is a basic example which shows you how to solve a common problem:

``` r
library(steward)
stw_read_yaml(system.file("metadata/diamonds.yaml", package = "steward"))
#> $name
#> [1] "diamonds"
#> 
#> $title
#> [1] "Prices of 50,000 round cut diamonds"
#> 
#> $description
#> [1] "A dataset containing the prices and other attributes of almost 54,000 diamonds."
#> 
#> $source
#> [1] "www.google.com"
#> 
#> $n_row
#> NULL
#> 
#> $n_col
#> NULL
#> 
#> $dictionary
#>       name      type
#> 1    price    double
#> 2    carat    double
#> 3      cut character
#> 4    color character
#> 5  clarity character
#> 6        x    double
#> 7        y    double
#> 8        z    double
#> 9    depth    double
#> 10   table    double
#>                                                                                          description
#> 1                                                               price in US dollars ($326 - $18,823)
#> 2                                                                     weight of diamond (0.2 - 5.01)
#> 3                                         quality of the cut (Fair, Good, Very Good, Premium, Ideal)
#> 4                                                          diamond color, from D (best) to J (worst)
#> 5  a measurement of how clear the diamond is (I1 (worst), SI2, SI1, VS2, VS1, VVS2, VVS1, IF (best))
#> 6                                                                             length in mm (0-10.74)
#> 7                                                                               width in mm (0-58.9)
#> 8                                                                               depth in mm (0-31.8)
#> 9                                  total depth percentage = z / mean(x, y) = 2 * z / (x + y) (43-79)
#> 10                                          width of top of diamond relative to widest point (43-95)
#> 
#> attr(,"class")
#> [1] "stw_meta"
```

## Example - Create Roxygen Meta

``` r

stw_to_roxygen(diamonds_meta)
#> #' Prices of 50,000 round cut diamonds
#> #' 
#> #' A dataset containing the prices and other attributes of almost 54,000 diamonds.
#> #' 
#> #' @format A data frame with 53940 rows and 10 variables:
#> #' 
#> #' \describe{ 
#> #'   \item{price}{price in US dollars ($326 - $18,823)}
#> #'   \item{carat}{weight of diamond (0.2 - 5.01)}
#> #'   \item{cut}{quality of the cut (Fair, Good, Very Good, Premium, Ideal)}
#> #'   \item{color}{diamond color, from D (best) to J (worst)}
#> #'   \item{clarity}{a measurement of how clear the diamond is (I1 (worst), SI2, SI1, VS2, VS1, VVS2, VVS1, IF (best))}
#> #'   \item{x}{length in mm (0-10.74)}
#> #'   \item{y}{width in mm (0-58.9)}
#> #'   \item{z}{depth in mm (0-31.8)}
#> #'   \item{depth}{total depth percentage = z / mean(x, y) = 2 * z / (x + y) (43-79)}
#> #'   \item{table}{width of top of diamond relative to widest point (43-95)}
#> #' }
#> #' @source www.google.com
#> "diamonds"
```

## Example - GT table
