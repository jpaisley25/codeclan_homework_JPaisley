library(shiny)
library(tidyverse)
library(bslib)
library(CodeClanData)

jamie_theme <- theme(panel.background = element_rect(fill = "white"),
                     panel.grid = element_line(colour = "#ededed"),
                     strip.background = element_rect(fill = "white")
) ## my theme 



ui <- fluidPage(
  titlePanel("Game Sales"),
  theme = bs_theme(bootswatch = "minty", version = 5),
  tabsetPanel(    
    tabPanel(# first tab contains a graph that lets the user see the total 
      # sales of games for the subcategories in 5 different category types 
      "Total Game Sales",
             radioButtons(
               inputId = "category",
               label = "Category:",
               choices = c("Platform" = "platform", 
                           "Publisher" = "publisher",
                           "Developer" = "developer",
                           "Genre" = "genre",
                           "Rating" = "rating"
                           ),
               inline = TRUE
             ),
             plotOutput("plot")
    ),
    tabPanel(# second tab shows user a graph of average game rating vs
             # year of release. The user can use the layered inputs to 
             # customize the graph in a variety of ways
      "Genre Scores Over Time",
             radioButtons(
               inputId = "score",
               label = "Critic or User Score?",
               choices = c(
                 "Critic" = "critic_score",
                 "User" = "user_score"
               )
             ),
             selectInput(
               inputId = "selection1",
               label = "Selection 1:",
               choices = c("Platform" = "platform", 
                           "Publisher" = "publisher",
                           "Developer" = "developer",
                           "Genre" = "genre",
                           "Rating" = "rating"
               )
             ),
             selectInput(
               inputId = "genre",
               label = "Genre (can pick more than 1):",
               choices = "default",
               multiple = TRUE
               ),
             radioButtons(
               inputId = "line",
               label = "Best fit line type:",
               choices = c(
                 "lm",
                 "glm",
                 "gam",
                 "loess"
               )
             ),
             plotOutput("plot2")
    ),
    tabPanel(# third tab pulls a random game from the data and shows its
             # row in the table
      "Random Game Selector",
             sidebarLayout(
               sidebarPanel(
                 width = 3,
                 actionButton(
                   inputId = "randomizer",
                   label = "Randomizer")
               ),
               mainPanel(
                 width = 9, 
                 DT::DTOutput(
                   outputId = "random_game"
                 )
               )
             )
    )
  )
)

server <- function(input, output, session) {
  
  chosen_category <- eventReactive(
    eventExpr = input$category,
    CodeClanData::game_sales %>% 
      rename("x" = input$category)
  )
  
  output$plot <- renderPlot(
    chosen_category() %>% 
      group_by(x) %>% 
      summarise(y = sum(sales)) %>% 
      ggplot() +
      geom_col(aes(x = x, y = y, fill = x)) +
      jamie_theme +
      labs(x = input$category, y = "Total Game Sales (millions)", title = paste("Total game dales for each", input$category)) +
      coord_flip() +
      theme(axis.text = element_text(size = 12),
            legend.text = element_text(size = 11),
            axis.title = element_text(size = 12),
            plot.title = element_text(size = 16))
    
  )
  
  
  observe({ #updates select input based on previous select input
    updateSelectInput(session, "genre", choices = as.character(
      CodeClanData::game_sales %>% 
        rename("x" = input$selection1) %>% 
        distinct(x) %>% 
        pull(x)
    ))
  })

  output$plot2 <- renderPlot(
    CodeClanData::game_sales %>% 
      rename("x" = input$selection1) %>% 
      filter(x %in% input$genre)%>% 
      rename("score" = input$score) %>% 
      filter(year_of_release != 1988) %>% 
      group_by(year_of_release, x) %>% 
      summarise(avg_score = mean(score)) %>% 
      ungroup() %>% 
      ggplot(aes(x = year_of_release, y = avg_score, colour = x)) +
      geom_point() +
      geom_smooth(method = input$line, se = FALSE) +
      jamie_theme +
      labs(x = "year of release", y = "average score", title = paste("Average critic or user score vs year of release for different selections")) +
      theme(axis.text = element_text(size = 12),
            legend.text = element_text(size = 11),
            axis.title = element_text(size = 12),
            plot.title = element_text(size = 16)) +
      scale_x_continuous(breaks = seq(1994, 2016, 2))
  )
  
  randomizer <- eventReactive(
    eventExpr = input$randomizer,
    CodeClanData::game_sales %>% 
      sample_n(1)
  )
  
  output$random_game <- DT::renderDT(
    randomizer()
  ) 
  
  
  
}

shinyApp(ui, server)



