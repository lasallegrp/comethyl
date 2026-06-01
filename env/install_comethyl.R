# env/install_comethyl.R
# Run once after `pixi install`:
#   pixi run install-comethyl
#
# Fixes encoded here:
#   - rtracklayer 1.66.0: gcc15 rejects parameter named 'free' (shadows stdlib);
#     rename to 'freeFn' with explicit void* arg type in both common.c and common.h
#   - gdtools 0.5.1: cairo-ft.h is nested under cairo/ subdir on conda-forge;
#     patch sysdeps.c and source files, pass freetype2 include path explicitly
#   - ggtree 3.14.0 (Bioc 3.20): incompatible with ggplot2 >=4.0 (check_linewidth removed);
#     install GitHub HEAD (4.x) which is ggplot2-4.x compatible
#   - dmrseq depends on annotatr; install annotatr first
# -----------------------------------------------------------------------

options(repos = c(CRAN = "https://cloud.r-project.org"))

lib <- .libPaths()[1]
message("Installing into: ", lib)
message("Platform: ", R.version$os, " / ", R.version$arch)

# Pixi env prefix (parent of lib/R)
pixi_prefix <- dirname(dirname(R.home()))
message("Pixi prefix: ", pixi_prefix)

# ── Bootstrap ────────────────────────────────────────────────────────────────
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager", lib = lib)
if (!requireNamespace("remotes", quietly = TRUE))
  install.packages("remotes", lib = lib)

BiocManager::install(version = "3.20", ask = FALSE)
options(repos = BiocManager::repositories())

# ── Helper: install from tarball ─────────────────────────────────────────────
install_tarball <- function(pkg, version, repo, lib) {
  if (requireNamespace(pkg, quietly = TRUE)) {
    message("Already installed: ", pkg); return(invisible(NULL))
  }
  message("Installing from tarball: ", pkg)
  url <- paste0(repo, pkg, "_", version, ".tar.gz")
  tgz <- tempfile(pattern = paste0(pkg, "_"), fileext = ".tar.gz")
  tryCatch({
    download.file(url, tgz, quiet = TRUE)
    install.packages(tgz, repos = NULL, type = "source", lib = lib)
    if (!requireNamespace(pkg, quietly = TRUE))
      message("WARNING: ", pkg, " may not have installed correctly")
  }, error = function(e) {
    message("FAILED: ", pkg, " - ", e$message)
  })
}

bioc_base <- "https://bioconductor.org/packages/3.20/bioc/src/contrib/"
bioc_ann  <- "https://bioconductor.org/packages/3.20/data/annotation/src/contrib/"

# ── Step 1: rtracklayer ───────────────────────────────────────────────────────
# gcc 15 rejects ucsc/common.c because a parameter is literally named 'free',
# shadowing stdlib's free(). Fix: rename to 'freeFn' with explicit void* arg type.
# Also fix common.h declaration which uses old-style void (*free)() — no arg types —
# which gcc 15 now strictly treats as zero-argument.

