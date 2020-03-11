# Dicionário dos Dados ----------------------------------------------------

#CO_CATEGAD	Código da categoria administrativa da IES	

#1 = Pública Federal
#2 = Pública Estadual
#3 = Pública Municipal
#4 = Privada com fins lucrativos
#5 = Privada sem fins lucrativos
#7 = Especial

#area_curso
#Código da área de enquadramento do curso no Enade
#&CO_GRUPO==1401&
#"21 = Arquitetura e Urbanismo
#72 = Tecnologia em Análiseise e Desenvolvimento de Sistemas
#76 = Tecnologia em Gestão da Produçãoo Industrial
#79 = Tecnologia em Redes de Computadores
#701 = Matemática (Bacharelado)
#702 = Matemática (Licenciatura)
#903 = Letras-Portuguesa (Bacharelado)
#904 = Letras-Portuguesa (Licenciatura)
#905 = Letras-Portuguesa e Inglês (Licenciatura)
#906 = Letras-Portuguesa e Espanhol (Licenciatura)
#1401 = Física (Bacharelado)
#1402 = Física (Licenciatura)
#1501 = Química (Bacharelado)
#1502 = Química (Licenciatura)
#1601 = Ciências Biológicas (Bacharelado)
#1602 = Ciências Biológicas (Licenciatura)
#2001 = Pedagogia (Licenciatura)
#2401 = História (Bacharelado)
#2402 = História (Licenciatura)
#2501 = Artes Visuais (Licenciatura)
#3001 = Geografia (Bacharelado)
#3002 = Geografia (Licenciatura)
#3201 = Filosofia (Bacharelado)
#3202 = Filosofia (Licenciatura)
#3502 = Educaçãoo Física (Licenciatura)


#CO_REGIAO_CURSO	Código da região de funcionamento do curso	
#1 = Norte
#2 = Nordeste
#3 = Sudeste
#4 = Sul
#5 = Centro-Oeste

#NU_IDADE	Idade do inscrito em 26/11/2017	min = 10  max = 95

#TP_SEXO	Tipo de sexo	M = Masculino #F = Feminino  


#CO_TURNO_GRADUACAO	Código do turno de graduação	
#1 = Matutino
#2 = Vespertino
#3 = Integral
#4 = Noturno

#NT_GER	Nota bruta da prova - Media ponderada da formação geral (25%) e componente específico (75%). 
#(valor de 0 a 100)	

#QE_I01	Qual o seu estado civil?	

#A = Solteiro(a).
#B = Casado(a).
#C = Separado(a) judicialmente/divorciado(a).
#D = Viúvo(a).
#E = Outro.

#QE_I02	Qual a sua cor ou raça?	

#A = Branca.
#B = Preta.
#C = Amarela.
#D = Parda.
#E = Indígena.
#F = Não quero declarar.

#QE_I08	
#Qual a renda total de sua família, incluindo seus rendimentos?	

#A = Até 1,5 salários mínimo (atÃ© R$ 1.405,50).
#B = De 1,5 a 3 salários mínimos (R$ 1.405,51 a R$ 2.811,00).
#C = De 3 a 4,5 salários mínimos (R$ 2.811,01 a R$ 4.216,50).
#D = De 4,5 a 6 salários mínimos (R$ 4.216,51 a R$ 5.622,00).
#E = De 6 a 10 salários mínimos (R$ 5. 622,01 a R$ 9.370,00).
#F = De 10 a 30 salários mínimos (R$ 9.370,01 a R$ 28.110,00).
#G = Acima de 30 salários mínimos (mais de R$ 28.110,00).

#QE_I21	Alguém em sua família concluiu um curso superior?

#A = Sim.
#B = Não.

#QE_I23 Quantas horas por semana, aproximadamente, você dedicou aos estudos, excetuando as horas de aula?

#A = Nenhuma, apenas assisto as aulas.
#B = De uma a três.
#C = De quatro a sete.
#D = De oito a doze.
#E = Mais de doze.


# Libraries ---------------------------------------------------------------

if(!require(pacman)) {
  install.packages("pacman")
} else {
  pacman::p_load("pacman", "plotly", "tidyverse", "readr", "Hmisc", "skimr",
                 "e1071", "rstudioapi", "gridExtra")
}

