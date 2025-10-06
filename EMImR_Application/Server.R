Server <- function(input, output) {
  observeEvent(input$submit_button, {
    # volcano plot
    volcano_plot_reactive <- reactive({
    
      req(input$Expression_data)
      expression  <- read.csv(input$Expression_data$datapath)
      expression$diffexpressed <- "Not Significant"
      #define degs
      expression$diffexpressed[expression$log2FoldChange  > as.numeric(input$log ) & expression$pvalue < as.numeric(input$pval) ] <- "Upregulated genes"
      expression$diffexpressed[expression$log2FoldChange  < -(as.numeric(input$log ))  & expression$pvalue < as.numeric(input$pval) ] <- "Downregulated genes"
      #plot
      ggplot(data=expression, aes(x=log2FoldChange, y=-log10(pvalue), col=diffexpressed)) +
        geom_point() + theme_minimal() + theme(text = element_text(size = 15))  
      
    })
    output$volcano_plot <- renderPlot({
      req(input$Expression_data)
      expression  <- read.csv(input$Expression_data$datapath)
      volcano_plot_reactive()
    })   
    #saver
    ## PDF download
    output$download_volcano_pdf <- downloadHandler(
      filename = function() {
        paste0("VolcanoPlot_", Sys.Date(), ".pdf")
      },
      content = function(file) {
        pdf(file, width = 8, height = 6)
        print(volcano_plot_reactive())
        dev.off()
      }
    )
    
    ## PNG download
    output$download_volcano_png <- downloadHandler(
      filename = function() {
        paste0("VolcanoPlot_", Sys.Date(), ".png")
      },
      content = function(file) {
        png(file, width = 1000, height = 800)
        print(volcano_plot_reactive())
        dev.off()
      }
    )
    #################################################################
    # Intersection exp met  
    inter_upexp_met_data <- reactive({
      req(input$Expression_data)
      req(input$Methylation_data)
      
      expdata <- read.csv(input$Expression_data$datapath)
      upregulated <- expdata %>%
        filter(pvalue < as.numeric(input$pval), log2FoldChange > as.numeric(input$log)) # upregulated
      
      colnames(upregulated)[colnames(upregulated) == "pvalue"] <- "expression_pvalue"
      colnames(upregulated)[colnames(upregulated) == "log2FoldChange"] <- "expression_log2FoldChange"
      
      metdata <- read.csv(input$Methylation_data$datapath)
      hypomethylated <- metdata %>%
        filter(pvalue < as.numeric(input$mpval), log2FoldChange < as.numeric(-input$mlog)) # hypomethylated
      
      colnames(hypomethylated)[colnames(hypomethylated) == "pvalue"] <- "methylation_pvalue"
      colnames(hypomethylated)[colnames(hypomethylated) == "log2FoldChange"] <- "methylation_log2FoldChange"
      
      upexp_met <- merge(upregulated, hypomethylated, by.x = "gene", by.y = "gene")
      upexp_met <-unique(upexp_met)
      
    })
    output$inter_upexp_met <- renderDT({
      inter_upexp_met_data <- inter_upexp_met_data()
      datatable(inter_upexp_met_data())
    })
    # Download 
    output$download_inter_upexp_met <- downloadHandler(
      filename = function() {
        paste0("inter_upexp_met_", Sys.Date(), ".csv")
      },
      content = function(file) {
        # Get the reactive table
        table_data <- inter_upexp_met_data()
        
        # Write to CSV
        write.csv(table_data, file, row.names = FALSE)
      }
    )
    
    
    ### OA
    plot_upexp_met <- reactive({
      # Get data from the reactive expression
      inter_upexp_met <- inter_upexp_met_data()
      exp_met <- inter_upexp_met 
      # filter genes m e
      group_gene  <- unique(c(exp_met$gene))
      
      #ontology type
      if (input$GOtype1 == "Biological Processes"){
        GO_type1 <- "BP"
      }else if (input$GOtype1 == "Cellular Compenant"){
        GO_type1 <- "CC"
      }else if (input$GOtype1 == "Molecular Function"){ 
        GO_type1 <- "MF"
      }
      #specie
      if (input$species == "Homo sapiens") {
        library(org.Hs.eg.db)
        specie1 <- "org.Hs.eg.db"
      } else if (input$species == "Mus musculus") {
        library(org.Mm.eg.db)
        specie1 <- "org.Mm.eg.db"
      } else if (input$species == "Arabidopsis thaliana") {
        library(org.At.tair.db)
        specie1 <- "org.At.tair.db"
      } else if (input$species == "Drosophila melanogaster") {
        library(org.Dm.eg.db)
        specie1 <- "org.Dm.eg.db"
      } else if (input$species == "Danio rerio") {
        library(org.Dr.eg.db)
        specie1 <- "org.Dr.eg.db"
      } else if (input$species == "Rattus norvegicus") {
        library(org.Rn.eg.db)
        specie1 <- "org.Rn.eg.db"
      } else if (input$species == "Saccharomyces cerevisiae") {
        library(org.Sc.sgd.db)
        specie1 <- "org.Sc.sgd.db"
      } else if (input$species == "Caenorhabditis elegans") {
        library(org.Ce.eg.db)
        specie1 <- "org.Ce.eg.db"
      } else {
        # Handle the case when no species is selected or handle an unknown species
        specie1 <- NULL
      }
      # analysis
      ontology <- enrichGO(gene = group_gene, OrgDb=specie1, keyType="SYMBOL", ont=GO_type1)
      s_ontology <- simplify(ontology)
      #plot
      if (input$plottype1 == "Dotplot"){
        dotplot(ontology, showCategory=as.numeric(input$show1))
      }else if (input$plottype1 == "Barplot"){
        barplot(ontology, showCategory=as.numeric(input$show1))
      }else{
        cnetplot(s_ontology, foldChange=group_gene, circular = TRUE, colorEdge = TRUE)
      }
      #barplot(ontology, showCategory=10)
    })
    output$ontology_plot_upexp_met <- renderPlot({
      plot_upexp_met()
    })
    #download
    # PDF
    output$download_upexp_met_pdf <- downloadHandler(
      filename = function() {
        paste0("UpExp_Met_", Sys.Date(), ".pdf")
      },
      content = function(file) {
        pdf(file, width = 8, height = 6)
        print(plot_upexp_met())
        dev.off()
      }
    )
    
    # PNG
    output$download_upexp_met_png <- downloadHandler(
      filename = function() {
        paste0("UpExp_Met_", Sys.Date(), ".png")
      },
      content = function(file) {
        png(file, width = 1000, height = 800)
        print(plot_upexp_met())
        dev.off()
      }
    )
    #############
    inter_downexp_met <- reactive({
      req(input$Expression_data)
      req(input$Methylation_data)
      
      expdata <- read.csv(input$Expression_data$datapath)
      downregulated <- expdata %>%
        filter(pvalue < as.numeric(input$pval), log2FoldChange < as.numeric(-input$log)) # downregulated
      
      colnames(downregulated)[colnames(downregulated) == "pvalue"] <- "expression_pvalue"
      colnames(downregulated)[colnames(downregulated) == "log2FoldChange"] <- "expression_log2FoldChange"
      
      metdata <- read.csv(input$Methylation_data$datapath)
      hypermethylated <- metdata %>%
        filter(pvalue < as.numeric(input$mpval), log2FoldChange > as.numeric(input$mlog)) # hypermethylated
      
      colnames(hypermethylated)[colnames(hypermethylated) == "pvalue"] <- "methylation_pvalue"
      colnames(hypermethylated)[colnames(hypermethylated) == "log2FoldChange"] <- "methylation_log2FoldChange"
      
      
      downexp_met <- merge(downregulated, hypermethylated, by.x = "gene", by.y = "gene")
      downexp_met <- unique(downexp_met)
      
    })
    output$inter_downexp_met <- renderDT({
      inter_downexp_met_data <- inter_downexp_met()
      datatable(inter_downexp_met())
    })
    #Download
    output$download_inter_downexp_met <- downloadHandler(
      filename = function() {
        paste0("inter_downexp_met_", Sys.Date(), ".csv")
      },
      content = function(file) {
        # Get the reactive table
        table_data <- inter_downexp_met()
        
        # Write to CSV
        write.csv(table_data, file, row.names = FALSE)
      }
    )
    
    ### OA
    plot_downexp_met <- reactive({
      exp_met <- inter_downexp_met()
      
      # filter genes m e
      group_gene  <- unique(c(exp_met$gene))
      
      #ontology type
      if (input$GOtype2 == "Biological Processes"){
        GO_type2 <- "BP"
      }else if (input$GOtype2 == "Cellular Compenant"){
        GO_type2 <- "CC"
      }else{
        GO_type2 <- "MF"
      }
      #specie
      if (input$species == "Homo sapiens") {
        library(org.Hs.eg.db)
        specie1 <- "org.Hs.eg.db"
      } else if (input$species == "Mus musculus") {
        library(org.Mm.eg.db)
        specie1 <- "org.Mm.eg.db"
      } else if (input$species == "Arabidopsis thaliana") {
        library(org.At.tair.db)
        specie1 <- "org.At.tair.db"
      } else if (input$species == "Drosophila melanogaster") {
        library(org.Dm.eg.db)
        specie1 <- "org.Dm.eg.db"
      } else if (input$species == "Danio rerio") {
        library(org.Dr.eg.db)
        specie1 <- "org.Dr.eg.db"
      } else if (input$species == "Rattus norvegicus") {
        library(org.Rn.eg.db)
        specie1 <- "org.Rn.eg.db"
      } else if (input$species == "Saccharomyces cerevisiae") {
        library(org.Sc.sgd.db)
        specie1 <- "org.Sc.sgd.db"
      } else if (input$species == "Caenorhabditis elegans") {
        library(org.Ce.eg.db)
        specie1 <- "org.Ce.eg.db"
      } else {
        # Handle the case when no species is selected or handle an unknown species
        specie1 <- NULL
      }
      # analysis
      ontology <- enrichGO(gene = group_gene, OrgDb=specie1, keyType="SYMBOL", ont=GO_type2)
      s_ontology <- simplify(ontology)
      #plot
      if (input$plottype2 == "Dotplot"){
        dotplot(ontology, showCategory=as.numeric(input$show2))
      }else if (input$plottype2 == "Barplot"){
        barplot(ontology, showCategory=as.numeric(input$show2))
      }else{
        cnetplot(s_ontology, foldChange=group_gene, circular = TRUE, colorEdge = TRUE)
      }
      
    })
    
    output$ontology_plot_downexp_met<- renderPlot({
      plot_downexp_met()
    })
    #download
    # PDF
    output$download_downexp_met_pdf <- downloadHandler(
      filename = function() {
        paste0("DownExp_Met_", Sys.Date(), ".pdf")
      },
      content = function(file) {
        pdf(file, width = 8, height = 6)
        print(plot_downexp_met())
        dev.off()
      }
    )
    
    # PNG
    output$download_downexp_met_png <- downloadHandler(
      filename = function() {
        paste0("DownExp_Met_", Sys.Date(), ".png")
      },
      content = function(file) {
        png(file, width = 1000, height = 800)
        print(plot_downexp_met())
        dev.off()
      }
    )
    # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
    # Intersection exp micro  
    inter_upexp_mic <- reactive({
      req(input$Expression_data)
      req(input$MicroRNA_data)
      
      expdata <- read.csv(input$Expression_data$datapath)
      upregulated <- expdata %>%
        filter(pvalue < as.numeric(input$pval), log2FoldChange > as.numeric(input$log)) # upregulated
      
      colnames(upregulated)[colnames(upregulated) == "pvalue"] <- "expression_pvalue"
      colnames(upregulated )[colnames(upregulated) == "log2FoldChange"] <- "expression_log2FoldChange"
      
      micdata <- read.csv(input$MicroRNA_data$datapath)
      
      downmic <- micdata %>%
        filter(pvalue < as.numeric(input$micpval), log2FoldChange < as.numeric(-input$miclog)) # hypomethylated
      colnames(downmic)[colnames(downmic) == "pvalue"] <- "miRNA_pvalue"
      colnames(downmic)[colnames(downmic) == "log2FoldChange"] <- "miRNA_log2FoldChange"
      
      upexp_mic <- merge(upregulated, downmic, by.x = "gene", by.y = "gene")
      upexp_mic <- unique(upexp_mic)
      
    })
    output$inter_upexp_mic <- renderDT({
      inter_upexp_mic<-  inter_upexp_mic()
      datatable( inter_upexp_mic())
    })
    
    #Download
    output$download_inter_upexp_mic <- downloadHandler(
      filename = function() {
        paste0("inter_upexp_mic_", Sys.Date(), ".csv")
      },
      content = function(file) {
        # Get the reactive table
        table_data <- inter_upexp_mic()
        
        # Write to CSV
        write.csv(table_data, file, row.names = FALSE)
      }
    )
    
    ### OA
    plot_upexp_mic <- reactive({
      # Get data from the reactive expression
      inter_upexp_mic<-  inter_upexp_mic()
      exp_mic <- inter_upexp_mic
      # filter genes m e
      group_gene  <- unique(c(exp_mic$gene))
      
      #ontology type
      if (input$GOtype3 == "Biological Processes"){
        GO_type3 <- "BP"
      }else if (input$GOtype3 == "Cellular Compenant"){
        GO_type3 <- "CC"
      }else{
        GO_type3 <- "MF"
      }
      #specie
      if (input$species == "Homo sapiens") {
        library(org.Hs.eg.db)
        specie1 <- "org.Hs.eg.db"
      } else if (input$species == "Mus musculus") {
        library(org.Mm.eg.db)
        specie1 <- "org.Mm.eg.db"
      } else if (input$species == "Arabidopsis thaliana") {
        library(org.At.tair.db)
        specie1 <- "org.At.tair.db"
      } else if (input$species == "Drosophila melanogaster") {
        library(org.Dm.eg.db)
        specie1 <- "org.Dm.eg.db"
      } else if (input$species == "Danio rerio") {
        library(org.Dr.eg.db)
        specie1 <- "org.Dr.eg.db"
      } else if (input$species == "Rattus norvegicus") {
        library(org.Rn.eg.db)
        specie1 <- "org.Rn.eg.db"
      } else if (input$species == "Saccharomyces cerevisiae") {
        library(org.Sc.sgd.db)
        specie1 <- "org.Sc.sgd.db"
      } else if (input$species == "Caenorhabditis elegans") {
        library(org.Ce.eg.db)
        specie1 <- "org.Ce.eg.db"
      } else {
        # Handle the case when no species is selected or handle an unknown species
        specie1 <- NULL
      }
      # analysis
      ontology <- enrichGO(gene = group_gene, OrgDb=specie1, keyType="SYMBOL", ont=GO_type3)
      s_ontology <- simplify(ontology)
      #plot
      if (input$plottype3 == "Dotplot"){
        dotplot(ontology, showCategory=as.numeric(input$show3))
      }else if (input$plottype3 == "Barplot"){
        barplot(ontology, showCategory=as.numeric(input$show3))
      }else{
        cnetplot(s_ontology, foldChange=group_gene, circular = TRUE, colorEdge = TRUE)
      }
      
    })
    output$ontology_plot_upexp_mic <- renderPlot({
      plot_upexp_mic()
    })
    
    # Download
    
    # PDF
    output$download_upexp_mic_pdf <- downloadHandler(
      filename = function() {
        paste0("UpExp_miRNA_", Sys.Date(), ".pdf")
      },
      content = function(file) {
        pdf(file, width = 8, height = 6)
        print(plot_upexp_mic())
        dev.off()
      }
    )
    
    # PNG
    output$download_upexp_mic_png <- downloadHandler(
      filename = function() {
        paste0("UpExp_miRNA_", Sys.Date(), ".png")
      },
      content = function(file) {
        png(file, width = 1000, height = 800)
        print(plot_upexp_mic())
        dev.off()
      }
    )
    #############
    inter_downexp_mic <- reactive({
      req(input$Expression_data)
      req(input$MicroRNA_data)
      
      expdata <- read.csv(input$Expression_data$datapath)
      downregulated <- expdata %>%
        filter(pvalue < as.numeric(input$pval), log2FoldChange < as.numeric(-input$log)) # downregulated
      
      colnames(downregulated)[colnames(downregulated) == "pvalue"] <- "expression_pvalue"
      colnames(downregulated)[colnames(downregulated) == "log2FoldChange"] <- "expression_log2FoldChange"
      
      micdata <- read.csv(input$MicroRNA_data$datapath)
      upmic <- micdata %>%
        filter(pvalue < as.numeric(input$micpval), log2FoldChange > as.numeric(input$miclog)) # hypermethylated
      
      colnames(upmic )[colnames(upmic ) == "pvalue"] <- "miRNA_pvalue"
      colnames(upmic )[colnames(upmic ) == "log2FoldChange"] <- "miRNA_log2FoldChange"
      
      downexp_mic <- merge(downregulated, upmic, by.x = "gene", by.y = "gene")
      downexp_mic <- unique(downexp_mic)
      
    })
    output$inter_downexp_mic <- renderDT({
      inter_downexp_mic_data <- inter_downexp_mic()
      datatable(inter_downexp_mic())
    })
    # Download
    output$download_inter_downexp_mic <- downloadHandler(
      filename = function() {
        paste0("inter_downexp_mic_", Sys.Date(), ".csv")
      },
      content = function(file) {
        # Get the reactive table
        table_data <- inter_downexp_mic()
        
        # Write to CSV
        write.csv(table_data, file, row.names = FALSE)
      }
    )
    
    ### OA
    plot_downexp_mic <- reactive({
      exp_mic <- inter_downexp_mic()
      
      # filter genes m e
      group_gene  <- unique(c(exp_mic$gene))
      
      #ontology type
      if (input$GOtype4 == "Biological Processes"){
        GO_type4 <- "BP"
      }else if (input$GOtype4 == "Cellular Compenant"){
        GO_type4 <- "CC"
      }else{
        GO_type4 <- "MF"
      }
      #specie
      if (input$species == "Homo sapiens") {
        library(org.Hs.eg.db)
        specie1 <- "org.Hs.eg.db"
      } else if (input$species == "Mus musculus") {
        library(org.Mm.eg.db)
        specie1 <- "org.Mm.eg.db"
      } else if (input$species == "Arabidopsis thaliana") {
        library(org.At.tair.db)
        specie1 <- "org.At.tair.db"
      } else if (input$species == "Drosophila melanogaster") {
        library(org.Dm.eg.db)
        specie1 <- "org.Dm.eg.db"
      } else if (input$species == "Danio rerio") {
        library(org.Dr.eg.db)
        specie1 <- "org.Dr.eg.db"
      } else if (input$species == "Rattus norvegicus") {
        library(org.Rn.eg.db)
        specie1 <- "org.Rn.eg.db"
      } else if (input$species == "Saccharomyces cerevisiae") {
        library(org.Sc.sgd.db)
        specie1 <- "org.Sc.sgd.db"
      } else if (input$species == "Caenorhabditis elegans") {
        library(org.Ce.eg.db)
        specie1 <- "org.Ce.eg.db"
      } else {
        # Handle the case when no species is selected or handle an unknown species
        specie1 <- NULL
      }
      # analysis
      ontology <- enrichGO(gene = group_gene, OrgDb=specie1, keyType="SYMBOL", ont=GO_type4)
      s_ontology <- simplify(ontology)
      #plot
      if (input$plottype4 == "Dotplot"){
        dotplot(ontology, showCategory=as.numeric(input$show4))
      }else if (input$plottype4 == "Barplot"){
        barplot(ontology, showCategory=as.numeric(input$show4))
      }else{
        cnetplot(s_ontology, foldChange=group_gene, circular = TRUE, colorEdge = TRUE)
      }
      
    })
    output$ontology_plot_downexp_mic <- renderPlot({
      plot_downexp_mic()
    })
    
    # Download handlers
    
    # PDF
    output$download_downexp_mic_pdf <- downloadHandler(
      filename = function() {
        paste0("DownExp_miRNA_", Sys.Date(), ".pdf")
      },
      content = function(file) {
        pdf(file, width = 8, height = 6)
        print(plot_downexp_mic())
        dev.off()
      }
    )
    
    # PNG
    output$download_downexp_mic_png <- downloadHandler(
      filename = function() {
        paste0("DownExp_miRNA_", Sys.Date(), ".png")
      },
      content = function(file) {
        png(file, width = 1000, height = 800)
        print(plot_downexp_mic())
        dev.off()
      }
    )
    
  })
}

