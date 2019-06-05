# Define server logic required to draw plots

# load the provisions data set
data <- read.csv("data/raw_data.csv", stringsAsFactors = FALSE)


server <- function(input, output) {
  
  # output for analysis1

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
  
  # Analysis2 output
  output$shootingPlot <- renderPlotly ({
    
    # the number of gun provisions in each state in 2016, out of a maximum possible of 133 provisions
    provisions_data <- data %>% 
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
      Information <- paste0(total_frame$state, ", Number of provisions: ", total_frame$lawtotal, ", # of Incidents: ", total_frame$Freq)
      
      total_frame %>% 
        ggplot(aes(x = Freq, y = lawtotal, label = Information)) +
        #ggplot(aes(x = Freq, y = lawtotal)) +
        geom_point(size = 3) +
        geom_smooth(method="lm", se=FALSE, fullrange=TRUE, level=0.95) +
        labs(x = "Number of occurrences of gun violence incidents", y = "Number of gun provisions in state (max: 133)") +
        theme(axis.title = element_text(size = 12),
              axis.text = element_text(size = 12))
      
      ggplotly(tooltip = 'label')
    }
    shooting_frequency_with_ordinances(input$selected_incident_type)
    
  })
  
}