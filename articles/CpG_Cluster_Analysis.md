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

## Setup

    library(tidyverse)
    library(comethyl)

## Set Global Options

`WGCNA::disableWGCNAthreads()` prevents multi-threading for WGCNA
calculations, including all functions using
[`WGCNA::cor()`](https://rdrr.io/pkg/WGCNA/man/cor.html) and
[`WGCNA::bicor()`](https://rdrr.io/pkg/WGCNA/man/bicor.html). This is
recommended for large sets of regions (\> 150,000). For smaller region
sets, use `WGCNA::enableWGCNAthreads()` to allow for parallel
calculations with the specified number of threads. If the number of
threads is not provided, the default is the number of processors online.

    options(stringsAsFactors = FALSE)
    Sys.setenv(R_THREADS = 1)
    WGCNA::disableWGCNAThreads()

## Read Bismark CpG Reports

We read in an excel table with
[`openxlsx::read.xlsx()`](https://rdrr.io/pkg/openxlsx/man/read.xlsx.html)
where the first column includes the names of sample Bismark CpG reports
and all other columns include trait values for each sample. All trait
values must be numeric, though traits can be categorical or continuous.
[`getCpGs()`](https://lasallegrp.github.io/comethyl/reference/getCpGs.md)
reads individual sample Bismark CpG reports into a single BSseq object
and then saves it as a .rds file. See
[Inputs](https://cemordaunt.github.io/comethyl/articles/comethyl.html#inputs)
for more information.

    colData <- openxlsx::read.xlsx("sample_info.xlsx", rowNames = TRUE)
    bs <- getCpGs(colData, file = "Unfiltered_BSseq.rds")

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

    CpGtotals <- getCpGtotals(bs, file = "CpG_Totals.txt")
    plotCpGtotals(CpGtotals, file = "CpG_Totals.pdf")

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

    bs <- filterCpGs(bs, cov = 2, perSample = 0.75, file = "Filtered_BSseq.rds")

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

    regions <- getRegions(bs, file = "Unfiltered_Regions.txt")
    plotRegionStats(regions, maxQuantile = 0.99, file = "Unfiltered_Region_Plots.pdf")

![Figure 2. Unfiltered Region
Plots](CpG%20Cluster%20Analysis/Unfiltered_Region_Plots.png)

Figure 2. Unfiltered Region Plots

    plotSDstats(regions, maxQuantile = 0.99, file = "Unfiltered_SD_Plots.pdf")

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

    regionTotals <- getRegionTotals(regions, file = "Region_Totals.txt")
    plotRegionTotals(regionTotals, file = "Region_Totals.pdf")

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

    regions <- filterRegions(regions, covMin = 10, methSD = 0.05, file = "Filtered_Regions.txt")
    plotRegionStats(regions, maxQuantile = 0.99, file = "Filtered_Region_Plots.pdf")

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

    meth <- getRegionMeth(regions, bs = bs, file = "Region_Methylation.rds")
    mod <- model.matrix(~1, data = pData(bs))
    PCs <- getPCs(meth, mod = mod, file = "Top_Principal_Components.rds")
    methAdj <- adjustRegionMeth(meth, PCs = PCs, file = "Adjusted_Region_Methylation.rds")
    getDendro(methAdj, distance = "euclidean") %>% 
    plotDendro(file = "Sample_Dendrogram.pdf", expandY = c(0.25,0.08))

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

    sft <- getSoftPower(methAdj, corType = "pearson", file = "Soft_Power.rds")
    plotSoftPower(sft, file = "Soft_Power_Plots.pdf")

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
creates a bed file of regions annotated with identified modules; regions
in the unassigned grey module are excluded.

    modules <- getModules(methAdj, power = sft$powerEstimate, regions = regions, corType = "pearson", file = "Modules.rds")
    plotRegionDendro(modules, file = "Region_Dendrograms.pdf")
    BED <- getModuleBED(modules$regions, file = "Modules.bed")

![Figure 8. Region
Dendrograms](CpG%20Cluster%20Analysis/Region_Dendrograms.png)

Figure 8. Region Dendrograms

## Examine Correlations between Modules and Samples

In order to examine relationships between modules, `getDendro(MEs)`
clusters modules based on eigennode values using Bicor or Pearson
correlations, which are then plotted with
[`plotDendro()`](https://lasallegrp.github.io/comethyl/reference/plotDendro.md).
`getCor(MEs)` calculates a correlation matrix for module eigennodes
using Bicor or Pearson correlations, which are then plotted with
[`plotHeatmap()`](https://lasallegrp.github.io/comethyl/reference/plotHeatmap.md).
We use Bicor correlations at this stage to identify robust associations
with less impact of outliers. Note that module correlation statistics
(with p-values) can also be calculated with
[`getMEtraitCor()`](https://lasallegrp.github.io/comethyl/reference/getMEtraitCor.md).
We can use these plots to identify large groups of modules with low
correlation as well as highly correlated pairs (such as floral white and
light cyan).

    MEs <- modules$MEs
    moduleDendro <- getDendro(MEs, distance = "bicor")
    plotDendro(moduleDendro, labelSize = 4, nBreaks = 5, file = "Module_ME_Dendrogram.pdf")

![Figure 9. Module ME
Dendrogram](CpG%20Cluster%20Analysis/Module_ME_Dendrogram.png)

Figure 9. Module ME Dendrogram

    moduleCor <- getCor(MEs, corType = "bicor")
    plotHeatmap(moduleCor, rowDendro = moduleDendro, colDendro = moduleDendro, file = "Module_Correlation_Heatmap.pdf")
    moduleCorStats <- getMEtraitCor(MEs, colData = MEs, corType = "bicor", robustY = TRUE, file = "Module_Correlation_Stats.txt")

![Figure 10. Module Correlation
Heatmap](CpG%20Cluster%20Analysis/Module_Correlation_Heatmap.png)

Figure 10. Module Correlation Heatmap

To explore associations between samples,
`getDendro(MEs, transpose = TRUE)` clusters the samples based on module
eigennode values using Bicor or Pearson correlations, which are then
plotted with
[`plotDendro()`](https://lasallegrp.github.io/comethyl/reference/plotDendro.md).
`getCor(MEs, transpose = TRUE)` calculates a correlation matrix for
samples based on module eigennode vales using Bicor or Pearson
correlations, which are then plotted with
[`plotHeatmap()`](https://lasallegrp.github.io/comethyl/reference/plotHeatmap.md).
[`plotHeatmap()`](https://lasallegrp.github.io/comethyl/reference/plotHeatmap.md)
can also be used to visualize module eigennode values for each sample as
below. These plots can be useful to identify sets of samples with
correlated methylation at these regions. This may also reveal the impact
of batch effects on the identified modules.

    sampleDendro <- getDendro(MEs, transpose = TRUE, distance = "bicor")
    plotDendro(sampleDendro, labelSize = 3, nBreaks = 5, file = "Sample_ME_Dendrogram.pdf")

![Figure 11. Sample ME
Dendrogram](CpG%20Cluster%20Analysis/Sample_ME_Dendrogram.png)

Figure 11. Sample ME Dendrogram

    sampleCor <- getCor(MEs, transpose = TRUE, corType = "bicor")
    plotHeatmap(sampleCor, rowDendro = sampleDendro, colDendro = sampleDendro, file = "Sample_Correlation_Heatmap.pdf")

![Figure 12. Sample Correlation
Heatmap](CpG%20Cluster%20Analysis/Sample_Correlation_Heatmap.png)

Figure 12. Sample Correlation Heatmap

    plotHeatmap(MEs, rowDendro = sampleDendro, colDendro = moduleDendro, legend.title = "Module\nEigennode", legend.position = c(0.37,0.89), file = "Sample_ME_Heatmap.pdf")

![Figure 13. Sample ME
Heatmap](CpG%20Cluster%20Analysis/Sample_ME_Heatmap.png)

Figure 13. Sample ME Heatmap

## Test Correlations between Module Eigennodes and Sample Traits

Next we can look for modules associated with sample traits.
[`getMEtraitCor()`](https://lasallegrp.github.io/comethyl/reference/getMEtraitCor.md)
tests associations between module eigennodes and sample traits using
Bicor or Pearson correlation.
[`getCor()`](https://lasallegrp.github.io/comethyl/reference/getCor.md)
calculates a correlation matrix for sample traits using Bicor or Pearson
correlations, which are clustered with
[`getDendro()`](https://lasallegrp.github.io/comethyl/reference/getDendro.md),
and then plotted with
[`plotDendro()`](https://lasallegrp.github.io/comethyl/reference/plotDendro.md).
This allows us to identify correlated traits and order both traits and
modules on the heatmap by similarity.
[`plotMEtraitCor()`](https://lasallegrp.github.io/comethyl/reference/plotMEtraitCor.md)
creates a heatmap of sample traits versus modules. To focus on the top
associations, another heatmap is created showing only the top 15
associations by p-value. Significant associations can be identified by a
star or the p-value itself. Here we identify significant correlations
between several modules and sample traits including cell type
proportions, study cohort, genome-wide methylation, and later autism
diagnosis.

    MEtraitCor <- getMEtraitCor(MEs, colData = colData, corType = "bicor", file = "ME_Trait_Correlation_Stats.txt")
    traitDendro <- getCor(MEs, y = colData, corType = "bicor", robustY = FALSE) %>% getDendro(transpose = TRUE)
    plotDendro(traitDendro, labelSize = 3.5, expandY = c(0.65,0.08), file = "Trait_Dendrogram.pdf")

![Figure 14. Trait
Dendrogram](CpG%20Cluster%20Analysis/Trait_Dendrogram.png)

Figure 14. Trait Dendrogram

    plotMEtraitCor(MEtraitCor, moduleOrder = moduleDendro$order, traitOrder = traitDendro$order, file = "ME_Trait_Correlation_Heatmap.pdf")

![Figure 15. ME Trait Correlation
Heatmap](CpG%20Cluster%20Analysis/ME_Trait_Correlation_Heatmap.png)

Figure 15. ME Trait Correlation Heatmap

    plotMEtraitCor(MEtraitCor, moduleOrder = moduleDendro$order, traitOrder = traitDendro$order, topOnly = TRUE, label.type = "p", label.size = 4, label.nudge_y = 0, legend.position = c(1.11, 0.795), colColorMargins = c(-1,4.75,0.5,10.1), file = "Top_ME_Trait_Correlation_Heatmap.pdf", width = 8.5, height = 4.25)

![Figure 16. Top ME Trait Correlation
Heatmap](CpG%20Cluster%20Analysis/Top_ME_Trait_Correlation_Heatmap.png)

Figure 16. Top ME Trait Correlation Heatmap

## Explore Significant Module Eigennode - Trait Correlations

### Plot Module Eigennodes vs Traits

To further investigate top module-trait associations,
[`plotMEtraitDot()`](https://lasallegrp.github.io/comethyl/reference/plotMEtraitDot.md)
creates a dotplot of a module eigennode by a categorical trait, while
[`plotMEtraitScatter()`](https://lasallegrp.github.io/comethyl/reference/plotMEtraitScatter.md)
creates a scatterplot of a module eigennode by a continuous trait. Any
module and any sample trait can be selected. These plots can help verify
that the module-trait association is robust and identify any outlier
samples. Here we see that the bisque 4 module has lower methylation in
ASD samples, while the pale turquoise module methylation correlates (in
opposite directions) with the proportion of granulocytes and B cells.

    plotMEtraitDot(MEs$bisque4, trait = colData$Diagnosis_ASD, traitCode = c("TD" = 0, "ASD" = 1), colors = c("TD" = "#3366CC", "ASD" = "#FF3366"), ylim = c(-0.2,0.2), xlab = "Diagnosis", ylab = "Bisque 4 Module Eigennode", file = "bisque4_ME_Diagnosis_Dotplot.pdf")

![Figure 17. Bisque4 ME Diagnosis
Dotplot](CpG%20Cluster%20Analysis/bisque4_ME_Diagnosis_Dotplot.png)

Figure 17. Bisque4 ME Diagnosis Dotplot

    plotMEtraitScatter(MEs$paleturquoise, trait = colData$Gran, ylim = c(-0.15,0.15), xlab = "Granulocytes", ylab = "Pale Turquoise Module Eigennode", file = "paleturquoise_ME_Granulocytes_Scatterplot.pdf")

![Figure 18. Pale Turquoise ME Granulocytes
Scatterplot](CpG%20Cluster%20Analysis/paleturquoise_ME_Granulocytes_Scatterplot.png)

Figure 18. Pale Turquoise ME Granulocytes Scatterplot

    plotMEtraitScatter(MEs$paleturquoise, trait = colData$Bcell, ylim = c(-0.15,0.15), xlab = "B-cells", ylab = "Pale Turquoise Module Eigennode", file = "paleturquoise_ME_Bcells_Scatterplot.pdf")

![Figure 19. Pale Turquoise ME B Cells
Scatterplot](CpG%20Cluster%20Analysis/paleturquoise_ME_Bcells_Scatterplot.png)

Figure 19. Pale Turquoise ME B Cells Scatterplot

### Plot Region Methylation vs Traits

Next we dig further into the data and plot the raw methylation values
against a sample trait using
[`plotMethTrait()`](https://lasallegrp.github.io/comethyl/reference/plotMethTrait.md).
These values are not adjusted by principal components, just centered on
the mean methylation for each region. This allows you to see the change
in actual methylation across regions in a module in relation to a trait.
We plot the same associations as above.

    regions <- modules$regions
    plotMethTrait("bisque4", regions = regions, meth = meth, trait = colData$Diagnosis_ASD, traitCode = c("TD" = 0, "ASD" = 1), traitColors = c("TD" = "#3366CC", "ASD" = "#FF3366"), trait.legend.title = "Diagnosis", file = "bisque4_Module_Methylation_Diagnosis_Heatmap.pdf")

![Figure 20. Bisque4 Module Methylation Diagnosis
Heatmap](CpG%20Cluster%20Analysis/bisque4_Module_Methylation_Diagnosis_Heatmap.png)

Figure 20. Bisque4 Module Methylation Diagnosis Heatmap

    plotMethTrait("paleturquoise", regions = regions, meth = meth, trait = colData$Gran, expandY = 0.04, trait.legend.title = "Granulocytes", trait.legend.position = c(1.034,3.35), file = "paleturquoise_Module_Methylation_Granulocytes_Heatmap.pdf")

![Figure 21. Pale Turquoise Module Methylation Granulocytes
Heatmap](CpG%20Cluster%20Analysis/paleturquoise_Module_Methylation_Granulocytes_Heatmap.png)

Figure 21. Pale Turquoise Module Methylation Granulocytes Heatmap

    plotMethTrait("paleturquoise", regions = regions, meth = meth, trait = colData$Bcell, expandY = 0.04, trait.legend.title = "B-cells", trait.legend.position = c(1.004,3.35), file = "paleturquoise_Module_Methylation_Bcells_Heatmap.pdf")

![Figure 22. Pale Turquoise Module Methylation B-Cells
Heatmap](CpG%20Cluster%20Analysis/paleturquoise_Module_Methylation_Bcells_Heatmap.png)

Figure 22. Pale Turquoise Module Methylation B-Cells Heatmap

## Annotate Modules

[`annotateModule()`](https://lasallegrp.github.io/comethyl/reference/annotateModule.md)
annotates a module of choice with nearby gene and CpG island context.
Genes are added to regions using GREAT, gene info is added from BioMart,
and both gene and CpG island context is added from `annotatr`.
[`getGeneList()`](https://lasallegrp.github.io/comethyl/reference/getGeneList.md)
then extracts just the genes for that module, in the form of the gene
symbol, description, Ensembl ID, or NCBI Entrez ID.

    regionsAnno <- annotateModule(regions, module = c("bisque4", "paleturquoise"), genome = "hg38", file = "Annotated_bisque4_paleturquoise_Module_Regions.txt")
    geneList_bisque4 <- getGeneList(regionsAnno, module = "bisque4")
    geneList_paleturquoise <- getGeneList(regionsAnno, module = "paleturquoise")

## Analyze Functional Enrichment

Next we test our modules of interest for enrichment in genes with
particular functions.
[`listOntologies()`](https://lasallegrp.github.io/comethyl/reference/listOntologies.md)
gets available ontologies for GREAT with the selected genome assembly.
[`enrichModule()`](https://lasallegrp.github.io/comethyl/reference/enrichModule.md)
analyzes functional enrichments for all regions assigned to the selected
module, relative to the background set of all regions input into the
network (including those assigned to the grey (unassigned) module).
[`plotEnrichment()`](https://lasallegrp.github.io/comethyl/reference/plotEnrichment.md)
then plots the module enrichments from GREAT.

Using this approach, we see that the bisque 4 module associated with ASD
diagnosis is enriched for genes that play a role in glial
differentiation and other neurodevelopmental processes. In contrast the
pale turquoise module associated with the proportion of immune cell
types is enriched for genes that function in the response to bacterial
infection and other immune processes.

    ontologies <- listOntologies("hg38", version = "4.0.4")
    enrich_bisque4 <- enrichModule(regions, module = "bisque4", genome = "hg38", file = "bisque4_Module_Enrichment.txt")
    plotEnrichment(enrich_bisque4, file = "bisque4_Module_Enrichment_Plot.pdf")

![Figure 23. Bisque4 Module Enrichment
Plot](CpG%20Cluster%20Analysis/bisque4_Module_Enrichment_Plot.png)

Figure 23. Bisque4 Module Enrichment Plot

    enrich_paleturquoise <- enrichModule(regions, module = "paleturquoise", genome = "hg38", file = "paleturquoise_Module_Enrichment.txt")
    plotEnrichment(enrich_paleturquoise, axis.text.y.size = 14, width = 10, file = "paleturquoise_Module_Enrichment_Plot.pdf")

![Figure 24. Pale Turquoise Module Enrichment
Plot](CpG%20Cluster%20Analysis/paleturquoise_Module_Enrichment_Plot.png)

Figure 24. Pale Turquoise Module Enrichment Plot
