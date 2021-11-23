# Launch R Shiny App for GD Retention Costs Calculator
# Andrew Chamberlain, Ph.D.
# achamberlain.com
# March 2018

# Set working directory
setwd("/shiny-app-example")

# Load libraries.
library(rsconnect)
library(shiny)

# Run the app locally
shinyApp(ui = ui, server = server)
runApp("retentionCosts")