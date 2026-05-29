# Filter BSseq Objects by Coverage

`filterCpGs()` subsets a
[BSseq](https://rdrr.io/pkg/bsseq/man/BSseq-class.html) object to
include only those CpGs meeting `cov` and `perSample` cutoffs and then
saves it as a .rds file.

## Usage

``` r
filterCpGs(
  bs,
  cov = 2,
  perSample = 0.75,
  save = TRUE,
  file = "Filtered_BSseq.rds",
  verbose = TRUE
)
```

## Arguments

- bs:

  A [BSseq](https://rdrr.io/pkg/bsseq/man/BSseq-class.html) object.

- cov:

  A `numeric(1)` specifying the minimum number of reads overlapping a
  CpG for it to be included in the total.

- perSample:

  A `numeric(1)` specifying the minimum percent of samples with `cov`
  reads at a CpG for it to be included in the total.

- save:

  A `logical(1)` indicating whether to save the
  [BSseq](https://rdrr.io/pkg/bsseq/man/BSseq-class.html) object.

- file:

  A `character(1)` giving the file name (.rds) for the saved BSseq
  object.

- verbose:

  A `logical(1)` indicating whether messages should be printed.

## Value

A [BSseq](https://rdrr.io/pkg/bsseq/man/BSseq-class.html) object.

## Details

`filterCpGs()` is designed to be used after `cov` and `perSample`
arguments have been optimized by
[`getCpGtotals()`](https://lasallegrp.github.io/comethyl/reference/getCpGtotals.md)
and
[`plotCpGtotals()`](https://lasallegrp.github.io/comethyl/reference/plotCpGtotals.md).

## See also

- [`getCpGs()`](https://lasallegrp.github.io/comethyl/reference/getCpGs.md)
  to generate the
  [BSseq](https://rdrr.io/pkg/bsseq/man/BSseq-class.html) object from
  individual Bismark CpG reports.

- [`getCpGtotals()`](https://lasallegrp.github.io/comethyl/reference/getCpGtotals.md)
  and
  [`plotCpGtotals()`](https://lasallegrp.github.io/comethyl/reference/plotCpGtotals.md)
  for help with deciding coverage cutoffs.

- [`getRegions()`](https://lasallegrp.github.io/comethyl/reference/getRegions.md)
  to generate a set of regions based on the CpGs.

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
