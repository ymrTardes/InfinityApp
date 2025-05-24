module Forms.Games (gamesForm) where

import Data.Char


import Animations
import ScreenControl

import Forms.Default


gamesForm :: MenuForm
gamesForm _ FormClose           _ = defFormClose
gamesForm n (FormErr msg) appData = defFormErr   (gamesForm n) appData msg
gamesForm n FormClear     appData = defFormClear (gamesForm n) appData

gamesForm n FormNew appData = do
  putStr toMain
  putStr . inMain True $ titleText "[Games]"

  let
    menuOptions = zip [0..] [
        (centerMain "Game 1", runForm gamesForm appData game1Form)
      , (centerMain "Quite", pure FormClear)
      ]

  mapM_ (printMenuSelected n) menuOptions
  putStr toError

  controlKey <- getKeyAnim gamesAnim

  case map toUpper controlKey of
    -- Menu control
    "\ESC[A" -> gamesForm (n - 1) FormClear appData
    "\ESC[B" -> gamesForm (n + 1) FormClear appData
    "\n"     -> snd . snd $ menuOptions !! n

    key      -> gamesForm n (FormErr $ "No command" <> show key) appData



game1Form :: Form
game1Form FormClose           _ = defFormClose
game1Form (FormErr msg) appData = defFormErr   game1Form appData msg
game1Form FormClear     appData = defFormClear game1Form appData

game1Form FormNew _ = do
  putStr toSide

  msg <- getLine

  pure (FormErr msg)
