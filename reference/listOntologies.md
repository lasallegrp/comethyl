# Get Ontologies Available in GREAT

`listOntologies()` obtains a `character vector` of the available
ontologies for functional enrichment analysis by GREAT for a specified
version and genome build.

## Usage

``` r
listOntologies(
  genome = c("hg38", "hg19", "hg18", "mm10", "mm9", "danRer7"),
  version = c("4.0.4", "3.0.0", "2.0.2"),
  verbose = TRUE
)
```

## Arguments

- genome:

  A `character(1)` giving the genome build. Supported genomes include
  `hg38`, `hg19`, `hg18`, `mm10`, `mm9`, and `danRer7`. See `Details`.

- version:

  A `character(1)` specifying the version of GREAT. Possible values
  include `4.0.4`, `3.0.0`, and `2.0.2`. Different versions of GREAT
  support different genomes. See `Details`.

- verbose:

  A `logical(1)` indicating whether messages should be printed.

## Value

A `character vector`.

## Details

`listOntologies()` generates the possible ontologies to use for
functional enrichment analysis in
[`enrichModule()`](https://lasallegrp.github.io/comethyl/reference/enrichModule.md).
Supported ontologies may change over time, so this function queries
GREAT using the rGREAT package to get the ones currently available.

GREAT supports different genomes depending on the version:

- GREAT v4.0.4:

  `hg38`, `hg19`, `mm10`, `mm9`

- GREAT v3.0.0:

  `hg19`, `mm10`, `mm9`, `danRer7`

- GREAT v2.0.2:

  `hg19`, `hg18`, `mm9`, `danRer7`

## See also

- [`getModules()`](https://lasallegrp.github.io/comethyl/reference/getModules.md)
  to build a comethylation network and identify modules of comethylated
  regions.

- [`annotateModule()`](https://lasallegrp.github.io/comethyl/reference/annotateModule.md)
  and
  [`getGeneList()`](https://lasallegrp.github.io/comethyl/reference/getGeneList.md)
  to annotate a set of regions with genes and regulatory context and
  then extract the gene symbols or IDs.

- [`enrichModule()`](https://lasallegrp.github.io/comethyl/reference/enrichModule.md)
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
