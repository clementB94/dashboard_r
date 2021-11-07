#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# libraries
library(shiny)
library(lubridate)
library(tidyverse)
library(gapminder)
library(dplyr)
library(ggplot2)
library(plotly)
library(DT)
library(ggrepel)

# Hard coded variables
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

################################################
# DATA IMPORTATION,PREPARATION AND AGGREGATION #
################################################

df1 <- read.csv('athlete_events.csv')
df1 <- df1 %>% filter(!duplicated(cbind(Team,Games,Year,City,Sport,Event,Medal)))

# Medals of top 20 countries
medal <- select(df1,'NOC','Medal')
medal <- na.omit(medal)
medal <- table(medal)
medal <- medal[order(medal[,2]),]
medal20 <- tail(medal,20)
medal20 <- as.data.frame(medal20)
medal <- as.data.frame(medal)

# Select countries based on their region
medal20eu <- medal[medal$NOC %in% europe,]

medal20am <- medal[medal$NOC %in% america,]

medal20as <- medal[medal$NOC %in% asia,]

medal20af <- medal[medal$NOC %in% africa,]


years <- sort(unique(df1$Year))

# Medals by countries depending on the year for the world map
worlds_medals <- df1 %>% 
    select(Year, NOC, Medal) %>%
    na.omit
worlds_medals$Medal=1
worlds_medals <- worlds_medals  %>%  count(Year,NOC)
lapply(0:length(worlds_medals$n),FUN = function(i){worlds_medals[worlds_medals == noc[i]] <<- iso[i]})

# Medals by countries depending on the sport for the world map
worlds_medals_map <- df1 %>% 
    select(Sport, NOC, Medal) %>%
    na.omit
worlds_medals_map$Medal=1
worlds_medals_map <- worlds_medals_map  %>%  count(NOC,Sport)
lapply(0:length(worlds_medals_map$n),FUN = function(i){worlds_medals_map[worlds_medals_map == noc[i]] <<- iso[i]})

# Performances by sport
data1 <- read.csv("running_times.csv")
data1$results <- parse_time(data1$results, "%H:%M:%OS")

data3 <- read.csv("swimming_results.csv")
data3$results <- parse_time(data3$results, "%H:%M:%OS")

data <- bind_rows(data1, data3)

data$gender <- factor(data$gender)
data$sport <- ordered(data$sport)
data$location <- factor(data$location)
data$year <- ordered(data$year)
data$rank <- ordered(data$rank)
data$country <- factor(data$country)
data$name <- factor(data$name)

# Weight and Height by sport
weight_height <- read.csv('athlete_events.csv') %>%
    select(Sport, Sex, Weight, Height, Age) %>% na.omit
weight_height <- aggregate(weight_height[,3:4],list(weight_height$Sport,weight_height$Sex),mean)
print(weight_height)
weight_height <- round(weight_height,2)

# Medals by athletes
player_wise <- df1 %>% select(Name,Medal) %>%
    na.omit
player_wise <- table(player_wise)
player_wise <- as.data.frame(player_wise)
player_wise <- spread(player_wise, key=Medal, value=Freq)
player_wise$Total <- player_wise$Bronze + player_wise$Gold + player_wise$Silver

# Medals by sport
sport_wise <- read.csv('athlete_events.csv') %>% select(Sport,Medal) %>%
    na.omit
sport_wise <- table(sport_wise)
sport_wise <- as.data.frame(sport_wise)
sport_wise <- spread(sport_wise, key=Medal, value=Freq)
sport_wise$Total <- sport_wise$Bronze + sport_wise$Gold + sport_wise$Silver

# Medals by team
team_wise <- read.csv('athlete_events.csv') %>% select(Team,Medal) %>%
    na.omit
team_wise <- table(team_wise)
team_wise <- as.data.frame(team_wise)
team_wise <- spread(team_wise, key=Medal, value=Freq)
team_wise$Total <- team_wise$Bronze + team_wise$Gold + team_wise$Silver

