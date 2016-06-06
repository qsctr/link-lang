module Main where

import Parser
import Compiler
import System.Environment

main = getArgs >>= mapM_ (\file ->
    let linkFile = file ++ ".link"
        jsFile = file ++ ".js" in
    readFile linkFile >>=
    compileProgram . parseProgram linkFile >>=
    writeFile jsFile >>
    putStrLn ("Successfully compiled " ++ linkFile ++ " to " ++ jsFile))
