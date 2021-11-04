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
library(DT)

Sys.setenv("VROOM_CONNECTION_SIZE"=131072 * 2)
noc = c('GER', 'SUI', 'POR', 'NED', 'DEN', 'CRO', 'INA', 'MAS', 'UAE', 'KSA', 'IRI',
        'CHI', 'SLO', 'GRE', 'BUL', 'LAT', 'OMA', 'MGL', 'NEP', 'RSA', 'GUI', 'SLE',
        'BOT', 'GBS', 'GAM', 'MLI', 'ALG', 'LBA', 'ZIM', 'ANG', 'CGO', 'PAR', 'MAD',
        'NIG', 'NGR', 'TOG', 'SUD', 'SRI', 'VIE', 'TPE', 'PHI', 'URU', 'GUA', 'CRC', 'HAI')
iso = c('DEU', 'CHE', 'PRT', 'NLD', 'DNK', 'HRV', 'IDN', 'MYS', 'ARE', 'SAU', 'IRN',
        'CHL', 'SVN', 'GRC', 'BGR', 'LVA', 'OMN', 'MNG', 'NPL', 'ZAF', 'GIN', 'SLE',
        'BWA', 'GNB', 'GMB', 'RMM', 'DZA', 'LBY', 'ZWE', 'AGO', 'COG', 'PRY', 'MDG',
        'NER', 'NGA', 'TGO', 'SDN', 'LKA', 'VNM', 'TWN', 'PHL', 'URY', 'GTM', 'CRI', 'HTI')

africa = c('ALG', 'LBA', 'EGY', 'MAR', 'SUD', 'TUN', 'BEN', 'BUR', 'GAM', 'GHA', 'GUI', 'GBS', 'CIV', 'LBR', 'MTN',
          'MLI', 'MTN', 'NIG', 'NGR', 'SEN', 'CMR', 'GAB', 'KEN', 'RWA', 'ETH', 'ANG', 'BOT', 'RSA', 'ZAM', 'ZIM')

europe = c('AUT', 'BEL', 'BIH', 'BUL', 'CRO', 'CZE', 'DEN', 'EST', 'FIN', 'FRA', 'GER', 'GBR', 'GRE', 'HUN', 'ISL',
          'IRL', 'ITA', 'LAT', 'LTU', 'NED', 'NOR', 'POL', 'POR', 'ROU', 'RUS', 'AUT', 'SRB', 'SVK', 'SLO', 'ESP',
          'SWE', 'SUI', 'IRL', 'TUR', 'UKR')

america = c('USA', 'ARG', 'BRA', 'CAN', 'CHI', 'COL', 'CRC', 'CUB', 'DOM', 'HAI', 'JAM', 'MEX', 'NCA', 'PAN', 'PAR',
           'PUR', 'URU', 'VEN')

asia = c('IRI', 'IRQ', 'QAT', 'KSA', 'UAE', 'KAZ', 'IND', 'NEP', 'PAK', 'SRI', 'TPE', 'CHN', 'HKG', 'JPN', 'PRK', 'KOR',
        'MGL', 'CAM', 'INA', 'MAS', 'MYA', 'PHI', 'SGP', 'THA', 'VIE', 'ISR')

df1 <- read.csv('athlete_events.csv')
df1 <- df1 %>% filter(!duplicated(cbind(Team,Games,Year,City,Sport,Event,Medal)))

medal <- select(df1,'NOC','Medal')
medal <- na.omit(medal)
medal <- table(medal)
medal <- medal[order(medal[,2]),]
medal20 <- tail(medal,20)
medal20 <- as.data.frame(medal20)
medal <- as.data.frame(medal)
medal20eu <- medal[medal$NOC %in% europe,]

medal20am <- medal[medal$NOC %in% america,]

medal20as <- medal[medal$NOC %in% asia,]

medal20af <- medal[medal$NOC %in% africa,]


years <- sort(unique(df1$Year))

