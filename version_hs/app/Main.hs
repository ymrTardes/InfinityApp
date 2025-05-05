module Main(main) where

import System.IO

import User
import Config
import Forms


main :: IO ()
main = do
  hSetBuffering stdout NoBuffering
  
  usersS <- readFile usersPath
  let
    usersL = filter (/= []) $ lines usersS
    uSplit = mSplit ';'
    users  = map (\usr -> User (uSplit usr !! 0) (read $ uSplit usr !! 1) (uSplit usr !! 2)) usersL

  -- print usersL

  menuForm RNew 0 users