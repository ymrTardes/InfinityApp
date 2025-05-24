module Forms.Login (loginForm) where

import User
import ScreenControl

import Forms.Default
import Forms.Chat


loginForm :: Form
loginForm FormClose           _ = defFormClose
loginForm (FormErr msg) appData = defFormErr   loginForm appData msg
loginForm FormClear     appData = defFormClear loginForm appData

loginForm FormNew (accountList, _, _) = do
  putStr toMain
  putStr . inMain True $ titleText "[LOGIN]"

  putStr . inMain False $ "Login (or :q): "

  login <- getLine

  let
    findUser = filter (\x -> login == ulogin x) accountList

  if login == ":q" then pure $ FormClear

  else if findUser == [] then do
    pure $ FormErr "No account"

  else do
    chatForm FormClear $ (accountList, findUser !! 0, [])