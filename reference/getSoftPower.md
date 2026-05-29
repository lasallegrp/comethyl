# Estimate Soft Power Threshold

`getSoftPower()` analyzes scale-free topology to estimate the best
soft-thresholding power from a vector of powers, calculate fit indices,
and then saves this as a .rds file. Possible correlation statistics
include `pearson` and `bicor`.

## Usage

``` r
getSoftPower(
  meth,
  powerVector = 1:20,
  corType = c("pearson", "bicor"),
  maxPOutliers = 0.1,
  RsquaredCut = 0.8,
  blockSize = 40000,
  gcInterval = blockSize - 1,
  save = TRUE,
  file = "Soft_Power.rds",
  verbose = TRUE
)
```

## Arguments

- meth:

  A `numeric matrix`, where each row is a sample and each column is a
  region. This is typically obtained from
  [`adjustRegionMeth()`](https://lasallegrp.github.io/comethyl/reference/adjustRegionMeth.md).

- powerVector:

  A `numeric` specifying the soft power thresholds to examine for
  scale-free topology.

- corType:

  A `character(1)` indicating which correlation statistic to use in the
  adjacency calculation.

- maxPOutliers:

  A `numeric(1)` specifying the maximum percentile that can be
  considered outliers on each side of the median for the `bicor`
  statistic.

- RsquaredCut:

  A `numeric(1)` giving the minimum R-squared value for scale-free
  topology. Used to choose the best soft-thresholding power.

- blockSize:

  A `numeric(1)` specifying the number of regions in each block for the
  connectivity calculation. Decrease this if memory is insufficient.

- gcInterval:

  A `numeric(1)` indicating the interval for garbage collection.

- save:

  A `logical(1)` indicating whether to save the `list`.

- file:

  A `character(1)` giving the file name (.rds) for the saved `list`.

- verbose:

  A `logical(1)` indicating whether messages should be printed.

## Value

A `list` with two elements: `powerEstimate`, which gives the estimated
best soft-thresholding power, and `fitIndices`, which is a `data.frame`
with statistics on scale-free topology, including fit and connectivity,
along with network density, centralization, and heterogeneity.

## Details

Soft power is estimated by
[`WGCNA::pickSoftThreshold()`](https://rdrr.io/pkg/WGCNA/man/pickSoftThreshold.html),
with `corFnc` set to either `cor` or `bicor`. Calculations are performed
for a signed network in blocks of regions of size `blockSize` (default =
40000). The best soft power threshold is chosen as the lowest power
where fit (R-squared) is greater than `RsquaredCut` (default = 0.8).
More information is given in the documentation for
[`WGCNA::pickSoftThreshold()`](https://rdrr.io/pkg/WGCNA/man/pickSoftThreshold.html).

## See also

- [`getRegionMeth()`](https://lasallegrp.github.io/comethyl/reference/getRegionMeth.md),
  [`getPCs()`](https://lasallegrp.github.io/comethyl/reference/getPCs.md),
  and
  [`adjustRegionMeth()`](https://lasallegrp.github.io/comethyl/reference/adjustRegionMeth.md)
  to extract methylation data and then adjust it for the top principal
  components.

- [`plotSoftPower()`](https://lasallegrp.github.io/comethyl/reference/plotSoftPower.md)
  to visualize fit and connectivity for soft power estimation.

- [`getModules()`](https://lasallegrp.github.io/comethyl/reference/getModules.md)
  to build a comethylation network and identify modules of comethylated
  regions.

## Examples

``` r
if (FALSE) { # \dontrun{

# Get Methylation Data
meth <- getRegionMeth(regions, bs = bs, file = "Region_Methylation.rds")

# Adjust Methylation Data for PCs
mod <- model.matrix(~1, data = pData(bs))
PCs <- getPCs(meth, mod = mod, file = "Top_Principal_Components.rds")
methAdj <- adjustRegionMeth(meth, PCs = PCs,
                            file = "Adjusted_Region_Methylation.rds")

# Select Soft Power Threshold
sft <- getSoftPower(methAdj, corType = "pearson", file = "Soft_Power.rds")
plotSoftPower(sft, file = "Soft_Power_Plots.pdf")

# Get Comethylation Modules
modules <- getModules(methAdj, power = sft$powerEstimate, regions = regions,
                      corType = "pearson", file = "Modules.rds")
} # }
```
