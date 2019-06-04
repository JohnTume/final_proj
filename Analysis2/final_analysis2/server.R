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

accident_children <- transform_data(read.csv("data/gun-violence-database/accidental_deaths_children.csv", stringsAsFactors = FALSE))

# accident_chilren <- read.csv("data/gun-violence-database/accidental_deaths_children.csv", stringsAsFactors = FALSE)
# accident_children <- select(accident_children, Incident.Date, State)

accident_teen <- transform_data(read.csv("data/gun-violence-database/accidental_deaths_teens.csv", stringsAsFactors = FALSE))
accident_adult <- transform_data(read.csv("data/gun-violence-database/accidental_deaths.csv", stringsAsFactors = FALSE))
police_data <- transform_data(read.csv("data/gun-violence-database/officer_involved_shootings.csv", stringsAsFactors = FALSE))
#mass_shootings_2015 <- read.csv("data/gun-violence-database/mass_shootings_2015.csv", stringsAsFactors = FALSE)
mass_shootings_2016 <- transform_data(read.csv("data/gun-violence-database/mass_shootings_2016.csv", stringsAsFactors = FALSE))

# the number of gun provisions in each state in 2016, out of a maximum possible of 133 provisions
provisions_data <- read.csv("data/raw_data.csv", stringsAsFactors = FALSE) %>% 
                     select(state, year, lawtotal) %>% 
                     filter(year == 2016)

# function to transform our csv files into data frames we want, written to avoid copy pasting a bunch of code
transform_data <- function(data){
  data$Incident.Date <- mdy(data$Incident.Date) %>% year()
  data <- data %>% 
    select(Incident.Date, State) %>% 
    filter(Incident.Date == 2016)
  return(data)
}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  
})
