# Plot Heatmaps of Region Standard Deviation vs Features

`plotSDstats()` takes a set of regions from
[`getRegions()`](https://lasallegrp.github.io/comethyl/reference/getRegions.md),
generates heatmaps of methylation standard deviation against region
features, and saves it as a pdf. Compared features include number of
CpGs, minimum coverage, mean coverage, and mean methylation.

## Usage

``` r
plotSDstats(
  regions,
  maxQuantile = 1,
  bins = 30,
  nBreaks = 4,
  legend.position = c(1.09, 0.9),
  save = TRUE,
  file = "SD_Plots.pdf",
  width = 8.5,
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

  A `numeric(1)` specifying the number of bins for both axes in each
  heatmap.

- nBreaks:

  A `numeric(1)` specifying the number of breaks for both axes.

- legend.position:

  A `numeric(2)` specifying the position of the legend, as x-axis,
  y-axis. May also be a `character(1)` indicating "none", "left",
  "right", "bottom", or "top".

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

It's recommended examine these plots before and after filtering to
ensure removal of regions with high variability due to insufficient
data. Plots are heatmaps of 2D bin counts, with the color indicating the
number of regions in that bin on the log10 scale. A `ggplot` object is
produced and can be edited outside of this function if desired.

## See also

- [`getRegions()`](https://lasallegrp.github.io/comethyl/reference/getRegions.md)
  to generate the set of regions.

- [`plotRegionStats()`](https://lasallegrp.github.io/comethyl/reference/plotRegionStats.md),
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
