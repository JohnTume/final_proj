library(shiny)
library(dplyr)
library(ggplot2)
library(lubridate)

gun_violence_data <- read.csv("data/gun-violence-data_01-2013_03-2018.csv")
background_checks_data <- read.csv("data/nics-firearm-background-checks.csv")

gun_violence_filtered <-
  gun_violence_data %>%
  group_by(date) %>%
  arrange(desc(date)) %>%
  select(date, state)

background_checks_filtered <-
  background_checks_data %>%
  group_by(month) %>%
  mutate(total_permits = permit + permit_recheck) %>%
  select(month, state, total_permits)

my_server <- function(input, output) {

    output$dataPlot <- renderPlot({
        
        barplot(WorldPhones[,input$select1]*1000, 
                main=input$select1,
                ylab="Quantity",
                xlab="Year")
    })
}



my_ui <- fluidPage(
    # Give the page a title
    titlePanel("Relationship Between Gun Background Checks & Gun-Related Crimes"),
    p("In states, does gun violence decrease with background checks?"),
    
    # Generate a row with a sidebar
    sidebarLayout(
        
        # Define the sidebar with one input
        sidebarPanel(
            selectInput("select1", "Select a state:", 
                        choices = unique(background_checks_filtered$state)),
            hr(),
            helpText("Over-time relationship between gun background checks and gun-related crimes.")
        ),
        
        # Create a spot for the barplot
        mainPanel(
            plotOutput("dataPlot")
        )
    )
    
    #     titlePanel("Relationship Between Gun Background Checks & Gun-Related Crimes"),
    #     titlePanel("In states, does gun violence decrease with background checks?"),
    #     
    #     sidebarLayout(
    #         sidebarPanel(
    #             
    #             selectInput("select_state", label = h3("Select a state"), 
    #                         choices = c(unique(gun_violence_data$state)), 
    #                         selected = "Alabama"),
    #         
    #             hr(),
    #             fluidRow(column(12, verbatimTextOutput("value")))
    #             
    #         ),
    #     
    #         mainPanel(
    #             plotOutput("select_state")
    # 
    #         )
    # )
)


shinyApp(ui = my_ui, server = my_server)