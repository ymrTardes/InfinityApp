module Config (
    RenderOpt (..)

  , usersPath
  , chatPath
  , showHelp

  , getKey
  , colorPrint
  , titleText
  , errorText
  , successText

  , mSplit

  , checkAge
  , validateLogin
  )
where


import System.IO
import System.Console.ANSI
import Data.Char (isLetter)

data RenderOpt = RCls | RNew | RErr String
  deriving Show

usersPath :: FilePath
chatPath  :: FilePath
usersPath  = "data/users"
chatPath   = "data/chat"

showHelp :: [String]
showHelp =  [ " [HELP]         "
            , ":h for help"
            , ":a for show chat"
            , ":i for info user"
            , ":q for exit"
            , ":r <msg> to reverse"
            , ":c <a> <b> to a + b"
            , ":l <login> to search"
            ]


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
checkAge :: Int -> Bool
checkAge x = (x > 17) && (x < 80)

validateLogin :: String -> Bool
validateLogin  = and . map isLetter