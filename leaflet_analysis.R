library(shiny)
library(dplyr)
library(shinythemes)
library(leaflet)
library(readr)
library(rebus)
library(stringr)
library(lubridate)
library(ggmap)
library(htmlwidgets)

mass_shooting_df <- read_csv('Mother Jones - Mass Shootings Database, 1982 - 2020 - Sheet1.csv')


mass_shooting_df$date <- mdy(mass_shooting_df$date)


ui <- bootstrapPage(

  #theme = shinytheme('simplex'),
  leafletOutput('map', width = "200%", height = 1000 ),

  absolutePanel(top = 10, right = 10, id = 'controls',

                sliderInput('nb_fatalities', 'Minimum Fatalities', 1, 40, 10),
                dateRangeInput('date_range', 'Select Date', '1982-08-01', '2020-03-01')
)







)

server <- function(input, output, session) {

  output$map <- renderLeaflet({
    mass_shooting_df %>% filter(
      date >= input$date_range[1],
      date <= input$date_range[2],
      fatalities >= input$nb_fatalities
    ) %>%
    leaflet() %>%
       addTiles() %>%
       setView(-98.58, 39.82, zoom = 5) %>%
       addCircleMarkers(
      popup = ~summary,
         radius = ~fatalities,
      fillColor = 'red', color = 'red', weight = 1
       )

  })




}




shinyApp(ui, server)







