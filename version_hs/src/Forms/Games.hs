module Forms.Games (gamesForm) where

import Data.Char


import Animations
import ScreenControl
import User

import Forms.Default


gamesForm :: MenuForm
gamesForm _ (FormClose  ,       _) = defFormClose
gamesForm n (FormErr msg, appData) = defFormErr   (gamesForm n) appData msg
gamesForm n (FormClear  , appData) = defFormClear (gamesForm n) appData

gamesForm n (FormNew, appData@(_, user, _)) = do
  putStr toMain
  putStr . inMain True $ titleText "[Games]"

  let
    menuOptions = zip [0..] [
        (centerMain "Game 1", gamesForm 0 =<< game1Form (FormClear, appData))
      , (centerMain "Quite", pure (FormClear, appData))
      ]

  mapM_ (printMenuSelected n) menuOptions

  putStr . inMain True $ "Id:   "  <> (show $ uid user)
  putStr . inMain True $ "User: "  <> ulogin user
  putStr . inMain True $ "Age:  "  <> (show $ uage user)
  putStr . inMain True $ "Bio:  "  <> ubio user

  putStr toError
  controlKey <- getKeyAnim gamesAnim

  case map toUpper controlKey of
    -- Menu control
    "\ESC[A" -> gamesForm (n - 1) (FormClear, appData)
    "\ESC[B" -> gamesForm (n + 1) (FormClear, appData)
    "\n"     -> snd . snd $ menuOptions !! n

    key      -> gamesForm n ((FormErr $ "No command" <> show key), appData)



game1Form :: Form
game1Form (FormClose  ,       _) = defFormClose
game1Form (FormErr msg, appData) = defFormErr   game1Form appData msg
game1Form (FormClear  , appData) = defFormClear game1Form appData

game1Form (FormNew, (a, _, b)) = do
  putStr toSide

  msg <- getLine

  let
    appData' = (a, User 0 msg 666 "In Game1", b)

  pure ((FormErr msg), appData')
