# load library
library(shiny)
library(shinythemes)
library(ggplot2)
library(dplyr)
library(plotly)

# load data set

data <- read.csv("data/raw_data.csv", stringsAsFactors = FALSE)

# The user interface of the app
ui <- fluidPage(
   theme = shinytheme("slate"),
   titlePanel("Number of Gun Legislation In States Over Year"),
   hr(),
   p("The map depicts the number of firearm laws in all the states over year (1991 - 2017), as the state with deeper color has more gun legislation in the given year. The line chart below shows the change of number of gun legislations in a selected state over year."),


   p("From the two graphs, we can observe a nation-level increase of the number of firearm laws, with the average continues to increase over year. Yet, among the country, the range of the law number is large and increases over year. Some states such as California and Massachusetts shows a drastic increasing trend and maintains a number around 80 to 100 in most of the observed years. On the other hand, states such as Idaho and Kentucky has a stable trend of change over year and maintain a number within 10. Though more factors should be included in discussion and further considered, we generally observe a trend that the states, especially in the coastal areas, which has relatively developed economy and productivity as well as more concentrated populations, issued more laws to restrict the sale of firearm. Because the regions with concentrated population could have more frequent criminal incidents, we also hypothesize that there could be relationship between criminal rate and the number of firearm laws and will further explore in the later sections. 
     "),
   br(),
   
   sidebarLayout(
      sidebarPanel(
         sliderInput("years",
                     "Select year:",
                     min = 1991,
                     max = 2017,
                     value = 5),
         selectInput("state", label = h3("Select your state:"), 
                     choices = unique(data$state),
                     selected = "Alabama")
      ),
      
      mainPanel(
         plotlyOutput("Map"),
         textOutput("Mapdescription"),
         hr(),
         plotOutput("Linechart")
      )
   )
)

# Define server logic required to draw plots
server <- function(input, output) {
    
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
   
}

# Run the application 
shinyApp(ui = ui, server = server)

