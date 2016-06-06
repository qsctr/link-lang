module Parser (parseProgram) where

import AST
import Text.Parsec

parseProgram :: String -> String -> [Fun]
parseProgram file code = case parse (parseFun `sepEndBy` spaces) file code of
    Left err -> error $ show err
    Right funs -> funs

parseFun :: Parsec String () Fun
parseFun = do
    indent <- indentation
    string "let"
    char ' '
    funName <- word
    funArgs <- manyTill (space >> jsWord) $ try $ spaces >> char '='
    spaces
    body <- parseExp indent
    scoped <- option [] $ try $
        many (oneOf " \t") >> string "scoped" >> endOfLine >> many1 parseFun
    return $ Fun funName funArgs body scoped

parseExp :: Int -> Parsec String () Exp
parseExp pre = do
    indent <- indentation
    let isntArg = notFollowedBy $ count (indent + pre + 1) $ oneOf " \t"
    try (string "test" >> endOfLine >>
        Test <$> manyTill parseTestItem isntArg) <|> try (do
            Funcall funName inlineArgs <- try parseFuncall <|> parseNoArgs
            endOfLine
            otherArgs <- manyTill (parseExp 0) isntArg
            return $ Funcall funName (inlineArgs ++ otherArgs))
             <|> (do
                item <- parseItem
                endOfLine
                isntArg
                return item)

parseTestItem :: Parsec String () (Exp, Exp)
parseTestItem = do
    indent <- indentation
    name <- word
    optional $ char ' '
    args <- flip manyTill (try $ string "->") $ do
        arg <- parseItem
        char ' '
        return arg
    let cond = Funcall name args
    spaces
    res <- parseExp indent
    return (cond, res)

parseFuncall :: Parsec String () Exp
parseFuncall = do
    name <- word
    char ' '
    args <- parseItem `sepBy1` char ' '
    return $ Funcall name args

parseItem :: Parsec String () Exp
parseItem = parseLNumber <|> parseLString <|> parseLArg <|> parseLFunRef
    <|> parseLList <|> parseLambda <|> parseParens <|> parseNoArgs

parseLNumber :: Parsec String () Exp
parseLNumber = LNumber . read <$> many1 (digit <|> char '.')

parseLString :: Parsec String () Exp
parseLString = do
    char '"'
    s <- many $
        (char '\\' >> (('\\':) . (:[])) <$> anyChar) <|> (:[]) <$> noneOf "\""
    char '"'
    return $ LString $ concat s

parseLArg :: Parsec String () Exp
parseLArg = char '$' >> LArg <$> jsWord

parseLFunRef :: Parsec String () Exp
parseLFunRef = char '@' >> LFunRef <$> word

parseLList :: Parsec String () Exp
parseLList = do
    char '['
    items <- parseItem `sepBy` (char ',' >> spaces)
    char ']'
    return $ LList items

parseLambda :: Parsec String () Exp
parseLambda = do
    char '{'
    spaces
    args <- flip manyTill (try $ string "->") $ do
        arg <- jsWord
        space
        return arg
    spaces
    body <- flip (<|>) parseItem $ do
        bodyName <- word
        spaces
        bodyArgs <- parseItem `sepBy1` skipMany1 space
        return $ Funcall bodyName bodyArgs
    spaces
    char '}'
    return $ Lambda args body

parseParens :: Parsec String () Exp
parseParens = do
    char '('
    spaces
    inside <- parseFuncall <|> parseItem
    spaces
    char ')'
    return inside

parseNoArgs :: Parsec String () Exp
parseNoArgs = flip Funcall [] <$> word

word :: Parsec String () String
word = do
    first <- both
    rest <- many $ both <|> digit
    return (first:rest)
    where both = letter <|> oneOf "`~!#%^&*-_+=|:;,<>/?"

jsWord :: Parsec String () String
jsWord = do
    first <- letter
    rest <- many $ letter <|> digit
    return (first:rest)

indentation :: Parsec String () Int
indentation = length <$> many (oneOf " \t")
