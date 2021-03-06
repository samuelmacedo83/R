# librarie para gerar o gr�fico
library(ggplot2)

# sumarizar os dados
summary(iris$Sepal.Length)


# Cria uma coluna chamada "Sepal.Bins" no data frame "iris". Essa coluna categorizar� os valores da coluna "Sepal.Length" de acordo com o intervalo definido no "breaks" (defini os intervalos de acordo com os valores do zero - 1�Q, 1�Q - 3�Q, 3�Q - M�x). O "rigth" como FALSE vai fazer com que os valores sejam "fechados � esquerda e abertos � direita". E o "include.lowest" vai fazer com que seja fechado � direita no �ltimo valor. O "labels" vai substiruir os intervalos por r�tulos na mesma sequ�ncia. E o "ordered_result" vai fazer com o que haja uma ordem entre os valores, logo Small < Medium < Large
iris$Sepal.Bins <- base::cut(x = iris$Sepal.Length,
                            breaks = c(0, 5.1, 6.4, 7.9),
                            right = FALSE,
                            include.lowest = TRUE,
                            labels = c("Small", "Medium", "Large"),
                            ordered_result = TRUE)

# Plota um boxplot com a distribui��o dos valoes da coluna "Sepal.Length", agrupados pela "Sepal.Bins" e por "Species"
qplot(x = iris$Sepal.Bins,
      y = iris$Sepal.Length,
      geom = "boxplot",
      fill = iris$Species)
