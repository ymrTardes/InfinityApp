module Forms.Games (gamesForm) where

import Config
import ScreenControl

import Animations

gamesForm :: Form
gamesForm FormClose _ = pure FormClose

gamesForm (FormErr msg) appData = do
  size <- tSize
  mapM_ putStr $ clearAll size
  printError msg
  gamesForm FormNew appData

gamesForm FormClear appData = do
  size <- tSize
  mapM_ putStr $ clearAll size
  gamesForm FormNew appData

gamesForm FormNew _ = do
  putStr toMain
  printMain True $ titleText "[Games]"

  printMain True "No games"

  _ <- waitingKey gamesAnim

  size <- tSize
  mapM_ putStr $ clearSide size
  pure FormNew