module Forms.Menu (menuForm) where

import System.IO
import System.Console.ANSI
import Data.Char

import Config

import Forms.Register
import Forms.Login

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
  putStrLn $ titleText " [APP]          "

  let
    runFormR = runForm appData registerForm
    runFormL = runForm appData loginForm

    menu_options = [
        ("> (R)egister    ", runFormR)
      , ("> (L)ogin       ", runFormL)
      , ("> (Q)ite        ", pure FormClose)
      ]

    menu_list = zip [0..] menu_options

  -- Show Menu:
  mapM_ (printMenuSelected selectedIndex) menu_list
  clearLine
  putStr "> "

  hSetBuffering stdin NoBuffering
  controlKey <- getKey
  hSetBuffering stdin LineBuffering

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


printMenuSelected :: Int -> MenuElement -> IO ()
printMenuSelected n (i, (s, _)) = do
      clearLine
      putStrLn $
        if i == n then colorPrint Background Blue s
        else s


runForm :: AppData -> Form -> IO FormType
runForm appData form = do
      putStrLn ""
      formType <- form FormClear appData
      putStrLn "\n"
      menuForm 0 formType appData 