# Setting working directory -----------------------------------------------
base::dirname(rstudioapi::getActiveDocumentContext()$path) %>% base::setwd()


# Loading Data ------------------------------------------------------------
df_enade <- readr::read_csv2(file = "MICRODADOS_ENADE_2017.txt",
                             col_names = TRUE)

# Organizando o Banco de Dados --------------------------------------------

# Dicionário:
# QE_I01	Qual o seu estado civil?	
# CO_GRUPO Curso(Matemática, estatística, psicologia..)
# CO_REGIAO_CURSO (Norte, nordeste, sul..)
# TP_SEXO (Masculino/Feminino)

# Selecionando as variáveis de interesse
df_enade_filtrados <- df_enade %>% dplyr::select(CO_GRUPO,
                                                 CO_REGIAO_CURSO,
                                                 NU_IDADE,
                                                 TP_SEXO,
                                                 CO_TURNO_GRADUACAO,
                                                 NT_GER,
                                                 QE_I01,
                                                 QE_I02,
                                                 QE_I08,
                                                 QE_I21,
                                                 QE_I23,
                                                 NT_OBJ_FG, 
                                                 NT_OBJ_CE)

# Filtrando pelo Curso Análise e Desenvolvimento de Sistemas
df_ti <- df_enade_filtrados %>%
  dplyr::filter(CO_GRUPO == 72)
df_ti$CO_GRUPO <- as.factor(df_ti$CO_GRUPO)    # convertendo o número em levels


# Sexo
df_ti$sexo <- as.factor(df_ti$TP_SEXO)
levels(df_ti$sexo) <- c("Feminino", "Masculino")


# Estado Civil
df_ti$estado_civil <- as.factor(df_ti$QE_I01)
levels(df_ti$estado_civil) <- c("Solteiro(a)", "Casado(a)", "Separado(a)", "Viuvo(a)", "Outro")


# Região
df_ti$regiao <- as.factor(df_ti$CO_REGIAO_CURSO)
levels(df_ti$regiao) <- c("Norte", "Nordeste", "Sudeste", "Sul", "Centro-Oeste")

# Horas de Estudo
df_ti$hestudos <- as.factor(df_ti$QE_I23)
levels(df_ti$hestudos) <- c("Nenhuma, apenas assisto Às aulas",
                            "De uma a três",
                            "De quatro a sete",
                            "De oito a doze",
                            "Mais de doze")

# Removendo variáveis não utilizadas
df_ti <- df_ti %>% dplyr::select(-c(TP_SEXO,
                             QE_I01,
                             CO_REGIAO_CURSO,
                             QE_I23))

# Análise Descritiva dos Dados --------------------------------------------
skimr::skim(df_ti)
Hmisc::describe(df_ti)

# Proporção de alunos por região
table(df_ti$regiao) %>% prop.table()


# Total de alunos por estado civil
df_ti %>% 
  select(estado_civil) %>% 
  group_by(estado_civil) %>% 
  summarise(freq = n()) %>% 
  arrange(desc(freq))

# Média das notas por região
df_ti %>% 
  group_by(regiao) %>% 
  summarise(media = mean(NT_OBJ_FG, na.rm = TRUE)) %>% 
  arrange(desc(media))

# Média das notas por estado civil
df_ti %>% 
  group_by(estado_civil) %>% 
  summarise(media = mean(NT_OBJ_FG, na.rm = TRUE)) %>% 
  arrange(desc(media))

# Listando todos os NAs
df_ti %>% 
  select(everything()) %>% 
  summarise_all(list(~sum(is.na(.))))

# Removendo os NAs do Data Frame TI
df_ti_noNA <- df_ti %>% na.omit()

# Análise Descritiva para a Variável Nota ---------------------------------

# Média das notas
mean(df_ti_noNA$NT_OBJ_CE)

# Mediana das notas
median(df_ti_noNA$NT_OBJ_CE)

# Consolidando os dados descritivos
df_ti_noNA$NT_OBJ_CE %>% skimr::skim()

# Calculando assimetria de Pearson para entender a distribuição dos dados
e1071::skewness(df_ti_noNA$NT_OBJ_CE)
e1071::kurtosis(df_ti_noNA$NT_OBJ_CE)


