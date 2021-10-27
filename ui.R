ui <- fluidPage(
  
  # Application title
  titlePanel("Olympics game dashboard"),
  
  
  mainPanel(plotOutput("distPlot"),
            plotlyOutput("world_map"))
)