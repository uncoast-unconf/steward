
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

The current capabilities all deal with metadata:

  - [read from YAML](#read-yaml)
  - [read from CSV](#read-csv)
  - [write to YAML](#write-yaml)
  - [write to roxygen](#write-roxygen)
  - [write to gt table](#write-gt-table)

### Future capabilities

Soon, we hope to add additional capabilities:

  - [write metadata to
    YAML](https://github.com/uncoast-unconf/steward/issues/42)
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

#### Read YAML

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

We can read a YAML file using `stw_read_yaml()`:

``` r
stw_read_yaml(system.file("metadata/diamonds.yml", package = "steward"))
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

#### Read CSV

This is an emerging capability that we need to document.

#### Write YAML

To get a YAML string from metadata, you can use the `stw_to_yaml()`
function. Here are the first few lines:

``` r
cat(stw_to_yaml(diamonds_meta))
```

    name: diamonds
    title: Prices of 50,000 round cut diamonds
    description: A dataset containing the prices and other attributes of almost 54,000
      diamonds.
    source: <http://www.diamondse.info/>
    n_row: 53940
    n_col: 10
    dictionary:
    - name: price
      type: double
      description: price in US dollars ($326--$18,823)
    ...

Other functions in this family:

  - `stw_use_yaml()` copies the YAML string to the clipboard.
  - `stw_write_yaml()` writes the YAML string to a file.

#### Write roxygen

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

Other functions in this family:

  - `stw_use_roxygen()` copies the roxygen string to the clipboard.
  - `stw_write_roxygen()` writes the roxygen string to a file.

#### Write gt Table

If you are creating an R Markdown document, you can use the
`stw_to_table()` function to create a [gt
table](https://gt.rstudio.com):

``` r
stw_to_table(diamonds_meta)
```

<!--html_preserve-->

<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#sjkfbydmeh .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #000000;
  font-size: 16px;
  background-color: #FFFFFF;
  /* table.background.color */
  width: auto;
  /* table.width */
  border-top-style: solid;
  /* table.border.top.style */
  border-top-width: 2px;
  /* table.border.top.width */
  border-top-color: #A8A8A8;
  /* table.border.top.color */
}

#sjkfbydmeh .gt_heading {
  background-color: #FFFFFF;
  /* heading.background.color */
  border-bottom-color: #FFFFFF;
}

#sjkfbydmeh .gt_title {
  color: #000000;
  font-size: 125%;
  /* heading.title.font.size */
  padding-top: 4px;
  /* heading.top.padding */
  padding-bottom: 1px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#sjkfbydmeh .gt_subtitle {
  color: #000000;
  font-size: 85%;
  /* heading.subtitle.font.size */
  padding-top: 1px;
  padding-bottom: 4px;
  /* heading.bottom.padding */
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#sjkfbydmeh .gt_bottom_border {
  border-bottom-style: solid;
  /* heading.border.bottom.style */
  border-bottom-width: 2px;
  /* heading.border.bottom.width */
  border-bottom-color: #A8A8A8;
  /* heading.border.bottom.color */
}

#sjkfbydmeh .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  padding-top: 4px;
  padding-bottom: 4px;
}

#sjkfbydmeh .gt_col_heading {
  color: #000000;
  background-color: #FFFFFF;
  /* column_labels.background.color */
  font-size: 16px;
  /* column_labels.font.size */
  font-weight: initial;
  /* column_labels.font.weight */
  vertical-align: middle;
  padding: 10px;
  margin: 10px;
}

#sjkfbydmeh .gt_sep_right {
  border-right: 5px solid #FFFFFF;
}

#sjkfbydmeh .gt_group_heading {
  padding: 8px;
  color: #000000;
  background-color: #FFFFFF;
  /* row_group.background.color */
  font-size: 16px;
  /* row_group.font.size */
  font-weight: initial;
  /* row_group.font.weight */
  border-top-style: solid;
  /* row_group.border.top.style */
  border-top-width: 2px;
  /* row_group.border.top.width */
  border-top-color: #A8A8A8;
  /* row_group.border.top.color */
  border-bottom-style: solid;
  /* row_group.border.bottom.style */
  border-bottom-width: 2px;
  /* row_group.border.bottom.width */
  border-bottom-color: #A8A8A8;
  /* row_group.border.bottom.color */
  vertical-align: middle;
}

#sjkfbydmeh .gt_empty_group_heading {
  padding: 0.5px;
  color: #000000;
  background-color: #FFFFFF;
  /* row_group.background.color */
  font-size: 16px;
  /* row_group.font.size */
  font-weight: initial;
  /* row_group.font.weight */
  border-top-style: solid;
  /* row_group.border.top.style */
  border-top-width: 2px;
  /* row_group.border.top.width */
  border-top-color: #A8A8A8;
  /* row_group.border.top.color */
  border-bottom-style: solid;
  /* row_group.border.bottom.style */
  border-bottom-width: 2px;
  /* row_group.border.bottom.width */
  border-bottom-color: #A8A8A8;
  /* row_group.border.bottom.color */
  vertical-align: middle;
}

#sjkfbydmeh .gt_striped {
  background-color: #f2f2f2;
}

#sjkfbydmeh .gt_from_md > :first-child {
  margin-top: 0;
}

#sjkfbydmeh .gt_from_md > :last-child {
  margin-bottom: 0;
}

#sjkfbydmeh .gt_row {
  padding: 10px;
  /* row.padding */
  margin: 10px;
  vertical-align: middle;
}

#sjkfbydmeh .gt_stub {
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #A8A8A8;
  padding-left: 12px;
}

#sjkfbydmeh .gt_stub.gt_row {
  background-color: #FFFFFF;
}

#sjkfbydmeh .gt_summary_row {
  background-color: #FFFFFF;
  /* summary_row.background.color */
  padding: 6px;
  /* summary_row.padding */
  text-transform: inherit;
  /* summary_row.text_transform */
}

#sjkfbydmeh .gt_first_summary_row {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
}

#sjkfbydmeh .gt_table_body {
  border-top-style: solid;
  /* table_body.border.top.style */
  border-top-width: 2px;
  /* table_body.border.top.width */
  border-top-color: #A8A8A8;
  /* table_body.border.top.color */
  border-bottom-style: solid;
  /* table_body.border.bottom.style */
  border-bottom-width: 2px;
  /* table_body.border.bottom.width */
  border-bottom-color: #A8A8A8;
  /* table_body.border.bottom.color */
}

#sjkfbydmeh .gt_footnote {
  font-size: 90%;
  /* footnote.font.size */
  padding: 4px;
  /* footnote.padding */
}

#sjkfbydmeh .gt_sourcenote {
  font-size: 90%;
  /* sourcenote.font.size */
  padding: 4px;
  /* sourcenote.padding */
}

#sjkfbydmeh .gt_center {
  text-align: center;
}

#sjkfbydmeh .gt_left {
  text-align: left;
}

#sjkfbydmeh .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#sjkfbydmeh .gt_font_normal {
  font-weight: normal;
}

#sjkfbydmeh .gt_font_bold {
  font-weight: bold;
}

#sjkfbydmeh .gt_font_italic {
  font-style: italic;
}

#sjkfbydmeh .gt_super {
  font-size: 65%;
}

#sjkfbydmeh .gt_footnote_glyph {
  font-style: italic;
  font-size: 65%;
}
</style>

<div id="sjkfbydmeh" style="overflow-x:auto;">

<!--gt table start-->

<table class="gt_table">

<thead>

<tr>

<th colspan="3" class="gt_heading gt_title gt_font_normal gt_center">

DIAMONDS

</th>

</tr>

<tr>

<th colspan="3" class="gt_heading gt_subtitle gt_font_normal gt_center gt_bottom_border">

Prices of 50,000 round cut diamonds

</th>

</tr>

</thead>

<tr>

<th class="gt_col_heading gt_left" rowspan="1" colspan="1">

Name

</th>

<th class="gt_col_heading gt_left" rowspan="1" colspan="1">

Type

</th>

<th class="gt_col_heading gt_left" rowspan="1" colspan="1">

Description

</th>

</tr>

<tbody class="gt_table_body">

<tr>

<td class="gt_row gt_left" style="font-style:italic;">

price

</td>

<td class="gt_row gt_left">

double

</td>

<td class="gt_row gt_left">

price in US dollars ($326–$18,823)

</td>

</tr>

<tr>

<td class="gt_row gt_left gt_striped" style="font-style:italic;">

carat

</td>

<td class="gt_row gt_left gt_striped">

double

</td>

<td class="gt_row gt_left gt_striped">

weight of diamond (0.2–5.01)

</td>

</tr>

<tr>

<td class="gt_row gt_left" style="font-style:italic;">

cut

</td>

<td class="gt_row gt_left">

character

</td>

<td class="gt_row gt_left">

quality of the cut (Fair, Good, Very Good, Premium, Ideal)

</td>

</tr>

<tr>

<td class="gt_row gt_left gt_striped" style="font-style:italic;">

color

</td>

<td class="gt_row gt_left gt_striped">

character

</td>

<td class="gt_row gt_left gt_striped">

diamond color, from D (best) to J (worst)

</td>

</tr>

<tr>

<td class="gt_row gt_left" style="font-style:italic;">

clarity

</td>

<td class="gt_row gt_left">

character

</td>

<td class="gt_row gt_left">

a measurement of how clear the diamond is (I1 (worst), SI2, SI1, VS2,
VS1, VVS2, VVS1, IF (best))

</td>

</tr>

<tr>

<td class="gt_row gt_left gt_striped" style="font-style:italic;">

x

</td>

<td class="gt_row gt_left gt_striped">

double

</td>

<td class="gt_row gt_left gt_striped">

length in mm (0–10.74)

</td>

</tr>

<tr>

<td class="gt_row gt_left" style="font-style:italic;">

y

</td>

<td class="gt_row gt_left">

double

</td>

<td class="gt_row gt_left">

width in mm (0–58.9)

</td>

</tr>

<tr>

<td class="gt_row gt_left gt_striped" style="font-style:italic;">

z

</td>

<td class="gt_row gt_left gt_striped">

double

</td>

<td class="gt_row gt_left gt_striped">

depth in mm (0–31.8)

</td>

</tr>

<tr>

<td class="gt_row gt_left" style="font-style:italic;">

depth

</td>

<td class="gt_row gt_left">

double

</td>

<td class="gt_row gt_left">

total depth percentage = z / mean(x, y) = 2 \* z / (x + y) (43–79)

</td>

</tr>

<tr>

<td class="gt_row gt_left gt_striped" style="font-style:italic;">

table

</td>

<td class="gt_row gt_left gt_striped">

double

</td>

<td class="gt_row gt_left gt_striped">

width of top of diamond relative to widest point (43–95)

</td>

</tr>

</tbody>

<tfoot>

<tr>

<td colspan="4" class="gt_sourcenote">

<http://www.diamondse.info/>

</td>

</tr>

</tfoot>

</table>

<!--gt table end-->

</div>

<!--/html_preserve-->

## Related work

The [codebook](https://rubenarslan.github.io/codebook/) package can help
you manage dataset metadata.
