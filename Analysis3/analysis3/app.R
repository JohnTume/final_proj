library(shiny)
library(dplyr)
library(ggplot2)
library(lubridate)

## gun_violence_data <- read.csv("data/gun-violence-data_01-2013_03-2018.csv")
## background_checks_data <- read.csv("data/nics-firearm-background-checks.csv")

gun_violence_filtered <-
  gun_violence_data %>%
  group_by(date) %>%
  select(date, state)

gun_violence_tallied <-
  gun_violence_filtered %>%
  group_by(date, state) %>%
  tally()

background_checks_filtered <-
  background_checks_data %>%
  group_by(month) %>%
  mutate(total_permits = permit + permit_recheck) %>%
  select(month, state, total_permits)

my_server <- function(input, output) {
  
  background_checks_state_filter <- function(selected) {
    filtered <- background_checks_filtered %>%
      group_by(month) %>%
      filter(state == selected) %>%
      select(month, state, total_permits)
    filtered
  }
  
  gun_violence_state_filter <- function(selected) {
    filtered <- gun_violence_tallied %>%
      group_by(date) %>%
      filter(state == selected) %>%
      select(date, state, n)
  }
  
    output$dataPlot <- renderPlot({
      ggplot(background_checks_state_filter(input$select1), aes(x = background_checks_state_filter(input$select1)$month, 
                                                                y = background_checks_state_filter(input$select1)$total_permits)) + 
      geom_bar(stat = "identity") +
      ggtitle(paste0("Gun Background Check Levels 2013-2018 for ", input$select1)) +
      labs(y="Number of Background Checks", x = "Time")
      
    })
    
    output$dataPlot2 <- renderPlot({
      ggplot(gun_violence_state_filter(input$select1), aes(x = gun_violence_state_filter(input$select1)$date, 
                                                         y = gun_violence_state_filter(input$select1)$n)) + 
      geom_bar(stat = "identity") + 
      ggtitle(paste0("Gun Violence Levels 2013-2018 for ", input$select1)) +
      labs(y="Number of Gun Violence Incidents", x = "Time")
      
    })
}




my_ui <- fluidPage(
    titlePanel("Relationship Between Gun Background Checks & Gun-Related Crimes"),
    p("In states, does gun violence decrease with background checks?"),
    
    sidebarLayout(
        
        sidebarPanel(
            selectInput("select1", "Select a state:", 
                        choices = unique(background_checks_filtered$state), selected = "Alabama"),
            hr(),
            helpText("Over-time relationship between gun background checks and gun-related crimes.")
        ),
        
        mainPanel(
          tableOutput("debug"),
          plotOutput("dataPlot"),
          plotOutput("dataPlot2")
        )
    )
)
shinyApp(ui = my_ui, server = my_server)