# load library
library(shiny)
library(ggplot2)
library(zoo)
library(dplyr)
library(plotly)
# load data set
map <- map_data("state")
data <- read.csv("data/raw_data.csv", stringsAsFactors = FALSE)

# The user interface of the app
ui <- fluidPage(
   
   titlePanel("Number of Gun Legislation Over Year"),
   hr(),
   
   sidebarLayout(
      sidebarPanel(
         sliderInput("years",
                     "Select year:",
                     min = 1991,
                     max = 2017,
                     value = 5),
         textOutput("Anlysis1"),
         selectInput("state", label = h3("Select your state:"), 
                     choices = unique(data$state),
                     selected = "Alabama")
      ),
      
      mainPanel(
         plotlyOutput("Map", height = "90%"),
         textOutput("Mapdescription"),
         hr(),
         plotOutput("Linechart")
      )
   )
)

# Define server logic required to draw plots
server <- function(input, output) {
    
   # map output
   output$Map <- renderPlotly({
     map <- map_data("state")
     
     filtered_data <- data %>% 
       filter(year == as.character(input$years)) %>% 
       mutate(state = tolower(state))
     
     map_data <- full_join(map, filtered_data, by = c("region" = "state"))
     
     ggplot(map_data, aes(long, lat)) +
       geom_polygon(aes(group = group, fill = lawtotal), color = "white") +
       coord_map() +
       labs(title = paste0("Overall gun legislation distribution in ", input$years)) +
       scale_fill_continuous(low='thistle2', high='darkred', limits = c(0, 133), 
                      guide='colorbar') +
       theme(plot.title = element_text(hjust = 0.5, size = 20))
     
     ggplotly()
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
   
   # description and analysis in sidebar layout
   output$Anlysis1 <- renderText({
     
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

