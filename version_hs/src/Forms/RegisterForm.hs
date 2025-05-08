module Forms.RegisterForm (registerForm) where

import Data.Char

import User
import Config

import Forms.ChatForm

registerForm :: AppData -> IO MenuOption
registerForm appData@(accountList, _) = do 
  titleText " [REGISTRATION] "

  putStr "Login (or :q): "
  login <- getLine

  case getLoginErrs accountList login of
    Just "-" -> pure MenuNew
    Just err -> errorText err >> registerForm appData
    _ -> registerFormAge appData login

registerFormAge :: AppData -> String -> IO MenuOption
registerFormAge appData@(accountList, _) login = do
  putStr "Enter age: "
  age <- getLine

  case getAgeErrs age of
    Just err -> errorText err >> registerForm appData
    _ -> do
      successText "Register success"
      -- appendFile usersPath $ concat ["\n", login, ";", age, ";"]

      titleText " [CHAT]         "

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
validateAge x = (x > 17) && (x < 80)