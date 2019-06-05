#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  
  # map output
  output$Map <- renderPlotly ({
    map <- map_data("state")
    
    filtered_data <- data %>% 
      filter(year == as.character(input$years)) %>% 
      mutate(state = tolower(state))
    
    map_data <- full_join(map, filtered_data, by = c("region" = "state"))
    
    plot <- ggplot(map_data, aes(long, lat)) +
      geom_polygon(aes(group = group, fill = lawtotal, text = paste("there are", lawtotal, "laws in", region)), color = "white") +
      labs(title = paste0("Overall gun legislation distribution in ", input$years)) +
      scale_fill_continuous(low='thistle2', high='darkred', limits = c(0, 133), 
                            guide='colorbar') +
      theme(plot.title = element_text(hjust = 0.5, size = 20)) +
      coord_map() 
    
    ggplotly(tooltip = 'text')
  })
  
  # line chart output
  output$Linechart <- renderPlot({
    
    filtered_data <- data %>% 
      filter(state == input$state)
    
    ggplot(filtered_data) +
      geom_line(mapping = aes(x = year, y = lawtotal), color = "coral", size = 1.5) +
      labs(title = paste0("The total number of laws over year in ", input$state)) +
      theme(plot.title = element_text(hjust = 0.5, size = 18))
  })
  
  # description text summarizing the average, max, min data shown in the map.
  output$Mapdescription <- renderText({
    filtered_data <- data %>% 
      filter(year == as.character(input$years))
    
    paste0("The average number of legislations is ", mean(filtered_data$lawtotal),
           ", ", 
           "the most is ",
           max(filtered_data$lawtotal), 
           ", the least is ",
           min(filtered_data$lawtotal),
           ".")
  })
  
})
