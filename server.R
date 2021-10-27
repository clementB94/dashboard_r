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