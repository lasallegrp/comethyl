# Annotate Module Regions

`annotateModule()` takes a `data.frame` of regions with module
assignments, annotates them with genes using GREAT, adds additional gene
information with Ensembl BioMart, provides gene regulatory context with
annotatr, and then saves this as a .txt file. Support is provided for
several genomes, including `hg38`, `hg19`, `hg18`, `mm10`, `mm9`, and
`danRer7`.

## Usage

``` r
annotateModule(
  regions,
  module = NULL,
  grey = FALSE,
  genome = c("hg38", "hg19", "hg18", "mm10", "mm9", "danRer7"),
  includeCuratedRegDoms = FALSE,
  rule = c("basalPlusExt", "twoClosest", "oneClosest"),
  adv_upstream = 5,
  adv_downstream = 1,
  adv_span = 1000,
  adv_twoDistance = 1000,
  adv_oneDistance = 1000,
  version = c("4.0.4", "3.0.0", "2.0.2"),
  save = TRUE,
  file = "Annotated_Module_Regions.txt",
  verbose = TRUE
)
```

## Arguments

- regions:

  A `data.frame` of regions with module assignments, typically obtained
  from
  [`getModules()`](https://lasallegrp.github.io/comethyl/reference/getModules.md).

- module:

  A `character` giving the name of one or more modules to annotate. If
  null, all modules will be annotated.

- grey:

  A `logical(1)` specifying whether or not to include the grey
  (unassigned) module.

- genome:

  A `character(1)` giving the genome build for the regions. Supported
  genomes include `hg38`, `hg19`, `hg18`, `mm10`, `mm9`, and `danRer7`.
  See `Details`.

- includeCuratedRegDoms:

  A `logical(1)` indicating whether to include curated regulatory
  domains for GREAT gene annotation.

- rule:

  A `character(1)` specifying the rule used by GREAT for gene
  annotation. Possible values include `basalPlusExt`, `twoClosest`, and
  `oneClosest`. See
  [`rGREAT::submitGreatJob()`](https://rdrr.io/pkg/rGREAT/man/submitGreatJob.html)
  for more details for this and the next six arguments.

- adv_upstream:

  A `numeric(1)` giving the distance upstream of the TSS (in kb) to
  define a basal regulatory domain in the `basalPlusExt` rule.

- adv_downstream:

  A `numeric(1)` giving the distance downstream of the TSS (in kb) to
  define a basal regulatory domain in the `basalPlusExt` rule.

- adv_span:

  A `numeric(1)` specifying the distance upstream and downstream of the
  TSS (in kb) to define the maximum extension of the regulatory domain
  in the `basalPlusExt` rule.

- adv_twoDistance:

  A `numeric(1)` giving the distance upstream and downstream of the TSS
  (in kb) to define the maximum extension of the regulatory domain in
  the `twoClosest` rule.

- adv_oneDistance:

  A `numeric(1)` giving the distance upstream and downstream of the TSS
  (in kb) to define the maximum extension of the regulatory domain in
  the `oneClosest` rule.

- version:

  A `character(1)` specifying the version of GREAT to use for gene
  annotation. Possible values include `4.0.4`, `3.0.0`, and `2.0.2`.
  Different versions of GREAT support different genomes. See `Details`.

- save:

  A `logical(1)` indicating whether to save the `data.frame`.

- file:

  A `character(1)` giving the file name (.txt) for the saved
  `data.frame`.

- verbose:

  A `logical(1)` indicating whether messages should be printed.

## Value

A `data.frame` adding gene and regulatory annotations to the regions.

## Details

`regions` can be filtered for one or more modules of interest, or the
grey (unassigned) module can be excluded. Gene annotation is performed
by the rGREAT package, which allows for different annotation rules and
versions of GREAT. The default `basalPlusExt` annotation rule associates
a gene with a region if the region is within the basal regulatory domain
of the gene (5 kb upstream and 1 kb downstream of the TSS) or if it is
within 1 Mb upstream or downstream of the TSS and not in the basal
regulatory domain of another gene. Other rules include `twoClosest` and
`oneClosest`, which effectively assign the two nearest genes or one
nearest genes, respectively. See
[`rGREAT::submitGreatJob()`](https://rdrr.io/pkg/rGREAT/man/submitGreatJob.html)
for more details.

GREAT supports different genomes depending on the version:

- GREAT v4.0.4:

  `hg38`, `hg19`, `mm10`, `mm9`

- GREAT v3.0.0:

  `hg19`, `mm10`, `mm9`, `danRer7`

- GREAT v2.0.2:

  `hg19`, `hg18`, `mm9`, `danRer7`

Gene information is provided by the biomaRt package, which adds the gene
description along with Ensembl and NCBI Entrez gene IDs. Regulatory
context is added by the annotatr package. This provides positional
context of the region relative to nearby genes, enhancers, and CpG
islands. Note that annotatr does not support the `hg18` or `danRer7`
genomes.

## See also

- [`getModules()`](https://lasallegrp.github.io/comethyl/reference/getModules.md)
  to build a comethylation network and identify modules of comethylated
  regions.

- [`getGeneList()`](https://lasallegrp.github.io/comethyl/reference/getGeneList.md)
  to extract a list of genes or IDs from the annotated regions.

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
