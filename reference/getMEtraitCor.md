# Calculate Correlation Statistics Between Module Eigennodes and Traits

`getMEtraitCor()` calculates correlation coefficients and p-values
between eigennode values for all modules and all sample traits and saves
it as a .txt file. Correlations are performed using either `pearson` or
`bicor` methods.

## Usage

``` r
getMEtraitCor(
  MEs,
  colData,
  corType = c("bicor", "pearson"),
  maxPOutliers = 0.1,
  robustY = FALSE,
  save = TRUE,
  file = "ME_Trait_Correlation_Stats.txt",
  verbose = TRUE
)
```

## Arguments

- MEs:

  A `data.frame` of module eigennode values, where rows are samples and
  columns are modules. The row names of `MEs` must include the same set
  of values as the row names of `colData`.

- colData:

  A `data.frame` whose row names specify samples and whose columns are
  sample traits with numeric values.

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

- save:

  A `logical(1)` indicating whether to save the `data.frame`.

- file:

  A `character(1)` giving the file name (.txt) for the saved
  `data.frame`.

- verbose:

  A `logical(1)` indicating whether messages should be printed.

## Value

A `data.frame` giving correlation statistics for each module-trait pair.

## Details

`getMEtraitCor()` is designed to be used in combination with
[`getModules()`](https://lasallegrp.github.io/comethyl/reference/getModules.md).
The correlation calculations are performed by
[`WGCNA::corAndPvalue()`](https://rdrr.io/pkg/WGCNA/man/corAndPvalue.html)
and
[`WGCNA::bicorAndPvalue()`](https://rdrr.io/pkg/WGCNA/man/bicorAndPvalue.html).
`getMEtraitCor()` can also be used to calculate pairwise correlation
coefficients and p-values between module eigennode values, or between
top adjusted PCs and sample traits (see examples).

## See also

- [`getModules()`](https://lasallegrp.github.io/comethyl/reference/getModules.md)
  to build a comethylation network and identify modules of comethylated
  regions.

- [`getCor()`](https://lasallegrp.github.io/comethyl/reference/getCor.md)
  to calculate correlation coefficients.

- [`getDendro()`](https://lasallegrp.github.io/comethyl/reference/getDendro.md)
  and
  [`plotDendro()`](https://lasallegrp.github.io/comethyl/reference/plotDendro.md)
  to generate and visualize dendrograms.

- [`plotMEtraitCor()`](https://lasallegrp.github.io/comethyl/reference/plotMEtraitCor.md)
  to visualize ME-trait correlations.

## Examples

``` r
if (FALSE) { # \dontrun{

# Get Comethylation Modules
modules <- getModules(methAdj, power = sft$powerEstimate, regions = regions,
                      corType = "pearson", file = "Modules.rds")

# Test Correlations between Module Eigennodes and Sample Traits
MEs <- modules$MEs
MEtraitCor <- getMEtraitCor(MEs, colData = colData, corType = "bicor",
                            file = "ME_Trait_Correlation_Stats.txt")

# Examine Correlations between Modules
moduleCorStats <- getMEtraitCor(MEs, colData = MEs, corType = "bicor",
                                robustY = TRUE,
                                file = "Module_Correlation_Stats.txt")

# Compare Top PCs to Sample Traits
MEtraitCor <- getMEtraitCor(PCs, colData = colData, corType = "bicor",
                            file = "PC_Trait_Correlation_Stats.txt")
PCdendro <- getDendro(PCs, distance = "bicor")
PCtraitDendro <- getCor(PCs, y = colData, corType = "bicor", robustY = FALSE) %>%
        getDendro(transpose = TRUE)
plotMEtraitCor(PCtraitCor, moduleOrder = PCdendro$order,
               traitOrder = PCtraitDendro$order,
               file = "PC_Trait_Correlation_Heatmap.pdf")

# Examine Correlations between Sample Traits
traitDendro <- getCor(MEs, y = colData, corType = "bicor",
                      robustY = FALSE) %>%
        getDendro(transpose = TRUE)
plotDendro(traitDendro, labelSize = 3.5, expandY = c(0.65,0.08),
           file = "Trait_Dendrogram.pdf")

# Visualize Correlations between Module Eigennodes and Sample Traits
moduleDendro <- getDendro(MEs, distance = "bicor")
plotMEtraitCor(MEtraitCor, moduleOrder = moduleDendro$order,
               traitOrder = traitDendro$order,
               file = "ME_Trait_Correlation_Heatmap.pdf")
plotMEtraitCor(MEtraitCor, moduleOrder = moduleDendro$order,
               traitOrder = traitDendro$order, topOnly = TRUE,
               label.type = "p", label.size = 4, label.nudge_y = 0,
               legend.position = c(1.11, 0.795),
               colColorMargins = c(-1,4.75,0.5,10.1),
               file = "Top_ME_Trait_Correlation_Heatmap.pdf", width = 8.5,
               height = 4.25)
} # }
```
