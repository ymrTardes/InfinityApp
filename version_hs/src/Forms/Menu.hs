module Forms.Menu (menuForm) where

import System.Console.ANSI
import Data.Char

import Config
import ScreenControl
import Animations

import Forms.Register
import Forms.Login
import Forms.Games

type MenuElement = (Int, (String, IO FormType))

menuForm :: Int -> Form
menuForm (-1) cls appData = menuForm 0 cls appData

menuForm 4    cls appData = menuForm 3 cls appData

menuForm _ FormClose _ = pure FormClose

menuForm n (FormErr msg) appData = do
  size <- tSize
  mapM_ putStr $ clearAll size
  printError msg
  menuForm n FormNew appData

menuForm n FormClear appData  = do
  size <- tSize
  mapM_ putStr $ clearAll size
  menuForm n FormNew appData

menuForm selectedIndex FormNew appData        = do
  putStr toMain
  printMain True $ titleText "[MENU]"

  let
    runFormR = runForm appData registerForm
    runFormL = runForm appData loginForm
    runFormG = runForm appData gamesForm

    menu_options = [
        (centerMain "Register (R)", runFormR)
      , (centerMain "Login    (L)", runFormL)
      , (centerMain "Games    (G)", runFormG)
      , (centerMain "Qite     (Q)", pure FormClose)
      ]

    menu_list = zip [0..] menu_options

  -- Show Menu:
  mapM_ (printMenuSelected selectedIndex) menu_list
  putStr toError

  controlKey <- waitingKey menuAnim

  case map toUpper controlKey of
    -- Menu control
    "\ESC[A" -> menuForm (selectedIndex - 1) FormClear appData
    "\ESC[B" -> menuForm (selectedIndex + 1) FormClear appData
    "\n"     -> snd $ menu_options !! selectedIndex

    -- Hotkeys
    "R"      -> runFormR
    "L"      -> runFormL
    "G"      -> runFormG
    "Q"      -> pure FormClose

    d        -> menuForm selectedIndex (FormErr $ "No command" <> show d) appData

runForm :: AppData -> Form -> IO FormType
runForm appData form = do
      formType <- form FormClear appData
      menuForm 0 formType appData 

printMenuSelected :: Int -> MenuElement -> IO ()
printMenuSelected n (i, (s, _)) = do
      printMain True $
        if i == n then colorPrint Background Blue s
        else s

