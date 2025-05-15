module Config (
    FormType (..)
  , AppData
  , Form

  , usersPath
  , chatPath

  , formError
  , formClear
  , tSize

  , colorPrint
  , errorText
  , successText

  , printMain
  , printSecond

  , titleText
  , centerMain
  )
where

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

printMain :: String -> IO ()
printMain str = do
  cursorForward 2
  putStr str
  cursorDownLine 1

printSecond :: String -> IO ()
printSecond str = do
  cursorForward 36
  putStr str
  cursorDownLine 1


formError :: String -> IO ()
formError msg = do
  setCursorPosition 0 0
  clearScreen
  drawAll
  setCursorPosition 1 2
  putStr "Error: "
  putStrLn $ errorText msg

tSize :: IO (Int, Int)
tSize = do
  size' <- getTerminalSize
  pure $ fromMaybe (0,0) size'

formClear :: IO ()
formClear = do
  setCursorPosition 0 0
  clearScreen
  drawAll
  setCursorPosition 1 1
  putStrLn ""

drawAll :: IO ()
drawAll = do
  (y,x) <- tSize
  putStrLn $ replicate x '='
  replicateM_ (y - 3) $
    putStrLn $ concat ["|", replicate 32 ' ' , "|" ,  replicate (x - 35) ' ', "|"]
  putStrLn $ replicate x '='


colorPrint :: ConsoleLayer -> Color -> String -> String
colorPrint l c msg =
  setSGRCode [SetColor l Vivid c] <> msg <> setSGRCode [Reset]

errorText, successText :: String -> String
errorText   = colorPrint Foreground     Red
successText = colorPrint Foreground   Green

titleText :: String  -> String
titleText str = colorPrint Background Magenta $ centerMain str

centerMain :: String -> String
centerMain str = concat [l, str, r]
  where
      space = 30 - (length str)
      cor = space `mod` 2
      l = replicate (space `div` 2) ' '
      r = replicate ((space `div` 2) + cor) ' '