# Medals and log(GDP) by country
gdp_df <- read_csv('GDP.csv') %>% select(c('Country Name','2020'))
gdp_df <- merge(gdp_df, team_wise, by.x = 'Country Name', by.y = 'Team')
gdp_df$logw <- log(gdp_df$`2020`)

# Medals and log(Population) by country
pop_df <- read_csv('Population.csv') %>% select(Country, Year_2016)
pop_df <- merge(pop_df, team_wise, by.x = 'Country', by.y = 'Team')
pop_df$logp <- log(pop_df$`Year_2016`)

####################################################
# Define UI for application that draws a histogram #
####################################################

ui <- fluidPage(
    # Application title
    titlePanel("Olympics Games Dashboard"),
 
    fluidRow(column(12, align = 'center',
                  tags$h3('Amount of Medals by Country'),
                  tabsetPanel(type = "tabs",
                          tabPanel("Worldwide", plotOutput("Plot", width='100%')),
                          tabPanel("Europe", plotOutput("Ploteu", width='100%')),
                          tabPanel("America", plotOutput("Plotam", width='100%')),
                          tabPanel("Asia", plotOutput("Plotas", width='100%')),
                          tabPanel("Africa", plotOutput("Plotaf", width='100%'))
                          ),
                  tags$h3('World map of Medals won by Year'),
                  plotlyOutput("world_map", width='100%'),
                  tags$h3('Performance by Sport'),
                  fluidRow(column(width = 6,
                      selectInput("sport", "Select a sport",
                                  c(unique(data$sport)))),
                      column(width = 6,
                      radioButtons("sex_select", "Which gender ?",
                                   choices = unique(data$gender),
                                 selected = "M", inline = T))
                  ),
                  plotOutput("runningPlot1", width='100%'),
                  plotOutput("runningPlot2", width='100%'),
                  tags$h3('World map of Performance by Sport'),
                  radioButtons("rd",
                               label = "Select a sport",
                               choices = list("Athletics" = "Athletics",
                                              "Gymnastics" = "Gymnastics",
                                              "Swimming" = "Swimming",
                                              "Alpine Skiing" = "Alpine Skiing",
                                              "Cycling" = "Cycling",
                                              "Wrestling" = "Wrestling",
                                              "Shooting" = "Shooting",
                                              "Canoeing" = "Canoeing",
                                              "Fencing" = "Fencing",
                                              "Archery" = "Archery",
                                              "Rowing" = "Rowing",
                                              "Football" = "Football",
                                              "Volleyball" = "Volleyball",
                                              "Diving" = "Diving",
                                              "Equestrianism" = "Equestrianism",
                                              "Sailing" = "Sailing",
                                              "Weightlifting" = "Weightlifting",
                                              "Basketball" = "Basketball",
                                              "Hockey" = "Hockey",
                                              "Boxing" = "Boxing",
                                              "Art Competitions" = "Art Competitions",
                                              "Judo" = "Judo",
                                              "Tennis" = "Tennis"),
                               selected = "Athletics", inline = T),
                  plotlyOutput("world_map_bysport", width='100%'),
                  tags$h3('Weight and Height by sport'),
                  plotOutput("weight_height_scatter", width='100%'),
                  tags$h3('Medals won by Player and Sport'),
                  splitLayout(cellWidths = c("50%", "50%"),
                              dataTableOutput("player_wise"),
                              dataTableOutput("sport_wise")),
                  tags$h3('Medals won by GDP and Population'),
                  splitLayout(cellWidths = c("49%", "49%"),
                              plotOutput("gdp_scatter"), plotOutput("pop_scatter")),
    ))
)

####################################################
# Define server logic required to draw a histogram #
####################################################