patch_and_install_rtracklayer <- function(lib) {
  if (requireNamespace("rtracklayer", quietly = TRUE)) {
    message("Already installed: rtracklayer"); return(invisible(TRUE))
  }
  message("Patching rtracklayer (gcc15 'free' parameter conflict)...")
  pkg_url <- paste0("https://bioconductor.org/packages/3.20/bioc/src/",
                    "contrib/rtracklayer_1.66.0.tar.gz")
  pkg_tgz <- tempfile(pattern = "rtracklayer_", fileext = ".tar.gz")
  src_dir  <- tempfile(pattern = "rt_src_")
  dir.create(src_dir)

  download.file(pkg_url, pkg_tgz, quiet = FALSE)
  untar(pkg_tgz, exdir = src_dir)

  common_c <- file.path(src_dir, "rtracklayer", "src", "ucsc", "common.c")
  common_h <- file.path(src_dir, "rtracklayer", "src", "ucsc", "common.h")

  # Patch common.c: rename 'free' parameter -> 'freeFn' with void* arg type
  src_c <- readLines(common_c)
  src_c <- gsub("void \\(\\*free\\)\\(", "void (*freeFn)(", src_c, fixed = FALSE)
  src_c <- gsub("else if (free != NULL)", "else if (freeFn != NULL)", src_c, fixed = TRUE)
  src_c <- gsub("free(el);", "freeFn(el);", src_c, fixed = TRUE)
  src_c <- gsub("void (*freeFn)()", "void (*freeFn)(void *)", src_c, fixed = TRUE)
  writeLines(src_c, common_c)
  message("  common.c patched")

  # Patch common.h: fix old-style void (*free)() declaration
  if (file.exists(common_h)) {
    src_h <- readLines(common_h)
    src_h <- gsub("void (*free)()", "void (*freeFn)(void *)", src_h, fixed = TRUE)
    writeLines(src_h, common_h)
    message("  common.h patched: ", sum(grepl("freeFn", src_h)), " line(s) changed")
  }

  # Update MD5 checksums
  md5_file <- file.path(src_dir, "rtracklayer", "MD5")
  if (file.exists(md5_file)) {
    md5lines <- readLines(md5_file)
    md5lines <- sub("^[a-f0-9]+ \\*src/ucsc/common\\.c$",
                    paste0(tools::md5sum(common_c)[[1]], " *src/ucsc/common.c"), md5lines)
    md5lines <- sub("^[a-f0-9]+ \\*src/ucsc/common\\.h$",
                    paste0(tools::md5sum(common_h)[[1]], " *src/ucsc/common.h"), md5lines)
    writeLines(md5lines, md5_file)
  }

  install.packages(file.path(src_dir, "rtracklayer"),
                   repos = NULL, type = "source", lib = lib)

  if (requireNamespace("rtracklayer", quietly = TRUE)) {
    message("rtracklayer installed successfully")
    return(invisible(TRUE))
  } else {
    message("FAILED: rtracklayer still not installed")
    return(invisible(FALSE))
  }
}

patch_and_install_rtracklayer(lib)

# ── Step 2: rtracklayer dependents — direct tarballs, correct order ───────────
# annotatr must come before dmrseq (dmrseq Imports annotatr)
install_tarball("BSgenome",        "1.74.0",  bioc_base, lib)
install_tarball("GenomicFeatures", "1.58.0",  bioc_base, lib)
install_tarball("GenomicAlignments","1.42.0", bioc_base, lib)
install_tarball("regioneR",        "1.38.0",  bioc_base, lib)
install_tarball("bumphunter",      "1.48.0",  bioc_base, lib)
install_tarball("TxDb.Hsapiens.UCSC.hg19.knownGene", "3.2.2",  bioc_ann, lib)
install_tarball("TxDb.Hsapiens.UCSC.hg38.knownGene", "3.20.0", bioc_ann, lib)
install_tarball("bsseq",           "1.42.0",  bioc_base, lib)
install_tarball("annotatr",        "1.32.0",  bioc_base, lib)  # before dmrseq
install_tarball("dmrseq",          "1.26.0",  bioc_base, lib)
install_tarball("rGREAT",          "2.8.0",   bioc_base, lib)

# ── Step 3: gdtools (patched) → ggiraph → ggtree ─────────────────────────────
# gdtools 0.5.1 configure test includes <cairo-ft.h> but conda-forge puts it
# at include/cairo/cairo-ft.h and ft2build.h at include/freetype2/ft2build.h.
# Patch the configure test and pass explicit include paths.

