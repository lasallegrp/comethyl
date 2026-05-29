# Get Total CpGs at Different Coverage Cutoffs

`getCpGtotals()` calculates the total number and percent of CpGs
remaining in a [BSseq](https://rdrr.io/pkg/bsseq/man/BSseq-class.html)
object after filtering at different `cov` and `perSample` cutoffs and
then saves it as a tab-delimited text file.

## Usage

``` r
getCpGtotals(
  bs,
  cov = seq(0, 10, 1),
  perSample = seq(0.5, 1, 0.05),
  save = TRUE,
  file = "CpG_Totals.txt",
  verbose = TRUE
)
```

## Arguments

- bs:

  A [BSseq](https://rdrr.io/pkg/bsseq/man/BSseq-class.html) object.

- cov:

  A `numeric` specifying the minimum number of reads overlapping a CpG
  for it to be included in the total.

- perSample:

  A `numeric` specifying the minimum percent of samples with `cov` reads
  at a CpG for it to be included in the total.

- save:

  A `logical(1)` indicating whether to save the `data.frame`.

- file:

  A `character(1)` giving the file name (.txt) for the saved
  `data.frame`.

- verbose:

  A `logical(1)` indicating whether messages should be printed.

## Value

A `data.frame` giving the number of CpGs (in millions) and the percent
of total CpGs at all combinations of `cov` and `perSample`. The number
of samples corresponding to `perSample` is also given.

## Details

The purpose of this function is to help determine cutoffs to maximize
the number of CpGs with sufficient data after filtering. It's
recommended to input multiple `cov` and `perSample` cutoffs for
comparison. Typically, the number of CpGs covered in 100% of samples
decreases as the sample size increases, especially with low-coverage
datasets.

## See also

- [`getCpGs()`](https://lasallegrp.github.io/comethyl/reference/getCpGs.md)
  to generate the
  [BSseq](https://rdrr.io/pkg/bsseq/man/BSseq-class.html) object from
  individual Bismark CpG reports.

- [`plotCpGtotals()`](https://lasallegrp.github.io/comethyl/reference/plotCpGtotals.md)
  to visualize the CpG totals.

- [`filterCpGs()`](https://lasallegrp.github.io/comethyl/reference/filterCpGs.md)
  to filter the [BSseq](https://rdrr.io/pkg/bsseq/man/BSseq-class.html)
  object.

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
