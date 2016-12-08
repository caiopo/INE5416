-- Aluno: Caio Pereira Oliveira - 15100724

module SeriesSomas (serieImpares, somaImpares,
             seriePares, somaPares,
             serieQuadrados, somaQuadrados,
             serieQuadradosImpares, somaQuadradosImpares,
             quaseDois, quaseE) where

serieImpares n = [x * ((2 * x - 1) + 1) / 2 | x <- [1 .. n]]
seriePares n = [x * (2 * x + 2) / 2 | x <- [1 .. n]]
serieQuadrados n = [x * (x + 1) * (2 * x + 1) / 6 | x <- [1 .. n]]
serieQuadradosImpares n = [x * (4 * x^2 - 1) / 3 | x <- [1 .. n]]

somaImpares n = last(serieImpares n)
somaPares n = last(seriePares n)
somaQuadrados n = last(serieQuadrados n)
somaQuadradosImpares n = last(serieQuadradosImpares n)

quaseDois n = sum([2 / (x + x^2) | x <- [1 .. n]])
quaseE n = 1 + sum([1 / product[1 .. x] | x <- [1 .. n]])
