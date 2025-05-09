module Forms.Login (loginForm) where

import User
import Config

import Forms.Chat

loginForm :: Form
loginForm (accountList, _) = do
  putStrLn $ titleText " [LOGIN]        "
  putStr "Login (or :q): "
  login <- getLine

  let
    findUser = filter (\x -> login == ulogin x) accountList

  if login == ":q" then pure $ MenuNew

  else if findUser == [] then do
    pure $ MenuErr "No account"

  else do
    putStrLn $ successText $ "Login success"

    putStrLn $ titleText " [CHAT]         "
    chatForm $ (accountList, findUser !! 0)