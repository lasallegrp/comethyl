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
options(timeout = max(3600, getOption("timeout")))

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


# ── Step 1: rtracklayer ───────────────────────────────────────────────────────
# gcc 15 rejects ucsc/common.c because a parameter is literally named 'free',
# shadowing stdlib's free(). Fix: rename to 'freeFn' with explicit void* arg type.
# Also fix common.h declaration which uses old-style void (*free)() — no arg types —
# which gcc 15 now strictly treats as zero-argument.

install_bioc_or_stop <- function(pkgs, lib, retries = 3) {
  for (pkg in pkgs) {
    if (requireNamespace(pkg, quietly = TRUE)) {
      message("Already installed: ", pkg)
      next
    }

    success <- FALSE

    for (attempt in seq_len(retries)) {
      message("Installing Bioconductor: ", pkg, " [attempt ", attempt, "/", retries, "]")

      tryCatch(
        {
          BiocManager::install(pkg, lib = lib, ask = FALSE, update = FALSE)
        },
        error = function(e) {
          message("Attempt ", attempt, " failed for ", pkg, ": ", e$message)
        }
      )

      if (requireNamespace(pkg, quietly = TRUE)) {
        success <- TRUE
        break
      }

      if (attempt < retries) {
        message("Retrying ", pkg, " after 30 seconds...")
        Sys.sleep(30)
      }
    }

    if (!success) {
      stop("Failed to install required package: ", pkg, call. = FALSE)
    }
  }
}

pre_rtracklayer_pkgs <- c(
  "BiocGenerics",
  "S4Vectors",
  "IRanges",
  "XVector",
  "GenomeInfoDb",
  "GenomeInfoDbData",
  "Biostrings",
  "GenomicRanges",
  "XML",
  "curl",
  "httr",
  "Rsamtools",
  "BiocIO",
  "restfulr",
  "GenomicAlignments"
)

install_bioc_or_stop(pre_rtracklayer_pkgs, lib)


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

if (!requireNamespace("rtracklayer", quietly = TRUE)) {
  stop("rtracklayer failed to install even after patching.", call. = FALSE)
}


# ── Step 2: rtracklayer dependents — direct tarballs, correct order ───────────
# annotatr must come before dmrseq (dmrseq Imports annotatr)
post_rtracklayer_pkgs <- c(
  "BSgenome",
  "GenomicFeatures",
  "regioneR",
  "bumphunter",
  "TxDb.Hsapiens.UCSC.hg19.knownGene",
  "TxDb.Hsapiens.UCSC.hg38.knownGene",
  "bsseq",
  "annotatr",
  "dmrseq",
  "rGREAT"
)

install_bioc_or_stop(post_rtracklayer_pkgs, lib)
# ── Step 3: gdtools (patched) → ggiraph → ggtree ─────────────────────────────
# gdtools 0.5.1 configure test includes <cairo-ft.h> but conda-forge puts it
# at include/cairo/cairo-ft.h and ft2build.h at include/freetype2/ft2build.h.
# Patch the configure test and pass explicit include paths.

#install gdtools dependency
install_cran_or_stop <- function(pkgs, lib) {
  for (pkg in pkgs) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      message("Installing CRAN: ", pkg)
      install.packages(pkg, lib = lib, dependencies = TRUE)
    } else {
      message("Already installed: ", pkg)
    }

    if (!requireNamespace(pkg, quietly = TRUE)) {
      stop("Failed to install required CRAN package: ", pkg, call. = FALSE)
    }
  }
}

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
  # Patch all C/C++/header files, including src/tests/sysdeps.c.
  gdtools_root <- file.path(src, "gdtools")

  files_to_patch <- list.files(
    gdtools_root,
    pattern = "\\.(c|cc|cpp|h|hpp)$",
    full.names = TRUE,
    recursive = TRUE
  )

  for (f in files_to_patch) {
    lines <- readLines(f, warn = FALSE)

    if (any(grepl("<cairo-ft.h>", lines, fixed = TRUE))) {
      lines <- gsub("<cairo-ft.h>", "<cairo/cairo-ft.h>", lines, fixed = TRUE)
      writeLines(lines, f)
      message("  Patched cairo-ft include in: ", f)
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
    PKG_CONFIG_PATH = paste(
      file.path(pixi_prefix, "lib", "pkgconfig"),
      file.path(pixi_prefix, "share", "pkgconfig"),
      Sys.getenv("PKG_CONFIG_PATH"),
      sep = ":"
    ),
    PKG_CFLAGS = inc,
    PKG_LIBS   = libs
  )

  install.packages(file.path(src, "gdtools"), repos = NULL, type = "source",
                   lib = lib,
                   configure.vars = paste0(
                     "INCLUDE_DIR=", pixi_prefix, "/include",
                     " LIB_DIR=", pixi_prefix, "/lib"))

  if (!requireNamespace("gdtools", quietly = TRUE)) {
      stop("Failed to install patched gdtools.", call. = FALSE)
    }

  message("gdtools installed successfully")
}
gdtools_cran_prereqs <- c("fontquiver")
install_cran_or_stop(gdtools_cran_prereqs, lib)

