# Plot Soft Power Fit and Connectivity

`plotSoftPower()` visualizes scale-free topology fit and mean
connectivity for multiple soft power thresholds as a scatterplot, and
then saves it as a .pdf.

## Usage

``` r
plotSoftPower(
  sft,
  pointCol = "#132B43",
  lineCol = "red",
  nBreaks = 4,
  save = TRUE,
  file = "Soft_Power_Plots.pdf",
  width = 8.5,
  height = 4.25,
  verbose = TRUE
)
```

## Arguments

- sft:

  A `list` produced by
  [`getSoftPower()`](https://lasallegrp.github.io/comethyl/reference/getSoftPower.md)
  with two elements: `powerEstimate` and `fitIndices`.

- pointCol:

  A `character(1)` specifying the color of the points.

- lineCol:

  A `character(1)` giving the color of line and label for the estimated
  soft power threshold for scale-free topology.

- nBreaks:

  A `numeric(1)` specifying the number of breaks used for both axes.

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

`plotSoftPower()` is designed to be used in combination with
[`getSoftPower()`](https://lasallegrp.github.io/comethyl/reference/getSoftPower.md).
A `ggplot` object is produced and can be edited outside of this function
if desired.

## See also

- [`getRegionMeth()`](https://lasallegrp.github.io/comethyl/reference/getRegionMeth.md),
  [`getPCs()`](https://lasallegrp.github.io/comethyl/reference/getPCs.md),
  and
  [`adjustRegionMeth()`](https://lasallegrp.github.io/comethyl/reference/adjustRegionMeth.md)
  to extract methylation data and then adjust it for the top principal
  components.

- [`getSoftPower()`](https://lasallegrp.github.io/comethyl/reference/getSoftPower.md)
  to calculate the best soft-thresholding power and fit indices for
  scale-free topology.

- [`getModules()`](https://lasallegrp.github.io/comethyl/reference/getModules.md)
  to build a comethylation network and identify modules of comethylated
  regions.

## Examples

``` r
if (FALSE) { # \dontrun{

# Get Methylation Data
meth <- getRegionMeth(regions, bs = bs, file = "Region_Methylation.rds")

# Adjust Methylation Data for PCs
mod <- model.matrix(~1, data = pData(bs))
PCs <- getPCs(meth, mod = mod, file = "Top_Principal_Components.rds")
methAdj <- adjustRegionMeth(meth, PCs = PCs,
                            file = "Adjusted_Region_Methylation.rds")

# Select Soft Power Threshold
sft <- getSoftPower(methAdj, corType = "pearson", file = "Soft_Power.rds")
plotSoftPower(sft, file = "Soft_Power_Plots.pdf")

# Get Comethylation Modules
modules <- getModules(methAdj, power = sft$powerEstimate, regions = regions,
                      corType = "pearson", file = "Modules.rds")
} # }
```
