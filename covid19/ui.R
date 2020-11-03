#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

day_s <- as.POSIXct("2020/01/01")
day_e <- as.POSIXct("2020/11/01")

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Covid-19 cases - G7 Countries"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("range",
                        "Select duration:",
                        min = day_s,
                        max = day_e,
                        timeFormat = '%F',
                        step = 1,
                        value = c(day_s,day_e)),
            checkboxGroupInput("countries", 
                               "Select countries:", 
                               choices = list("Canada"="Canada", "France"="France", "Germany"="Germany", "Italy"="Italy",
                                              "Japan"="Japan", "United Kingdom"="United_Kingdom",
                                              "United States of America"="United_States_of_America"),
                               selected = "Canada"),
            radioButtons("type", "Select type:", c('cases','death'))
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("distPlot")
        )
    )
))
