# Get a Module BED file

`getModuleBED()` takes a `data.frame` of regions with module
annotations, converts it to the BED file format suitable for viewing it
on the UCSC Genome Browser, and then saves it.

## Usage

``` r
getModuleBED(
  regions,
  grey = FALSE,
  save = TRUE,
  file = "Modules.bed",
  verbose = TRUE
)
```

## Arguments

- regions:

  A `data.frame` of regions with module assignments, typically obtained
  from
  [`getModules()`](https://lasallegrp.github.io/comethyl/reference/getModules.md).

- grey:

  A `logical(1)` specifying whether to include "grey" (unassigned)
  regions in the BED file.

- save:

  A `logical(1)` indicating whether to save the BED file.

- file:

  A `character(1)` giving the file name (.BED).

- verbose:

  A `logical(1)` indicating whether messages should be printed.

## Value

A BED file.

## Details

`getModuleBED()` is designed to be used in combination with
[`getModules()`](https://lasallegrp.github.io/comethyl/reference/getModules.md).
The BED file produced includes a header line to enable single-step
viewing on the UCSC Genome Browser. Each region is labeled by its
`RegionID` and assigned module, and is colored by the module color.
"Grey" (unassigned) regions are excluded by default, but can be
optionally included.

## See also

- [`getModules()`](https://lasallegrp.github.io/comethyl/reference/getModules.md)
  to build a comethylation network and identify modules of comethylated
  regions.

- [`plotRegionDendro()`](https://lasallegrp.github.io/comethyl/reference/plotRegionDendro.md)
  to visualize region similarity and module assignments.

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
