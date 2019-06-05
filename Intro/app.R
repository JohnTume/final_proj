library(shiny)

ui <- fluidPage(
  
  # Title of the section
  h1("Project Overview"),
  hr(),
  p("The topic of our project is to research on the relationship between gun violence and firearm laws that restricts gun sale. The main purpose of our research is to answer the general question \" Do more gun legislations against gun sale and using actually ensure public's safety \", but we also explore questions with broader topics. We believe these questions are controversial, as there are both concerns about individuals' safety and doubts about limitation on gun using among public. In our research analysis, we focused on the policy of background checking, as it could reflect the general tendency of gun sale, but also explored other policies and their relationship with various types of incidents and crime. "),
  
  img(src='2016-GUN-LAWS.jpg', align = "middle", height = 250, width = 600),
  hr(),
  h2("Audience"),
  p("While our report concerns general safety issue with gun restriction, which is related to every individuals' life, we hope to focus on explaining our results to gun lovers, who could oppose the gun legislations of gun. We hope to explain the reasonability of the firearm law to them if the research result shows more laws actually lead to better social safety, or support the stand of the gun lovers by showing there is not a strong relationship between the laws and crime or gun violence."),
  
  # Introduce the data
  h2("Data"),
  p("1. background checking data:
    Comes from the FBI's National Instant Criminal Background Check System.
    Provides data on number of firearm checks by month, state, and type"),
  p("2. gun violence data set
    This dataset is comprised of a collection of incidents involving gun violence between January 1, 2013 to March 31, 2018 from http://www.gunviolencearchive.org.
    Provides data on date, location, number of deaths/injuries, congressional district, etc."),
  p("3. Provisions data set
    Covers all 50 states from 1991 through 2017
    Includes data regarding the amount of regulations covering the sale of ammunition, such as licenses, background checks, and minimum age to legally purchase ammunition. 
    "),
  
  h2("What are some interesting questions?"),
  column(4,
         h4("A. How has the amount of restrictions on guns varied by state over the years?")
  ),
  column(4,
         h4("B. How does the amount of gun violence in a certain time period correlate with the amount of gun regulations/restrictions in place during that time period?")
  ),
  column(4,
         h4("C. How does the amount of crime, such as robberies, during a certain time period correlate with the amount of gun legislation during that same time period?")
  ),
  br(),
  hr(),
  
  # Introduce creator teams
  h2("Creators"),
  p("- Xiangyu Zhou"),
  p("- Navjyot Sandhu"),
  p("- John Tumenbayar"),
  p("- Ivan Lancaster")
  

  



  
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$distPlot <- renderPlot({
      # generate bins based on input$bins from ui.R
      x    <- faithful[, 2] 
      bins <- seq(min(x), max(x), length.out = input$bins + 1)
      
      # draw the histogram with the specified number of bins
      hist(x, breaks = bins, col = 'darkgray', border = 'white')
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

