module Forms.Register (registerForm) where

import Data.Char
import Database.SQLite.Simple


import User
import Config
import ScreenControl

import Forms.Default
import Forms.Chat


registerForm :: Form
registerForm FormClose           _ = defFormClose
registerForm (FormErr msg) appData = defFormErr   registerForm appData msg
registerForm FormClear     appData = defFormClear registerForm appData

registerForm FormNew appData@(accountList, _, _) = do
  putStr toMain
  putStr . inMain True $ titleText "[REGISTRATION]"

  putStr . inMain False $ "Login (or :q): "
  login <- getLine

  case getLoginErrs accountList login of
    Just "-" -> pure FormClear
    Just err -> registerForm (FormErr err) appData
    _ -> registerFormAge login FormNew appData

registerFormAge :: String ->  Form
registerFormAge login _ appData@(accountList, _, _) = do

  putStr . inMain False $  "Age: "
  age <- getLine

  case getAgeErrs age of
    Just err -> registerForm (FormErr err) appData
    _ -> do
      let usr' = User 0 login (read age) ""

      rowId <- withConnection dbPath $ \conn -> do
        execute conn "insert into users (name, age, bio) values (?, ?, ?)" usr'
        lastInsertRowId conn

      let usr = usr' {uid = (fromIntegral rowId)}

      chatForm FormClear (accountList <> [usr], usr, [])



getLoginErrs :: [User] -> String -> Maybe String
getLoginErrs accountList login = do
  let
    findUser = filter (\x -> login == ulogin x) accountList

  if login == ":q" then do
    pure "-"
  else if length findUser /= 0 then do
    pure "Login is used"
  else if not $ validateLogin login then do
    pure "Use only letters"
  else
    Nothing

validateLogin :: String -> Bool
validateLogin  = and . map isLetter



getAgeErrs :: [Char] -> Maybe String
getAgeErrs age = do
    if not . and $ map isDigit age then do
      pure "Age incorrect"
    else if not . validateAge $ read age then do
      pure "Age us not in range 18-80"
    else do
      Nothing

validateAge :: Int -> Bool
validateAge age = (age > 17) && (age < 80)