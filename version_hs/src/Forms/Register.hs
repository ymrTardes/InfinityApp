module Forms.Register (registerForm) where

import Data.Char

import User
import Config
import ScreenControl

import Forms.Chat
import Database.SQLite.Simple

registerForm :: Form
registerForm FormClose _ = pure FormClose

registerForm (FormErr msg) appData  = do
  size <- tSize
  mapM_ putStr $ clearAll size
  printError msg
  registerForm FormNew appData

registerForm FormClear appData  = do
  size <- tSize
  mapM_ putStr $ clearAll size
  registerForm FormNew appData

registerForm FormNew appData@(accountList, _, _) = do
  putStr toMain
  printMain True $ titleText "[REGISTRATION]"

  printMain False "Login (or :q): "
  login <- getLine

  case getLoginErrs accountList login of
    Just "-" -> pure FormClear
    Just err -> registerForm (FormErr err) appData
    _ -> registerFormAge login FormNew appData

registerFormAge :: String ->  Form
registerFormAge login _ appData@(accountList, _, _) = do

  printMain False "Age: "
  age <- getLine

  case getAgeErrs age of
    Just err -> registerForm (FormErr err) appData
    _ -> do
      conn <- open dbPath
      execute conn "INSERT INTO users (name, age, bio) VALUES (?, ?, ?)" (login, read age :: Int, "" :: String)
      rowId <- lastInsertRowId conn
      close conn

      let usr = User (fromIntegral rowId) login (read age) ""

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