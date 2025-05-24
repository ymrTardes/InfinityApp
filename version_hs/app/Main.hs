module Main(main) where

import System.Console.ANSI
import System.IO
import Control.Exception
import Database.SQLite.Simple


import User
import Config
import ScreenControl (drawAll)

import Forms.Default

import Forms.Menu

main :: IO ()
main = do
  hSetBuffering stdout NoBuffering

  setTitle "InfinityApp"

  users <- withConnection dbPath $ \conn -> do
    query_ @User conn "select * from users"

  let
    appData = (users, defUser, [])

  bracket_
    useAlternateScreenBuffer
    useNormalScreenBuffer
    $ do
      drawAll
      _ <- menuForm 0 (FormClear, appData)
      pure ()