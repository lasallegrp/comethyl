# Visualize Total CpGs at Different Coverage Cutoffs

`plotCpGtotals()` plots the number of CpGs remaining after filtering by
different combinations of `cov` and `perSample` in a line plot and then
saves it as a pdf.

## Usage

``` r
plotCpGtotals(
  CpGtotals,
  nBreaks = 4,
  legend.position = c(1.08, 0.73),
  save = TRUE,
  file = "CpG_Totals.pdf",
  width = 11,
  height = 4.25,
  verbose = TRUE
)
```

## Arguments

- CpGtotals:

  A `data.frame`, output from
  [`getCpGtotals()`](https://lasallegrp.github.io/comethyl/reference/getCpGtotals.md).

- nBreaks:

  A `numeric(1)` specifying the number of breaks used for both axes and
  the legend.

- legend.position:

  A `numeric(2)` specifying the position of the legend, as x-axis,
  y-axis. May also be a `character(1)` indicating "none", "left",
  "right", "bottom", or "top".

- save:

  A `logical(1)` indicating whether to save the plot.

- file:

  A `character(1)` giving the file name (.pdf) for the saved plot.

- width:

  A `numeric(1)` specifying the width in inches of the saved plot.

- height:

  A `numeric(1)` specifying the height in inches of the saved plot.

- verbose:

  A `logical(1)` indicating whether messages should be printed.

## Value

A `ggplot` object.

## Details

`plotCpGtotals()` is designed to be used in combination with
[`getCpGtotals()`](https://lasallegrp.github.io/comethyl/reference/getCpGtotals.md).
A `ggplot` object is produced and can be edited outside of this function
if desired.

## See also

- [`getCpGs()`](https://lasallegrp.github.io/comethyl/reference/getCpGs.md)
  to generate the
  [BSseq](https://rdrr.io/pkg/bsseq/man/BSseq-class.html) object from
  individual Bismark CpG reports.

- [`getCpGtotals()`](https://lasallegrp.github.io/comethyl/reference/getCpGtotals.md)
  to generate `CpGtotals`.

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