df_ti_noNA %>% 
  summarise(qntd_notas = length(NT_OBJ_CE),
            media = mean(NT_OBJ_CE),
            mediana = median(NT_OBJ_CE),
            Q1 = quantile(NT_OBJ_CE, 0.25),
            Q3 = quantile(NT_OBJ_CE, 0.75),
            assimetria = e1071::skewness(NT_OBJ_CE),
            curtose = e1071::kurtosis(NT_OBJ_CE)
            )


# Plots -------------------------------------------------------------------

# Histograma das notas
df_ti_noNA %>% 
  ggplot(mapping = aes(x = NT_OBJ_CE)) +
  geom_histogram(mapping = aes(y = ..count.. / sum(..count..)),
                 fill = "white", color = "black") +
  labs(x = "Notas", y = "Frequência Relativa") +
  scale_y_continuous(labels = scales::percent_format())


# Análise Comparativa -----------------------------------------------------

# Comparando as médias das notas de acordo com o estado civil e o sexo

df_ti_noNA %>% 
  select(estado_civil, NT_GER, sexo) %>% 
  group_by(sexo, estado_civil) %>% 
  summarise(qntd = n(),
            media = mean(NT_GER),
            mediana = median(NT_GER),
            coef_var = sd(NT_GER) / media * 100,
            Interquartil = IQR(NT_GER)
            ) %>% 
  arrange(desc(mediana))


# Analisando os dados apenas por estado civil
df_ti_noNA %>% 
  select(estado_civil, NT_GER) %>% 
  group_by(estado_civil) %>% 
  summarise(qntd = n(),
            media = mean(NT_GER),
            mediana = median(NT_GER),
            coef_var = sd(NT_GER) / media * 100,
            q1 = quantile(NT_GER, 0.25),
            q3 = quantile(NT_GER, 0.75),
            interv_iqr = IQR(NT_GER),
            assimetria = e1071::skewness(NT_GER),
            curtose = e1071::kurtosis(NT_GER)
            ) %>% 
  arrange(desc(coef_var))


# Plots Part 2 ------------------------------------------------------------

# Histograma das notas para cada estado civil
df_ti_noNA %>% 
  ggplot(mapping = aes(x = NT_GER,
                       y = ..count..,
                       fill = estado_civil)) +
  geom_histogram() +
  facet_grid(~estado_civil) +
  labs(x = "notas",
       y = "frequência simples")

# Box-plot por estado civil e sexo
df_ti_noNA %>% 
  ggplot(mapping = aes(x = estado_civil, y = NT_GER, fill = estado_civil)) +
  geom_boxplot() +
  facet_grid(~sexo) +
  labs(x = "Estado Civil", y = "Nota")


# Análise das notas por Região do País ------------------------------------

# Análise das notas por sexo e região
df_ti_noNA %>% 
  group_by(sexo, regiao) %>% 
  summarise(qntd = n(),
            media = mean(NT_GER),
            mediana = median(NT_GER),
            coef_var = sd(NT_GER) / media,
            q1 = quantile(NT_GER, 0.25),
            q3 = quantile(NT_GER, 0.75),
            interv_iqr = IQR(NT_GER),
            assimetria = e1071::skewness(NT_GER),
            curtose = e1071::kurtosis(NT_GER)
            ) %>% 
  arrange(desc(media))

# Histograma das notas por sexo e região
plt_hist_nota_sexo_regiao <- df_ti_noNA %>% 
  ggplot(mapping = aes(x = NT_GER, y = ..count.., fill = regiao)) +
  geom_histogram() +
  facet_grid(~regiao) +
  labs(x = "nota", y = "frequência simples")

# Bloxplot das notas por sexo e região
plt_boxplot_nota_sex_regiao <- df_ti_noNA %>% 
  ggplot(mapping = aes(x = regiao, y = NT_GER, fill = regiao)) +
  geom_boxplot() +
  facet_grid(~sexo) +
  labs(x = "região", y = "notas")

# Organizando os gráficos para gerar a imagem
gridExtra::grid.arrange(plt_hist_nota_sexo_regiao,
                        plt_boxplot_nota_sex_regiao,
                        nrow = 2,
                        ncol = 1)
