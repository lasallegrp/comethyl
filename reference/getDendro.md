# Perform Hierarchical Clustering

`getDendro()` computes the distance between the rows of a matrix and
performs hierarchical clustering. Possible distance measures include
`euclidean`, `pearson`, and `bicor`. The function also optionally
transposes the matrix.

## Usage

``` r
getDendro(
  x,
  transpose = FALSE,
  distance = c("euclidean", "pearson", "bicor"),
  maxPOutliers = 0.1,
  verbose = TRUE
)
```

## Arguments

- x:

  A `numeric matrix`.

- transpose:

  A `logical(1)` specifying whether to transpose the `matrix`.

- distance:

  A `character(1)` indicating which distance measure to use. Possible
  values include `euclidean`, `pearson`, and `bicor`.

- maxPOutliers:

  A `numeric(1)` specifying the maximum percentile that can be
  considered outliers on each side of the median for the `bicor`
  statistic.

- verbose:

  A `logical(1)` indicating whether messages should be printed.

## Value

An [stats::hclust](https://rdrr.io/r/stats/hclust.html) object that
describes the clustering tree.

## Details

Euclidean distance is calculated by
[`stats::dist()`](https://rdrr.io/r/stats/dist.html), where
`method = "euclidean"`, while Pearson correlation and biweight
midcorrelation (bicor) are computed by
[`WGCNA::cor()`](https://rdrr.io/pkg/WGCNA/man/cor.html) and
[`WGCNA::bicor()`](https://rdrr.io/pkg/WGCNA/man/bicor.html),
respectively. The `cor` and `bicor` are then subtracted from 1 to
calculate the dissimilarity. Hierarchical clustering is done by
[`stats::hclust()`](https://rdrr.io/r/stats/hclust.html), where
`method = "average"`.

## See also

- [`plotDendro()`](https://lasallegrp.github.io/comethyl/reference/plotDendro.md)
  to visualize dendrograms from `getDendro()`.

## Examples

``` r
if (FALSE) { # \dontrun{

# Assess Sample Similarity
getDendro(methAdj, distance = "euclidean") %>%
        plotDendro(file = "Sample_Dendrogram.pdf", expandY = c(0.25,0.08))

# Examine Correlations between Modules
moduleDendro <- getDendro(MEs, distance = "bicor")
plotDendro(moduleDendro, labelSize = 4, nBreaks = 5,
           file = "Module_ME_Dendrogram.pdf")

# Characterize Correlations between Samples
sampleDendro <- getDendro(MEs, transpose = TRUE, distance = "bicor")
plotDendro(sampleDendro, labelSize = 3, nBreaks = 5,
           file = "Sample_ME_Dendrogram.pdf")

# Examine Correlations between Traits
traitDendro <- getCor(MEs, y = colData, corType = "bicor",
                      robustY = FALSE) %>%
        getDendro(transpose = TRUE)
plotDendro(traitDendro, labelSize = 3.5, expandY = c(0.65,0.08),
           file = "Trait_Dendrogram.pdf")
} # }
```
