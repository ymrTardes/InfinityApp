module Forms.Login (loginForm) where

import User
import Config
import ScreenControl

import Forms.Chat

loginForm :: Form
loginForm FormClose _ = pure FormClose

loginForm (FormErr msg) appData = do
  size <- tSize
  mapM_ putStr $ clearAll size
  printError msg
  loginForm FormNew appData

loginForm FormClear appData = do
  size <- tSize
  mapM_ putStr $ clearAll size
  loginForm FormNew appData

loginForm FormNew (accountList, _, _) = do
  putStr toMain
  printMain True $ titleText "[LOGIN]"

  printMain False "Login (or :q): "

  login <- getLine

  let
    findUser = filter (\x -> login == ulogin x) accountList

  if login == ":q" then pure $ FormClear

  else if findUser == [] then do
    pure $ FormErr "No account"

  else do
    chatForm FormClear $ (accountList, findUser !! 0, [])