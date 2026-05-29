# Plot Module Methylation Values By a Sample Trait

`plotMethTrait()` extracts the methylation values for regions in a given
module, plots it against a sample trait in a heatmap, and then saves it
as a .pdf. `trait` must be in the same order as the columns in `meth`.

## Usage

``` r
plotMethTrait(
  module,
  regions,
  meth,
  trait,
  discrete = NULL,
  traitCode = NULL,
  traitColors = NULL,
  heatmapColors = blueWhiteRed(100, gamma = 0.3),
  limit = NULL,
  expandY = 0.05,
  axis.text.size = 11,
  heatmap.legend.position = c(1.1, 0.743),
  trait.legend.position = c(1.017, 4.39),
  heatmap.legend.title = "Relative\nMethylation (%)",
  trait.legend.title = "Trait",
  legend.text.size = 11,
  legend.title.size = 14,
  heatmapMargins = c(1, 8, 0, 1),
  traitMargins = c(0, 6, 1, 5.15),
  save = TRUE,
  file = "Module_Methylation_Trait_Heatmap.pdf",
  width = 11,
  height = 4,
  verbose = TRUE
)
```

## Arguments

- module:

  A `character(1)` giving the name of the module to plot.

- regions:

  A `data.frame` of regions with module assignments, typically obtained
  from
  [`getModules()`](https://lasallegrp.github.io/comethyl/reference/getModules.md).

- meth:

  A `numeric matrix`, where each row is a region and each column is a
  sample. This is typically obtained from
  [`getRegionMeth()`](https://lasallegrp.github.io/comethyl/reference/getRegionMeth.md).

- trait:

  A `numeric` of sample trait values.

- discrete:

  A `logical(1)` identifying `trait` as a discrete variable or not. If
  null, `plotMethTrait()` will guess if the trait is discrete (\<= 5
  unique values).

- traitCode:

  A named `numeric vector` matching each trait level to a numeric value.
  Example: c("Control" = 0, "Treatment" = 1).

- traitColors:

  A named `character vector` matching each trait level to a color.
  Example: c("Control" = "blue", "Treatment" = "red").

- heatmapColors:

  A `character` giving a vector of colors to use for the gradient on the
  heatmap. The default uses
  [`WGCNA::blueWhiteRed()`](https://rdrr.io/pkg/WGCNA/man/blueWhiteRed.html)
  to generate these colors.

- limit:

  A `numeric(1)` giving the maximum value (symmetric) for the heatmap
  color scale.

- expandY:

  A `numeric` specifying the multiplicative range expansion factors. Can
  be given as the symmetric lower and upper limit expansions or
  separately as a `vector` of length 2.

- axis.text.size:

  A `numeric(1)` giving the size of the text on the y-axis.

- heatmap.legend.position:

  A `numeric(2)` with the position of the heatmap legend, as x-axis,
  y-axis. May also be a `character(1)` indicating "none", "left",
  "right", "bottom", or "top".

- trait.legend.position:

  A `numeric(2)` with the position of the color bar legend, as x-axis,
  y-axis. May also be a `character(1)` indicating "none", "left",
  "right", "bottom", or "top".

- heatmap.legend.title:

  A `character(1)` giving the title for the heatmap legend.

- trait.legend.title:

  A `character(1)` giving the title for the color bar legend.

- legend.text.size:

  A `numeric(1)` indicating the size the text in both legends.

- legend.title.size:

  A `numeric(1)` specifying the size of the text for both legend titles.

- heatmapMargins:

  A `numeric(4)` giving the width of the margins for the heatmap as top,
  right, bottom, and left.

- traitMargins:

  A `numeric(4)` giving the width of the margins for the color bar as
  top, right, bottom, and left.

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
corresponding `ME` values. If `discrete` is not provided
`plotMethTrait()` will guess if the trait is discrete (\<= 5 unique
values) and plot the trait color as a discrete scale rather than a
continuous one. Samples are ordered by trait value in ascending order.
Methylation values are plotted relative to the mean methylation in that
region.

## See also

- [`getModules()`](https://lasallegrp.github.io/comethyl/reference/getModules.md)
  to build a comethylation network and identify modules of comethylated
  regions.

- [`getMEtraitCor()`](https://lasallegrp.github.io/comethyl/reference/getMEtraitCor.md)
  and
  [`plotMEtraitCor()`](https://lasallegrp.github.io/comethyl/reference/plotMEtraitCor.md)
  to calculate and visualize all ME-trait correlations.

- [`plotMEtraitDot()`](https://lasallegrp.github.io/comethyl/reference/plotMEtraitDot.md)
  and
  [`plotMEtraitScatter()`](https://lasallegrp.github.io/comethyl/reference/plotMEtraitScatter.md)
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