worlds_medals <- read.csv('athlete_events.csv') %>% 
    select(Year, NOC, Medal) %>%
    na.omit
worlds_medals$Medal=1
worlds_medals <- worlds_medals  %>%  count(Year,NOC)
lapply(0:length(worlds_medals$n),FUN = function(i){worlds_medals[worlds_medals == noc[i]] <<- iso[i]})

worlds_medals_map <- read.csv('athlete_events.csv') %>% 
    select(Sport, NOC, Medal) %>%
    na.omit
worlds_medals_map$Medal=1
worlds_medals_map <- worlds_medals_map  %>%  count(NOC,Sport)
lapply(0:length(worlds_medals_map$n),FUN = function(i){worlds_medals_map[worlds_medals_map == noc[i]] <<- iso[i]})

data1 <- read.csv("running_times.csv")
data1$results <- parse_time(data1$results, "%H:%M:%OS")
data2 <- read.csv("athletics_results.csv")

#data2 <- transform(data2, year = as.numeric(year), rank = as.numeric(rank))

data3 <- read.csv("swimming_results.csv")
data3 <- data3[,-ncol(data)]
data3$results <- parse_time(data3$results, "%H:%M:%OS")
#data3 <- transform(data3, year = as.numeric(year), rank = as.numeric(rank))
print(medal[medal$NOC %in% europe,])
data <- bind_rows(data1, data3)

data$gender <- factor(data$gender)
data$sport <- ordered(data$sport)
data$location <- factor(data$location)
data$year <- ordered(data$year)
data$rank <- ordered(data$rank)
data$country <- factor(data$country)
data$name <- factor(data$name)

weight_height <- read.csv('athlete_events.csv') %>%
    select(Sport, Sex, Weight, Height, Age) %>% na.omit
weight_height <- aggregate(weight_height[,3:4],list(weight_height$Sport,weight_height$Sex),mean)
print(weight_height)
weight_height <- round(weight_height,2)

player_wise <- read.csv('athlete_events.csv') %>% select(Name,Medal) %>%
    na.omit
player_wise <- table(player_wise)
player_wise <- as.data.frame(player_wise)
player_wise <- spread(player_wise, key=Medal, value=Freq)
player_wise$Total <- player_wise$Bronze + player_wise$Gold + player_wise$Silver

sport_wise <- read.csv('athlete_events.csv') %>% select(Sport,Medal) %>%
    na.omit
sport_wise <- table(sport_wise)
sport_wise <- as.data.frame(sport_wise)
sport_wise <- spread(sport_wise, key=Medal, value=Freq)
sport_wise$Total <- sport_wise$Bronze + sport_wise$Gold + sport_wise$Silver


team_wise <- read.csv('athlete_events.csv') %>% select(Team,Medal) %>%
    na.omit
team_wise <- table(team_wise)
team_wise <- as.data.frame(team_wise)
team_wise <- spread(team_wise, key=Medal, value=Freq)
team_wise$Total <- team_wise$Bronze + team_wise$Gold + team_wise$Silver

gdp_df <- read_csv('GDP.csv') %>% select(c('Country Name','2020'))
gdp_df <- merge(gdp_df, team_wise, by.x = 'Country Name', by.y = 'Team')
gdp_df$logw <- log(gdp_df$`2020`)

