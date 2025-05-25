module Forms.Login (loginForm) where

import User
import ScreenControl

import Forms.Default
import Forms.Chat


loginForm :: Form
loginForm (FormClose  ,       _) = defFormClose
loginForm (FormErr msg, appData) = defFormErr   loginForm appData msg
loginForm (FormClear  , appData) = defFormClear loginForm appData

loginForm (FormNew, appData) = do
  putStr toMain
  putStr . inMain True $ titleText "[LOGIN]"

  putStr . inMain False $ "Login (or :q): "

  login <- getLine

  let
    findUser = filter (\x -> login == ulogin x) $ appUsersList appData

  if login == ":q" then pure (FormClear, appData)

  else if findUser == [] then do
    pure ((FormErr "No account"), appData)

  else do
    chatForm (FormClear, AppData (appUsersList appData) (findUser !! 0) [])