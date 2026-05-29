# comethyl <img src="man/figures/comethyl.png" align="right" width="120"/>

An R package for weighted region comethylation network analysis.

[![DOI](https://img.shields.io/badge/DOI-10.1093%2Fbib%2Fbbab554-blue)](https://academic.oup.com/bib/advance-article/doi/10.1093/bib/bbab554/6509051)

## Overview

Comethyl builds upon the WGCNA package to identify and interpret modules of
comethylated regions from whole-genome bisulfite sequencing data. Regions are
defined from clusters of CpG sites or from genomic annotations, and then
percent methylation values are used to identify comethylation modules.
Interesting modules are identified and explored by comparing with sample traits
and examining functional enrichments. Results are then visualized with
high-quality, editable plots from ggplot2.

## Installation

### Option 1: pixi (Recommended)

[pixi](https://pixi.sh) provides a fully reproducible, cross-platform
environment with all dependencies pinned via a lock file.

```bash
# Install pixi (macOS / Linux / WSL2)
curl -fsSL https://pixi.sh/install.sh | bash

# Clone the repo and install the environment
git clone https://github.com/lasallegrp/comethyl.git
cd comethyl
pixi install
pixi run install-comethyl
```

See the [Get Started vignette](https://lasallegrp.github.io/comethyl/articles/comethyl.html)
for full installation instructions including Windows (WSL2) and Apple Silicon support.

### Option 2: remotes

If you already have R ≥ 4.3 and Bioconductor set up:

```r
install.packages(c("BiocManager", "remotes"))
BiocManager::install("lasallegrp/comethyl")
library(comethyl)
```

## Documentation

Complete documentation is available at <https://lasallegrp.github.io/comethyl/>.

- [Get Started](https://lasallegrp.github.io/comethyl/articles/comethyl.html)
- [Function Reference](https://lasallegrp.github.io/comethyl/reference/index.html)
- [CpG Cluster Analysis](https://lasallegrp.github.io/comethyl/articles/CpG_Cluster_Analysis.html)
- [Gene Body Analysis](https://lasallegrp.github.io/comethyl/articles/Gene_Body_Analysis.html)
- [Module Preservation](https://lasallegrp.github.io/comethyl/articles/Module_Preservation.html)
- [Consensus Module Analysis](https://lasallegrp.github.io/comethyl/articles/Consensus_Module_Analysis.html)

## Citation

Mordaunt CE, Mouat JS, Schmidt RJ, and LaSalle JM. (2022) Comethyl: a
network-based methylome approach to investigate the multivariate nature of
health and disease. *Briefings in Bioinformatics* bbab554.
<https://academic.oup.com/bib/advance-article/doi/10.1093/bib/bbab554/6509051>