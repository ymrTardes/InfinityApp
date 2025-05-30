module Forms.Login (loginForm) where

import User
import Config

import Forms.Chat
import System.Console.ANSI

loginForm :: Form
loginForm FormClose _ = pure FormClose
loginForm (FormErr msg) appData = do
                                    formError msg
                                    loginForm FormNew appData
loginForm FormClear appData = do
                                formClear
                                loginForm FormNew appData

loginForm FormNew (accountList, _) = do
  printMain $ titleText "[LOGIN]"

  cursorForward 2
  putStr "Login (or :q): "

  login <- getLine

  let
    findUser = filter (\x -> login == ulogin x) accountList

  if login == ":q" then pure $ FormClear

  else if findUser == [] then do
    pure $ FormErr "No account"

  else do
    chatForm FormClear $ (accountList, findUser !! 0)