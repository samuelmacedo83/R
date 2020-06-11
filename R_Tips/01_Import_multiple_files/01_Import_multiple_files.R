# libraries que precisam ser carregadas
library(dplyr)
library(purrr)
library(writexl)


# cria um vetor com o nome de todos os arquivos que estão no diretório "my_files"
my_files <- dir("./my_files/", full.names = TRUE)   


# esse trecho do código vai ler o nome de cada arquivo no vetor my_files,
# em seguida vai importar os dados, depois vai unir os dados e por último exporta
# todos os dados em um único arquivo Excel
dir("./my_files/", full.names = TRUE) %>% 
  purrr::map(., read.csv) %>%
  do.call(rbind,.) %>% 
  writexl::write_xlsx(x = ., path = "my_file.xlsx")


# OBS: a mesma linha de raciocínio se aplica a arquivos Excel. Apenas tem que carregar
# a library (readxl) e no lucar do "read.csv", substituir pelo "read_xlsx".



# Outra maneira de realizar esta tarefa
purrr::map_df(.x = dir(path = ., pattern = ".xlsx", full.names = TRUE),
              .f = readxl::read_xlsx) %>% 
  writexl::write_xlsx(x = ., path = "my_file.xlsx")