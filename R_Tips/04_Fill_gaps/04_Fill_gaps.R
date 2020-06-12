# Libraries ---------------------------------------------------------------
library(tidyverse)
library(readxl)
library(rstudioapi)


# Setting working directory -----------------------------------------------
dirname(rstudioapi::getActiveDocumentContext()$path) %>% setwd()


# Loading data ------------------------------------------------------------
df_test <- readxl::read_xlsx(path = "Teste.xlsx")


# Fill the NAs gaps -------------------------------------------------------
df_test %>% 
  fill(AGRUPAMENTO_1,
       AGRUPAMENTO_2) %>% 
  view()