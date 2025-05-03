module Forms.RegisterForm (registerForm) where

import Data.Char

import User
import Config

import Forms.ChatForm

registerForm :: [User] -> IO Bool
registerForm accountList = do
  titleText " [REGISTRATION] "
  putStr "Login (or :q): "
  login <- getLine

  let
    findUser = filter (\x -> login == ulogin x) accountList

  if login == ":q" then
    pure True
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
      appendFile usersPath $ concat ["\n", login, ";", age, ";"]
  
      titleText " [CHAT]         "
      chatForm accountList (User login (read age) "")
      pure False