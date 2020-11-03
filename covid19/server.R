#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(readr)
library(ggplot2)

# read pre-processed G7 data
g7 <- as.data.frame(read_csv("g7.csv"))
g7$date <- as.POSIXct(g7$date)
g7$country <- factor(g7$country,levels=c('United_States_of_America','France','United_Kingdom','Italy','Germany','Canada','Japan'))

# set initial values
day_s <- as.POSIXct("2020/01/01")
day_e <- as.POSIXct("2020/11/01")
g7_countries <- c("Canada","France","Germany","Italy","Japan","United_Kingdom","United_States_of_America")
text_cases <- 'cases'
text_death <- 'death'

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$distPlot <- renderPlot({

        # set start/end days based on input$range from ui.R
        day_d1 <- input$range[1]
        day_d2 <- input$range[2]
        
        g7_stage <- subset(g7, ((date >= day_d1) & (date <= day_d2)))
        
        # create a subset based on input$countries from ui.R

        if (length(input$countries) > 0) {
            
            # select countries based on input$countries
            for (i in input$countries) {
                g7_country <- subset(g7_stage, country == i)
                if (exists("g7_summary") == FALSE) {
                    g7_summary <- g7_country
                } else {
                    g7_summary <- rbind(g7_summary, g7_country)
                }
            }

            # select either "cases" or "death" based on input$type
            if (input$type == 'cases') {
                g <- ggplot(g7_summary, aes(x=date, y=cases, color=country))
            } else {
                g <- ggplot(g7_summary, aes(x=date, y=death, color=country))
            }
            g <- g + geom_point()
            g <- g + geom_smooth(se=FALSE, method='gam')
            g <- g + xlab("date") + ylab(input$type)
            g
            
        }
        # nothing is selected. No update

    })

})
