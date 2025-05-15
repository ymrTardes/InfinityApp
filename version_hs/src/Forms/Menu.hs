module Forms.Menu (menuForm) where

import System.IO
import System.Console.ANSI
import Data.Char

import Config

import Forms.Register
import Forms.Login
import Control.Concurrent (threadDelay)

import Data.Time

type MenuElement = (Int, (String, IO FormType))

menuForm :: Int -> Form
menuForm (-1) cls appData = menuForm 0 cls appData
menuForm 3    cls appData = menuForm 2 cls appData

menuForm _ FormClose _ = pure FormClose
menuForm n (FormErr msg) appData  = do
                                      formError msg
                                      menuForm n FormNew appData
menuForm n FormClear appData  = do
                                  formClear
                                  menuForm n FormNew appData
menuForm selectedIndex FormNew appData        = do
  printMain $ titleText "[APP]"

  let
    runFormR = runForm appData registerForm
    runFormL = runForm appData loginForm

    menu_options = [
        (centerMain "(R)egister", runFormR)
      , (centerMain "(L)ogin"   , runFormL)
      , (centerMain "(Q)ite"    , pure FormClose)
      ]

    menu_list = zip [0..] menu_options

  -- Show Menu:
  mapM_ (printMenuSelected selectedIndex) menu_list

  cursorForward 2
  putStr "> "

  hideCursor
  hSetBuffering stdin NoBuffering
  controlKey <- waitingKey
  hSetBuffering stdin LineBuffering
  showCursor

  case map toUpper controlKey of
    -- Menu control
    "A[\ESC" -> menuForm (selectedIndex - 1) FormClear appData
    "B[\ESC" -> menuForm (selectedIndex + 1) FormClear appData
    "\n"     -> snd $ menu_options !! selectedIndex

    -- Hotkeys
    "R"      -> runFormR
    "L"      -> runFormL
    "Q"      -> pure FormClose

    _        -> menuForm selectedIndex (FormErr "No command") appData


waitingKey :: IO String
waitingKey = do
      more <- hReady stdin
      if more then do
        content <- getKey
        pure $ content
      else do
        miniAnim
        waitingKey

getKey :: IO String
getKey = getKey' ""
  where 
    getKey' chars = do
      char <- getChar
      more <- hReady stdin

      if more then 
        getKey' (char:chars) 
      else
        return (char:chars)

miniAnim :: IO ()
miniAnim = do
  threadDelay 100000
  saveCursor

  setCursorPosition 2 35
  time <- getCurrentTime
  putStr $ formatTime defaultTimeLocale "%a %b %e %H:%M:%S" time <> "       "

  setCursorPosition 3 35
  let 
    arr = ["|", "/", "-", "\\"]
    d = diffTimeToPicoseconds $ utctDayTime time
    r = fromInteger $ d `div` 100000000000 `mod` 4
  putStr . concat $ replicate 5 $ (arr !! r)

  restoreCursor
  threadDelay 0

printMenuSelected :: Int -> MenuElement -> IO ()
printMenuSelected n (i, (s, _)) = do
      printMain $
        if i == n then colorPrint Background Blue s
        else s


runForm :: AppData -> Form -> IO FormType
runForm appData form = do
      formType <- form FormClear appData
      putStrLn "\n"
      menuForm 0 formType appData 

