# Calculate Top Principal Components

`getPCs()` calculates the top principal components for region
methylation data, and then saves it as a .rds file.

## Usage

``` r
getPCs(
  meth,
  mod = matrix(1, nrow = ncol(meth), ncol = 1),
  save = TRUE,
  file = "Top_Principal_Components.rds",
  verbose = TRUE
)
```

## Arguments

- meth:

  A `numeric matrix`, where each row is a region and each column is a
  sample. This is typically obtained from
  [`getRegionMeth()`](https://lasallegrp.github.io/comethyl/reference/getRegionMeth.md).

- mod:

  A `matrix` giving the model matrix being used to fit the data. See
  below for an example.

- save:

  A `logical(1)` indicating whether to save the `matrix`.

- file:

  A `character(1)` giving the file name (.rds) for the saved `matrix`.

- verbose:

  A `logical(1)` indicating whether messages should be printed.

## Value

A `numeric matrix`, where each row is a sample and each column is a
principal component.

## Details

`getPCs()` uses
[`sva::num.sv()`](https://rdrr.io/pkg/sva/man/num.sv.html) to identify
the number of top principal components and then
[`svd()`](https://rdrr.io/r/base/svd.html) to calculate them, after
centering methylation values within each gene. This is the same approach
used by
[`sva::sva_network()`](https://rdrr.io/pkg/sva/man/sva_network.html).
More information on the function and approach is given in the
documentation and publications related to the sva package.

## See also

- [`getRegionMeth()`](https://lasallegrp.github.io/comethyl/reference/getRegionMeth.md)
  to extract region methylation values.

- [`adjustRegionMeth()`](https://lasallegrp.github.io/comethyl/reference/adjustRegionMeth.md)
  to adjust region methylation values using these top PCs.

- [`getMEtraitCor()`](https://lasallegrp.github.io/comethyl/reference/getMEtraitCor.md)
  to compare these top PCs to sample traits.

- [`getDendro()`](https://lasallegrp.github.io/comethyl/reference/getDendro.md)
  and
  [`plotDendro()`](https://lasallegrp.github.io/comethyl/reference/plotDendro.md)
  to generate and visualize dendrograms.

- [`getSoftPower()`](https://lasallegrp.github.io/comethyl/reference/getSoftPower.md)
  and
  [`plotSoftPower()`](https://lasallegrp.github.io/comethyl/reference/plotSoftPower.md)
  to estimate the best soft-thresholding power and visualize scale-free
  topology fit and connectivity.

- [`getModules()`](https://lasallegrp.github.io/comethyl/reference/getModules.md)
  to build a comethylation network and identify modules of comethylated
  regions.

## Examples

``` r
if (FALSE) { # \dontrun{

# Get Methylation Data
meth <- getRegionMeth(regions, bs = bs, file = "Region_Methylation.rds")

# Adjust Methylation Data for Top PCs
mod <- model.matrix(~1, data = pData(bs))
PCs <- getPCs(meth, mod = mod, file = "Top_Principal_Components.rds")
methAdj <- adjustRegionMeth(meth, PCs = PCs,
                            file = "Adjusted_Region_Methylation.rds")

# Compare Top PCs to Sample Traits
MEtraitCor <- getMEtraitCor(PCs, colData = colData, corType = "bicor",
                            file = "PC_Trait_Correlation_Stats.txt")
PCdendro <- getDendro(PCs, distance = "bicor")
PCtraitDendro <- getCor(PCs, y = colData, corType = "bicor", robustY = FALSE) %>%
        getDendro(transpose = TRUE)
plotMEtraitCor(PCtraitCor, moduleOrder = PCdendro$order,
               traitOrder = PCtraitDendro$order,
               file = "PC_Trait_Correlation_Heatmap.pdf")

# Assess Sample Similarity
getDendro(methAdj, distance = "euclidean") %>%
         plotDendro(file = "Sample_Dendrogram.pdf", expandY = c(0.25,0.08))

# Select Soft Power Threshold
sft <- getSoftPower(methAdj, corType = "pearson", file = "Soft_Power.rds")
plotSoftPower(sft, file = "Soft_Power_Plots.pdf")

# Get Comethylation Modules
modules <- getModules(methAdj, power = sft$powerEstimate, regions = regions,
                      corType = "pearson", file = "Modules.rds")
} # }
```
