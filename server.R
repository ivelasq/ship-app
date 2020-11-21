library(leaflet)

function(input, output, session) {
  
  ships_filter <- reactive({
    ships %>%
      filter(ship_type == input$shipType)
  })
  
  observeEvent(ships_filter(), {
    updateSelectInput(session = session, 
                      inputId = "shipName", 
                      label = "Select Ship Name",
                      choices = ships_filter()$SHIPNAME)
  })
  
  ships_pts <- reactive({
    ships_filter() %>%
      filter(SHIPNAME == input$shipName)
  })
  
  # Create the map
  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron) %>% 
      setView(lng = 21.0122, 
              lat = 52.2297, 
              zoom = 5)
  })
  
  # display that on the map
  # show two points, the beginning and the end of the movement
  # the map should be created using the leaflet library
  # changing type and vessel name should re-render the map and the note.
  
  observe({
    leafletProxy("map", data = ships_pts()) %>%
      clearShapes() %>%
      setView(lng = ships_pts()$LON, 
              lat = ships_pts()$LAT, 
              zoom = 12) %>% 
      addCircles(
        lng = ~ LON,
        lat = ~ LAT,
          color = "#2f0909",
        fillOpacity = 0.7,
        popup = ~ paste("Ship Name: ",
                        "<br>",
                        SHIPNAME,
                        "<br>",
                        "Port: ",
                        "<br>",
                        port),
        radius = 220
      ) %>%
      addCircles(
        lng = ~ lon2,
        lat = ~ lat2,
        color = "#CCCC00",
        fillOpacity = 0.7,
        popup = ~ paste("Ship Name: ",
                        "<br>",
                        SHIPNAME,
                        "<br>",
                        "Port: ",
                        "<br>",
                        port),
        radius = 220
      )
  })
  
  output$histLength <- renderPlot({

    hist(ships_filter()$LENGTH,
         main = paste0("Length of ", input$shipType, " Ships"),
         xlab = "Meters",
         xlim = range(ships_filter()$LENGTH, na.rm = T),
         col = '#301934',
         border = 'white')
    })
  
  output$histWidth <- renderPlot({
    
    hist(ships_filter()$WIDTH,
         main = paste0("Width of ", input$shipType, " Ships"),
         xlab = "Meters",
         xlim = range(ships_filter()$WIDTH, na.rm = T),
         col = '#301934',
         border = 'white')
  })

  # provide a short note saying how much the ship sailed
  # distance should be provided in meters
  
  output$distance_blurb <- renderText({ 
    paste0("On ",
           ships_pts()$date,
           ", the ship named ",
           ships_pts()$SHIPNAME,
           " sailed ",
           round(ships_pts()$dist, 1),
           " meters."
    )
  })
  
}