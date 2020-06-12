Células mescladas no Excel. Quem nunca?
Este é um hábito muito comum: mesclarmos as células para gerar agrupamentos com base nos dados. Visualmente é bastante eficiente, no entanto, ao tentar filtrar ou criar uma tabela dinâmica para poder trabalhar com os dados, isso dificulta um pouco.  
A solução? Remover os agrupamentos e preencher os gaps com os respectivos valores. Para poucos valores isso é simples e dá para fazer em pouco tempo. E se o software da sua empresa gera o relatório em Excel com dezenas (até mesmo centenas) de linhas mescladas?  
Uma solução que é bastante eficiente e elegante é o uso da função "fill()" do package "tidyr" no R.
Segue minha sugestão e espero que possa ser útil no seu trabalho.