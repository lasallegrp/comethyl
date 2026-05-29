# Visualize a Module Eigennode - Trait Correlation as a Dot Plot

`plotMEtraitDot()` takes a `vector` of module eigennode values and a
`vector` of categorical sample trait values, generates a dot plot, and
then saves it as a .pdf. `ME` and `trait` must be in the same order.

## Usage

``` r
plotMEtraitDot(
  ME,
  trait,
  traitCode = NULL,
  colors = NULL,
  fun.data = c("median_hilow", "mean_cl_boot", "mean_cl_normal", "mean_sdl"),
  fun.args = list(conf.int = 0.5),
  binwidth = 0.01,
  stackratio = 1.4,
  dotsize = 0.85,
  ylim = NULL,
  nBreaks = 4,
  axis.title.size = 20,
  axis.text.size = 16,
  xlab = "Trait",
  ylab = "Module Eigennode",
  save = TRUE,
  file = "ME_Trait_Dotplot.pdf",
  width = 6,
  height = 6,
  verbose = TRUE
)
```

## Arguments

- ME:

  A `numeric` of module eigennode values. `ME` must be in the same order
  as `trait`.

- trait:

  A `numeric` of categorical sample trait values.

- traitCode:

  A named `numeric vector` matching each trait level to a numeric value.
  Example: c("Control" = 0, "Treatment" = 1).

- colors:

  A named `character vector` matching each trait level to a color.
  Example: c("Control" = "blue", "Treatment" = "red").

- fun.data:

  A `character(1)` specifying the summary function to use. Potential
  values include `median_hilow`, `mean_cl_boot`, `mean_cl_normal`, and
  `mean_sdl`.

- fun.args:

  A `list` giving additional arguments to the summary function.

- binwidth:

  A `numeric(1)` specifying the maximum bin width.

- stackratio:

  A `numeric(1)` indicating how far apart to stack the dots.

- dotsize:

  A `numeric(1)` giving the size of the dots relative to `binwidth`.

- ylim:

  A `numeric(2)` specifying the limits of the y-axis.

- nBreaks:

  A `numeric(1)` giving the number of breaks on the y-axis.

- axis.title.size:

  A `numeric(1)` indicating the size of the title text for both axes.

- axis.text.size:

  A `numeric(1)` specifying the size of the text for both axes.

- xlab:

  A `character(1)` giving the x-axis title.

- ylab:

  A `character(1)` giving the y-axis title.

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

`NA` values in the trait are removed if present, along with
corresponding `ME` values. Data is summarized like a box plot (median,
Q1, Q3) by default, but can also be summarized with other methods. See
[`ggplot2::stat_summary()`](https://ggplot2.tidyverse.org/reference/stat_summary.html)
for more details. A `ggplot` object is produced and can be edited
outside of this function if desired.

## See also

- [`getModules()`](https://lasallegrp.github.io/comethyl/reference/getModules.md)
  to build a comethylation network and identify modules of comethylated
  regions.

- [`getMEtraitCor()`](https://lasallegrp.github.io/comethyl/reference/getMEtraitCor.md)
  and
  [`plotMEtraitCor()`](https://lasallegrp.github.io/comethyl/reference/plotMEtraitCor.md)
  to calculate and visualize all ME-trait correlations.

- [`plotMEtraitScatter()`](https://lasallegrp.github.io/comethyl/reference/plotMEtraitScatter.md)
  and
  [`plotMethTrait()`](https://lasallegrp.github.io/comethyl/reference/plotMethTrait.md)
  for other methods to visualize a single ME-trait correlation.

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
plotMEtraitCor(MEtraitCor, moduleOrder = moduleDendro$order,
               traitOrder = traitDendro$order,
               file = "ME_Trait_Correlation_Heatmap.pdf")

# Explore Individual ME-Trait Correlations
plotMEtraitDot(MEs$bisque4, trait = colData$Diagnosis_ASD,
               traitCode = c("TD" = 0, "ASD" = 1),
               colors = c("TD" = "#3366CC", "ASD" = "#FF3366"),
               ylim = c(-0.2,0.2), xlab = "Diagnosis",
               ylab = "Bisque 4 Module Eigennode",
               file = "bisque4_ME_Diagnosis_Dotplot.pdf")
plotMEtraitScatter(MEs$paleturquoise, trait = colData$Gran,
                   ylim = c(-0.15,0.15), xlab = "Granulocytes",
                   ylab = "Pale Turquoise Module Eigennode",
                   file = "paleturquoise_ME_Granulocytes_Scatterplot.pdf")
regions <- modules$regions
plotMethTrait("bisque4", regions = regions, meth = meth,
              trait = colData$Diagnosis_ASD,
              traitCode = c("TD" = 0, "ASD" = 1),
              traitColors = c("TD" = "#3366CC", "ASD" = "#FF3366"),
              trait.legend.title = "Diagnosis",
              file = "bisque4_Module_Methylation_Diagnosis_Heatmap.pdf")
} # }
```