install_gdtools_patched <- function(lib, pixi_prefix) {
  if (requireNamespace("gdtools", quietly = TRUE)) {
    message("Already installed: gdtools"); return(invisible(NULL))
  }
  message("Installing gdtools (patched for conda-forge cairo layout)...")

  tgz <- tempfile(pattern = "gdtools_", fileext = ".tar.gz")
  src <- tempfile(pattern = "gdtools_src_")
  dir.create(src)
  download.file("https://cloud.r-project.org/src/contrib/gdtools_0.5.1.tar.gz",
                tgz, quiet = TRUE)
  untar(tgz, exdir = src)

  # Patch: conda-forge puts cairo-ft.h under cairo/ subdir
  for (f in list.files(file.path(src, "gdtools", "src"),
                        pattern = "[.][ch]$", full.names = TRUE, recursive = TRUE)) {
    lines <- readLines(f)
    if (any(grepl("<cairo-ft.h>", lines, fixed = TRUE))) {
      lines <- gsub("<cairo-ft.h>", "<cairo/cairo-ft.h>", lines, fixed = TRUE)
      writeLines(lines, f)
      message("  Patched: ", basename(f))
    }
  }

  # Build include/lib flags pointing at pixi env
  inc <- paste0(
    "-I", pixi_prefix, "/include",
    " -I", pixi_prefix, "/include/freetype2",
    " -I", pixi_prefix, "/include/cairo"
  )
  libs <- paste0("-L", pixi_prefix, "/lib -lcairo -lfreetype -lfontconfig")

  Sys.setenv(
    PKG_CONFIG_PATH = paste0(pixi_prefix, "/lib/pkgconfig"),
    PKG_CFLAGS = inc,
    PKG_LIBS   = libs
  )

  install.packages(file.path(src, "gdtools"), repos = NULL, type = "source",
                   lib = lib,
                   configure.vars = paste0(
                     "INCLUDE_DIR=", pixi_prefix, "/include",
                     " LIB_DIR=", pixi_prefix, "/lib"))

  if (!requireNamespace("gdtools", quietly = TRUE))
    message("WARNING: gdtools may not have installed correctly")
}

install_gdtools_patched(lib, pixi_prefix)

# ggiraph depends on gdtools
if (!requireNamespace("ggiraph", quietly = TRUE)) {
  message("Installing ggiraph...")
  install.packages("ggiraph", lib = lib)
} else {
  message("Already installed: ggiraph")
}

# ggtree 3.14.0 (Bioc 3.20) calls check_linewidth() which was removed in
# ggplot2 4.0. Install GitHub HEAD (4.x) which is ggplot2-4.x compatible.
# ggtree is required by enrichplot → clusterProfiler → ReactomePA → comethyl.
if (!requireNamespace("ggtree", quietly = TRUE)) {
  message("Installing ggtree from GitHub (ggplot2 4.x compatible)...")
  remotes::install_github("YuLab-SMU/ggtree",
                          lib = lib, upgrade = "never", dependencies = FALSE)
} else {
  message("Already installed: ggtree")
}

# ── Step 4: remaining Bioconductor via BiocManager ───────────────────────────
bioc_pkgs <- c(
  "BiocGenerics", "S4Vectors", "IRanges", "GenomeInfoDb",
  "GenomeInfoDbData", "GenomicRanges", "SummarizedExperiment",
  "DelayedArray", "MatrixGenerics", "DelayedMatrixStats",
  "Biobase", "BiocParallel",
  "AnnotationDbi", "biomaRt",
  "org.Hs.eg.db", "GO.db", "HDO.db",
  "sva", "preprocessCore", "impute",
  "WGCNA", "GOSemSim", "DOSE", "fgsea",
  "enrichplot", "clusterProfiler",
  "ReactomePA", "reactome.db"
)

for (pkg in bioc_pkgs) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    message("Installing Bioconductor: ", pkg)
    tryCatch(
      BiocManager::install(pkg, lib = lib, ask = FALSE,
                           update = FALSE, force = FALSE),
      error = function(e) message("FAILED: ", pkg, " - ", e$message)
    )
    # BiocManager sometimes reinstalls rtracklayer unpatched as a side effect
    if (!requireNamespace("rtracklayer", quietly = TRUE)) {
      message("rtracklayer overwritten after ", pkg, " — repatching...")
      # Force reinstall by temporarily removing it
      try(remove.packages("rtracklayer", lib = lib), silent = TRUE)
      patch_and_install_rtracklayer(lib)
    }
  } else {
    message("Already installed: ", pkg)
  }
}

# ── Step 5: comethyl ──────────────────────────────────────────────────────────
message("Installing comethyl from lasallegrp/comethyl ...")
remotes::install_github("lasallegrp/comethyl",
                        lib = lib, upgrade = "never",
                        dependencies = FALSE)

message("\nDone. Run `pixi run test-r` to verify the session.")