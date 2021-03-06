# Dicion�rio dos Dados ----------------------------------------------------

#CO_CATEGAD	C�digo da categoria administrativa da IES	

#1 = P�blica Federal
#2 = P�blica Estadual
#3 = P�blica Municipal
#4 = Privada com fins lucrativos
#5 = Privada sem fins lucrativos
#7 = Especial

#area_curso
#C�digo da �rea de enquadramento do curso no Enade
#&CO_GRUPO==1401&
#"21 = Arquitetura e Urbanismo
#72 = Tecnologia em An�liseise e Desenvolvimento de Sistemas
#76 = Tecnologia em Gest�o da Produ��oo Industrial
#79 = Tecnologia em Redes de Computadores
#701 = Matem�tica (Bacharelado)
#702 = Matem�tica (Licenciatura)
#903 = Letras-Portuguesa (Bacharelado)
#904 = Letras-Portuguesa (Licenciatura)
#905 = Letras-Portuguesa e Ingl�s (Licenciatura)
#906 = Letras-Portuguesa e Espanhol (Licenciatura)
#1401 = F�sica (Bacharelado)
#1402 = F�sica (Licenciatura)
#1501 = Qu�mica (Bacharelado)
#1502 = Qu�mica (Licenciatura)
#1601 = Ci�ncias Biol�gicas (Bacharelado)
#1602 = Ci�ncias Biol�gicas (Licenciatura)
#2001 = Pedagogia (Licenciatura)
#2401 = Hist�ria (Bacharelado)
#2402 = Hist�ria (Licenciatura)
#2501 = Artes Visuais (Licenciatura)
#3001 = Geografia (Bacharelado)
#3002 = Geografia (Licenciatura)
#3201 = Filosofia (Bacharelado)
#3202 = Filosofia (Licenciatura)
#3502 = Educa��oo F�sica (Licenciatura)


#CO_REGIAO_CURSO	C�digo da regi�o de funcionamento do curso	
#1 = Norte
#2 = Nordeste
#3 = Sudeste
#4 = Sul
#5 = Centro-Oeste

#NU_IDADE	Idade do inscrito em 26/11/2017	min = 10  max = 95

#TP_SEXO	Tipo de sexo	M = Masculino #F = Feminino  


#CO_TURNO_GRADUACAO	C�digo do turno de gradua��o	
#1 = Matutino
#2 = Vespertino
#3 = Integral
#4 = Noturno

#NT_GER	Nota bruta da prova - Media ponderada da forma��o geral (25%) e componente espec�fico (75%). 
#(valor de 0 a 100)	

#QE_I01	Qual o seu estado civil?	

#A = Solteiro(a).
#B = Casado(a).
#C = Separado(a) judicialmente/divorciado(a).
#D = Vi�vo(a).
#E = Outro.

#QE_I02	Qual a sua cor ou ra�a?	

#A = Branca.
#B = Preta.
#C = Amarela.
#D = Parda.
#E = Ind�gena.
#F = N�o quero declarar.

#QE_I08	
#Qual a renda total de sua fam�lia, incluindo seus rendimentos?	

#A = At� 1,5 sal�rios m�nimo (até R$ 1.405,50).
#B = De 1,5 a 3 sal�rios m�nimos (R$ 1.405,51 a R$ 2.811,00).
#C = De 3 a 4,5 sal�rios m�nimos (R$ 2.811,01 a R$ 4.216,50).
#D = De 4,5 a 6 sal�rios m�nimos (R$ 4.216,51 a R$ 5.622,00).
#E = De 6 a 10 sal�rios m�nimos (R$ 5. 622,01 a R$ 9.370,00).
#F = De 10 a 30 sal�rios m�nimos (R$ 9.370,01 a R$ 28.110,00).
#G = Acima de 30 sal�rios m�nimos (mais de R$ 28.110,00).

#QE_I21	Algu�m em sua fam�lia concluiu um curso superior?

#A = Sim.
#B = N�o.

#QE_I23 Quantas horas por semana, aproximadamente, voc� dedicou aos estudos, excetuando as horas de aula?

#A = Nenhuma, apenas assisto as aulas.
#B = De uma a tr�s.
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

# Dicion�rio:
# QE_I01	Qual o seu estado civil?	
# CO_GRUPO Curso(Matem�tica, estat�stica, psicologia..)
# CO_REGIAO_CURSO (Norte, nordeste, sul..)
# TP_SEXO (Masculino/Feminino)

