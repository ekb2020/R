# UI 

library(shiny)
library(ggplot2)
library(plotly)
library(scales)

# Define UI for application that draws a histogram.
shinyUI(fluidPage(
  
  includeCSS("styles.css"),
  
  # Application title.
  titlePanel("Estimating Recruiting Cost Savings from Informed Candidate Hiring on Glassdoor"),
  
  # Sidebar  
  sidebarLayout(
    sidebarPanel(
      h3("Tell Us About Your Open Jobs"),
      
      sliderInput("openJobs", 
                  "Number of candidates you plan to hire.",
                  min=0,
                  max=2000,
                  value=1000,
                  step=10,
                  sep=","),
      
      tags$br(),

      sliderInput("meanSalary", 
                  "Average salary per candidate (annual).",
                  min=15000,
                  max=300000,
                  value=51975,
                  step=5000,
                  pre="$",
                  sep=","),
      
      tags$br(),
      
      sliderInput("costHire", 
                  "Average cost per hire (recruiting, hiring, and onboarding) as a % of salary at your company.",
                  min=0.0,
                  max=100.0,
                  value=21.4,
                  step=0.1,
                  post="%"),
      
    HTML("<b>Note</b>: U.S. average is 21.4 percent."),

    tags$a(href="https://www.americanprogress.org/issues/economy/reports/2012/11/16/44464/there-are-significant-business-costs-to-replacing-employees/", "(source)")
  
  ),
    
    # Main Panel.
    mainPanel(
      
      h3("What Is This Calculator?"),
      
      HTML("This calculator estimates average cost savings that your company can expect from better employee retention by hiring informed candidates on <a href='https://www.glassdoor.com/index.htm' target='_blank'>Glassdoor</a>. Just enter the number of open jobs, average salary, and your company's average cost per hire (for recruiting, hiring and onboarding new candidates as a percentage of the typical employee's salary) below. The calculator shows your company's average cost savings over a 4-year period from hiring on Glassdoor compared to other candidate sources."),
      
      tags$br(),
      
      h3("Cost Savings from Hiring Through Glassdoor vs. Other Sources"),
      
      tableOutput("table"),
      
      tags$br(),
      
      plotlyOutput("figure"),
      
      HTML("<b>Disclaimer</b>: This calculator provides estimates based on survey research only. Individual company results may vary. Estimates are provided for illustrative purposes, and should not be used as the sole basis for any investment or business decision. Copyright <a href='https://www.glassdoor.com/index.htm' target='_blank'>Glassdoor, Inc.</a> 2018."),
      
      img(src='glassdoor-logotype-rgb.jpg', align="right", width="300", height="100")
      
    )
  )
))