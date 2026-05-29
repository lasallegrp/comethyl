# Plot Functional Enrichment Results

`plotEnrichment()` takes a `data.frame` of enrichment results from
[`enrichModule()`](https://lasallegrp.github.io/comethyl/reference/enrichModule.md),
plots the log p-values in a bar plot, and saves it as a .pdf.

## Usage

``` r
plotEnrichment(
  enrichment,
  nTerms = 15,
  fill = "#132B43",
  xlim = NULL,
  nBreaks = 4,
  axis.title.x.size = 20,
  axis.text.x.size = 16,
  axis.text.y.size = 16,
  save = TRUE,
  file = "Module_Enrichment_Plot.pdf",
  width = 8,
  height = 6,
  verbose = TRUE
)
```

## Arguments

- enrichment:

  A `data.frame` of functional enrichment results, typically obtained
  from
  [`enrichModule()`](https://lasallegrp.github.io/comethyl/reference/enrichModule.md).

- nTerms:

  A `numeric(1)` specifying the number of terms to include in the plot.

- fill:

  A `character(1)` giving the color of the bars.

- xlim:

  A `numeric(2)` specifying the limits of the x-axis.

- nBreaks:

  A `numeric(1)` indicating the number of breaks to use in the x-axis.

- axis.title.x.size:

  A `numeric(1)` with the size of the x-axis title.

- axis.text.x.size:

  A `numeric(1)` giving the size of the x-axis text.

- axis.text.y.size:

  A `numeric(1)` giving the size of the y-axis text.

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

`plotEnrichment()` is designed to be used in combination with
[`enrichModule()`](https://lasallegrp.github.io/comethyl/reference/enrichModule.md).
The top 15 gene sets are plotted by default, but this can be expanded if
needed. A `ggplot` object is produced and can be edited outside of this
function if desired.

## See also

- [`getModules()`](https://lasallegrp.github.io/comethyl/reference/getModules.md)
  to build a comethylation network and identify modules of comethylated
  regions.

- [`annotateModule()`](https://lasallegrp.github.io/comethyl/reference/annotateModule.md)
  and
  [`getGeneList()`](https://lasallegrp.github.io/comethyl/reference/getGeneList.md)
  to annotate a set of regions with genes and regulatory context and
  then extract the gene symbols or IDs.

- [`listOntologies()`](https://lasallegrp.github.io/comethyl/reference/listOntologies.md)
  and
  [`enrichModule()`](https://lasallegrp.github.io/comethyl/reference/enrichModule.md),
  to investigate functional enrichment of module regions with GREAT.

## Examples

``` r
if (FALSE) { # \dontrun{

# Get Comethylation Modules
modules <- getModules(methAdj, power = sft$powerEstimate, regions = regions,
                      corType = "pearson", file = "Modules.rds")

# Annotate Modules
regionsAnno <- annotateModule(regions, module = "bisque4",
                              genome = "hg38",
                              file = "Annotated_bisque4_Module_Regions.txt")
geneList_bisque4 <- getGeneList(regionsAnno, module = "bisque4")

# Analyze Functional Enrichment
ontologies <- listOntologies("hg38", version = "4.0.4")
enrich_bisque4 <- enrichModule(regions, module = "bisque4",
                               genome = "hg38",
                               file = "bisque4_Module_Enrichment.txt")
plotEnrichment(enrich_bisque4,
               file = "bisque4_Module_Enrichment_Plot.pdf")
} # }
```
