## Run the following  code in order
source("Dependencies_emimr.R")
source("Ui.R",local = TRUE)

source("Server.R",local = TRUE)

# Run the application

shinyApp(ui = Ui, server = Server)
