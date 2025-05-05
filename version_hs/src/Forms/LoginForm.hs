module Forms.LoginForm (loginForm) where

import User
import Config

import Forms.ChatForm

loginForm :: [User] -> IO Bool
loginForm accountList = do
  titleText " [LOGIN]        "
  putStr "Login (or :q): "
  login <- getLine

  let
    findUser = filter (\x -> login == ulogin x) accountList

  if login == ":q" then
    pure True
  else if length findUser /= 0 then do
    successText $ "Login success"

    titleText " [CHAT]         "
    chatForm accountList (findUser !! 0)
    pure False
  else do
    errorText $ "No account"
    pure True