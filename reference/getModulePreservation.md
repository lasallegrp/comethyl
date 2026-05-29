# Calculate Module Preservation

`getModulePreservation()` examines module replication between a
reference and a test data set by estimating various preservation
statistics, which are then saved as a .txt file. Correlations are
performed using either `pearson` or `bicor` methods.

## Usage

``` r
getModulePreservation(
  meth_disc,
  regions_disc,
  meth_rep,
  regions_rep,
  corType = c("pearson", "bicor"),
  maxPOutliers = 0.1,
  nPermutations = 100,
  save = TRUE,
  file = "Module_Preservation_Stats.txt",
  verbose = TRUE
)
```

## Arguments

- meth_disc:

  A `numeric matrix`, where each row is a sample and each column is a
  region. This is typically obtained from
  [`adjustRegionMeth()`](https://lasallegrp.github.io/comethyl/reference/adjustRegionMeth.md)
  and is related to the discovery (reference) data set.

- regions_disc:

  A `data.frame` of regions with module assignments, which is typically
  obtained from
  [`getModules()`](https://lasallegrp.github.io/comethyl/reference/getModules.md)
  and is related to the discovery data set.

- meth_rep:

  A `numeric matrix`, where each row is a sample and each column is a
  region. This is typically obtained from
  [`adjustRegionMeth()`](https://lasallegrp.github.io/comethyl/reference/adjustRegionMeth.md)
  and is related to the replication (test) data set.

- regions_rep:

  A `data.frame` of regions with module assignments, which is typically
  obtained from
  [`getModules()`](https://lasallegrp.github.io/comethyl/reference/getModules.md)
  and is related to the replication data set.

- corType:

  A `character(1)` indicating which correlation statistic to use in the
  adjacency calculation.

- maxPOutliers:

  A `numeric(1)` specifying the maximum percentile that can be
  considered outliers on each side of the median for the `bicor`
  statistic.

- nPermutations:

  A `numeric(1)` indicating the number of permutations to perform in the
  permutation test.

- save:

  A `logical(1)` indicating whether to save the `data.frame`.

- file:

  A `character(1)` giving the file name (.txt) for the saved
  `data.frame`.

- verbose:

  A `logical(1)` indicating whether messages should be printed.

## Value

A `data.frame` giving preservation statistics for each module in the
discovery data set.

## Details

Identical sets of regions should be assessed and assigned modules within
discovery (reference) and replication (test) data sets, though the
replication regions may be a subset of the discovery regions due to low
coverage. It's also recommended to filter CpGs so identical loci are
also assessed within regions. Network parameters should be as similar as
possible, although modules should be identified independently between
the discovery and replication datasets. Preservation statistics are
calculated by
[`WGCNA::modulePreservation()`](https://rdrr.io/pkg/WGCNA/man/modulePreservation.html),
with `corFnc` set to either `cor` or `bicor`. More information is given
in the documentation for
[`WGCNA::modulePreservation()`](https://rdrr.io/pkg/WGCNA/man/modulePreservation.html).

## See also

- [`getModules()`](https://lasallegrp.github.io/comethyl/reference/getModules.md)
  to build a comethylation network and identify modules of comethylated
  regions.

- [`plotModulePreservation()`](https://lasallegrp.github.io/comethyl/reference/plotModulePreservation.md)
  to visualize module preservation statistics.

## Examples

``` r
if (FALSE) { # \dontrun{
# Calculate Module Preservation
regions_disc <- modules_disc$regions
regions_rep <- modules_rep$regions
preservation <- getModulePreservation(methAdj_disc,
                                      regions_disc = regions_disc,
                                      meth_rep = methAdj_rep,
                                      regions_rep = regions_rep,
                                      corType = "pearson",
                                      file = "Module_Preservation_Stats.txt")

# Visualize Module Preservation
plotModulePreservation(preservation, file = "Module_Preservation_Plots.pdf")
} # }
```
