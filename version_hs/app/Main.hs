module Main(main) where

import System.IO

-- import Database.SQLite.Simple
import System.Console.ANSI


import User
import Config
import Forms.Menu

import Control.Exception

main :: IO ()
main = do
  hSetBuffering stdout NoBuffering

  -- DB
  -- conn <- open "../infinityApp.db"
  -- execute conn "INSERT INTO users (name, age, bio) VALUES (?, ?, ?)"
  --   ("UU" :: String, 24 :: Int, "ds" :: String)
  -- usersDB <- query_ conn "SELECT * from users" :: IO [User]
  -- mapM_ print usersDB
  -- close conn
  -- /DB

  usersRaw <- readFile' usersPath
  let
    users = map strToUser  $ filter (/= []) $ lines usersRaw


  bracket_
    useAlternateScreenBuffer
    useNormalScreenBuffer 
    $ do
      _ <- menuForm 0 FormClear (users, defUser)
      pure ()

  -- catch (menuForm 0 FormClear (users, defUser) >> pure ()) (\e -> print (e :: AsyncException))