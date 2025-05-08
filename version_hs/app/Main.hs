module Main(main) where

import System.IO

import User
import Config
import Forms

import Database.SQLite.Simple


main :: IO ()
main = do

  -- SSS
  conn <- open "../infinityApp.db"

  -- execute conn "INSERT INTO users (name, age, bio) VALUES (?, ?, ?)"
  --   ("UU" :: String, 24 :: Int, "ds" :: String)
  r <- query_ conn "SELECT * from users" :: IO [User]
  mapM_ print r
  close conn
  -- SSS

  hSetBuffering stdout NoBuffering
  
  usersS <- readFile' usersPath
  let
    usersL = filter (/= []) $ lines usersS
    uSplit = mSplit ';'
    users  = map (\usr -> User 0 (uSplit usr !! 0) (read $ uSplit usr !! 1) (uSplit usr !! 2)) usersL

  -- print usersL

  putStrLn ""
  menuForm MenuNew 0 (users, defUser)