library(shiny)
library(tidyverse)
library(bslib)
library(CodeClanData)

jamie_theme <- theme(panel.background = element_rect(fill = "white"),
                     panel.grid = element_line(colour = "#ededed"),
                     strip.background = element_rect(fill = "white")
) 





ui <- fluidPage(titlePanel(title = "Money Money Money"),
                theme = bs_theme(bootswatch = "minty", version = 5),
                tabsetPanel(
                  tabPanel("Income Distribution",
                           sidebarLayout(
                             sidebarPanel(
                               sliderInput(inputId = "bins",
                                           label = "Number of bins",
                                           min = 10,
                                           max = 50,
                                           value = 25 
                               ),
                               tags$b("Click me!!!"),
                               tags$br(),
                               tags$a(img(src="money-money-money.png", height="80%", width="80%"), href = "https://www.youtube.com/watch?v=ETxmCCsMoD0/")
                             ),
                             mainPanel(plotOutput("income_hist"))
                           )
                  ),
                  tabPanel("Age vs Income",
                           fluidRow(
                             column(
                               width =2,
                               numericInput(
                                 inputId = "min_age",
                                 label = "Input min age",
                                 value = 20,
                               ),
                               numericInput(
                                 inputId = "max_age",
                                 label = "Input max age",
                                 value = 100,
                               )
                             ),
                             column(
                               width = 10,
                               plotOutput("age_vs_income"))
                           )
                  )
                )
)


server <- function(input, output) {
  output$income_hist <- renderPlot(CodeClanData::bayestown_survey %>% 
                                     ggplot(aes(x = income)) +
                                     geom_histogram(bins = input$bins, fill = "darkslategray4") +
                                     jamie_theme +
                                     scale_x_continuous(breaks = seq(0, 100000, 10000 )) +
                                     labs(title = "Income distribution in Bayestown") +
                                     theme(title = element_text(size = 16),
                                           axis.text = element_text(size = 12))
  ) 
  
  output$age_vs_income <- renderPlot(CodeClanData::bayestown_survey %>%
                                       filter(age > input$min_age & age < input$max_age) %>% 
                                       ggplot(aes(x = age, y = income)) +
                                       geom_point() +
                                       geom_smooth(method = "lm", se = FALSE) +
                                       jamie_theme)
}

shinyApp(ui, server)
