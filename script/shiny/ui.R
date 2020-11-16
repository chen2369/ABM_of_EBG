source("global.R")

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Simulation of EBG"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      h3("Simulation setting"),
      selectInput("p1_type", "Player1 type:", 
                  choices = typelist, selected = "Herd"),
      selectInput("p2_type", "Player2 type:", 
                  choices = typelist, selected = "Hedge"),
      sliderInput("sim_times", "Simulation times",
                  min = 1, max = 200, value = 50),
      sliderInput("down_ratio", "對方不動作時降低行動比率",
                  min = 0, max = 0.85, value = 0.7),
      # selectInput("action_ratio", "10% / 6,5% / 3% / 0%",
      #             choices = ratiolist, selected = "90 / 85 / 80 / 50"),
      actionButton("run", "RUN"),
      
      hr(),
      h3("Result"),
      sliderInput("trial_range", "Trial range",
                  min = 1, max = 101, value = c(1, 101)),
      selectInput("plot_choice", "The alternatives of player's plot:",
                  choices = plot_choices),
      
      actionButton("update", "UPDATE")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("price_plot"),
      plotOutput("player_plot"),
      gt_output("winRate_table")
    )
  )
))
