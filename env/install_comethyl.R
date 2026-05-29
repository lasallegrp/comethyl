# env/install_comethyl.R
# Run once after `pixi install`:
#   pixi run install-comethyl
#
# On linux-64 / osx-64: conda already installed Bioconductor packages.
#   requireNamespace() returns TRUE for them and the loops skip quickly.
#   Only WGCNA and comethyl itself are installed here.
#
# On osx-arm64: bioconda ARM64 builds require r-base >=4.4 but this env
#   uses 4.3.*. BiocManager installs the full Bioconductor stack instead.
# -----------------------------------------------------------------------

options(repos = c(CRAN = "https://cloud.r-project.org"))

lib <- .libPaths()[1]
message("Installing into: ", lib)
message("Platform: ", R.version$os, " / ", R.version$arch)

# ── Bootstrap ────────────────────────────────────────────────────────────────
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager", lib = lib)
if (!requireNamespace("remotes", quietly = TRUE))
  install.packages("remotes", lib = lib)

# Lock Bioconductor to 3.18 — the release matching r-base 4.3.*
BiocManager::install(version = "3.18", ask = FALSE)
options(repos = BiocManager::repositories())

# ── Bioconductor packages ────────────────────────────────────────────────────
# On linux-64/osx-64 these are already conda-installed and will be skipped.
# On osx-arm64 BiocManager installs them all.
bioc_pkgs <- c(
  # Core infrastructure
  "BiocGenerics",
  "S4Vectors",
  "IRanges",
  "GenomeInfoDb",
  "GenomeInfoDbData",
  "GenomicRanges",
  "SummarizedExperiment",
  "DelayedArray",
  "MatrixGenerics",
  "DelayedMatrixStats",
  # Methylation
  "bsseq",
  "dmrseq",
  # Annotation
  "AnnotationDbi",
  "annotatr",
  "biomaRt",
  "TxDb.Hsapiens.UCSC.hg19.knownGene",
  "TxDb.Hsapiens.UCSC.hg38.knownGene",
  "org.Hs.eg.db",
  "GO.db",
  "HDO.db",
  # Batch / normalisation
  "sva",
  "preprocessCore",
  "impute",
  # Network / enrichment
  "WGCNA",
  "clusterProfiler",
  "DOSE",
  "enrichplot",
  "fgsea",
  "ReactomePA",
  "rGREAT",
  "reactome.db"
)

for (pkg in bioc_pkgs) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    message("Installing Bioconductor: ", pkg)
    tryCatch(
      BiocManager::install(pkg, lib = lib, ask = FALSE,
                           update = FALSE, force = FALSE),
      error = function(e) message("FAILED: ", pkg, " - ", e$message)
    )
  } else {
    message("Already installed: ", pkg)
  }
}

# ── comethyl ─────────────────────────────────────────────────────────────────
message("Installing comethyl from lasallegrp/comethyl ...")
remotes::install_github(
  "lasallegrp/comethyl",
  lib          = lib,
  upgrade      = "never",
  dependencies = FALSE
)

message("\nDone. Run `pixi run test-r` to verify the session.")