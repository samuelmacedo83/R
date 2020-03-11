# Criando o vetor com os códigoa para a amostra
# 0 = grupo controle | 1 = grupo teste A | 2 = grupo teste B
amostra <- c(0,1,0,1,2,1,0,2,2)
str(amostra)  # mostra a estrutura do vetor

# Convertendo os valores numéricos em "fatores"
amostra_fatores <- as.factor(amostra)
amostra_fatores

# Copiando o amostra_fatores para outro vetor para mostrar a diferença
amostra_fatores_grupo <- amostra_fatores

# Substituindo os levels 0, 1, 2 pelos respectivos grupos
# OBS: a sequência dos levels tem que ser a mesma dos valores que se deseja substituir
levels(amostra_fatores_grupo) <- c("grupo controle", "grup teste A", "grupo teste B")
amostra_fatores_grupo
