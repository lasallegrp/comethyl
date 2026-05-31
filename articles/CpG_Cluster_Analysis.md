# CpG Cluster Analysis

## Introduction

In this vignette, we use Comethyl to construct a weighted region
comethylation network from WGBS data using clusters of CpGs grouped by
genomic location. We identify modules of comethylated regions,
investigate correlations with sample traits, and analyze functional
enrichments.

The data set includes 74 male cord blood samples from newborns who were
later diagnosed with autism spectrum disorder (ASD) and those with
typical development (TD). Comethylation modules were associated with 49
sample characteristics including diagnosis, cell types, sample
sequencing information such as percent CpG methylation, and demographic
data such as home ownership. The goal of this analysis is to explore
interactions between the methylome and sample traits prior to diagnosis
with ASD.

Raw data is available on GEO
([GSE140730](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE140730)),
see the [previous
publication](https://genomemedicine.biomedcentral.com/articles/10.1186/s13073-020-00785-8)
for more details.

## Environment Setup

All analyses should be run within the comethyl pixi environment to
ensure reproducibility. If you have not yet set up the environment, see
the [Get Started
vignette](https://lasallegrp.github.io/comethyl/articles/comethyl.html)
for full installation instructions.

**Activate the environment before launching R:**

``` bash
# From the repository root
pixi shell       # activates the environment
R                # launch R from within it

# Or run scripts directly
pixi run Rscript analysis/CpG_Cluster_Analysis.R
```

## Setup

``` r

library(tidyverse)
library(comethyl)
```

## Set Global Options

`WGCNA::disableWGCNAthreads()` prevents multi-threading for WGCNA
calculations, including all functions using
[`WGCNA::cor()`](https://rdrr.io/pkg/WGCNA/man/cor.html) and
[`WGCNA::bicor()`](https://rdrr.io/pkg/WGCNA/man/bicor.html). This is
recommended for large sets of regions (\> 150,000). For smaller region
sets, use `WGCNA::enableWGCNAthreads()` to allow for parallel
calculations with the specified number of threads. If the number of
threads is not provided, the default is the number of processors online.

``` r

options(stringsAsFactors = FALSE)
Sys.setenv(R_THREADS = 1)
WGCNA::disableWGCNAThreads()
```

## Read Bismark CpG Reports

We read in an excel table with
[`openxlsx::read.xlsx()`](https://rdrr.io/pkg/openxlsx/man/read.xlsx.html)
where the first column includes the names of sample Bismark CpG reports
and all other columns include trait values for each sample. All trait
values must be numeric, though traits can be categorical or continuous.
[`getCpGs()`](https://lasallegrp.github.io/comethyl/reference/getCpGs.md)
reads individual sample Bismark CpG reports into a single BSseq object
and then saves it as a .rds file. See
[Inputs](https://lasallegrp.github.io/comethyl/articles/comethyl.html#inputs)
for more information.

``` r

colData <- openxlsx::read.xlsx("sample_info.xlsx", rowNames = TRUE)
bs <- getCpGs(colData, file = "Unfiltered_BSseq.rds")
```

## Examine CpG Totals at Different Cutoffs

[`getCpGtotals()`](https://lasallegrp.github.io/comethyl/reference/getCpGtotals.md)
calculates the total number and percent of CpGs remaining in a BSseq
object after filtering at different `cov` (coverage) and `perSample`
cutoffs and then saves it as a tab-separated text file. The purpose of
this function is to help determine cutoffs to maximize the number of
CpGs with sufficient data after filtering. Typically, the number of CpGs
covered in 100% of samples decreases as the sample size increases,
especially with low-coverage datasets. The goal for filtering is to try
and balance the sequencing depth per CpG and the number of samples with
the total number of CpGs.

[`plotCpGtotals()`](https://lasallegrp.github.io/comethyl/reference/plotCpGtotals.md)
plots the number of CpGs remaining after filtering by different
combinations of `cov` and `perSample` in a line plot and then saves it
as a PDF.
[`plotCpGtotals()`](https://lasallegrp.github.io/comethyl/reference/plotCpGtotals.md)
is designed to be used in combination with
[`getCpGtotals()`](https://lasallegrp.github.io/comethyl/reference/getCpGtotals.md).
A ggplot is produced and can be further edited outside of this function
if desired.

``` r

CpGtotals <- getCpGtotals(bs, file = "CpG_Totals.txt")
plotCpGtotals(CpGtotals, file = "CpG_Totals.pdf")
```

![Figure 1. CpG Totals](CpG%20Cluster%20Analysis/CpG_Totals.png)

Figure 1. CpG Totals

## Filter BSobject

[`filterCpGs()`](https://lasallegrp.github.io/comethyl/reference/filterCpGs.md)
subsets a BSseq object to include only those CpGs meeting `cov` and
`perSample` cutoffs and then saves it as a .rds file.
[`filterCpGs()`](https://lasallegrp.github.io/comethyl/reference/filterCpGs.md)
is designed to be used after `cov` and `perSample` arguments have been
optimized by
[`getCpGtotals()`](https://lasallegrp.github.io/comethyl/reference/getCpGtotals.md)
and
[`plotCpGtotals()`](https://lasallegrp.github.io/comethyl/reference/plotCpGtotals.md).
Here we keep only CpGs with at least 2 reads in at least 75% of samples.

``` r

bs <- filterCpGs(bs, cov = 2, perSample = 0.75, file = "Filtered_BSseq.rds")
```

## Call Regions

[`getRegions()`](https://lasallegrp.github.io/comethyl/reference/getRegions.md)
generates a set of regions and some statistics based on the CpGs in a
BSseq object. Regions can be defined based on CpG locations (as here for
CpG clusters), built-in genomic annotations from `annotatr`, or a custom
genomic annotation.

[`plotRegionStats()`](https://lasallegrp.github.io/comethyl/reference/plotRegionStats.md)
plots histograms of region statistics, while
[`plotSDstats()`](https://lasallegrp.github.io/comethyl/reference/plotSDstats.md)
plots methylation standard deviation versus region statistics. With
these plots, we can get an idea of the characteristics of our regions
and see how methylation variability is affected. The goal is to identify
regions with biological variability rather than technical variability
(due to low coverage).

``` r

regions <- getRegions(bs, file = "Unfiltered_Regions.txt")
plotRegionStats(regions, maxQuantile = 0.99, file = "Unfiltered_Region_Plots.pdf")
```

![Figure 2. Unfiltered Region
Plots](CpG%20Cluster%20Analysis/Unfiltered_Region_Plots.png)

Figure 2. Unfiltered Region Plots

``` r

plotSDstats(regions, maxQuantile = 0.99, file = "Unfiltered_SD_Plots.pdf")
```

![Figure 3. Unfiltered SD
Plots](CpG%20Cluster%20Analysis/Unfiltered_SD_Plots.png)

Figure 3. Unfiltered SD Plots

## Examine Region Totals at Different Cutoffs

[`getRegionTotals()`](https://lasallegrp.github.io/comethyl/reference/getRegionTotals.md)
calculates region totals at specified covMin and methSD cutoffs. Total
regions (and thus total width and CpGs) are expected to decrease as the
minimum coverage cutoff increases and SD cutoff increases.
[`plotRegionTotals()`](https://lasallegrp.github.io/comethyl/reference/plotRegionTotals.md)
plots these region totals by potential covMin and methSD cutoffs.

``` r

regionTotals <- getRegionTotals(regions, file = "Region_Totals.txt")
plotRegionTotals(regionTotals, file = "Region_Totals.pdf")
```

![Figure 4. Region Totals](CpG%20Cluster%20Analysis/Region_Totals.png)

Figure 4. Region Totals

## Filter Regions

[`filterRegions()`](https://lasallegrp.github.io/comethyl/reference/filterRegions.md)
subsets the regions to only include those meeting `covMin` and `methSD`
cutoffs.
[`filterRegions()`](https://lasallegrp.github.io/comethyl/reference/filterRegions.md)
is designed to be used after `covMin` and `methSD` functions have been
optimized with
[`getRegionTotals()`](https://lasallegrp.github.io/comethyl/reference/getRegionTotals.md)
and
[`plotRegionTotals()`](https://lasallegrp.github.io/comethyl/reference/plotRegionTotals.md).
Here we filter for regions with at least 10 reads in all samples and
with a methylation standard deviation of at least 5%. Then we examine
our regions again with
[`plotRegionStats()`](https://lasallegrp.github.io/comethyl/reference/plotRegionStats.md)
after filtering.

``` r

regions <- filterRegions(regions, covMin = 10, methSD = 0.05,
                         file = "Filtered_Regions.txt")
plotRegionStats(regions, maxQuantile = 0.99, file = "Filtered_Region_Plots.pdf")
```

![Figure 5. Filtered Region
Plots](CpG%20Cluster%20Analysis/Filtered_Region_Plots.png)

Figure 5. Filtered Region Plots

## Adjust Methylation Data for Principal Components

[`getRegionMeth()`](https://lasallegrp.github.io/comethyl/reference/getRegionMeth.md)
calculates region methylation from a BSseq object and saves it as a
.rds. [`model.matrix()`](https://rdrr.io/r/stats/model.matrix.html)
creates a design matrix for our set of samples.
[`getPCs()`](https://lasallegrp.github.io/comethyl/reference/getPCs.md)
calculates the top principal components, and then
[`adjustRegionMeth()`](https://lasallegrp.github.io/comethyl/reference/adjustRegionMeth.md)
adjusts the region methylation for the top PCs and saves it as a .rds
file.
[`getDendro()`](https://lasallegrp.github.io/comethyl/reference/getDendro.md)
clusters the samples based on the adjusted region methylation using
Euclidean distance, while
[`plotDendro()`](https://lasallegrp.github.io/comethyl/reference/plotDendro.md)
plots the dendrogram. We can use this dendrogram to see if there are any
outlier samples or samples clustering separately due to batch effects.

``` r

meth <- getRegionMeth(regions, bs = bs, file = "Region_Methylation.rds")
mod <- model.matrix(~1, data = pData(bs))
PCs <- getPCs(meth, mod = mod, file = "Top_Principal_Components.rds")
methAdj <- adjustRegionMeth(meth, PCs = PCs,
                            file = "Adjusted_Region_Methylation.rds")
getDendro(methAdj, distance = "euclidean") %>%
  plotDendro(file = "Sample_Dendrogram.pdf", expandY = c(0.25, 0.08))
```

![Figure 6. Sample
Dendrogram](CpG%20Cluster%20Analysis/Sample_Dendrogram.png)

Figure 6. Sample Dendrogram

## Select Soft Power Threshold

[`getSoftPower()`](https://lasallegrp.github.io/comethyl/reference/getSoftPower.md)
analyzes scale-free topology with Pearson or Bicor correlations to
determine the best soft-thresholding power. This refers to the power to
which all correlations are raised and how much more stronger
correlations are weighted compared to weaker correlations. Pearson
correlation is more sensitive than Bicor correlation, but is also more
influenced by outlier samples. We use Pearson correlation in order to
have higher power to detect correlated regions in a dataset with
relatively low variability between samples.

[`plotSoftPower()`](https://lasallegrp.github.io/comethyl/reference/plotSoftPower.md)
plots the soft power threshold against scale free topology fit and
connectivity. Typically, as the soft power threshold increases, fit
increases and connectivity decreases. A soft power threshold should be
selected as the lowest threshold where fit is 0.8 or higher (here we use
18).

``` r

sft <- getSoftPower(methAdj, corType = "pearson", file = "Soft_Power.rds")
plotSoftPower(sft, file = "Soft_Power_Plots.pdf")
```

![Figure 7. Soft Power
Plots](CpG%20Cluster%20Analysis/Soft_Power_Plots.png)

Figure 7. Soft Power Plots

## Get Comethylation Modules

[`getModules()`](https://lasallegrp.github.io/comethyl/reference/getModules.md)
identifies comethylation modules using filtered regions, a chosen soft
power threshold, and either Pearson or Bicor correlation. Here we use
Pearson correlation for the greater sensitivity to detect modules.
Regions are first formed into blocks close to but not exceeding the
maximum block size. A full network analysis is then performed on each
block to assign regions to modules; modules are merged if their
eigennodes are highly correlated. The modules are then saved as a .rds
file. This two-level clustering approach requires less computational
memory and is significantly faster than performing network analysis on
all regions at once.

[`plotRegionDendro()`](https://lasallegrp.github.io/comethyl/reference/plotRegionDendro.md)
plots region dendrograms and modules for each block.
[`getModuleBED()`](https://lasallegrp.github.io/comethyl/reference/getModuleBED.md)
creates a BED file of regions annotated with module assignments for
visualization in a genome browser.

``` r

modules <- getModules(methAdj, power = 18, regions = regions,
                      corType = "pearson", file = "Modules.rds")
plotRegionDendro(modules, file = "Region_Dendrograms.pdf")
BED <- getModuleBED(modules$regions, file = "Modules.bed")
```

![Figure 8. Region
Dendrograms](CpG%20Cluster%20Analysis/Region_Dendrograms.png)

Figure 8. Region Dendrograms

## Correlate Modules with Sample Traits

[`getMEtraitCor()`](https://lasallegrp.github.io/comethyl/reference/getMEtraitCor.md)
correlates module eigennodes with sample traits and saves the results as
a tab-separated text file.
[`plotMEtraitCor()`](https://lasallegrp.github.io/comethyl/reference/plotMEtraitCor.md)
plots the correlation between module eigennodes and sample traits as a
heatmap.

``` r

MEs <- modules$MEs
colData <- read.xlsx("sample_info.xlsx", rowNames = TRUE)
MEtraitCor <- getMEtraitCor(MEs, colData = colData, corType = "pearson",
                            file = "ME_Trait_Correlation.txt")
traitDendro <- getDendro(colData, distance = "bicor")
plotMEtraitCor(MEtraitCor, moduleOrder = modules$modules$module,
               traitDendro = traitDendro,
               file = "ME_Trait_Correlation_Heatmap.pdf")
```

![Figure 9. ME Trait Correlation
Heatmap](CpG%20Cluster%20Analysis/ME_Trait_Correlation_Heatmap.png)

Figure 9. ME Trait Correlation Heatmap

## Explore Significant Module-Trait Correlations

[`plotMEtraitDot()`](https://lasallegrp.github.io/comethyl/reference/plotMEtraitDot.md)
plots module eigennode values by trait for a single module and trait.
[`plotMethTrait()`](https://lasallegrp.github.io/comethyl/reference/plotMethTrait.md)
plots methylation values for regions in a module by trait, showing
individual sample values.

``` r

plotMEtraitDot(MEs$MEblue, trait = colData$Diagnosis_ASD,
               traitCode = c("TD" = 0, "ASD" = 1),
               colors = c("TD" = "#3366CC", "ASD" = "#FF3366"),
               file = "Blue_ME_Diagnosis_Dot.pdf",
               xlabel = "Diagnosis", ylabel = "Blue Module Eigennode")
plotMethTrait(methAdj, regions = regions, modules = modules,
              module = "blue", trait = colData$Diagnosis_ASD,
              traitCode = c("TD" = 0, "ASD" = 1),
              traitColors = c("TD" = "#3366CC", "ASD" = "#FF3366"),
              file = "Blue_Module_Methylation_Heatmap.pdf")
```

![Figure 10. Blue ME Diagnosis Dot
Plot](CpG%20Cluster%20Analysis/Blue_ME_Diagnosis_Dot.png)

Figure 10. Blue ME Diagnosis Dot Plot

![Figure 11. Blue Module Methylation
Heatmap](CpG%20Cluster%20Analysis/Blue_Module_Methylation_Heatmap.png)

Figure 11. Blue Module Methylation Heatmap

## Annotate Modules and Perform Enrichment Analysis

[`annotateModule()`](https://lasallegrp.github.io/comethyl/reference/annotateModule.md)
annotates regions in a module with gene and CpG island context.
[`getGeneList()`](https://lasallegrp.github.io/comethyl/reference/getGeneList.md)
extracts a list of genes from annotated regions.
[`enrichModule()`](https://lasallegrp.github.io/comethyl/reference/enrichModule.md)
performs enrichment analysis for a module using Enrichr,
[`listOntologies()`](https://lasallegrp.github.io/comethyl/reference/listOntologies.md)
lists available ontologies, and
[`plotEnrichment()`](https://lasallegrp.github.io/comethyl/reference/plotEnrichment.md)
plots the enrichment results.

``` r

regions_annotated <- annotateModule(regions, module = "blue",
                                   genome = "hg38",
                                   file = "Blue_Module_Annotated_Regions.txt")
geneList <- getGeneList(regions_annotated, module = "blue")
enrichment <- enrichModule(regions = regions, module = "blue",
                          genome = "hg38",
                          file = "Blue_Module_Enrichment.txt")
plotEnrichment(enrichment, file = "Blue_Module_Enrichment.pdf")
```

![Figure 12. Blue Module
Enrichment](CpG%20Cluster%20Analysis/Blue_Module_Enrichment.png)

Figure 12. Blue Module Enrichment

## See Also

- [Function
  reference](https://lasallegrp.github.io/comethyl/reference/index.html)
- [Get Started
  vignette](https://lasallegrp.github.io/comethyl/articles/comethyl.html)
- [Gene Body Analysis
  vignette](https://lasallegrp.github.io/comethyl/articles/Gene_Body_Analysis.html)
- [Module Preservation
  vignette](https://lasallegrp.github.io/comethyl/articles/Module_Preservation.html)
- [Consensus Module Analysis
  vignette](https://lasallegrp.github.io/comethyl/articles/Consensus_Module_Analysis.html)
