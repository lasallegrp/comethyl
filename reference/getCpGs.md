# Read Bismark CpG reports

`getCpGs()` reads individual sample Bismark CpG reports into a single
[BSseq](https://rdrr.io/pkg/bsseq/man/BSseq-class.html) object and then
saves it as a .rds file.

## Usage

``` r
getCpGs(
  colData,
  path = getwd(),
  pattern = "*CpG_report.txt.gz",
  sameLoci = TRUE,
  chroms = c(paste("chr", 1:22, sep = ""), "chrX", "chrY", "chrM"),
  BPPARAM = BiocParallel::MulticoreParam(10),
  save = TRUE,
  file = "Unfiltered_BSseq.rds",
  verbose = TRUE
)
```

## Arguments

- colData:

  A `data.frame` whose row names specify CpG reports to load into the
  [BSseq](https://rdrr.io/pkg/bsseq/man/BSseq-class.html) object and
  whose columns are sample traits with numeric values.

- path:

  A `character` giving the path(s) to the CpG reports.

- pattern:

  A regular expression used to filter for CpG reports.

- sameLoci:

  A `logical(1)` indicating whether CpG reports contain the same set of
  methylation loci. This is the case if the files are genome wide
  cytosine reports aligned to the same reference genome. The default
  `sameLoci = TRUE` speeds up `getCpGs()` by only having to parse each
  CpG report once.

- chroms:

  A `character` giving the chromosomes to include in the
  [BSseq](https://rdrr.io/pkg/bsseq/man/BSseq-class.html) object.

- BPPARAM:

  A
  [BiocParallel::BiocParallelParam](https://rdrr.io/pkg/BiocParallel/man/BiocParallelParam-class.html)
  instance providing the parallel back-end to use during evaluation.

- save:

  A `logical(1)` indicating whether to save the
  [BSseq](https://rdrr.io/pkg/bsseq/man/BSseq-class.html) object.

- file:

  A `character(1)` giving the file name (.rds) for the saved
  [BSseq](https://rdrr.io/pkg/bsseq/man/BSseq-class.html) object.

- verbose:

  A `logical(1)` indicating whether messages should be printed.

## Value

A [BSseq](https://rdrr.io/pkg/bsseq/man/BSseq-class.html) object.

## Details

This [BSseq](https://rdrr.io/pkg/bsseq/man/BSseq-class.html) object
still needs to be filtered for coverage at individual CpGs. More
information on these arguments is given in the documentation for
[`bsseq::read.bismark()`](https://rdrr.io/pkg/bsseq/man/read.bismark.html).

## See also

- [`getCpGtotals()`](https://lasallegrp.github.io/comethyl/reference/getCpGtotals.md)
  and
  [`plotCpGtotals()`](https://lasallegrp.github.io/comethyl/reference/plotCpGtotals.md)
  for help with deciding coverage cutoffs.

- [`filterCpGs()`](https://lasallegrp.github.io/comethyl/reference/filterCpGs.md)
  to filter the [BSseq](https://rdrr.io/pkg/bsseq/man/BSseq-class.html)
  object.

- [`bsseq::read.bismark()`](https://rdrr.io/pkg/bsseq/man/read.bismark.html)
  for more details on the arguments and the underlying functions.

## Examples

``` r
if (FALSE) { # \dontrun{

# Read Bismark CpG Reports
colData <- read.xlsx("sample_info.xlsx", rowNames = TRUE)
bs <- getCpGs(colData, file = "Unfiltered_BSseq.rds")

# Examine CpG Totals at Different Cutoffs
CpGtotals <- getCpGtotals(bs, file = "CpG_Totals.txt")
plotCpGtotals(CpGtotals, file = "CpG_Totals.pdf")

# Filter BSseq Object
bs <- filterCpGs(bs, cov = 2, perSample = 0.75, file = "Filtered_BSseq.rds")
} # }
```
