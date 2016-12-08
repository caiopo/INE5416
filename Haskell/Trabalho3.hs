-- Aluno: Caio Pereira Oliveira - 15100724

import System.IO
import System.Environment
import Data.Char

toList :: (a, a, a) -> [a]
toList (x, y, z) = [x, y, z]

separaRGB (b:g:r:[]) = ([b], [g], [r])
separaRGB (b:g:[]) = ([b], [g], [0])
separaRGB (b:[]) = ([b], [0], [0])
separaRGB (b:g:r:resto) = let
    (bs, gs, rs) = separaRGB resto in (b:bs, g:gs, r:rs)

processaArquivo input = do
    inString <- readFile input
    let fname = take (length input - 4) input
    let outnames = map (fname++) ["_blue.out", "_green.out", "_red.out"]
    outputs <- sequence [openFile f WriteMode | f <- outnames]
    let depth = snd (splitAt 54 (map ord inString))
    let rgb = toList (separaRGB (map (\x -> fromIntegral x / 256) depth))
    sequence [hPrint file color | (file, color) <- zip outputs rgb]
    sequence [hClose f | f <- outputs]
    return ()

main :: IO ()
main = do
    args <- getArgs
    case args of
        [arquivo] -> do
            processaArquivo arquivo
        _ -> putStrLn "uso: ghc Trabalho3.hs && ./Trabalho3 file.bmp"
