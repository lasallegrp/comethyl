# Get Region Totals at Different Cutoffs

`getRegionTotals()` calculates the total number of regions, as well as
the total width and number of CpGs remaining in a region set after
filtering at different `covMin` and `methSD` cutoffs and then saves it
as a tab-delimited text file.

## Usage

``` r
getRegionTotals(
  regions,
  covMin = seq(0, 20, 2),
  methSD = seq(0, 0.1, 0.01),
  save = TRUE,
  file = "Region_Totals.txt",
  verbose = TRUE
)
```

## Arguments

- regions:

  A `data.frame` output from
  [`getRegions()`](https://lasallegrp.github.io/comethyl/reference/getRegions.md)
  giving the set of regions and statistics for each region.

- covMin:

  A `numeric` specifying the minimum number of reads at CpGs in a region
  in any sample for that region to be included in the total.

- methSD:

  A `numeric` specifying the minimum methylation standard deviation for
  that region to be included in the total.

- save:

  A `logical(1)` indicating whether to save the `data.frame`

- file:

  A `character(1)` giving the file name (.txt) for the saved
  `data.frame`

- verbose:

  A `logical(1)` indicating whether messages should be printed.

## Value

A `data.frame` giving the total number of regions, width, and number of
CpGs at all combinations of `covMin` and `methSD`.

## Details

The purpose of this function is to help balance cutoffs for minimum
coverage and methylation standard deviation and identify a robust set of
variably methylated regions. It's recommended to input multiple `covMin`
and `methSD` cutoffs for comparison. Computational resources are also a
consideration for network construction, with region sets of 250K or less
generally performing well.

## See also

- [`getRegions()`](https://lasallegrp.github.io/comethyl/reference/getRegions.md)
  to generate the set of regions.

- [`plotRegionStats()`](https://lasallegrp.github.io/comethyl/reference/plotRegionStats.md),
  [`plotSDstats()`](https://lasallegrp.github.io/comethyl/reference/plotSDstats.md),
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
