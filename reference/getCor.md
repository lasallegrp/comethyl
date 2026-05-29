# Calculate Correlations

`getCor()` calculates correlation coefficients using either `pearson` or
`bicor` methods. Calculations can be done between columns of a single
matrix or between two vectors or matrices.

## Usage

``` r
getCor(
  x,
  y = NULL,
  transpose = FALSE,
  corType = c("bicor", "pearson"),
  maxPOutliers = 0.1,
  robustY = TRUE,
  verbose = TRUE
)
```

## Arguments

- x:

  A `numeric vector` or `matrix`. `x` must be a `matrix` if `y` is null.

- y:

  A `numeric vector` or `matrix`. If null, correlations will be
  calculated for columns of `x`.

- transpose:

  A `logical(1)` specifying whether to transpose the `matrix`.

- corType:

  A `character(1)` indicating which correlation statistic to use in the
  calculation. Potential values include `pearson` and `bicor`.

- maxPOutliers:

  A `numeric(1)` specifying the maximum percentile that can be
  considered outliers on each side of the median for the `bicor`
  statistic.

- robustY:

  A `logical(1)` indicating whether to use robust calculation for `y`
  for the `bicor` statistic. `FALSE` is recommended if `y` is a binary
  variable.

- verbose:

  A `logical(1)` indicating whether messages should be printed.

## Value

A `numeric matrix`.

## Details

The first input argument can be optionally transposed. The correlation
calculations are performed by
[`WGCNA::cor()`](https://rdrr.io/pkg/WGCNA/man/cor.html) and
[`WGCNA::bicor()`](https://rdrr.io/pkg/WGCNA/man/bicor.html).

## See also

- [`getModules()`](https://lasallegrp.github.io/comethyl/reference/getModules.md)
  to build a comethylation network and identify modules of comethylated
  regions.

- [`getDendro()`](https://lasallegrp.github.io/comethyl/reference/getDendro.md)
  and
  [`plotDendro()`](https://lasallegrp.github.io/comethyl/reference/plotDendro.md)
  to generate and visualize dendrograms.

- [`plotHeatmap()`](https://lasallegrp.github.io/comethyl/reference/plotHeatmap.md)
  to visualize correlations between samples and modules.

- [`getMEtraitCor()`](https://lasallegrp.github.io/comethyl/reference/getMEtraitCor.md)
  to calculate pairwise correlation coefficients and p-values between
  module eigennode values.

## Examples

``` r
if (FALSE) { # \dontrun{

# Get Comethylation Modules
modules <- getModules(methAdj, power = sft$powerEstimate, regions = regions,
                      corType = "pearson", file = "Modules.rds")

# Examine Correlations between Modules
MEs <- modules$MEs
moduleDendro <- getDendro(MEs, distance = "bicor")
plotDendro(moduleDendro, labelSize = 4, nBreaks = 5,
           file = "Module_ME_Dendrogram.pdf")
moduleCor <- getCor(MEs, corType = "bicor")
plotHeatmap(moduleCor, rowDendro = moduleDendro, colDendro = moduleDendro,
            file = "Module_Correlation_Heatmap.pdf")
moduleCorStats <- getMEtraitCor(MEs, colData = MEs, corType = "bicor",
                                robustY = TRUE,
                                file = "Module_Correlation_Stats.txt")

# Examine Correlations between Samples
sampleDendro <- getDendro(MEs, transpose = TRUE, distance = "bicor")
plotDendro(sampleDendro, labelSize = 3, nBreaks = 5,
           file = "Sample_ME_Dendrogram.pdf")
sampleCor <- getCor(MEs, transpose = TRUE, corType = "bicor")
plotHeatmap(sampleCor, rowDendro = sampleDendro, colDendro = sampleDendro,
            file = "Sample_Correlation_Heatmap.pdf")

# Visualize Module Eigennode Values
plotHeatmap(MEs, rowDendro = sampleDendro, colDendro = moduleDendro,
            legend.title = "Module\nEigennode",
            legend.position = c(0.37,0.89),
            file = "Sample_ME_Heatmap.pdf")
} # }
```
