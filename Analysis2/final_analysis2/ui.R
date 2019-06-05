#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  theme = shinytheme("slate"),
  
  # Application title
  titlePanel("Number of Firearm Provisions vs Number of Gun Violence Incidents (by state); Data from 2016"),
  p("The plots shown below display data taken from the Gun Violence Archive on the number of instances of gun violence
    that occur in each state. The original data also separates occurrences of gun violence by the type of violence
    that occurred (e.g. incidents involving police officers)."),
  br(),
  p("Some interesting results are that, in general, there is a roughly negative correlatio between the number of gun provisions
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
       plotlyOutput("shootingPlot"),
       tableOutput("debug")
    )
  )
))
