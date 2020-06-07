# Libraries ---------------------------------------------------------------
if(!require(pacman)) {install.packages("pacman")}
pacman::p_load("pacman", "tidyverse", "rstudioapi", "shiny", "janitor", "directlabels", "httr")


# Setting working directory -----------------------------------------------
dirname(rstudioapi::getActiveDocumentContext()$path) %>% setwd()

# Importar o data set -----------------------------------------------------

# Importando o data set do site do Brasil IO e gravando em disco
httr::GET(url = "https://data.brasil.io/dataset/covid19/caso_full.csv.gz",
          write_disk(path = "./input/caso_full.csv.gz", overwrite = TRUE),
          progress()
)

# Lendo o arquivo importado do Brasil IO para um data frame
df_covid <- read.csv(file = "./input/caso_full.csv.gz", sep = ",", dec = ",",
                     encoding = "UTF-8", stringsAsFactors = FALSE)

df_covid$date <- as.Date(df_covid$date)
# Data wrangling ----------------------------------------------------------

# Converting empty string in city variable to NA
df_covid$city <- ifelse(test = df_covid$city == "", yes = NA, no = df_covid$city)

# Removendo os NAs da cidades
df_covid_clean <- df_covid %>% 
  filter(!is.na(city))


# Criando o filtro com as cidades de interesse
cidades_filtro <- c("São Caetano do Sul",
                    "Santo André",
                    "Mauá",
                    "Diadema",
                    "São Bernardo do Campo",
                    "Rio Grande da Serra",
                    "Ribeirão Pires")

# Criando o data frame com as 7 (sete) cidades do ABC
df_covid_abc <- df_covid_clean %>% 
  filter(city %in% cidades_filtro)

# Criando o data frame com a frequência acumulada de novos casos desde o dia do primeiro caso
df_covid_shiny <- df_covid_abc %>% 
  group_by(city) %>%
  summarise(city,
            date,
            new_confirmed,
            new_deaths) %>% 
  mutate(cum_sum_daily_cases = cumsum(new_confirmed),
         cum_sum_daily_deaths = cumsum(new_deaths))
cumsum(df_covid_abc$new)

# Shiny App ---------------------------------------------------------------


# UI ----------------------------------------------------------------------
ui <- fluidPage(
  titlePanel(tags$strong("Evolução do COVID nas 7 Cidades do ABC")), #end of titlePane
  
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
      ), #end of dateRangeInput
      
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
      ) #end of checkboxGroupInput
    ), #end of sidebarPanel
    
    mainPanel(plotOutput("covid_linear")) #end of mainPanel
  ), #end of sidebarLayout
  
  tags$hr(),
) #end of fluidPage


# Server ------------------------------------------------------------------
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
