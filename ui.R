# choices for drop-downs
vars_shiptype <- unique(ships$ship_type)
vars_shipname <- unique(ships$SHIPNAME)

# css and design inspired by the SuperZip Shiny Example
# https://github.com/rstudio/shiny-examples/tree/master/063-superzip-example

semanticPage("Ship App",
           div(
             class = "outer",
             
             tags$head(includeCSS("style.css")),
             
             leafletOutput("map", width = "100%", height = "100%"),
             
             absolutePanel(
               id = "controls",
               class = "panel panel-default",
               fixed = TRUE,
               draggable = TRUE,
               top = 60,
               left = "auto",
               right = 20,
               bottom = "auto",
               width = 330,
               height = "auto",
               
               h2("Select Ship"),
               
               # user can select a vessel type (ship_type) from the dropdown field
               selectInput("shipType", "Select Ship Type", vars_shiptype),
               
               # user can select a vessel from a dropdown field 
               # available vessels should correspond to the selected type
               
               selectInput("shipName", "Select Ship Name", vars_shipname),
               
               # provide a short note saying how much the ship sailed
               # distance should be provided in meters.
               br(),
               br(),
               
               textOutput("distance_blurb"),
               
               plotOutput("histLength", height = 200),
               plotOutput("histWidth", height = 250),
             ),
             
             tags$div(id = "cite",
                      "Shiny App Created for Appsilon by Isabella Velásquez"
             )
           ))
