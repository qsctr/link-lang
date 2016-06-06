module AST where

-- The abstract syntax tree for the language

data Exp =
    LNumber Double |
    LString String |
    LArg String |
    LFunRef String |
    LList [Exp] |
    Test [(Exp, Exp)] |
    Funcall String [Exp] |
    Lambda [String] Exp deriving Show

data Fun = Fun String [String] Exp [Fun] deriving Show
