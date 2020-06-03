# Libraries ---------------------------------------------------------------
if(!require(pacman)) {install.packages("pacman")}
pacman::p_load("pacman", "tidyverse", "rstudioapi", "shiny", "janitor", "directlabels")


# Setting working directory -----------------------------------------------
dirname(rstudioapi::getActiveDocumentContext()$path) %>% setwd()


# Loading data ------------------------------------------------------------
my_file <- dir(path = "./shiny_database/", pattern = ".csv", full.names = TRUE)
df_covid_shiny <- read.delim(file = my_file,
                             sep = ";",
                             stringsAsFactors = FALSE,
                             dec = ",",
                             fileEncoding = "UTF-8")

df_covid_shiny$date <- as.Date(df_covid_shiny$date)
glimpse(df_covid_shiny)



# Shiny App ---------------------------------------------------------------

ui <- fluidPage(
  titlePanel(tags$strong("Evolução do COVID nas 7 Cidades do ABC")),
  tags$hr(),
  
  sidebarLayout(
    sidebarPanel(
      dateRangeInput(inputId = "date_range",
                     label = "Selecione o intervalo de datas",
                     format = "dd/mm/yyyy",
                     separator = "-",
                     min = min(df_covid_shiny$date),
                     max = max(df_covid_shiny$date),
                     start = min(df_covid_shiny$date),
                     end = max(df_covid_shiny$date)
      ),
      
      checkboxGroupInput(inputId = "cities_abc",
                         label = "Selecione a(s) Cidade(s)",
                         choices = c("São Caetano do Sul",
                                     "Santo André",
                                     "Mauá",
                                     "Diadema",
                                     "São Bernardo do Campo",
                                     "Rio Grande da Serra",
                                     "Ribeirão Pires"),
                         selected = "São Caetano do Sul"
      )
    ),
    
    mainPanel(plotOutput("covid_linear")   )
  ),
  
  tags$hr(),
)

server <- function(input, output) {
  
  output$covid_linear <- renderPlot({
    
    # Limits of days of the scale_x_date()
    first_day = min(df_covid_shiny$date)
    last_day = max(df_covid_shiny$date)
    
    # Setting colours of the cities
    main_color = "#5d615e"
    
    # Position of the annotation about quarentine
    x_quarentine_pos <- as.Date("2020-03-25")
    y_quarentine_pos <- max(df_covid_shiny$cum_sum_daily_cases)
    
    # Criando o gráfico dos casos em função das datas
    plot_shiny <- df_covid_shiny %>%
      filter(date >= paste(input$date_range[1]),
             date <= paste(input$date_range[2]),
             city %in% input$cities_abc) %>% 
      ggplot(data = .,
             mapping = aes(x = date,
                           y = cum_sum_daily_cases,
                           colour = city)) +
      geom_line(size = 1) +
      geom_vline(xintercept = as.Date("2020-03-25"),
                 linetype = "dashed",
                 colour = "#2769db") +
      scale_color_discrete(guide = "none") +
      scale_x_date(expand = expansion(add = c(1, 12)),
                   limits = c(first_day, last_day),
                   breaks = seq(from = first_day, to = last_day, by = 3),
                   date_labels = "%d-%B") +
      directlabels::geom_dl(mapping = aes(label = city),
                            method = list(dl.trans(x = x + 0.2), "last.points")) +
      annotate(geom = "text",
               x = x_quarentine_pos,
               y = y_quarentine_pos,
               colour = "#2769db",
               hjust = -0.01,
               label = "Início da quarentena no Estado de São Paulo (25/03/2020)") +
      labs(
        x = "Data de novos casos",
        y = "Número de casos acumulados por dia (linear)",
        title = "Evolução do número de casos COVID acumulados por dia nas 7 cidades do ABC",
        caption = "Dados públicos e abertos providos pelo Brasil.IO") +
      theme_bw() +
      theme(
        plot.title = element_text(size = 20, colour = main_color),
        plot.subtitle = element_text(colour = main_color),
        plot.caption = element_text(colour = main_color),
        axis.title.x = element_text(size = 14, colour = main_color),
        axis.text.x = element_text(size = 12, angle = 45, hjust = 1, vjust = 1, colour = main_color),
        axis.title.y = element_text(size = 14, colour = main_color),
        axis.text.y = element_text(size = 12, colour = main_color)
      )
    
    print(plot_shiny)
    
  })
}


shinyApp(ui = ui, server = server)