# Midwest Airbnb Explorer: ask questions, get SQL, a table, or a chart back
library(shiny)
library(bslib)
library(querychat)

con = DBI::dbConnect(RSQLite::SQLite(), "data/midwest_airbnb.db")

client = ellmer::chat_openai(
  model  = "gpt-5.6-luna",
  params = ellmer::params(reasoning_effort = "none")
)

qc = querychat(
  con, "listings",
  client             = client,
  tools              = c("filter", "query", "visualize"),
  greeting           = "Ask me about 14,887 Airbnb listings in Chicago, Columbus, and the Twin Cities.",
  data_description   = "data/data_desc.md",
  extra_instructions = "data/extra_instructions.md"
)

# Custom theme: clean layout with an Airbnb-style coral accent
my_theme = bs_theme(preset = "flatly", primary = "#FF5A5F")

ui = page_navbar(
  title = "Midwest Airbnb Explorer",
  theme = my_theme,
  
  # Main tab: chat in the sidebar, SQL and data on the right
  nav_panel(
    "Explore",
    layout_sidebar(
      sidebar = qc$sidebar(),
      card(
        card_header("SQL behind the current view"),
        verbatimTextOutput("sql")
      ),
      card(
        card_header("Listings"),
        DT::DTOutput("table")
      )
    )
  ),
  
  # About tab: data source and who built the app
  nav_panel(
    "About",
    card(
      card_header("About this app"),
      p("This app lets you ask plain-English questions about Airbnb listings in three Midwest markets.
        It turns each question into SQL, runs it on the data, and returns a table or chart."),
      h5("Data source"),
      p("Listings come from Inside Airbnb (insideairbnb.com), using these snapshots:"),
      tags$ul(
        tags$li("Chicago: 2026-07-20"),
        tags$li("Columbus: 2026-07-23"),
        tags$li("Twin Cities (Minneapolis-St. Paul): 2026-07-21")
      ),
      p("14,887 listings in total, 29 columns per listing."),
      h5("Built by"),
      p("Jay Dietz, Business Intelligence course project. Built with R, Shiny, querychat, and bslib, and deployed on Render.")
    )
  )
)

server = function(input, output, session) {
  qc_vals = qc$server()
  
  # Show the SQL for the current view
  output$sql = renderText({
    sql = qc_vals$sql()
    if (is.null(sql) || sql == "") "SELECT * FROM listings" else sql
  })
  
  # Show the current data
  output$table = DT::renderDT(
    qc_vals$df(),
    options = list(pageLength = 10, scrollX = TRUE)
  )
}

shinyApp(ui, server)
