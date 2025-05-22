module Forms.Games (gamesForm) where

import Config
import Animations
import ScreenControl

import Forms.Default


gamesForm :: Form
gamesForm FormClose           _ = defFormClose
gamesForm (FormErr msg) appData = defFormErr   gamesForm appData msg
gamesForm FormClear     appData = defFormClear gamesForm appData

gamesForm FormNew _ = do
  putStr toMain
  putStr . inMain True $ titleText "[Games]"

  putStr . inMain True $ "No games"

  _ <- waitingKey gamesAnim

  size <- tSize
  mapM_ putStr $ clearSide size
  pure FormNew