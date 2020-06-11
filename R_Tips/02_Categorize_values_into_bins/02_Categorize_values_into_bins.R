# librarie para gerar o gráfico
library(ggplot2)

# sumarizar os dados
summary(iris$Sepal.Length)


# Cria uma coluna chamada "Sepal.Bins" no data frame "iris". Essa coluna categorizará os valores da coluna "Sepal.Length" de acordo com o intervalo definido no "breaks" (defini os intervalos de acordo com os valores do zero - 1ºQ, 1ºQ - 3ºQ, 3ºQ - Máx). O "rigth" como FALSE vai fazer com que os valores sejam "fechados à esquerda e abertos à direita". E o "include.lowest" vai fazer com que seja fechado à direita no último valor. O "labels" vai substiruir os intervalos por rótulos na mesma sequência. E o "ordered_result" vai fazer com o que haja uma ordem entre os valores, logo Small < Medium < Large
iris$Sepal.Bins <- base::cut(x = iris$Sepal.Length,
                            breaks = c(0, 5.1, 6.4, 7.9),
                            right = FALSE,
                            include.lowest = TRUE,
                            labels = c("Small", "Medium", "Large"),
                            ordered_result = TRUE)

# Plota um boxplot com a distribuição dos valoes da coluna "Sepal.Length", agrupados pela "Sepal.Bins" e por "Species"
qplot(x = iris$Sepal.Bins,
      y = iris$Sepal.Length,
      geom = "boxplot",
      fill = iris$Species)
