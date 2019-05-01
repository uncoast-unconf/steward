
``` r
library("steward")
library("here")
```

    ## here() starts at /Users/sesa19001/Documents/repos/public/forked/steward

``` r
diamonds_meta <- stw_read_meta_yaml(here("inst", "metadata", "diamonds.yml"))

diamonds_meta
```

    ## List of 7
    ##  $ name       : chr "diamonds"
    ##  $ title      : chr "Prices of 50,000 round cut diamonds"
    ##  $ description: chr "A dataset containing the prices and other attributes of almost 54,000 diamonds."
    ##  $ source     : chr "<http://www.diamondse.info/>"
    ##  $ n_row      : int 53940
    ##  $ n_col      : int 10
    ##  $ dict       :Classes 'stw_dict' and 'data.frame':  10 obs. of  3 variables:
    ##   ..$ name       : chr [1:10] "price" "carat" "cut" "color" ...
    ##   ..$ type       : chr [1:10] "double" "double" "character" "character" ...
    ##   ..$ description: chr [1:10] "price in US dollars ($326--$18,823)" "weight of diamond (0.2--5.01)" "quality of the cut (Fair, Good, Very Good, Premium, Ideal)" "diamond color, from D (best) to J (worst)" ...
    ##  - attr(*, "class")= chr "stw_meta"

``` r
usethis::use_data(
  diamonds_meta, 
  overwrite = TRUE
)
```

    ## ✔ Setting active project to '/Users/sesa19001/Documents/repos/public/forked/steward'
    ## ✔ Saving 'diamonds_meta' to 'data/diamonds_meta.rda'
