# Get Region Methylation Data

`getRegionMeth()` extracts methylation values at specified regions for
all samples and then saves it as a .rds file.

## Usage

``` r
getRegionMeth(
  regions,
  bs,
  type = c("raw", "smooth"),
  save = TRUE,
  file = "Region_Methylation.rds",
  verbose = TRUE
)
```

## Arguments

- regions:

  A `data.frame` of regions, typically after filtering with
  [`filterRegions()`](https://lasallegrp.github.io/comethyl/reference/filterRegions.md).
  Must have the columns `chr`, `start`, and `end`.

- bs:

  A [BSseq](https://rdrr.io/pkg/bsseq/man/BSseq-class.html) object,
  typically after filtering with
  [`filterCpGs()`](https://lasallegrp.github.io/comethyl/reference/filterCpGs.md).

- type:

  A `character(1)` specifying the type of methylation values to extract.
  Accepted values are `raw` and `smooth`

- save:

  A `logical(1)` indicating whether to save the `matrix`.

- file:

  A `character(1)` giving the file name (.rds) for the saved `matrix`.

- verbose:

  A `logical(1)` indicating whether messages should be printed.

## Value

A `numeric matrix`, where each row is a region and each column is a
sample.

## Details

Methylation is summarized at the region level, and is estimated as the
methylated reads divided by the total reads. Methylation values are
obtained from a [BSseq](https://rdrr.io/pkg/bsseq/man/BSseq-class.html)
object and can be either raw or smoothed methylation.

## See also

- [`getPCs()`](https://lasallegrp.github.io/comethyl/reference/getPCs.md)
  and
  [`adjustRegionMeth()`](https://lasallegrp.github.io/comethyl/reference/adjustRegionMeth.md)
  to adjust methylation for the top principal components.

- [`getDendro()`](https://lasallegrp.github.io/comethyl/reference/getDendro.md)
  and
  [`plotDendro()`](https://lasallegrp.github.io/comethyl/reference/plotDendro.md)
  to generate and visualize dendrograms.

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

# Assess Sample Similarity
getDendro(methAdj, distance = "euclidean") %>%
        plotDendro(file = "Sample_Dendrogram.pdf", expandY = c(0.25,0.08))
} # }
```
