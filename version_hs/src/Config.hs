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
  , titleText
  , errorText
  , successText
  )
where

import System.IO
import System.Console.ANSI

import User



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

formError :: String -> IO ()
formError msg = do
  clearScreen
  setCursorPosition 0 0
  putStr "Error: "
  putStrLn $ errorText msg

formClear :: IO ()
formClear = do
  clearScreen
  setCursorPosition 0 0
  putStrLn ""


colorPrint :: ConsoleLayer -> Color -> String -> String
colorPrint l c msg =
  setSGRCode [SetColor l Vivid c] <> msg <> setSGRCode [Reset]

titleText, errorText, successText :: String -> String
titleText   = colorPrint Background Magenta
errorText   = colorPrint Foreground     Red
successText = colorPrint Foreground   Green
