# Package index

## Package

- [`comethyl`](https://lasallegrp.github.io/comethyl/reference/comethyl.md)
  : comethyl: An R package for weighted region comethylation network
  analysis

## Prepare Methylation Data

- [`getCpGs()`](https://lasallegrp.github.io/comethyl/reference/getCpGs.md)
  : Read Bismark CpG reports
- [`getCpGtotals()`](https://lasallegrp.github.io/comethyl/reference/getCpGtotals.md)
  : Get Total CpGs at Different Coverage Cutoffs
- [`plotCpGtotals()`](https://lasallegrp.github.io/comethyl/reference/plotCpGtotals.md)
  : Visualize Total CpGs at Different Coverage Cutoffs
- [`filterCpGs()`](https://lasallegrp.github.io/comethyl/reference/filterCpGs.md)
  : Filter BSseq Objects by Coverage
- [`getRegions()`](https://lasallegrp.github.io/comethyl/reference/getRegions.md)
  : Generate Regions from CpGs
- [`getRegionTotals()`](https://lasallegrp.github.io/comethyl/reference/getRegionTotals.md)
  : Get Region Totals at Different Cutoffs
- [`plotRegionTotals()`](https://lasallegrp.github.io/comethyl/reference/plotRegionTotals.md)
  : Visualize Region Totals at Different Cutoffs
- [`getRegionMeth()`](https://lasallegrp.github.io/comethyl/reference/getRegionMeth.md)
  : Get Region Methylation Data
- [`filterRegions()`](https://lasallegrp.github.io/comethyl/reference/filterRegions.md)
  : Filter Regions
- [`plotRegionStats()`](https://lasallegrp.github.io/comethyl/reference/plotRegionStats.md)
  : Plot Histograms of Region Statistics
- [`plotSDstats()`](https://lasallegrp.github.io/comethyl/reference/plotSDstats.md)
  : Plot Heatmaps of Region Standard Deviation vs Features
- [`getDendro()`](https://lasallegrp.github.io/comethyl/reference/getDendro.md)
  : Perform Hierarchical Clustering
- [`plotDendro()`](https://lasallegrp.github.io/comethyl/reference/plotDendro.md)
  : Plot a Dendrogram
- [`getPCs()`](https://lasallegrp.github.io/comethyl/reference/getPCs.md)
  : Calculate Top Principal Components
- [`adjustRegionMeth()`](https://lasallegrp.github.io/comethyl/reference/adjustRegionMeth.md)
  : Adjust Methylation Data for Principal Components

## Construct Network

- [`getCor()`](https://lasallegrp.github.io/comethyl/reference/getCor.md)
  : Calculate Correlations
- [`getSoftPower()`](https://lasallegrp.github.io/comethyl/reference/getSoftPower.md)
  : Estimate Soft Power Threshold
- [`plotSoftPower()`](https://lasallegrp.github.io/comethyl/reference/plotSoftPower.md)
  : Plot Soft Power Fit and Connectivity
- [`getModules()`](https://lasallegrp.github.io/comethyl/reference/getModules.md)
  : Identify Modules of Comethylated Regions
- [`plotRegionDendro()`](https://lasallegrp.github.io/comethyl/reference/plotRegionDendro.md)
  : Plot Region Dendrograms
- [`plotHeatmap()`](https://lasallegrp.github.io/comethyl/reference/plotHeatmap.md)
  : Plot a Heatmap with Dendrograms
- [`getModuleBED()`](https://lasallegrp.github.io/comethyl/reference/getModuleBED.md)
  : Get a Module BED file

## Explore Modules

- [`getMEtraitCor()`](https://lasallegrp.github.io/comethyl/reference/getMEtraitCor.md)
  : Calculate Correlation Statistics Between Module Eigennodes and
  Traits
- [`plotMEtraitCor()`](https://lasallegrp.github.io/comethyl/reference/plotMEtraitCor.md)
  : Plot a Heatmap of Correlations Between Module Eigennodes and Traits
- [`plotMEtraitDot()`](https://lasallegrp.github.io/comethyl/reference/plotMEtraitDot.md)
  : Visualize a Module Eigennode - Trait Correlation as a Dot Plot
- [`plotMEtraitScatter()`](https://lasallegrp.github.io/comethyl/reference/plotMEtraitScatter.md)
  : Visualize a Module Eigennode - Trait Correlation as a Scatter Plot
- [`plotMethTrait()`](https://lasallegrp.github.io/comethyl/reference/plotMethTrait.md)
  : Plot Module Methylation Values By a Sample Trait
- [`annotateModule()`](https://lasallegrp.github.io/comethyl/reference/annotateModule.md)
  : Annotate Module Regions
- [`getGeneList()`](https://lasallegrp.github.io/comethyl/reference/getGeneList.md)
  : Extract a Gene List from Annotated Regions
- [`enrichModule()`](https://lasallegrp.github.io/comethyl/reference/enrichModule.md)
  : Analyze Module Functional Enrichment with GREAT
- [`listOntologies()`](https://lasallegrp.github.io/comethyl/reference/listOntologies.md)
  : Get Ontologies Available in GREAT
- [`plotEnrichment()`](https://lasallegrp.github.io/comethyl/reference/plotEnrichment.md)
  : Plot Functional Enrichment Results

## Test Module Preservation

- [`getModulePreservation()`](https://lasallegrp.github.io/comethyl/reference/getModulePreservation.md)
  : Calculate Module Preservation
- [`plotModulePreservation()`](https://lasallegrp.github.io/comethyl/reference/plotModulePreservation.md)
  : Visualize Module Preservation
