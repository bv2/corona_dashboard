library(shiny)


load("../../out/df.RData")

# Define UI for application that plots random distributions 
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Monitoring Covid-19 (SARS-CoV-2)"),

  # Sidebar with a slider input for number of observations
  sidebarPanel(
    sliderInput("start_date", 
                "Starting date:", 
                min = min(df$date),
                max = max(df$date), 
                value = as.Date("2020-01-01")),
    checkboxInput("ds100",
                  "Time since 100 cases", FALSE),
    checkboxInput("logscale",
                  "Use log-scale (for number of deaths and confirmed cases)", FALSE),
    selectInput("cntrs", NULL , unique(df$country), selected = c("Germany", "Spain", "Italy", "UK", "US"), multiple = TRUE,
                selectize = TRUE, width = NULL, size = NULL)
  ),

  # Show a plot of the generated distribution
  mainPanel(
      tabsetPanel(
                tabPanel("Cofirmed cases", 
                        plotOutput("cases")
                ),
                tabPanel("Deaths",
                        plotOutput("deaths")
                ),
                tabPanel("Death rates",
                         plotOutput("death_rate")
                ),
                tabPanel("Doubling time & school closures",
                         plotOutput("doubling_time"),
                         plotOutput("growth_rate")
                         
                )
  )
)))