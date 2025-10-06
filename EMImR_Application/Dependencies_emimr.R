message("Checking and installing required dependencies...")

# ------------------------------------------------------------
# Install Bioconductor dependencies
# ------------------------------------------------------------
install_bioc <- function(pkgs) {
  if (!requireNamespace("BiocManager", quietly = TRUE)) {
    message("Installing BiocManager...")
    install.packages("BiocManager")
  }
  
  for (pkg in pkgs) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      message(paste0("Installing Bioconductor package: ", pkg))
      tryCatch({
        BiocManager::install(pkg, ask = FALSE, update = TRUE)
      },
      error = function(e) {
        message("❌ Failed to install ", pkg, ": ", e$message)
        message("➡ Try manually using: BiocManager::install('", pkg, "')")
      })
    } else {
      message(paste0("✔ ", pkg, " already installed."))
    }
  }
}
bioc_pkgs <- c(
  "org.Hs.eg.db",    # Homo sapiens
  "org.Mm.eg.db",    # Mus musculus
  "org.At.tair.db",  # Arabidopsis thaliana
  "org.Dm.eg.db",    # Drosophila melanogaster
  "org.Dr.eg.db",    # Danio rerio 
  "org.Rn.eg.db",    # Rattus norvegicus
  "org.Sc.sgd.db",   # Saccharomyces cerevisiae
  "org.Ce.eg.db",     # Caenorhabditis elegans
  "clusterProfiler",
  "enrichplot"
)
install_bioc(bioc_pkgs)

# ------------------------------------------------------------
# Install CRAN dependencies
# ------------------------------------------------------------
install_cran <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    message(paste0("Installing CRAN package: ", pkg))
    tryCatch({
      install.packages(pkg, dependencies = TRUE)
    },
    error = function(e) {
      message("❌ Failed to install ", pkg, ": ", e$message)
      message("➡ Please try manually using: install.packages('", pkg, "')")
    })
  } else {
    message(paste0("✔ ", pkg, " already installed."))
  }
}
cran_pkgs <- c(
  "shiny", "shinythemes", "shinycssloaders",
  "shinyWidgets", "shinydashboard", "shinyFiles",
  "DT", "dplyr", "ggplot2", "readr"
)
invisible(lapply(cran_pkgs, install_cran))

# ------------------------------------------------------------
# Load all libraries
# ------------------------------------------------------------
all_pkgs <- c(bioc_pkgs, cran_pkgs)
failed <- c()

for (pkg in all_pkgs) {
  tryCatch({
    library(pkg, character.only = TRUE)
    message(paste0("📦 Loaded ", pkg))
  },
  error = function(e) {
    failed <<- c(failed, pkg)
    message("⚠ Could not load ", pkg, ": ", e$message)
  })
}

# ------------------------------------------------------------
# Summary
# ------------------------------------------------------------
if (length(failed) > 0) {
  message("\n⚠ The following packages could not be installed or loaded:")
  print(failed)
  message("Please install them manually before continuing.")
} else {
  message("\n All dependencies installed and loaded successfully!")
}

# ------------------------------------------------------------
# Species List
# ------------------------------------------------------------
species_list <- c(
  "Homo sapiens",
  "Mus musculus",
  "Arabidopsis thaliana",
  "Drosophila melanogaster",
  "Danio rerio",
  "Rattus norvegicus",
  "Saccharomyces cerevisiae",
  "Caenorhabditis elegans"
)