# Selecionando as vari�veis de interesse
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

# Filtrando pelo Curso An�lise e Desenvolvimento de Sistemas
df_ti <- df_enade_filtrados %>%
  dplyr::filter(CO_GRUPO == 72)
df_ti$CO_GRUPO <- as.factor(df_ti$CO_GRUPO)    # convertendo o n�mero em levels


# Sexo
df_ti$sexo <- as.factor(df_ti$TP_SEXO)
levels(df_ti$sexo) <- c("Feminino", "Masculino")


# Estado Civil
df_ti$estado_civil <- as.factor(df_ti$QE_I01)
levels(df_ti$estado_civil) <- c("Solteiro(a)", "Casado(a)", "Separado(a)", "Viuvo(a)", "Outro")


# Regi�o
df_ti$regiao <- as.factor(df_ti$CO_REGIAO_CURSO)
levels(df_ti$regiao) <- c("Norte", "Nordeste", "Sudeste", "Sul", "Centro-Oeste")

# Horas de Estudo
df_ti$hestudos <- as.factor(df_ti$QE_I23)
levels(df_ti$hestudos) <- c("Nenhuma, apenas assisto �s aulas",
                            "De uma a tr�s",
                            "De quatro a sete",
                            "De oito a doze",
                            "Mais de doze")

# Removendo vari�veis n�o utilizadas
df_ti <- df_ti %>% dplyr::select(-c(TP_SEXO,
                             QE_I01,
                             CO_REGIAO_CURSO,
                             QE_I23))

# An�lise Descritiva dos Dados --------------------------------------------
skimr::skim(df_ti)
Hmisc::describe(df_ti)

# Propor��o de alunos por regi�o
table(df_ti$regiao) %>% prop.table()


# Total de alunos por estado civil
df_ti %>% 
  select(estado_civil) %>% 
  group_by(estado_civil) %>% 
  summarise(freq = n()) %>% 
  arrange(desc(freq))

# M�dia das notas por regi�o
df_ti %>% 
  group_by(regiao) %>% 
  summarise(media = mean(NT_OBJ_FG, na.rm = TRUE)) %>% 
  arrange(desc(media))

# M�dia das notas por estado civil
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

# An�lise Descritiva para a Vari�vel Nota ---------------------------------

# M�dia das notas
mean(df_ti_noNA$NT_OBJ_CE)

# Mediana das notas
median(df_ti_noNA$NT_OBJ_CE)

# Consolidando os dados descritivos
df_ti_noNA$NT_OBJ_CE %>% skimr::skim()

# Calculando assimetria de Pearson para entender a distribui��o dos dados
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
  labs(x = "Notas", y = "Frequ�ncia Relativa") +
  scale_y_continuous(labels = scales::percent_format())


# An�lise Comparativa -----------------------------------------------------

# Comparando as m�dias das notas de acordo com o estado civil e o sexo

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
       y = "frequ�ncia simples")

# Box-plot por estado civil e sexo
df_ti_noNA %>% 
  ggplot(mapping = aes(x = estado_civil, y = NT_GER, fill = estado_civil)) +
  geom_boxplot() +
  facet_grid(~sexo) +
  labs(x = "Estado Civil", y = "Nota")


# An�lise das notas por Regi�o do Pa�s ------------------------------------

# An�lise das notas por sexo e regi�o
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

# Histograma das notas por sexo e regi�o
plt_hist_nota_sexo_regiao <- df_ti_noNA %>% 
  ggplot(mapping = aes(x = NT_GER, y = ..count.., fill = regiao)) +
  geom_histogram() +
  facet_grid(~regiao) +
  labs(x = "nota", y = "frequ�ncia simples")

# Bloxplot das notas por sexo e regi�o
plt_boxplot_nota_sex_regiao <- df_ti_noNA %>% 
  ggplot(mapping = aes(x = regiao, y = NT_GER, fill = regiao)) +
  geom_boxplot() +
  facet_grid(~sexo) +
  labs(x = "regi�o", y = "notas")

# Organizando os gr�ficos para gerar a imagem
gridExtra::grid.arrange(plt_hist_nota_sexo_regiao,
                        plt_boxplot_nota_sex_regiao,
                        nrow = 2,
                        ncol = 1)
