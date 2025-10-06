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
source("Dependencies_emimr.R")
source("Ui.R",local = TRUE)

source("Server.R",local = TRUE)

# Run the application
shinyApp(ui = Ui, server = Server)
