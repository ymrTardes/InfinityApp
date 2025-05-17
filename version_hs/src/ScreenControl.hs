module ScreenControl (
    waitingKey
  , tSize, drawAll
  , printError, printMain, printSide, printSideDown

  , toError, toMain, toSide
  , clearError, clearMain, clearSide, clearAll

  , colorPrint, errorText, successText, titleText, centerMain
) where

import System.Console.ANSI

import Data.Maybe (fromMaybe)
import Control.Monad
import System.IO
import Control.Concurrent
import Data.Time

waitingKey :: (UTCTime -> [String]) -> IO String
waitingKey anim = do
  hideCursor
  hSetBuffering stdin NoBuffering
  res <- waitingKey' anim
  hSetBuffering stdin LineBuffering
  showCursor

  pure res

waitingKey' :: (UTCTime -> [String]) -> IO String
waitingKey' anim = do
      more <- hReady stdin
      if more then do
        getKey' ""
      else do
        time <- getCurrentTime
        threadDelay $ 5 * 1000
        mapM_ (printSide True) $ anim time

        setCursorPosition 1 2
        waitingKey' anim
  where 
      getKey' chars = do
        char <- getChar
        more <- hReady stdin
        if more then
          getKey' (char:chars) 
        else 
          return $ reverse (char:chars)



toError, toMain, toSide :: String
toError = setCursorPositionCode 1 2
toMain  = setCursorPositionCode 3 2
toSide  = setCursorPositionCode 3 35

printMain :: Bool -> String -> IO ()
printMain nl str = do
  setCursorColumn 2
  putStr str
  if nl then cursorDownLine 1 else pure ()


printSide :: Bool -> String -> IO ()
printSide nl str = do
  setCursorColumn 35
  putStr str
  if nl then cursorDown 1 else pure ()

printError :: String -> IO ()
printError msg = do
  putStr toError
  putStr "Error: "
  putStr $ errorText msg

printSideDown :: String -> IO ()
printSideDown str = do
  (y,_) <- tSize
  setCursorPosition (y - 3) 35
  putStr str


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



clearAll :: (Int, Int) -> [String]
clearAll a = [hideCursorCode] <> clearError a <> clearMain a <> clearSide a <> [showCursorCode]

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