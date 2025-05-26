module Forms.Menu (menuForm) where

import Data.Char

import ScreenControl
import Animations

import Forms.Default

import Forms.Games
import Forms.Register
import Forms.Login


menuForm :: MenuForm
menuForm _ (FormClose  ,       _) = defFormClose
menuForm n (FormErr msg, appData) = defFormErr   (menuForm n) appData msg
menuForm n (FormClear  , appData) = defFormClear (menuForm n) appData

menuForm (-1) appData = menuForm 0 appData
menuForm 4    appData = menuForm 3 appData

menuForm selectedIndex (FormNew, appData) = do
  putStr toMain
  putStr . inMain True $ titleText "[MENU]"

  let
    menuOptions = zip [0..] [
        (centerMain "Register (R)", menuForm 0 =<< registerForm  (FormClear, appData))
      , (centerMain "Login    (L)", menuForm 0 =<< loginForm     (FormClear, appData))
      , (centerMain "Games    (G)", menuForm 0 =<< (gamesForm 0) (FormClear, appData))
      , (centerMain "Qite     (Q)", pure (FormClose, appData))
      ]

  -- Show Menu:
  mapM_ (putStr . colorMenuSelected selectedIndex) menuOptions
  putStr toError

  controlKey <- getKeyAnim menuAnim

  case map toUpper controlKey of
    -- Menu control
    "\ESC[A" -> menuForm (selectedIndex - 1) (FormClear, appData)
    "\ESC[B" -> menuForm (selectedIndex + 1) (FormClear, appData)
    "\n"     -> snd . snd $ menuOptions !! selectedIndex

    -- Hotkeys
    "R"      -> menuForm 0 =<< registerForm  (FormClear, appData)
    "L"      -> menuForm 0 =<< loginForm     (FormClear, appData)
    "G"      -> menuForm 0 =<< (gamesForm 0) (FormClear, appData)
    "Q"      -> pure (FormClose, appData)

    key      -> menuForm selectedIndex ((FormErr $ "No command" <> show key), appData)

