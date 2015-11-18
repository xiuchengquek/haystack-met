
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Haystack : Finding Gene of Interest by Self Organizing Analysis"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      selectInput("sample",label = c("Select your Sample"),
                  choices = list("MET"),
                  selected = "MET"  ),
      numericInput("clusterNo", label=c("View Genes By Cluster"), value =1),
      checkboxInput('multipleHeatmap', label=c("Choose if plot heatmap across samples"),value = FALSE),
      textInput("geneName", label=c("Search For Gene"),value = '')
      
      
      
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(    
      tabsetPanel(
        tabPanel("clusterPlot", plotOutput("clusterPlot", width = "800", height = "1000")),      
        tabPanel("heatmap", uiOutput("heatMap", width = "400", height ="1200")),
        tabPanel("heatmapMetrics", dataTableOutput("heatMapTable")),
        
        tabPanel("genePlot", plotOutput("genePlot", width = "400", height ="400"), dataTableOutput("geneTable"), dataTableOutput("clusterTabl   e")),
        tabPanel("clusterSize", plotOutput("clusterSize", width = "1000", height ="800"))
      )
    )
  )
))
