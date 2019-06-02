library(shiny)

map <- map_data("state")
data <- read.csv("data/raw_data.csv", stringsAsFactors = FALSE)

#filtered_data <- data %>% filter(year == "2000")


ui <- fluidPage(
   
   titlePanel("Old Faithful Geyser Data"),
   
   sidebarLayout(
      sidebarPanel(
         sliderInput("years",
                     "Select year:",
                     min = 1991,
                     max = 2017,
                     value = 5)
      ),

      mainPanel(
         plotOutput("Map")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$Map <- renderPlot({
     map <- map_data("state")
     
     filtered_data <- data %>% filter(year == as.character(input$years))
     
     ggplot() +
       geom_map(data=map,
                map=map,
                aes(long, lat, map_id = region),
                fill="white", color="white", size=0.15) +
       geom_map(data=filtered_data,
                map=map,
                aes(fill=lawtotal, map_id=tolower(state)), 
                color="white", size=0.15) +
       coord_map() +
       labs(title = paste0("total number of law in each state")) +
       #scale_fill_gradient() +
       scale_fill_continuous(low='thistle2', high='darkred', 
                                           guide='colorbar') 
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

