module Forms.LoginForm (loginForm) where

import User
import Config

import Forms.ChatForm

loginForm :: [User] -> IO MenuOption
loginForm accountList = do
  titleText " [LOGIN]        "
  putStr "Login (or :q): "
  login <- getLine

  let
    findUser = filter (\x -> login == ulogin x) accountList

  if login == ":q" then
    pure MenuNew
  else if length findUser /= 0 then do
    successText $ "Login success"

    titleText " [CHAT]         "
    chatForm accountList (findUser !! 0)
    pure MenuClose
  else do
    pure $ MenuErr "No account"