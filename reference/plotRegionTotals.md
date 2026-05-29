# Visualize Region Totals at Different Cutoffs

`plotRegionTotals()` plots the total number of regions, width, and total
number of CpGs remaining after filtering by different combinations of
`covMin` and `methSD` in a line plot and then saves it as a .pdf.

## Usage

``` r
plotRegionTotals(
  regionTotals,
  nBreaks = 4,
  legend.position = c(1.08, 0.897),
  save = TRUE,
  file = "Region_Totals.pdf",
  width = 11,
  height = 11,
  verbose = TRUE
)
```

## Arguments

- regionTotals:

  A `data.frame`, output from
  [`getRegionTotals()`](https://lasallegrp.github.io/comethyl/reference/getRegionTotals.md).

- nBreaks:

  A `numeric(1)` specifying the number of breaks used for both axes and
  the legend.

- legend.position:

  A `numeric(2)` specifying the position of the legend, as x-axis,
  y-axis. May also be a `character(1)` indicating "none", "left",
  "right", "bottom", or "top".

- save:

  A `logical(1)` indicating whether to save the plot.

- file:

  A `character(1)` giving the file name (.pdf) for the saved plot.

- width:

  A `numeric(1)` specifying the width in inches of the saved plot.

- height:

  A `numeric(1)` specifying the height in inches of the saved plot.

- verbose:

  A `logical(1)` indicating whether messages should be printed.

## Value

A `ggplot` object.

## Details

`plotRegionTotals()` is designed to be used in combination with
[`getRegionTotals()`](https://lasallegrp.github.io/comethyl/reference/getRegionTotals.md).
A `ggplot` object is produced and can be edited outside of this function
if desired.

## See also

- [`getRegions()`](https://lasallegrp.github.io/comethyl/reference/getRegions.md)
  to generate the set of regions.

- [`plotRegionStats()`](https://lasallegrp.github.io/comethyl/reference/plotRegionStats.md),
  [`plotSDstats()`](https://lasallegrp.github.io/comethyl/reference/plotSDstats.md),
  and
  [`getRegionTotals()`](https://lasallegrp.github.io/comethyl/reference/getRegionTotals.md)
  for more help visualizing region characteristics and setting cutoffs
  for filtering.

- [`filterRegions()`](https://lasallegrp.github.io/comethyl/reference/filterRegions.md)
  for filtering regions by minimum coverage and methylation standard
  deviation.

## Examples

``` r
if (FALSE) { # \dontrun{

# Call Regions
regions <- getRegions(bs, file = "Unfiltered_Regions.txt")
plotRegionStats(regions, maxQuantile = 0.99,
                file = "Unfiltered_Region_Plots.pdf")
plotSDstats(regions, maxQuantile = 0.99,
            file = "Unfiltered_SD_Plots.pdf")

# Examine Region Totals at Different Cutoffs
regionTotals <- getRegionTotals(regions, file = "Region_Totals.txt")
plotRegionTotals(regionTotals, file = "Region_Totals.pdf")

# Filter Regions
regions <- filterRegions(regions, covMin = 10, methSD = 0.05,
                         file = "Filtered_Regions.txt")
plotRegionStats(regions, maxQuantile = 0.99,
                file = "Filtered_Region_Plots.pdf")
plotSDstats(regions, maxQuantile = 0.99,
            file = "Filtered_SD_Plots.pdf")
} # }
```