server <- function(input, output) {
    
    # Bar graph of medals by top 20 countries
    output$Plot <- renderPlot({
        ggplot(medal20, aes(fill=Medal, y=Freq, x=NOC)) + 
            geom_bar(position="stack", stat="identity") +
            scale_fill_manual(values = c("#614e1a", "#ffd700", "#C0C0C0"))
    })
    # Bar graph of medals by European countries
    output$Ploteu <- renderPlot({
        ggplot(medal20eu, aes(fill=Medal, y=Freq, x=NOC)) + 
            geom_bar(position="stack", stat="identity") +
            scale_fill_manual(values = c("#614e1a", "#ffd700", "#C0C0C0"))
    })
    # Bar graph of medals by American countries
    output$Plotam <- renderPlot({
        ggplot(medal20am, aes(fill=Medal, y=Freq, x=NOC)) + 
            geom_bar(position="stack", stat="identity") +
            scale_fill_manual(values = c("#614e1a", "#ffd700", "#C0C0C0"))
    })
    # Bar graph of medals by Asian countries
    output$Plotas <- renderPlot({
        ggplot(medal20as, aes(fill=Medal, y=Freq, x=NOC)) + 
            geom_bar(position="stack", stat="identity") +
            scale_fill_manual(values = c("#614e1a", "#ffd700", "#C0C0C0"))
    })
    # Bar graph of medals by African countries
    output$Plotaf <- renderPlot({
        ggplot(medal20af, aes(fill=Medal, y=Freq, x=NOC)) + 
            geom_bar(position="stack", stat="identity") +
            scale_fill_manual(values = c("#614e1a", "#ffd700", "#C0C0C0"))
    })
    # World map of medals by country
    output$world_map <- renderPlotly({
        plot_geo(worlds_medals, frame = ~Year) %>%
            add_trace(locations = ~NOC, z = ~n, color = ~n, colors = 'Blues')
    })
    # Performance Box plot by sport and gender
    output$runningPlot1 <- renderPlot({
        dataplot <- filter(data, sport==input$sport & gender==input$sex_select)
        Q <- quantile(dataplot$results, probs=c(.25, .75), na.rm = FALSE)
        iqr <- IQR(dataplot$results)
        dataplot <- subset(dataplot, dataplot$results < (Q[2]+1.5*iqr))
        ggplot(dataplot, aes(x=year,y=results, color=gender))+
            geom_boxplot(position="dodge")+geom_smooth() +
            labs(y='Results (H:M:S)')
    })
    # Performance Histogram by sport and gender
    output$runningPlot2 <- renderPlot({
        dataplot <- filter(data, sport==input$sport & gender==input$sex_select)
        Q <- quantile(dataplot$results, probs=c(.25, .75), na.rm = FALSE)
        iqr <- IQR(dataplot$results)
        dataplot <- subset(dataplot, dataplot$results < (Q[2]+1.5*iqr))
        ggplot(dataplot, aes(x=results, color=gender))+ 
            geom_histogram(alpha=0.7,position = "identity")+
            labs(x='Results (H:M:S)')
    })
    # World map of medals won by country and sport
    output$world_map_bysport <- renderPlotly({
        subset <- worlds_medals_map %>% filter(Sport == input$rd)
        plot_geo(subset, locations=subset$NOC, z=subset$n, text=subset$NOC,
                 colors = 'Blues')
    })
    # Scatter plot of weight and height by sport and gender
    output$weight_height_scatter <- renderPlot({
        ggplot(weight_height, aes(Weight,Height,color = Group.1, label = Group.1)) +
            facet_wrap(~Group.2, scales = "free", nrow = 1) +
            geom_point(show.legend = FALSE) +
            geom_label_repel(show.legend = FALSE, fontface = "bold") +
            labs(x='Weight (kg)', y='Height (cm)')
    })
    # Data table of medals by athlete
    output$player_wise <- renderDataTable({
        datatable(player_wise, option = list(order = list(5,'desc')))
    })
    # Data table of medals by sport
    output$sport_wise <- renderDataTable({
        datatable(sport_wise, option = list(order = list(5,'desc')))
    })
    # Scatter plot of Medals won and GDP 
    output$gdp_scatter <- renderPlot({
        ggplot(gdp_df, aes(logw, Total)) + geom_point() +
            geom_smooth(method='lm') +
            labs(x='Log(2016 GDP)', y='Total number of Medals')
    })
    # Scatter plot of Medals won and Population
    output$pop_scatter <- renderPlot({
        ggplot(pop_df, aes(logp, Total)) + geom_point() +
            geom_smooth(method='lm') +
            labs(x='Log(2020 Population)', y='Total number of Medals')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

