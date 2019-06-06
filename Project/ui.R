# load library
library(shiny)
library(shinythemes)
library(ggplot2)
library(dplyr)
library(plotly)
library(lubridate)
library(maps)
library(mapproj)

# load data set
provisions_data <- read.csv("data/raw_data.csv", stringsAsFactors = FALSE)

# The user interface of the app
ui <- fluidPage(
  theme = shinytheme("slate"),
  navbarPage("Gun Violence vs Firearm laws",
             tabPanel("Overview",
                      # Title of the section
                      h1("Project Overview"),
                      hr(),
                      hr(),
                      p("The focus of our project is to research on the relationship between gun violence and firearm laws and provisions that restrict gun sales. The main purpose of our research is to answer the general question: \"Do more gun legislations against gun sales and more background checks actually ensure public safety? \" We also explore broader questions -- we believe these questions are controversial, as there are both concerns about individuals' safety and doubts about limitations on gun using among the public. In our research analysis, we explored various policies and their relationship with various types of incidents of gun violence. "),
                      
                      img(src='2016-GUN-LAWS.jpg', align = "middle", height = 250, width = 600),
                      hr(),
                      h2("- Audience"),
                      p("While our report is concerned with general safety issues and gun restrictions, which can affect many individuals' lives, we hope to focus on explaining our results to firearm advocates, who would oppose legislations on gun ownership. We hope to explain the reasonability of firearm restrictions to them if the research results show more laws actually lead to increased safety, or support the view of firearm advocates by showing that there is not a strong relationship between increased gun restrictions and gun violence, depending on what the data shows."),
                      
                      # Introduce the data
                      h2("- Data"),
                      p("1. ",
                      a("Gun violence data set:", href = "https://www.kaggle.com/gunviolencearchive/gun-violence-database"),
    "This dataset is comprised of a collection of incidents involving gun violence between January 1, 2013 to March 31, 2018 from http://www.gunviolencearchive.org.
    Provides data on date, location, number of deaths/injuries, congressional district, etc."),
                      p("2. ",
                        a("Gun provisions data set:", href = "https://www.kaggle.com/jboysen/state-firearms"),
    "Covers all 50 states from 1991 through 2017;
    Includes data regarding the amount of regulations covering the sale of ammunition, such as licenses, background checks, and minimum age to legally purchase ammunition. 
    "),
                      
                      h2("- What are some interesting questions we can pose with this data?"),
                      column(4,
                             h4("A. How has the number of restriction laws on guns varied by state over the years?")
                      ),
                      column(4,
                             h4("B. What is the trend of change on the number of firearm laws over year in each state?")
                      ),
                      column(4,
                             h4("C. How does the amount of gun violence in a certain time period correlate with the amount of gun regulations/restrictions in place during that time period?")
                      ),
                      br(),
                      hr(),
                      
                      # Introduce creator teams
                      h2("- Creators"),
                      p("- Xiangyu Zhou"),
                      p("- Navjyot Sandhu"),
                      p("- John Tumenbayar"),
                      p("- Ivan Lancaster")
             ),
             tabPanel("Overal Trend Over Years",
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
                                      value = 5)
                        ),
                        
                        mainPanel(
                          plotlyOutput("Map"),
                          br(),
                          textOutput("Mapdescription")
                        )
                      )
             ), 
             tabPanel("Firearm laws change in states", 
                      # Section title
                      titlePanel("Firearm laws change in states"),
                      hr(),
                      p("This line chart shows how the number of laws in the given state changes over year (1990 - 2017). Users can select the state you care about by using the select box and to choose the state they care about.

                        As observed in the previous section, there is a general increasing trend over year in most of the states. However, we found that the states have a intense increasing over the observed year period mostly already have 15 to 30 laws at the beginning of the period, while the state have stable or decreasing change on the number of laws mostly have fewer (0 to 15) laws. Additionally, we observed that many of the states have an either decreasing or stable variation from 2003 to 2010 (one typical state is Washington). 
                        "),
                      br(),
                      # Sidebar with a slider input for number of bins 
                      sidebarLayout(
                        sidebarPanel(
                          selectInput("state", label = h3("Select your state:"), 
                                      choices = unique(provisions_data$state),
                                      selected = "Alabama")
                        ),
                        
                        
                        # Show a plot of the generated distribution
                        mainPanel(
                          plotlyOutput("Linechart")
                        )
                      )
             ),
             tabPanel("Firearm Provisions & Gun Violence (2016)",
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
             ),
             tabPanel("Summary and Conclusions",
                      titlePanel("Summary and Conclusions"),
                      sidebarLayout(
                        
                        sidebarPanel( h1("What Did We Find?")
                        ),
                        mainPanel(
                          h2("Thank you for viewing our work!"),
                          br(),
                          p("When analyzing the amount of firearm regulations by year and state, we found that there was generally a nationwide increase in the amount of regulations, although the amount of regulations in states varied dramatically. We found that coastal states, such as Massachusetts and California, have much more regulations on firearms than states such as Idaho and Kentucky. Areas that have a more concentrated population tend to have a higher amount of gun regulation as well. This could be due to a higher level of crime which may lead these areas to pass more gun legislation."),
                          br(),
                          br(),
                          p("When analyzing the data regarding the correlation between gun violence and the level of provisions available in a state, we discovered that there seems to be a negative correlation between the number of gun provisions and the amount of gun violence in the state. In other words, the amount of gun violence found in a state seems to fall when the amount of gun provisions increases, and vice versa. There is data, however, that shows that mass shootings and gun violence on the part of police officers increases when the amount of gun provisions increases."),
                          br(),
                          br(),
                          p("Overall, it seems to be that more gun regulations does not directly lead to a substantial decrease in gun violence. Therefore, it may be that gun violence is an issue that may be better solved with some additional gun regulations, but with increased focus on other social issues facing the United States. ")
                          
                        )
                      )
              )
  

  )
)
