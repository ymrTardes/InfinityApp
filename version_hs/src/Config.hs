module Config (
    FormType (..)
  , AppData
  , Form

  , usersPath
  , chatPath

  , formError
  , formClear

  , getKey
  , colorPrint
  , errorText
  , successText

  , printInside

  , titleText
  , toCenter
  )
where

import System.IO
import System.Console.ANSI

import User
import Data.Maybe (fromMaybe)
import Control.Monad



type Form = FormType -> AppData -> IO FormType

type AppData = ([User], User)

data FormType = FormNew | FormClear | FormErr String | FormClose
  deriving (Eq, Show)


usersPath :: FilePath
chatPath  :: FilePath
usersPath  = "data/users"
chatPath   = "data/chat"

getKey :: IO [Char]
getKey = getKey' ""
  where 
    getKey' chars = do
      char <- getChar
      more <- hReady stdin
      (if more then getKey' else return) (char:chars)

printInside :: String -> IO ()
printInside str = do
  cursorForward 2
  putStrLn str

formError :: String -> IO ()
formError msg = do
  setCursorPosition 0 0
  clearScreen
  drawAll
  setCursorPosition 1 1
  putStr "Error: "
  putStrLn $ errorText msg

formClear :: IO ()
formClear = do
  setCursorPosition 0 0
  clearScreen
  drawAll
  setCursorPosition 1 1
  putStrLn ""

drawAll :: IO ()
drawAll = do
  size' <- getTerminalSize
  let
    (y,x) = fromMaybe (0,0) size'
  putStrLn $ replicate x '='
  replicateM_ (y - 3) $
    putStrLn $ concat ["|", replicate (x -2) ' ', "|"]
  putStrLn $ replicate x '='


colorPrint :: ConsoleLayer -> Color -> String -> String
colorPrint l c msg =
  setSGRCode [SetColor l Vivid c] <> msg <> setSGRCode [Reset]

errorText, successText :: String -> String
errorText   = colorPrint Foreground     Red
successText = colorPrint Foreground   Green

titleText :: String -> (Int, Int) -> String
titleText str size = colorPrint Background Magenta $ toCenter str size

toCenter :: String -> (Int, Int) -> String
toCenter str (_,x) = concat [l, str, r]
  where
      space = (x `div` 3) - (length str)
      cor = space `mod` 2
      l = replicate (space `div` 2) ' '
      r = replicate ((space `div` 2) + cor) ' '
