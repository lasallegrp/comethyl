# Generate Regions from CpGs

`getRegions()` generates a set of regions and some statistics based on
the CpGs in a [BSseq](https://rdrr.io/pkg/bsseq/man/BSseq-class.html)
object and then saves it as a tab-delimited text file. Regions can be
defined based on CpG locations (for CpG clusters), built-in genomic
annotations from annotatr, or a custom genomic annotation.

## Usage

``` r
getRegions(
  bs,
  annotation = NULL,
  genome = c("hg38", "hg19", "mm10", "mm9", "rn6", "rn5", "rn4", "dm6", "dm3",
    "galGal5"),
  upstream = 5000,
  downstream = 1000,
  custom = NULL,
  maxGap = 150,
  n = 3,
  save = TRUE,
  file = "Unfiltered_Regions.txt",
  verbose = TRUE
)
```

## Arguments

- bs:

  A [BSseq](https://rdrr.io/pkg/bsseq/man/BSseq-class.html) object.

- annotation:

  A `character(1)` giving the built-in genomic annotation to use for
  defining regions. Shortcuts are available for `genes`, `promoters`,
  and `transcripts`. Get the entire list of possible annotations with
  [`annotatr::builtin_annotations()`](https://rdrr.io/pkg/annotatr/man/builtin_annotations.html),
  which also includes CpG islands, enhancers, and chromatin states.

- genome:

  A `character(1)` with the genome build to use for built-in
  annotations. Available builds include `hg38`, `hg19`, `mm10`, `mm9`,
  `rn6`, `rn5`, `rn4`, `dm6`, `dm3`, and `galGal5`.

- upstream:

  A `numeric(1)` giving the number of bases upstream of a transcription
  start site to specify a promoter. Used for the `promoters` built-in
  annotation.

- downstream:

  A `numeric(1)` giving the number of bases downstream of a
  transcription start site to specify a promoter. Used for the
  `promoters` built-in annotation.

- custom:

  A [GRanges](https://rdrr.io/pkg/GenomicRanges/man/GRanges-class.html)
  object with a custom genomic annotation for defining regions.
  Construct this using
  [`GenomicRanges::GRanges()`](https://rdrr.io/pkg/GenomicRanges/man/GRanges-class.html).

- maxGap:

  A `numeric(1)` specifying the maximum number of bases between CpGs to
  be included in the same CpG cluster.

- n:

  A `numeric(1)` giving the minimum number of CpGs for a region to be
  returned. This applies to CpG clusters, built-in, and custom,
  annotations.

- save:

  A `logical(1)` indicating whether to save the `data.frame`.

- file:

  A `character(1)` giving the file name (.txt) for the saved
  `data.frame`.

- verbose:

  A `logical(1)` indicating whether messages should be printed.

## Value

A `data.frame` with the region genomic locations along with some
statistics, including number of CpGs, coverage minimum, mean, and
standard deviation, and methylation mean and standard deviation.

## Details

These regions still need to be filtered for minimum coverage and
methylation standard deviation.

## See also

- [`plotRegionStats()`](https://lasallegrp.github.io/comethyl/reference/plotRegionStats.md),
  [`plotSDstats()`](https://lasallegrp.github.io/comethyl/reference/plotSDstats.md),
  [`getRegionTotals()`](https://lasallegrp.github.io/comethyl/reference/getRegionTotals.md),
  and
  [`plotRegionTotals()`](https://lasallegrp.github.io/comethyl/reference/plotRegionTotals.md)
  for help visualizing region characteristics and setting cutoffs for
  filtering.

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
