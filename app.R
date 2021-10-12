#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shiny)
library(lubridate)
library(tidyverse)
library(gapminder)
library(dplyr)
library(ggplot2)
library(plotly)

df1 <- read.csv('athlete_events.csv')
df1 <- df1 %>% filter(!duplicated(cbind(Team,Games,Year,City,Sport,Event,Medal)))

medal <- select(df1,'NOC','Medal')
medal <- na.omit(medal)
medal <- table(medal)
medal <- medal[order(medal[,2]),]
medal <- tail(medal,20)
medal <- as.data.frame(medal)

years <- sort(unique(df1$Year))

worlds_medals <- read_csv('athlete_events.csv') %>% 
    select(Year, NOC, Medal) %>%
    na.omit
worlds_medals$Medal=1
worlds_medals <- worlds_medals %>% group_by(Year,NOC) %>%
    summarise(Medal = sum(Medal))


# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Olympics game dashboard"),

 
    mainPanel(plotOutput("distPlot"),
              plotlyOutput("world_map"))
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        ggplot(medal, aes(fill=Medal, y=Freq, x=NOC)) + 
            geom_bar(position="stack", stat="identity") +
            scale_fill_manual(values = c("#614e1a", "#ffd700", "#C0C0C0"))
    })
    output$world_map <- renderPlotly({
        plot_geo(worlds_medals, frame = ~Year) %>%
            add_trace(locations = ~NOC,
                      z = ~Medal,
                      color = ~Medal)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
