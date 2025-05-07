module Forms.RegisterForm (registerForm) where

import Data.Char

import User
import Config

import Forms.ChatForm

registerForm :: AppData -> IO MenuOption
registerForm accountList = do
  titleText " [REGISTRATION] "
  putStr "Login (or :q): "
  login <- getLine

  let
    findUser = filter (\x -> login == ulogin x) accountList

  if login == ":q" then
    pure MenuNew

  else if length findUser /= 0 then do
    errorText "Login is used"
    registerForm accountList
  else if not $ validateLogin login then do
    errorText "Use only letters"
    registerForm accountList
  else do
    putStr "Enter age: "
    age <- getLine

    if not . and $ map isDigit age then do
      errorText "Age incorrect"
      registerForm accountList
  
    else if not . checkAge $ read age then do
      errorText "Age us not in range 18-80"
      registerForm accountList

    else do
      successText "Register success"
      -- appendFile usersPath $ concat ["\n", login, ";", age, ";"]
  
      titleText " [CHAT]         "

      let
        usr = User 0 login (read age) ""

      chatForm (accountList <> [usr], usr)


checkAge :: Int -> Bool
checkAge x = (x > 17) && (x < 80)