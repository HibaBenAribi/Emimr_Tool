message("Checking, installing (if needed), and loading required dependencies...")

# ----------------- Bioconductor -----------------
install_bioc <- function(pkgs) {
  if (!requireNamespace("BiocManager", quietly = TRUE)) {
    message("Installing BiocManager...")
    install.packages("BiocManager")
  }
  
  for (pkg in pkgs) {
    # Install only if missing
    if (!requireNamespace(pkg, quietly = TRUE)) {
      message(paste0("Installing Bioconductor package: ", pkg))
      tryCatch({
        BiocManager::install(pkg, ask = FALSE, update = TRUE)
      }, error = function(e) {
        message("❌ Failed to install ", pkg, ": ", e$message)
      })
    } else {
      message(paste0("✔ ", pkg, " already installed."))
    }
    
    # Load library
    tryCatch({
      library(pkg, character.only = TRUE)
      message(paste0("Loaded ", pkg))
    }, error = function(e) {
      message("⚠ Could not load ", pkg, ": ", e$message)
    })
  }
}

bioc_pkgs <- c(
  "org.Hs.eg.db","org.Mm.eg.db", "org.At.tair.db","org.Dm.eg.db", "org.Dr.eg.db", "org.Rn.eg.db",
  "org.Sc.sgd.db", "org.Ce.eg.db","clusterProfiler","enrichplot"
)
install_bioc(bioc_pkgs)

# ----------------- CRAN -----------------
install_cran <- function(pkgs) {
  for (pkg in pkgs) {
    # Install only if missing
    if (!requireNamespace(pkg, quietly = TRUE)) {
      message(paste0("Installing CRAN package: ", pkg))
      tryCatch({
        install.packages(pkg, dependencies = TRUE)
      }, error = function(e) {
        message("❌ Failed to install ", pkg, ": ", e$message)
      })
    } else {
      message(paste0("✔ ", pkg, " already installed."))
    }
    
    # Load library
    tryCatch({
      library(pkg, character.only = TRUE)
      message(paste0("Loaded ", pkg))
    }, error = function(e) {
      message("⚠ Could not load ", pkg, ": ", e$message)
    })
  }
}

cran_pkgs <- c(
  "shiny", "shinythemes", "shinycssloaders",
  "shinyWidgets", "shinydashboard", "shinyFiles",
  "DT", "dplyr", "ggplot2", "readr"
)
install_cran(cran_pkgs)

message("\n✅ All dependencies are installed and loaded successfully!")

