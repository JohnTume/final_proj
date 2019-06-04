#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Number of Firearm Provisions vs Number of Gun Violence Incidents (by state); Data from 2016"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      radioButtons("selected_incident_type", label = h3("Select Incident Type"),
                   choices = list("Accidental Children Deaths" = "accident_children", "Accidental Teen Deaths" = "accident_teen", 
                                  "Accidental Adult Deaths" = "accident_adult", "Incidents Involving Police Officers" = "police", 
                                  "2015 Mass Shootings" = "2015_mass_shootings", "2016 Mass Shootings" = "2016_mass_shootings"),
                   selected = "accident_children")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("distPlot")
    )
  )
))
