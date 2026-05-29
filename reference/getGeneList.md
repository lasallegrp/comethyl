# Extract a Gene List from Annotated Regions

`getGeneList()` takes a `data.frame` of regions annotated with gene
information and extracts a `vector` of unique gene symbols,
descriptions, or IDs.

## Usage

``` r
getGeneList(
  regions_annotated,
  module = NULL,
  type = c("symbol", "description", "ensemblID", "entrezID"),
  verbose = TRUE
)
```

## Arguments

- regions_annotated:

  A `data.frame` of regions with gene annotations, typically produced by
  [`annotateModule()`](https://lasallegrp.github.io/comethyl/reference/annotateModule.md).

- module:

  A `character` giving the name of one or more modules to include. If
  null, all modules will be included.

- type:

  A `character(1)` specifying the type of gene information to extract.
  Possible values include `symbol`, `description`, `ensemblID` and
  `entrezID`.

- verbose:

  A `logical(1)` indicating whether messages should be printed.

## Value

A `vector` of unique values.

## Details

`getGeneList()` is designed to be used in combination with
[`annotateModule()`](https://lasallegrp.github.io/comethyl/reference/annotateModule.md).
`regions` can be filtered for one or more modules of interest. Values
that can be extracted include gene `symbol`, `description`, `ensemblID`
and `entrezID`.

## See also

- [`getModules()`](https://lasallegrp.github.io/comethyl/reference/getModules.md)
  to build a comethylation network and identify modules of comethylated
  regions.

- [`annotateModule()`](https://lasallegrp.github.io/comethyl/reference/annotateModule.md)
  to annotate a set of regions with genes and regulatory context.

- [`listOntologies()`](https://lasallegrp.github.io/comethyl/reference/listOntologies.md),
  [`enrichModule()`](https://lasallegrp.github.io/comethyl/reference/enrichModule.md),
  and
  [`plotEnrichment()`](https://lasallegrp.github.io/comethyl/reference/plotEnrichment.md)
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
