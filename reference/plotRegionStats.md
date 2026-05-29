# Plot Histograms of Region Statistics

`plotRegionStats()` takes a set of regions from
[`getRegions()`](https://lasallegrp.github.io/comethyl/reference/getRegions.md),
generates histograms of region characteristics, and saves it as a pdf.
Region-level statistics include width, number of CpGs, minimum coverage,
mean coverage, mean methylation, and methylation standard deviation.

## Usage

``` r
plotRegionStats(
  regions,
  maxQuantile = 1,
  bins = 30,
  histCol = "#132B43",
  lineCol = "red",
  nBreaks = 4,
  save = TRUE,
  file = "Region_Plots.pdf",
  width = 11,
  height = 8.5,
  verbose = TRUE
)
```

## Arguments

- regions:

  A `data.frame` output from
  [`getRegions()`](https://lasallegrp.github.io/comethyl/reference/getRegions.md)
  giving the set of regions and statistics for each region.

- maxQuantile:

  A `numeric(1)` giving the maximum quantile of each feature to plot.

- bins:

  A `numeric(1)` specifying the number of bins in each histogram.

- histCol:

  A `character(1)` giving the color of the histogram.

- lineCol:

  A `character(1)` giving the color of the vertical median line.

- nBreaks:

  A `numeric(1)` specifying the number of breaks for the x-axis.

- save:

  A `logical(1)` indicating whether to save the plot.

- file:

  A `character(1)` giving the file name (.pdf) for the plot.

- width:

  A `numeric(1)` specifying the width in inches of the saved plot.

- height:

  A `numeric(1)` specifying the height in inches of the saved plot.

- verbose:

  A `logical(1)` indicating whether messages should be printed.

## Value

A `ggplot` object.

## Details

It's recommended to examine region characteristics before and after
filtering. The vertical line on each histogram indicates the median
value for that feature. A `ggplot` object is produced and can be edited
outside of this function if desired.

## See also

- [`getRegions()`](https://lasallegrp.github.io/comethyl/reference/getRegions.md)
  to generate the set of regions.

- [`plotSDstats()`](https://lasallegrp.github.io/comethyl/reference/plotSDstats.md),
  [`getRegionTotals()`](https://lasallegrp.github.io/comethyl/reference/getRegionTotals.md),
  and
  [`plotRegionTotals()`](https://lasallegrp.github.io/comethyl/reference/plotRegionTotals.md)
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
