module Forms.Menu (menuForm) where

import System.Console.ANSI
import Data.Char


import Config
import ScreenControl
import Animations

import Forms.Default

import Forms.Games
import Forms.Register
import Forms.Login


type MenuElement = (Int, (String, IO FormType))

menuForm :: Int -> Form
menuForm _ FormClose           _ = defFormClose
menuForm n (FormErr msg) appData = defFormErr   (menuForm n) appData msg
menuForm n FormClear     appData = defFormClear (menuForm n) appData

menuForm (-1) cls appData = menuForm 0 cls appData
menuForm 4    cls appData = menuForm 3 cls appData

menuForm selectedIndex FormNew appData        = do
  putStr toMain
  putStr . inMain True $ titleText "[MENU]"

  let
    runFormR = runForm appData registerForm
    runFormL = runForm appData loginForm
    runFormG = runForm appData gamesForm

    menuOptions = [
        (centerMain "Register (R)", runFormR)
      , (centerMain "Login    (L)", runFormL)
      , (centerMain "Games    (G)", runFormG)
      , (centerMain "Qite     (Q)", pure FormClose)
      ]

    menuList = zip [0..] menuOptions

  -- Show Menu:
  mapM_ (printMenuSelected selectedIndex) menuList
  putStr toError

  controlKey <- waitingKey menuAnim

  case map toUpper controlKey of
    -- Menu control
    "\ESC[A" -> menuForm (selectedIndex - 1) FormClear appData
    "\ESC[B" -> menuForm (selectedIndex + 1) FormClear appData
    "\n"     -> snd $ menuOptions !! selectedIndex

    -- Hotkeys
    "R"      -> runFormR
    "L"      -> runFormL
    "G"      -> runFormG
    "Q"      -> pure FormClose

    key      -> menuForm selectedIndex (FormErr $ "No command" <> show key) appData



runForm :: AppData -> Form -> IO FormType
runForm appData form = do
  formType <- form FormClear appData
  menuForm 0 formType appData 

printMenuSelected :: Int -> MenuElement -> IO ()
printMenuSelected n (i, (s, _)) = do
  putStr . inMain True $
    if i == n then colorPrint Background Blue s
    else s

