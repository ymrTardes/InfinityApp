module Config (
    MenuOption (..)

  , usersPath
  , chatPath

  , getKey
  , colorPrint
  , titleText
  , errorText
  , successText

  , mSplit

  , validateLogin
  )
where


import System.IO
import System.Console.ANSI
import Data.Char (isLetter)


data MenuOption = MenuClear | MenuNew | MenuErr String | MenuClose
  deriving (Eq, Show)

usersPath :: FilePath
chatPath  :: FilePath
usersPath  = "data/users"
chatPath   = "data/chat"

mSplit :: Eq a => a -> [a] -> [[a]]
mSplit _  [] = [[]]
mSplit c arr = takeWhile (/=c) arr : mSplit c (drop 1 $ dropWhile (/= c) arr)

getKey :: IO [Char]
getKey = reverse <$> getKey' ""
  where 
    getKey' chars = do
      char <- getChar
      more <- hReady stdin
      (if more then getKey' else return) (char:chars)

colorPrint :: ConsoleLayer -> Color -> String -> IO ()
colorPrint l c msg = do
  setSGR [SetColor l Vivid c]
  putStr msg
  setSGR [Reset]
  putStrLn ""

titleText, errorText, successText :: String -> IO ()
titleText   = colorPrint Background Magenta
errorText   = colorPrint Foreground Red
successText = colorPrint Foreground Green

-- Usually

validateLogin :: String -> Bool
validateLogin  = and . map isLetter