pop_df <- read_csv('Population.csv') %>% select(c('Country', 'Year_2016'))
pop_df <- merge(pop_df, team_wise, by.x = 'Country', by.y = 'Team')
pop_df$logp <- log(pop_df$`Year_2016`)
# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Olympics Games Dashboard"),

 
    mainPanel(tabsetPanel(type = "tabs",
                          tabPanel("Worldwide", plotOutput("Plot")),
                          tabPanel("Europe", plotOutput("Ploteu")),
                          tabPanel("America", plotOutput("Plotam")),
                          tabPanel("Asia", plotOutput("Plotas")),
                          tabPanel("Africa", plotOutput("Plotaf")),
    ),
              plotlyOutput("world_map"),
              selectInput("sport", "Select input",
                          c(unique(data$sport))),
              plotOutput("runningPlot1"),
              plotOutput("runningPlot2"),
              radioButtons("rd",
                           label = "Select a sport",
                           choices = list("Athletics" = "Athletics","Gymnastics" = "Gymnastics","Swimming" = "Swimming","Alpine Skiing" = "Alpine Skiing"),
                           selected = "Athletics", inline = T),
              plotlyOutput("world_map_bysport"),
              plotOutput("weight_height_scatter"),
              dataTableOutput("player_wise"),
              dataTableOutput("sport_wise"),
              plotOutput("gdp_scatter"),
              plotOutput("pop_scatter")
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$Plot <- renderPlot({
        ggplot(medal20, aes(fill=Medal, y=Freq, x=NOC)) + 
            geom_bar(position="stack", stat="identity") +
            scale_fill_manual(values = c("#614e1a", "#ffd700", "#C0C0C0"))
    })
    output$Ploteu <- renderPlot({
        ggplot(medal20eu, aes(fill=Medal, y=Freq, x=NOC)) + 
            geom_bar(position="stack", stat="identity") +
            scale_fill_manual(values = c("#614e1a", "#ffd700", "#C0C0C0"))
    })
    output$Plotam <- renderPlot({
        ggplot(medal20am, aes(fill=Medal, y=Freq, x=NOC)) + 
            geom_bar(position="stack", stat="identity") +
            scale_fill_manual(values = c("#614e1a", "#ffd700", "#C0C0C0"))
    })
    output$Plotas <- renderPlot({
        ggplot(medal20as, aes(fill=Medal, y=Freq, x=NOC)) + 
            geom_bar(position="stack", stat="identity") +
            scale_fill_manual(values = c("#614e1a", "#ffd700", "#C0C0C0"))
    })
    output$Plotaf <- renderPlot({
        ggplot(medal20af, aes(fill=Medal, y=Freq, x=NOC)) + 
            geom_bar(position="stack", stat="identity") +
            scale_fill_manual(values = c("#614e1a", "#ffd700", "#C0C0C0"))
    })
    
    output$world_map <- renderPlotly({
        plot_geo(worlds_medals, frame = ~Year) %>%
            add_trace(locations = ~NOC,
                      z = ~n,
                      color = ~n)
    })
    output$runningPlot1 <- renderPlot({
        ggplot(filter(data, sport==input$sport), aes(x=year,y=results, color=gender))+geom_boxplot(position="dodge")+geom_smooth()
    })
    output$runningPlot2 <- renderPlot({
        ggplot(filter(data, sport==input$sport), aes(x=results, color=gender))+geom_histogram(alpha=0.7,position = "identity")
    })
    output$world_map_bysport <- renderPlotly({
        subset <- worlds_medals_map %>% filter(Sport == input$rd)
        plot_geo(subset, locations=subset$NOC, z=subset$n, text=subset$NOC)
    })
    output$weight_height_scatter <- renderPlot({
        ggplot(weight_height, aes(Weight,Height,color = Group.1, label = Group.1)) +
            geom_point(show.legend = FALSE) +
            facet_wrap(~Group.2, scales = "free", nrow = 1) + 
            geom_text(size=3, show.legend = FALSE)

    })
    output$player_wise <- renderDataTable({
        datatable(player_wise, option = list(order = list(5,'desc')))
    })
    output$sport_wise <- renderDataTable({
        datatable(sport_wise, option = list(order = list(5,'desc')))
    })
    output$gdp_scatter <- renderPlot({
        ggplot(gdp_df, aes(logw, Total)) + geom_point() + geom_smooth(method='lm')
    })
    output$pop_scatter <- renderPlot({
        ggplot(pop_df, aes(logp, Total)) + geom_point() + geom_smooth(method='lm')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

