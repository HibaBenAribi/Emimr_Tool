
if (!require("shiny")) install.packages("shiny")
library(shiny)
if (!require("shinythemes")) install.packages("shinythemes")
library(shinythemes)
if (!require("shinycssloaders")) install.packages("shinycssloaders")
library(shinycssloaders)
if (!require("shinyWidgets")) install.packages("shinyWidgets")
library(shinyWidgets)
if (!require("shinydashboard")) install.packages("shinydashboard")
library(shinydashboard) 
if (!require("shinyFiles")) install.packages("shinyFiles")
library(shinyFiles)
if (!require("DT")) install.packages("DT")
library(DT) 
if (!require("dplyr")) install.packages("dplyr")
library(dplyr)
if (!require("ggplot2")) install.packages("ggplot2")
library(ggplot2)
if (!require("clusterProfiler")) install.packages("clusterProfiler")
library(clusterProfiler)
if (!require("enrichplot")) install.packages("enrichplot")
library(enrichplot)
if (!require("readr")) install.packages("readr")
library(readr)

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