install_gdtools_patched(lib, pixi_prefix)

if (!requireNamespace("gdtools", quietly = TRUE)) {
  stop("Patched gdtools failed to install. Cannot continue to ggiraph.", call. = FALSE)
}

# ggiraph depends on gdtools
if (!requireNamespace("ggiraph", quietly = TRUE)) {
  message("Installing ggiraph...")
  install.packages("ggiraph", lib = lib, dependencies = FALSE)
}

if (!requireNamespace("ggiraph", quietly = TRUE)) {
  stop("Failed to install ggiraph.", call. = FALSE)
}

# ggtree 3.14.0 (Bioc 3.20) calls check_linewidth() which was removed in
# ggplot2 4.0. Install GitHub HEAD (4.x) which is ggplot2-4.x compatible.
# ggtree is required by enrichplot → clusterProfiler → ReactomePA → comethyl.
if (!requireNamespace("ggtree", quietly = TRUE)) {
  message("Installing ggtree from GitHub for ggplot2 4.x compatibility...")
  remotes::install_github(
    "YuLab-SMU/ggtree",
    lib = lib,
    upgrade = "never",
    dependencies = TRUE
  )
}

if (!requireNamespace("ggtree", quietly = TRUE)) {
  stop("Failed to install ggtree.", call. = FALSE)
}



# ── Step 4: remaining Bioconductor via BiocManager ───────────────────────────
core_bioc_pkgs <- c(
  "SummarizedExperiment",
  "DelayedArray",
  "MatrixGenerics",
  "DelayedMatrixStats",
  "Biobase",
  "BiocParallel",
  "AnnotationDbi",
  "biomaRt",
  "org.Hs.eg.db",
  "GO.db",
  "HDO.db",
  "sva",
  "preprocessCore",
  "impute",
  "WGCNA"
)

install_bioc_or_stop(core_bioc_pkgs, lib)

enrichment_pkgs <- c(
  "GOSemSim",
  "DOSE",
  "fgsea",
  "reactome.db",
  "enrichplot",
  "clusterProfiler",
  "ReactomePA"
)

install_bioc_or_stop(enrichment_pkgs, lib)

# ── Step 5: comethyl ──────────────────────────────────────────────────────────
message("Installing comethyl from lasallegrp/comethyl ...")
remotes::install_github("lasallegrp/comethyl",
                        lib = lib, upgrade = "never",
                        dependencies = FALSE)

required_full_pipeline <- c(
  "bsseq",
  "annotatr",
  "dmrseq",
  "rGREAT",
  "clusterProfiler",
  "enrichplot",
  "ReactomePA",
  "reactome.db",
  "WGCNA",
  "sva",
  "rtracklayer",
  "comethyl"
)

missing <- required_full_pipeline[
  !vapply(required_full_pipeline, requireNamespace, logical(1), quietly = TRUE)
]

if (length(missing) > 0) {
  stop(
    "Full comethyl installation failed. Missing packages: ",
    paste(missing, collapse = ", "),
    call. = FALSE
  )
}

message("\nFull comethyl installation completed successfully.")
message("Run `pixi run test-r` to verify the session.")