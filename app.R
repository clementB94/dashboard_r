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
noc = c('GER', 'SUI', 'POR', 'NED', 'DEN', 'CRO', 'INA', 'MAS', 'UAE', 'KSA', 'IRI', 'CHI', 'SLO', 'GRE', 'BUL', 'LAT', 'OMA', 'MGL', 'NEP', 'RSA', 'GUI', 'SLE', 'BOT', 'GBS', 'GAM', 'MLI', 'ALG', 'LBA', 'ZIM', 'ANG', 'CGO', 'PAR', 'MAD', 'NIG', 'NGR', 'TOG', 'SUD', 'SRI', 'VIE', 'TPE', 'PHI', 'URU', 'GUA', 'CRC', 'HAI')
iso = c('DEU', 'CHE', 'PRT', 'NLD', 'DNK', 'HRV', 'IDN', 'MYS', 'ARE', 'SAU', 'IRN', 'CHL', 'SVN', 'GRC', 'BGR', 'LVA', 'OMN', 'MNG', 'NPL', 'ZAF', 'GIN', 'SLE', 'BWA', 'GNB', 'GMB', 'RMM', 'DZA', 'LBY', 'ZWE', 'AGO', 'COG', 'PRY', 'MDG', 'NER', 'NGA', 'TGO', 'SDN', 'LKA', 'VNM', 'TWN', 'PHL', 'URY', 'GTM', 'CRI', 'HTI')

df1 <- read.csv('athlete_events.csv')
df1 <- df1 %>% filter(!duplicated(cbind(Team,Games,Year,City,Sport,Event,Medal)))

medal <- select(df1,'NOC','Medal')
medal <- na.omit(medal)
medal <- table(medal)
medal <- medal[order(medal[,2]),]
medal <- tail(medal,20)
medal <- as.data.frame(medal)

years <- sort(unique(df1$Year))

worlds_medals <- read.csv('athlete_events.csv') %>% 
    select(Year, NOC, Medal) %>%
    na.omit
worlds_medals$Medal=1
worlds_medals <- worlds_medals  %>%  count()
lapply(0:length(worlds_medals$freq),FUN = function(i){worlds_medals[worlds_medals == noc[i]] <<- iso[i]})

worlds_medals_map <- read.csv('athlete_events.csv') %>% 
    select(Sport, NOC, Medal) %>%
    na.omit
worlds_medals_map$Medal=1
worlds_medals_map <- worlds_medals_map  %>%  count()
lapply(0:length(worlds_medals_map$freq),FUN = function(i){worlds_medals_map[worlds_medals_map == noc[i]] <<- iso[i]})

data1 <- read.csv("running_times.csv")
data1$results <- parse_time(data1$results, "%H:%M:%OS")
data2 <- read.csv("athletics_results.csv")

#data2 <- transform(data2, year = as.numeric(year), rank = as.numeric(rank))

data3 <- read.csv("swimming_results.csv")
data3 <- data3[,-ncol(data)]
data3$results <- parse_time(data3$results, "%H:%M:%OS")
#data3 <- transform(data3, year = as.numeric(year), rank = as.numeric(rank))

data <- bind_rows(data1, data3)

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
              plotOutput("runningPlot1"),
              plotOutput("runningPlot2"),
              radioButtons("rd",
                           label = "Select a sport",
                           choices = list("Athletics" = "Athletics","Gymnastics" = "Gymnastics","Swimming" = "Swimming","Alpine Skiing" = "Alpine Skiing"),
                           selected = "Athletics", inline = T),
              plotlyOutput("world_map_bysport")
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
                      z = ~freq,
                      color = ~freq)
    })
    output$runningPlot1 <- renderPlot({
        ggplot(filter(data, sport==input$sport), aes(x=year,y=results, color=gender))+geom_boxplot(position="dodge")+geom_smooth()
    })
    output$runningPlot2 <- renderPlot({
        ggplot(filter(data, sport==input$sport), aes(x=results, color=gender))+geom_histogram(alpha=0.7,position = "identity")
    })
    output$world_map_bysport <- renderPlotly({
        subset <- worlds_medals_map %>% filter(Sport == input$rd)
        plot_geo(subset, locations=subset$NOC, z=subset$freq, text=subset$NOC)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

