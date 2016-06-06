module Compiler (compileProgram) where

import AST
import Data.List
import System.Environment

type JavaScript = String

class Compilable a where
    compile :: a -> JavaScript

instance Compilable Exp where
    compile (LNumber n) = show n
    compile (LString s) = "\"" ++ s ++ "\""
    compile (LArg a) = a
    compile (LFunRef f) = "f('" ++ f ++ "')"
    compile (LList xs) = "[" ++ intercalate ", " (map compile xs) ++ "]"
    compile (Test []) = error "There is a test with no conditions"
    compile (Test [_]) = error "There is a test with only one condition"
    compile (Test tests) = "(" ++ compile' tests ++ ")" where
        compile' [(Funcall "else" _, body)] = compile body
        compile' [_] = error "The last condition in a test is not 'else'"
        compile' ((cond, body) : rest) =
            compile cond ++ " ? " ++ compile body ++ " : " ++ compile' rest
    compile (Funcall f xs) = compile (LFunRef f)
        ++ "(" ++ intercalate ", " (map compile xs) ++ ")"
    compile (Lambda args body) = "(" ++ intercalate ", " args
        ++ ") => " ++ compile body

instance Compilable Fun where
    compile (Fun name args body scoped) =
        "s['" ++ name ++ "'] = function (" ++ intercalate ", " args ++ ") { "
        ++ (if null scoped then ""
            else "var s = Object.assign({}, s); var f = g(s); ")
        ++ concatMap compile scoped ++ "return "
        ++ compile body ++ "; }; "

compileProgram :: [Fun] -> IO JavaScript
compileProgram funs = do
    path <- getExecutablePath
    let srcdir = dropWhileEnd (/= '/') $ map (\x -> if x == '\\' then '/' else x) path
    start <- readFile $ srcdir ++ "add-to-start.js"
    end <- readFile $ srcdir ++ "add-to-end.js"
    return ("var p = '" ++ srcdir ++ "stdlib/'; "
        ++ start ++ concatMap compile funs ++ end)
