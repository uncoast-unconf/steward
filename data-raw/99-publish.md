
``` r
library("steward")
library("here")
```

    ## here() starts at /Users/sesa19001/Documents/repos/public/forked/steward

``` r
diamonds_meta <- 
  stw_read_meta_yaml(here("inst", "metadata", "diamonds.yml")) %>%
  stw_mutate_meta(
    n_row = 53940L,
    n_col = 10L    
  ) %>%
  stw_check("all")
```

    ## ✔ Dictionary names are unique.
    ## ✔ Dictionary names are all non-trivial.
    ## ✔ Dictionary descriptions are all non-trivial.
    ## ✔ Dictionary types are all recognized.
    ## ✔ Metadata has all required fields.
    ## ✔ Metadata sources valid.
    ## ✔ Metadata has all optional fields.

``` r
usethis::use_data(
  diamonds_meta, 
  overwrite = TRUE
)
```

    ## ✔ Setting active project to '/Users/sesa19001/Documents/repos/public/forked/steward'
    ## ✔ Saving 'diamonds_meta' to 'data/diamonds_meta.rda'
