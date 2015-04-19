# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Central Limit Theorem Showcase - Exponential Distribution"),
  
  # Sidebar with a slider input for number of bins
  sidebarPanel(
    sliderInput("lambda",
                "Lambda of exponential:",
                min = 0.1,
                max = 1,
                value = 0.2),
    sliderInput("sims",
                "Number of sims:",
                min = 100,
                max = 1000,
                value = 500),
    sliderInput("n",
                "Sample size:",
                min = 10,
                max = 100,
                value = 40)
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    tabsetPanel(
      tabPanel("Normalized Plot", plotOutput("distPlot")), 
      tabPanel("Sample Mean Plot", plotOutput("smPlot")),
      tabPanel("Documentation", htmlOutput("document"))
    )    
  )
))
