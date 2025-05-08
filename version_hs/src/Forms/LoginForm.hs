module Forms.LoginForm (loginForm) where

import User
import Config

import Forms.ChatForm

loginForm :: AppData -> IO MenuOption
loginForm (accountList, _) = do
  titleText " [LOGIN]        "
  putStr "Login (or :q): "
  login <- getLine

  let
    findUser = filter (\x -> login == ulogin x) accountList

  if login == ":q" then pure $ MenuNew

  else if findUser == [] then do
    pure $ MenuErr "No account"

  else do
    successText $ "Login success"

    titleText " [CHAT]         "
    chatForm $ (accountList, findUser !! 0)