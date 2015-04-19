
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)
library(ggplot2)
library(gridExtra)

shinyServer(function(input, output) {

  output$smPlot <- renderPlot({
    # Extract the variables from the input
    lambda <- input$lambda
    muexp <- 1 / lambda
    sdexp <- 1 / lambda
    nosim <- round(input$sims)
    n <- input$n

    # Produce the density distribution of the sample mean
    Xbardat <- data.frame(
      x = c(apply(matrix(rexp(nosim*n,lambda), 
                         nosim), 1, mean)
      ),
      size = factor(rep(c(n), rep(nosim, 1))))    
    g1 <- ggplot(Xbardat, aes(x = x, fill = size)) + geom_histogram(alpha = .20, binwidth=.3, colour = "black", aes(y = ..density..)) 
    g1 <- g1+ geom_density(alpha=.2, fill="#FF6666")
    g1 <- g1 + geom_vline(xintercept=muexp,  
                          color="red", linetype="dashed", size=1)
    g1 <- g1 + ggtitle("Sample Mean - Density Chart")
    g1 <- g1 + labs(x = "Sample Mean", y = "Density")
    g1 + facet_grid(. ~ size)
    print(g1)
  })
  
  output$distPlot <- renderPlot({
    # Extract the variables from the input
    lambda <- input$lambda
    muexp <- 1 / lambda
    sdexp <- 1 / lambda
    nosim <- round(input$sims)
    n <- input$n
    
    # Produce the normalized distribution of the sample mean (CLT)
    cfunc <- function(x, n) sqrt(n) * (mean(x) - muexp) / sdexp
    XbarNormdat <- data.frame(
      x = c(apply(matrix(rexp(nosim*n,lambda), 
                         nosim), 1, cfunc, n)
      ),
      size = factor(rep(c(n), rep(nosim, 1))))
    g2 <- ggplot(XbarNormdat, aes(x = x, fill = size)) + geom_histogram(alpha = .20, binwidth=.3, colour = "black", aes(y = ..density..)) 
    g2 <- g2 + labs(x = "Number of simulations", y = "Normal Density")
    g2 <- g2 + ggtitle("Sample Mean - Normalized Density")
    g2 <- g2 + stat_function(fun = dnorm, size = 2) + facet_grid(. ~ size)  
    
    print(g2)    
  })
  
  output$document <- renderUI({
    lin1 = paste("<h1>My Shiny Application – Central Limit Theorem Showcase</h1>")
    lin2 = "<p class=MsoNormal>This demo application is inspired in the Statistical
Inference topic, and is used to demonstrate how a given probability
distribution (in this case the exponential distribution) has the following
properties:</p>"
    lin3 = "<ul><li><p> The <b style='mso-bidi-font-weight:normal'>sample
mean</b> (X-bar) for a certain <b style='mso-bidi-font-weight:normal'>sample
size n</b>, is a good estimator of the population mean (in an exponential
distribution, the population mean is equal to <b style='mso-bidi-font-weight:
normal'>1 / lambda</b>).</p>"
    lin4 ="<li><p>The sample mean, when converted to normal
standard values (that is, by calculating <b style='mso-bidi-font-weight:normal'>X-bar
– mu / sigma / <span class=SpellE><span class=GramE>sqrt</span></span><span
class=GramE>(</span>n)</b> for each sample ) , will converge to the standard normal
distribution. This will be more notorious as the sample size (n) goes larger.</p>
"
    lin5 = "<li><p>As the sample size, and/or the number of samples
(simulations) grow, the density distribution of the sample mean will converge
more to the population <span class=GramE>mean, that</span> is, the histogram
will be more “thin” and concentrated around the mean.</p></ul>"
    
    lin6="<p>To see this, use the sliders on the left side to select the
desired values of lambda (the exponential distribution “rate” parameter), the
number of simulations and the sample size. The resulting plots should be
consistent with the principles described above.</p>"
    
    HTML(paste(lin1,lin2,lin3,lin4,lin5,lin6, sep = '<br/>'))     
  })
  
})
