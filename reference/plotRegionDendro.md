# Plot Region Dendrograms

`plotRegionDendro()` extracts plotting data from a `modules` list, plots
a region dendrogram with module assignments, and then saves it as a
.pdf.

## Usage

``` r
plotRegionDendro(
  modules,
  save = TRUE,
  file = "Region_Dendrograms.pdf",
  width = 11,
  height = 4.25,
  verbose = TRUE
)
```

## Arguments

- modules:

  A `list` of module assignments and statistics produced by
  [`getModules()`](https://lasallegrp.github.io/comethyl/reference/getModules.md).

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

None, produces a plot as a side effect.

## Details

`plotRegionDendro()` is designed to be used in combination with
[`getModules()`](https://lasallegrp.github.io/comethyl/reference/getModules.md).
This function does not produce a `ggplot` object, but instead uses
[`WGCNA::plotDendroAndColors()`](https://rdrr.io/pkg/WGCNA/man/plotDendroAndColors.html)
to plot the dendrogram.

## See also

- [`getModules()`](https://lasallegrp.github.io/comethyl/reference/getModules.md)
  to build a comethylation network and identify modules of comethylated
  regions.

- [`getModuleBED()`](https://lasallegrp.github.io/comethyl/reference/getModuleBED.md)
  to visualize genomic locations and module assignments.

- [`getDendro()`](https://lasallegrp.github.io/comethyl/reference/getDendro.md)
  and
  [`plotDendro()`](https://lasallegrp.github.io/comethyl/reference/plotDendro.md)
  to generate and visualize dendrograms for samples, modules, and
  traits.

## Examples

``` r
if (FALSE) { # \dontrun{

# Get Comethylation Modules
modules <- getModules(methAdj, power = sft$powerEstimate, regions = regions,
                      corType = "pearson", file = "Modules.rds")

# Visualize Comethylation Modules
plotRegionDendro(modules, file = "Region_Dendrograms.pdf")
BED <- getModuleBED(modules$regions, file = "Modules.bed")
} # }
```
