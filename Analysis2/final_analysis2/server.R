#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(lubridate)
library(ggplot2)
library(plotly)

# the number of gun provisions in each state in 2016, out of a maximum possible of 133 provisions
provisions_data <- read.csv("data/raw_data.csv", stringsAsFactors = FALSE) %>% 
                     select(state, year, lawtotal) %>% 
                     filter(year == 2016)

# function to transform our csv files into data frames we want
transform_data <- function(data){
  data$Incident.Date <- mdy(data$Incident.Date) %>% year()
  data <- data %>% 
    select(Incident.Date, State) %>% 
    filter(Incident.Date == 2016)
  return(data)
}

# function that plots the number of gun violence incidents of a given type in all applicable states in 2016
# takes in the type of incident that the user selects, uses it to read in appropriate file
shooting_frequency_with_ordinances <- function(incident_type){
  selected_data <- transform_data(read.csv(paste0(incident_type)))
  frequencies <- as.data.frame(table(selected_data$State))
  names(frequencies)[names(frequencies) == "Var1"] <- "state"
  total_frame <- inner_join(provisions_data, frequencies, by = "state")
  total_frame <- filter(total_frame, Freq != 0)
  total_frame %>% 
    ggplot(aes(x = Freq, y = lawtotal, text = paste0(total_frame$state, ", Number of provisions: ", total_frame$lawtotal, 
                                                     ", # of Incidents: ", total_frame$Freq))) +
    geom_point(size = 3) +
    geom_smooth(method="lm", se=FALSE, fullrange=TRUE, level=0.95) +
    labs(x = "Number of occurrences of gun violence incidents", y = "Number of gun provisions (max: 133)") +
    theme(axis.title = element_text(size = 12),
          axis.text = element_text(size = 12))
  
  ggplotly(tooltip = 'text')
}


# Define server logic required to draw scatterplot
shinyServer(function(input, output) {
   output$shootingPlot <- renderPlotly ({
     shooting_frequency_with_ordinances(input$selected_incident_type)
   })
   
   # output$debug <- renderTable ({
   #   selected_data <- transform_data(read.csv(paste0(input$selected_incident_type)))
   #   frequencies <- as.data.frame(table(selected_data$State))
   #   names(frequencies)[names(frequencies) == "Var1"] <- "state"
   #   inner_join(provisions_data, frequencies, by = "state")
   # })
   
})
