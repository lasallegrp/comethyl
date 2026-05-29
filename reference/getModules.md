# Identify Modules of Comethylated Regions

`getModules()` builds a comethylation network, identifies comethylated
modules, outputs a `list` with region module assignments, eigennode
values, dendrograms, and module membership, and then saves this as a
.rds file.

## Usage

``` r
getModules(
  meth,
  power,
  regions,
  maxBlockSize = 40000,
  corType = c("pearson", "bicor"),
  maxPOutliers = 0.1,
  deepSplit = 4,
  minModuleSize = 10,
  mergeCutHeight = 0.1,
  nThreads = 4,
  save = TRUE,
  file = "Modules.rds",
  verbose = TRUE
)
```

## Arguments

- meth:

  A `numeric matrix`, where each row is a sample and each column is a
  region. This is typically obtained from
  [`adjustRegionMeth()`](https://lasallegrp.github.io/comethyl/reference/adjustRegionMeth.md).

- power:

  A `numeric(1)` giving the soft-thresholding power. This is typically
  obtained from
  [`getSoftPower()`](https://lasallegrp.github.io/comethyl/reference/getSoftPower.md).

- regions:

  A `data.frame` of regions, typically after filtering with
  [`filterRegions()`](https://lasallegrp.github.io/comethyl/reference/filterRegions.md).
  Must have the column `RegionID` and correspond to the regions in
  `meth`.

- maxBlockSize:

  A `numeric(1)` specifying the maximum number of regions in a block. If
  there are more than this number regions, then regions are
  pre-clustered into blocks using projective K-means clustering.
  Decrease this if memory is insufficient.

- corType:

  A `character(1)` indicating which correlation statistic to use in the
  adjacency calculation.

- maxPOutliers:

  A `numeric(1)` specifying the maximum percentile that can be
  considered outliers on each side of the median for the `bicor`
  statistic.

- deepSplit:

  A `numeric(1)` specifying the sensitivity for module detection.
  Possible values are integers 0 to 4, with 4 having the highest
  sensitivity.

- minModuleSize:

  A `numeric(1)` giving the minimum number of regions to qualify as a
  module.

- mergeCutHeight:

  A `numeric(1)` specifying the cut height for merging correlated
  modules. Value is the maximum dissimilarity (1 - correlation) and
  ranges from 0 to 1.

- nThreads:

  A `numeric(1)` indicating the number of threads for correlation
  calculations.

- save:

  A `logical(1)` indicating whether to save the `list`.

- file:

  A `character(1)` giving the file name (.rds) for the saved `list`.

- verbose:

  A `logical(1)` indicating whether messages should be printed.

## Value

A `list` with 11 elements. See
[`WGCNA::blockwiseModules()`](https://rdrr.io/pkg/WGCNA/man/blockwiseModules.html)
for a description of these. Additional `regions` element is a
`data.frame` with the region locations, statistics, module assignment,
module membership, and hub region status.

## Details

Comethylation networks are built and modules are identified by
[`WGCNA::blockwiseModules()`](https://rdrr.io/pkg/WGCNA/man/blockwiseModules.html),
with `corType` set to either `pearson` or `bicor`. Calculations are
performed for a signed network in blocks of regions of maximum size
`maxBlockSize` (default = 40000). If there are more than `maxBlocksize`
regions, then regions are pre-clustered into blocks using projective
K-means clustering. Region correlations are performed within each block
and regions are clustered with average linkage hierarchical clustering.
Modules are then identified with a dynamic hybrid tree cut and highly
correlated modules are merged together. More information is given in the
documentation for
[`WGCNA::blockwiseModules()`](https://rdrr.io/pkg/WGCNA/man/blockwiseModules.html).

## See also

- [`getRegionMeth()`](https://lasallegrp.github.io/comethyl/reference/getRegionMeth.md),
  [`getPCs()`](https://lasallegrp.github.io/comethyl/reference/getPCs.md),
  and
  [`adjustRegionMeth()`](https://lasallegrp.github.io/comethyl/reference/adjustRegionMeth.md)
  to extract methylation data and then adjust it for the top principal
  components.

- [`getSoftPower()`](https://lasallegrp.github.io/comethyl/reference/getSoftPower.md)
  and
  [`plotSoftPower()`](https://lasallegrp.github.io/comethyl/reference/plotSoftPower.md)
  to estimate the best soft-thresholding power and visualize scale-free
  topology fit and connectivity.

- [`plotRegionDendro()`](https://lasallegrp.github.io/comethyl/reference/plotRegionDendro.md)
  and
  [`getModuleBED()`](https://lasallegrp.github.io/comethyl/reference/getModuleBED.md)
  to visualize region similarity, genomic locations, and module
  assignments.

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

# Visualize Comethylation Modules
plotRegionDendro(modules, file = "Region_Dendrograms.pdf")
BED <- getModuleBED(modules$regions, file = "Modules.bed")
} # }
```
