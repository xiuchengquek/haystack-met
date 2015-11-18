##server.R





# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(pheatmap)
library(cluster)
library(R6)
library(reshape2)
library(plyr)


library(kohonen)
library(ggplot2)
source('./src/helper.R')

 

shinyServer(function(input, output) {
  
  output$clusterPlot <- renderPlot({
    somPlot$plotCluster(input$sample)
    # generate bins based on input$bins from ui.R 
  })
  
  
  output$clusterSize <- renderPlot({
    
    somPlot$plotSize(input$sample)
    
    
  })
  
  
  output$genePlot <- renderPlot({
    geneName <- Filter(function(x){ nchar(x) == 0 } , input$geneName)
    print(geneName)
    
    somPlot$plotGenePlot(input$geneName)
  })
  
  output$geneTable <- renderDataTable({
    
    values <- lapply(somPlot$samples, function(x) { 
      x$getGene(input$geneName)
    })
    
    df <-do.call(cbind, values)
    melt(df)
    
    
  })
  
  output$clusterTable <- renderDataTable({
    
    values <- lapply(somPlot$samples, function(x) { 
      x$getClusterByGene(input$geneName)
    })
    
    df <-do.call(cbind, values)
    df
    
    
  })
  
  output$heatMapTable <- renderDataTable({
    
    sample <- somPlot$samples[[input$sample]]
    df <- sample$getGeneByCluster(input$clusterNo,F)
    genes <- rownames(df)
    df <- lapply(somPlot$samples, function(x) x$getGene(genes))
    merged <- do.call(cbind, df)
    rownames(merged) <- rownames(df[[1]])
    print(head(merged))
    cbind(names=rownames(merged), merged)
    
  })
  
  output$heatMap <- renderUI({
    
    plot_output_list <- lapply(names(somPlot$samples), function(n) {    
      plotOutput(n, height=1000, width=800)
    })    
    do.call(tagList, plot_output_list);
    
  })  
  for (n in names(somPlot$samples)) { 
    local({      
      my_n <- n      
      output[[my_n]] <- renderPlot({              
        if( my_n == input$sample) {         
          somPlot$plotHeatMap(input$sample, input$clusterNo)
        }
        else {
          sample <- somPlot$getSamples(input$sample)
          df <- sample$getGeneByCluster(input$clusterNo, F)
          genes <- rownames(df)
          pheatmap(somPlot$getSamples(my_n)$getGene(genes), cluster_cols = F, main=my_n)
        }
      })
    })
    
    
    
    
    
    
  }
  
  
  
  
  
})
