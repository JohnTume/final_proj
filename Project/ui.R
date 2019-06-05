# load library
library(shiny)
library(shinythemes)
library(ggplot2)
library(dplyr)
library(plotly)

# load data set

provisions_data <- read.csv("data/raw_data.csv", stringsAsFactors = FALSE)

# The user interface of the app
ui <- fluidPage(
  theme = shinytheme("slate"),
  navbarPage("Gun Violence vs Firearm laws",
             tabPanel("Analysis1",
                      titlePanel("Number of Gun Legislation In States Over Year"),
                      hr(),
                      p("The map depicts the number of firearm laws in all the states over year (1991 - 2017), as the state with deeper color has more gun legislation in the given year. The line chart below shows the change of number of gun legislations in a selected state over year."),
                      
                      
                      p("From the two graphs, we can observe a nation-level increase of the number of firearm laws, with the average continues to increase over year. Yet, among the country, the range of the law number is large and increases over year. Some states such as California and Massachusetts shows a drastic increasing trend and maintains a number around 80 to 100 in most of the observed years. On the other hand, states such as Idaho and Kentucky has a stable trend of change over year and maintain a number within 10. Though more factors should be included in discussion and further considered, we generally observe a trend that the states, especially in the coastal areas, which has relatively developed economy and productivity as well as more concentrated populations, issued more laws to restrict the sale of firearm. Because the regions with concentrated population could have more frequent criminal incidents, we also hypothesize that there could be relationship between criminal rate and the number of firearm laws and will further explore in the later sections. "),
                      br(),
                      
                      sidebarLayout(
                        sidebarPanel(
                          sliderInput("years",
                                      "Select year:",
                                      min = 1991,
                                      max = 2017,
                                      value = 5),
                          selectInput("state", label = h3("Select your state:"), 
                                      choices = unique(provisions_data$state),
                                      selected = "Alabama")
                        ),
                        
                        mainPanel(
                          plotlyOutput("Map"),
                          br(),
                          textOutput("Mapdescription"),
                          hr(),
                          plotOutput("Linechart")
                        )
                      )
             ),
             tabPanel("Analysis2",
                      # Application title
                      titlePanel("Number of Firearm Provisions vs Number of Gun Violence Incidents (by state); Data from 2016"),
                      p("The plots shown below display data taken from the Gun Violence Archive on the number of instances of gun violence
                        that occur in each state. The original data also separates occurrences of gun violence by the type of violence
                        that occurred (e.g. incidents involving police officers)."),
                      br(),
                      p("Some interesting results are that, in general, there is a roughly negative correlation between the number of gun provisions
                        and the number of gun violence incidents -- that is to say that (again, in general) the amount of accidental gun violence
                        tends to decrease with a greater number of gun ownership provisions. However, mass shootings in 2016 and police involvement
                        in gun violence seemed to roughly increase with the number of gun provisions."),
                      hr(),
                      
                      # Sidebar with a slider input for number of bins 
                      sidebarLayout(
                        sidebarPanel(
                          radioButtons("selected_incident_type", label = h3("Select Incident Type"),
                                       choices = list("Accidental Children Deaths" = "data/gun-violence-database/accidental_deaths_children.csv", 
                                                      "Accidental Teen Deaths" = "data/gun-violence-database/accidental_deaths_teens.csv", 
                                                      "Accidental Adult Deaths" = "data/gun-violence-database/accidental_deaths.csv", 
                                                      "Accidental Children Injuries" = "data/gun-violence-database/accidental_injuries_children.csv",
                                                      "Accidental Teen Injuries" = "data/gun-violence-database/accidental_injuries_teens.csv",
                                                      "Accidental Adult Injuries" = "data/gun-violence-database/accidental_injuries.csv",
                                                      "Incidents Involving Police Officers" = "data/gun-violence-database/officer_involved_shootings.csv", 
                                                      "Mass Shootings in 2016" = "data/gun-violence-database/mass_shootings_2016.csv"),
                                       selected = "data/gun-violence-database/accidental_deaths_children.csv")
                        ),
                        
                        # Show a plot of the generated distribution
                        mainPanel(
                          plotlyOutput("shootingPlot")
                        )
                      )
             )
  

    
  )
)
