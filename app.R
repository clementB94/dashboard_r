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

Sys.setenv("VROOM_CONNECTION_SIZE"=131072 * 2)

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

data1 <- read_csv("running_times.csv")
print(head(data1))
data2 <- read_csv("athletics_results.csv")
print(head(data2))
print(unique(data2$sport))
print('on est la')
data2 <- transform(data2, year = as.numeric(year), rank = as.numeric(rank))
print(data2$sport)
data3 <- read_csv("swimming_results.csv")
data3 <- transform(data3, year = as.numeric(year), rank = as.numeric(rank))
print(data3$sport)

data <- rbind(data1, data2, data3)
print(unique(data$sport))
data$results <- parse_time(data$results, "%H:%M:%OS")
data$gender <- factor(data$gender)
data$sport <- ordered(data$sport)
data$location <- factor(data$location)
data$year <- ordered(data$year)
data$rank <- ordered(data$rank)
data$country <- factor(data$country)
data$name <- factor(data$name)


# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Olympics game dashboard"),

 
    mainPanel(plotOutput("distPlot"),
              plotlyOutput("world_map"),
              selectInput("sport", "Select input",
                          c(unique(data$sport))),
              plotOutput("runningPlot")
              )
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
    output$runningPlot <- renderPlot({
        ggplot(filter(data, sport==input$sport), aes(x=year,y=results, color=gender)) + geom_point() + geom_smooth()
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

