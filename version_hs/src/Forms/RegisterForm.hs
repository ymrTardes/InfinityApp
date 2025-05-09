module Forms.RegisterForm (registerForm) where

import Data.Char

import User
import Config

import Forms.ChatForm

registerForm :: Form
registerForm appData@(accountList, _) = do 
  putStrLn $ titleText " [REGISTRATION] "

  putStr "Login (or :q): "
  login <- getLine

  case getLoginErrs accountList login of
    Just "-" -> pure MenuNew
    Just err -> putStrLn (errorText err) >> registerForm appData
    _ -> registerFormAge login appData

registerFormAge :: String ->  Form
registerFormAge login appData@(accountList, _) = do
  putStr "Age: "
  age <- getLine

  case getAgeErrs age of
    Just err -> putStrLn (errorText err) >> registerForm appData
    _ -> do
      putStrLn $ successText "Register success"
      -- appendFile usersPath $ concat ["\n", login, ";", age, ";"]

      putStrLn $ titleText " [CHAT]         "

      let usr = User 0 login (read age) ""

      chatForm (accountList <> [usr], usr)



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