module ScreenControl (
  -- IO
    waitingKey
  , tSize, drawAll

  -- Strings
  --   SetPos
  , toError, toMain, toSide
  --   Pos for putStr
  , inError, inMain, inSide, inSideDown
  --   Clearing
  , clearError, clearMain, clearSide, clearAll
  --   Coloring
  , colorPrint, errorText, successText, titleText, centerMain
) where

import System.Console.ANSI
import System.IO
import Control.Concurrent
import Control.Monad
import Data.Time.Clock.System
import Data.Maybe (fromMaybe)


tSize :: IO (Int, Int)
tSize = do
  size <- getTerminalSize
  pure $ fromMaybe (0,0) size


drawAll :: IO ()
drawAll = do
  hideCursor
  (y,x) <- tSize
  
  setCursorPosition 0 0

  putStrLn $ concat ["+", replicate (x - 2) '-', "+"]
  putStrLn $ concat ["|", replicate (x - 2) ' ', "|"]
  putStrLn $ concat ["+", replicate (x - 2) '-', "+"]
  replicateM_ (y - 5) $
    putStrLn $ concat ["|", replicate 32 ' ' , "|" ,  replicate (x - 35) ' ', "|"]
  putStrLn $ concat ["+", replicate (x - 2) '-', "+"]

  showCursor

waitingKey :: (SystemTime -> [String]) -> IO String
waitingKey anim = do
  hideCursor
  hSetBuffering stdin NoBuffering
  res <- waitingKey' anim
  hSetBuffering stdin LineBuffering
  showCursor
  pure res

waitingKey' :: (SystemTime -> [String]) -> IO String
waitingKey' anim = do
  keyDown <- hReady stdin

  if keyDown then do
    char <- getChar
    getMore [char]

  else do
    time <- getSystemTime

    -- Run animation
    threadDelay $ 5 * 1000
    mapM_ (putStr . inSide True) $ anim time

    setCursorPosition 1 2
    waitingKey' anim

getMore :: String -> IO String
getMore chars = do
  more <- hReady stdin
  if more then do
    char <- getChar
    getMore (char:chars)
  else 
    return $ reverse chars


-- SetPos
toError, toMain, toSide :: String
toError = setCursorPositionCode 1 2
toMain  = setCursorPositionCode 3 2
toSide  = setCursorPositionCode 3 35


-- Pos for putStr
inError :: String -> String
inError msg = concat [
    toError
  , "Error: "
  , errorText msg
  ]

inMain :: Bool -> String -> String
inMain nl str = concat [
    setCursorColumnCode 2
  , str
  , if nl then cursorDownLineCode 1 else ""
  ]

inSide :: Bool -> String -> String
inSide nl str = concat [
    setCursorColumnCode 35
  , str
  , if nl then cursorDownCode 1 else ""
  ]

inSideDown :: (Int, Int) -> String -> String
inSideDown (y,_) str = concat [
    setCursorPositionCode (y - 3) 35
  , str
  ]


-- Clearing
clearAll :: (Int, Int) -> [String]
clearAll a =
     [hideCursorCode]
  <> clearError a
  <> clearMain a
  <> clearSide a
  <> [showCursorCode]

clearError :: (Int, Int) -> [String]
clearError (_, x) = toError : [cls]
  where
    cls = replicate (x - 4) ' '


clearMain :: (Int, Int) -> [String]
clearMain (y, _) = toMain : cls
  where
    cls = replicate (y - 5) $ concat [
              concat [replicate 30 ' ']
            , cursorDownCode 1
            , setCursorColumnCode 2
            ]

clearSide :: (Int, Int) -> [String]
clearSide (y,x) = toSide : cls
  where
    cls = replicate (y - 5) $ concat [
              concat [replicate (x - 37) ' ']
            , cursorDownCode 1
            , setCursorColumnCode 35
            ]


-- Coloring
colorPrint :: ConsoleLayer -> Color -> String -> String
colorPrint l c msg =
  setSGRCode [SetColor l Vivid c] <> msg <> setSGRCode [Reset]

errorText, successText, titleText :: String -> String
errorText   = colorPrint Foreground     Red
successText = colorPrint Foreground   Green
titleText   = colorPrint Background Magenta . centerMain

centerMain :: String -> String
centerMain str = concat [l, str, r]
  where
      space = 30 - (length str)
      cor = space `mod` 2
      l = replicate (space `div` 2) ' '
      r = replicate ((space `div` 2) + cor) ' '