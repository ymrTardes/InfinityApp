module Main(main) where

import System.IO

import User
import Config
import Forms

import Database.SQLite.Simple


main :: IO ()
main = do
  hSetBuffering stdout NoBuffering

  -- DB
  conn <- open "../infinityApp.db"

  -- execute conn "INSERT INTO users (name, age, bio) VALUES (?, ?, ?)"
  --   ("UU" :: String, 24 :: Int, "ds" :: String)
  usersDB <- query_ conn "SELECT * from users" :: IO [User]
  mapM_ print usersDB
  close conn
  -- /DB

  usersRaw <- readFile' usersPath

  let
    users = strToUsers  $ filter (/= []) $ lines usersRaw

  putStrLn ""
  menuForm MenuNew 0 (users, defUser)