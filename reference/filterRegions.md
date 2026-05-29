# Filter Regions

`filterRegions()` filters a region set using specified `covMin` and
`methSD` thresholds and then saves it as a tab-delimited text file.

## Usage

``` r
filterRegions(
  regions,
  covMin = 10,
  methSD = 0.05,
  save = TRUE,
  file = "Filtered_Regions.txt",
  verbose = TRUE
)
```

## Arguments

- regions:

  A `data.frame` output from
  [`getRegions()`](https://lasallegrp.github.io/comethyl/reference/getRegions.md)
  giving the set of regions and statistics for each region.

- covMin:

  A `numeric(1)` specifying the minimum number of reads at CpGs in a
  region in any sample

- methSD:

  A `numeric(1)` specifying the minimum methylation standard deviation
  in a region

- save:

  A `logical(1)` indicating whether to save the `data.frame`

- file:

  A `character(1)` giving the file name (.txt) for the saved
  `data.frame`

- verbose:

  A `logical(1)` indicating whether messages should be printed.

## Value

A filtered version of the `regions` `data.frame`

## Details

The purpose of this function is to use cutoffs for minimum coverage and
methylation standard deviation guided by other functions and obtain a
robust set of variably methylated regions. Computational resources are
also a consideration for network construction, with region sets of 250K
or less generally performing well.

## See also

- [`getRegions()`](https://lasallegrp.github.io/comethyl/reference/getRegions.md)
  to generate the set of regions.

- [`plotRegionStats()`](https://lasallegrp.github.io/comethyl/reference/plotRegionStats.md),
  [`plotSDstats()`](https://lasallegrp.github.io/comethyl/reference/plotSDstats.md),
  [`getRegionTotals()`](https://lasallegrp.github.io/comethyl/reference/getRegionTotals.md),
  and
  [`plotRegionTotals()`](https://lasallegrp.github.io/comethyl/reference/plotRegionTotals.md)
  for help visualizing region characteristics and setting cutoffs for
  filtering.

- [`getRegionMeth()`](https://lasallegrp.github.io/comethyl/reference/getRegionMeth.md)
  to get methylation values for these regions in all samples.

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
