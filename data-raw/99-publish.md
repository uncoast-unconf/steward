
``` r
library("steward")
```

``` r
diamonds_meta <- 
  stw_read_yaml(system.file("metadata/diamonds.yaml", package = "steward"))
```

``` r
devtools::use_data(
  diamonds_meta, 
  overwrite = TRUE
)
```

    ## Warning: 'devtools::use_data' is deprecated.
    ## Use 'usethis::use_data()' instead.
    ## See help("Deprecated") and help("devtools-deprecated").

    ## ✔ Setting active project to '/Users/ijlyttle/Documents/git/github/public_me/steward'
    ## ✔ Creating 'data/'
    ## ✔ Saving 'diamonds_meta' to 'data/diamonds_meta.rda'
