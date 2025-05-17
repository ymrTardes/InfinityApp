module Main(main) where

import System.IO

import Database.SQLite.Simple
import System.Console.ANSI


import User
import Config
import Forms.Menu

import Control.Exception

main :: IO ()
main = do
  hSetBuffering stdout NoBuffering
  setTitle "InfinityApp"

  conn <- open dbPath
  users <- query_ conn "select * from users" :: IO [User]
  close conn

  bracket_
    useAlternateScreenBuffer
    useNormalScreenBuffer 
    $ do
      _ <- menuForm 0 FormClear (users, defUser, [])
      pure ()

  -- catch (menuForm 0 FormClear (users, defUser) >> pure ()) (\e -> print (e :: AsyncException))