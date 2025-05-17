module Main(main) where

import System.IO

import Database.SQLite.Simple
import System.Console.ANSI


import User
import Config
import Forms.Menu

import Control.Exception
import ScreenControl (drawAll)

main :: IO ()
main = do
  hSetBuffering stdout NoBuffering
  setTitle "InfinityApp"

  -- conn <- open dbPath
  -- users <- query_ conn "select * from users" :: IO [User]
  -- close conn

  users <- withConnection dbPath $ \conn -> do
    query_ conn "select * from users" :: IO [User]

  bracket_
    useAlternateScreenBuffer
    useNormalScreenBuffer 
    $ do
      drawAll
      _ <- menuForm 0 FormClear (users, defUser, [])
      pure ()

  -- catch (menuForm 0 FormClear (users, defUser) >> pure ()) (\e -> print (e :: AsyncException))