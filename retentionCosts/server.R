# Server.

library(shiny)
library(ggplot2)
library(plotly)
library(scales)

dollar_format(prefix = "$", suffix = "", big.mark = ",", largest_with_cents = 1e0)

# Define retention percentages.
pctRetainedGD <- 0.66
pctRetainedOther <- 0.49

# Define server logic required to draw a histogram.
shinyServer(function(input, output) {
  
  # Calculate total cost to re-hire. 
  output$costRehireGD = renderText(input$meanSalary*(input$costHire/100)*(1-0.66)*input$openJobs)
  output$costRehireOther = renderText(input$meanSalary*(input$costHire/100)*(1-0.49)*input$openJobs)

  # Create final output table.
  output$table <- renderTable({
    cells <- c("Percentage of Candidates Retained (4-Year Average) (Source: 2018 Glassdoor survey.)", sprintf("%.0f%%", 66), sprintf("%.0f%%", 49), 
               "Retained Candidates", sprintf("%1.0f", 0.66*input$openJobs),sprintf("%1.0f", 0.49*input$openJobs),
               "Need to Re-Hire", sprintf("%1.0f",(1-0.66)*input$openJobs),sprintf("%1.0f",(1-0.49)*input$openJobs),
               "Cost Per Hire", dollar(input$meanSalary*(input$costHire/100)), dollar(input$meanSalary*(input$costHire/100)),
               "Total Cost to Re-Hire", dollar(input$meanSalary*(input$costHire/100)*(1-0.66)*input$openJobs), dollar(input$meanSalary*(input$costHire/100)*(1-0.49)*input$openJobs),
               "Cost Savings from Hiring More Informed Candidates on Glassdoor (4-Year Average)", dollar(input$meanSalary*(input$costHire/100)*(1-0.49)*input$openJobs - input$meanSalary*(input$costHire/100)*(1-0.66)*input$openJobs), " "
               )
    M <- matrix(cells, nrow=6, ncol=3, byrow = TRUE)
    colnames(M) <- c(" ", "Glassdoor", "All Others")
    M
    }, 
    colnames = TRUE,
    align = 'lcc'
    ) 
  
  # Render table. 
  renderTable(table)
  
  # Create data frame for bar chart. 
  df <- reactive({
    names <- c("Glassdoor", "All Others")
    costs <- c(dollar(input$meanSalary*(input$costHire/100)*(1-0.66)*input$openJobs), dollar(input$meanSalary*(input$costHire/100)*(1-0.49)*input$openJobs))
    N <- data.frame(names, costs)
    N$names <- factor(N$names, levels=c("Glassdoor","All Others"))
    N
  })
  
  # Render bar chart.
  output$figure <- renderPlotly({
    p <- ggplot(df(), aes(x = names,y = costs, text = paste('Source:', names, '<br>Re-Hire Costs:', costs))) + geom_bar(stat = "identity", fill = "#0CAA41") + ggtitle("HR Turnover Costs (4-Year Average") + theme(plot.title = element_text(size=16, family="lato"), panel.background = element_rect(fill = "white", colour = "grey50"), legend.title = element_blank(), legend.text = element_text(size=8, family="lato"), legend.key = element_rect(fill = "white"), axis.text=element_text(size=8, family="lato")) + ylab(" ") + xlab(" ")
    ggplotly(p, tooltip = c('text'))
    })

  })