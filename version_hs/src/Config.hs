module Config (
    MenuOption (..)
  , AppData
  , Form

  , usersPath
  , chatPath

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


data MenuOption = MenuClear | MenuNew | MenuErr String | MenuClose
  deriving (Eq, Show)

type AppData = ([User], User)
type Form = AppData -> IO MenuOption

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

colorPrint :: ConsoleLayer -> Color -> String -> String
colorPrint l c msg =
  setSGRCode [SetColor l Vivid c] <> msg <> setSGRCode [Reset]

titleText, errorText, successText :: String -> String
titleText   = colorPrint Background Magenta
errorText   = colorPrint Foreground     Red
successText = colorPrint Foreground   Green
