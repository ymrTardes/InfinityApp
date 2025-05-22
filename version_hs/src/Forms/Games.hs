module Forms.Games (gamesForm) where

import Config
import Animations
import ScreenControl

import Forms

gamesForm :: Form
gamesForm FormClose            _ = defFormClose
gamesForm fd@(FormErr _) appData = defFormErr   gamesForm fd appData
gamesForm FormClear      appData = defFormClear gamesForm appData

gamesForm FormNew _ = do
  putStr toMain
  putStr . inMain True $ titleText "[Games]"

  putStr . inMain True $ "No games"

  _ <- waitingKey gamesAnim

  size <- tSize
  mapM_ putStr $ clearSide size
  pure FormNew