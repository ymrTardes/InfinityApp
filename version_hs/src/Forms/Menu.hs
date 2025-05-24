module Forms.Menu (menuForm) where

import Data.Char


import ScreenControl
import Animations

import Forms.Default

import Forms.Games
import Forms.Register
import Forms.Login

menuForm :: MenuForm
menuForm _ FormClose           _ = defFormClose
menuForm n (FormErr msg) appData = defFormErr   (menuForm n) appData msg
menuForm n FormClear     appData = defFormClear (menuForm n) appData

menuForm (-1) cls appData = menuForm 0 cls appData
menuForm 4    cls appData = menuForm 3 cls appData

menuForm selectedIndex FormNew appData        = do
  putStr toMain
  putStr . inMain True $ titleText "[MENU]"

  let
    menuOptions = zip [0..] [
        (centerMain "Register (R)", runForm menuForm appData registerForm)
      , (centerMain "Login    (L)", runForm menuForm appData loginForm)
      , (centerMain "Games    (G)", runForm menuForm appData $ gamesForm 0)
      , (centerMain "Qite     (Q)", pure FormClose)
      ]

  -- Show Menu:
  mapM_ (printMenuSelected selectedIndex) menuOptions
  putStr toError

  controlKey <- getKeyAnim menuAnim

  case map toUpper controlKey of
    -- Menu control
    "\ESC[A" -> menuForm (selectedIndex - 1) FormClear appData
    "\ESC[B" -> menuForm (selectedIndex + 1) FormClear appData
    "\n"     -> snd . snd $ menuOptions !! selectedIndex

    -- Hotkeys
    "R"      -> runForm menuForm appData registerForm
    "L"      -> runForm menuForm appData loginForm
    "G"      -> runForm menuForm appData $ gamesForm 0
    "Q"      -> pure FormClose

    key      -> menuForm selectedIndex (FormErr $ "No command" <> show key) appData

