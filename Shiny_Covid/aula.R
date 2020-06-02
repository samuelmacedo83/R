# Libraries ---------------------------------------------------------------
if(!require(pacman)) {install.packages("pacman")}
pacman::p_load("pacman", "tidyverse", "rstudioapi", "janitor", "directlabels")

# Definir diretório de trabalho -------------------------------------------
dirname(rstudioapi::getActiveDocumentContext()$path) %>% setwd()

# Importar o data set -----------------------------------------------------
df_covid <- read.csv(file = "./input/caso_full.csv", sep = ",", dec = ",",
                     encoding = "UTF-8", stringsAsFactors = FALSE)

glimpse(df_covid)


# Tratamento das variáveis ------------------------------------------------
df_covid$date <- as.Date(df_covid$date)

# Análise de dados --------------------------------------------------------

# Substituir o espaço vazio na variávei city por NA
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
df_covid_abc_first_case <- df_covid_abc %>% 
  group_by(city, date) %>% 
  summarise(new_confirmed) %>% 
  mutate(cum_sum_daily_cases = cumsum(new_confirmed),
         days_since_first_case = date - min(date))

glimpse(df_covid_abc_first_case)

# Gráficos das Análises ---------------------------------------------------

# Vetor com o valor da quantidade de dias máximos desde do primeiro caso
max_days = max(df_covid_abc_first_case$days_since_first_case) %>% as.numeric()


# Criando gráfico dos casos acumulados ao longo do tempo desde o primeiro caso  
df_covid_abc_first_case %>% 
  ggplot(data = .,
         mapping = aes(x = days_since_first_case,
                       y = cum_sum_daily_cases,
                       colour = city)) +
  geom_line(size = 1) + 
  scale_color_discrete(guide = "none") +
  scale_x_continuous(expand = c(0.1,0,0.2,0),
                     limits = c(0, max_days),
                     breaks = seq(from = 0, to = max_days, by = 10)) +
  directlabels::geom_dl(mapping = aes(label = city),
                        method = list(dl.trans(x = x + 0.05),
                                      "last.points")) +
  labs(x = "Número de dias a partir do primeiro caso",
       y = "Número de casos acumulados por dia (linear)",
       title = "Evolução do número de casos COVID acumulados por dia nas 7 cidades do ABC",
       caption = "Dados públicos e abertos providos pelo Brasil.IO") +
  theme_bw() +
  theme(
    plot.title = element_text(size = 20),
    axis.title.x = element_text(size = 14),
    axis.text.x = element_text(size = 12),
    axis.title.y = element_text(size = 14),
    axis.text.y = element_text(size = 12)
  )


# Gráfico dos casos acumulados ao longo do tempo desde o primeiro dia do evento em cada cidade

# Limits of days of the scale_x_date()
first_day = min(df_covid_abc_first_case$date)
last_day = max(df_covid_abc_first_case$date)

# Setting colours of the cities
main_color = "#5d615e"

# Position of the annotation about quarentine
x_quarentine_pos <- as.Date("2020-03-25")
y_quarentine_pos <- max(df_covid_abc_first_case$cum_sum_daily_cases)

# Criando o gráfico dos casos em função das datas
plot_df_covid_abc_cases_daily <- df_covid_abc_first_case %>%
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

plot_df_covid_abc_cases_daily

# Exportando o gráfico
pdf(file = "./plot_output/plot_df_covid_abc_cases_daily.pdf",
    width = 15, height = 7)
plot(plot_df_covid_abc_cases_daily)
dev.off()

# Exportando os dados para a construição do Shiny
df_covid_abc_first_case %>% 
  utils::write.table(x = ., file =  "./shiny_database/df_covid_abc_first_case.csv",
            sep = ";", dec = ",", fileEncoding = "UTF-8", quote = FALSE)
