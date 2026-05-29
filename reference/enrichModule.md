# Analyze Module Functional Enrichment with GREAT

`enrichModule()` takes a `data.frame` of regions with module
assignments, filters it for the module(s) of interest, and submits it to
GREAT for functional enrichment analysis compared to gene sets in the
specified ontologies. The results are then processed and saved as a .txt
file.

## Usage

``` r
enrichModule(
  regions,
  module = NULL,
  genome = c("hg38", "hg19", "hg18", "mm10", "mm9", "danRer7"),
  includeCuratedRegDoms = FALSE,
  rule = c("basalPlusExt", "twoClosest", "oneClosest"),
  adv_upstream = 5,
  adv_downstream = 1,
  adv_span = 1000,
  adv_twoDistance = 1000,
  adv_oneDistance = 1000,
  version = c("4.0.4", "3.0.0", "2.0.2"),
  ontologies = c("GO Molecular Function", "GO Biological Process",
    "GO Cellular Component", "Mouse Phenotype", "Human Phenotype"),
  min_background_region_hits = 5,
  adjMethod = c("fdr", "holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "none"),
  min_region_hits = 2,
  pvalue_threshold = 0.01,
  save = TRUE,
  file = "Module_Enrichment_Results.txt",
  verbose = TRUE
)
```

## Arguments

- regions:

  A `data.frame` of regions with module assignments, typically obtained
  from
  [`getModules()`](https://lasallegrp.github.io/comethyl/reference/getModules.md).

- module:

  A `character` giving the name of one or more modules to analyze
  functional enrichment. If null, all modules will be analyzed, except
  the grey (unassigned) module.

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

- ontologies:

  A `character` giving the ontology databases to query. Default
  ontologies include `GO Molecular Function`, `GO Biological Process`,
  `GO Cellular Component`, `Mouse Phenotype`, and `Human Phenotype`. All
  possible ontologies can be obtained with
  [`listOntologies()`](https://lasallegrp.github.io/comethyl/reference/listOntologies.md).

- min_background_region_hits:

  A `numeric(1)` giving the minimum number of overlaps of gene set
  regulatory domains with background regions to include that gene set in
  the results. This affects the results used when adjusting p-values for
  multiple comparisons.

- adjMethod:

  A `character(1)` specifying the method for adjusting p-values,
  Potential values include `fdr`, `holm`, `hochberg`, `hommel`,
  `bonferroni`, `BH`, `BY`, and `none`.

- min_region_hits:

  A `numeric(1)` giving the minimum number of overlaps of gene set
  regulatory domains with module regions to include that gene set in the
  results.

- pvalue_threshold:

  A `numeric(1)` giving the maximum p-value for enrichment to include a
  gene set in the results.

- save:

  A `logical(1)` indicating whether to save the `data.frame`.

- file:

  A `character(1)` giving the file name (.txt) for the saved
  `data.frame`.

- verbose:

  A `logical(1)` indicating whether messages should be printed.

## Value

A `data.frame` of functional enrichment results.

## Details

Submission to GREAT is performed by the rGREAT package, which allows for
different annotation rules and versions of GREAT. The default
`basalPlusExt` annotation rule associates a gene with a region if the
region is within the basal regulatory domain of the gene (5 kb upstream
and 1 kb downstream of the TSS) or if it is within 1 Mb upstream or
downstream of the TSS and not in the basal regulatory domain of another
gene. Other rules include `twoClosest` and `oneClosest`, which
effectively assign the two nearest genes or one nearest genes,
respectively. See
[`rGREAT::submitGreatJob()`](https://rdrr.io/pkg/rGREAT/man/submitGreatJob.html)
for more details.

GREAT supports different genomes depending on the version:

- GREAT v4.0.4:

  `hg38`, `hg19`, `mm10`, `mm9`

- GREAT v3.0.0:

  `hg19`, `mm10`, `mm9`, `danRer7`

- GREAT v2.0.2:

  `hg19`, `hg18`, `mm9`, `danRer7`

Functional enrichment analysis is performed for regions in the module(s)
of interest relative to the background set of all regions in `regions`,
including the grey (unassigned) module. These regions are compared for
overlap with the regulatory domains of genes annotated to functional
gene sets of the ontologies of interest. The default ontologies include
`GO Molecular Function`, `GO Biological Process`,
`GO Cellular Component`, `Mouse Phenotype`, and `Human Phenotype`.
Initial enrichment results are filtered for terms with a minimum number
of overlaps with the background set of regions, p-values are adjusted
for multiple comparisons using the specified method, and then the
results are filtered again for a minimum number of overlaps with the
module(s) of interest and a p-value threshold. Finally, gene symbols are
obtained for the significant gene sets, and the result is saved as a
.txt file.

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
