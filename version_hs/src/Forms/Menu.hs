module Forms.Menu (menuForm) where

import System.IO
import System.Console.ANSI
import Data.Char

import Config

import Forms.Register
import Forms.Login

type MenuElement = (Int, (String, IO ()))

menuForm :: MenuType -> Int -> AppData -> IO ()
menuForm cls (-1) appData = menuForm cls 0 appData
menuForm cls 3    appData = menuForm cls 2 appData

-- Close menu
menuForm MenuClose _ _ = pure ()
-- Error menu
menuForm (MenuErr msg) n appData  = do
                                      clearMenu
                                      putStr "Error: "
                                      putStrLn $ errorText msg
                                      menuForm MenuNew n appData
-- Update menu
menuForm MenuClear n appData      = do
                                      clearMenu
                                      putStrLn ""
                                      menuForm MenuNew n appData
-- New menu
menuForm MenuNew n appData        = do
  putStrLn $ titleText " [APP]          "

  let
    runFormR = runForm appData registerForm
    runFormL = runForm appData loginForm

    menu_options = [
        ("> (R)egister    ", runFormR)
      , ("> (L)ogin       ", runFormL)
      , ("> (Q)ite        ", pure ())
      ]

    menu_list = zip [0..] menu_options

  -- Show Menu:
  mapM_ (printMenuSelected n) menu_list
  clearLine
  putStr "> "

  hSetBuffering stdin NoBuffering
  controlKey <- getKey
  hSetBuffering stdin LineBuffering

  case map toUpper controlKey of
    -- Menu control
    "A[\ESC" -> menuForm MenuClear (n - 1) appData
    "B[\ESC" -> menuForm MenuClear (n + 1) appData
    "\n"     -> snd $ menu_options !! n

    -- Hotkeys
    "R"      -> runFormR
    "L"      -> runFormL
    "Q"      -> putStrLn ""

    _        -> menuForm (MenuErr "No command") n appData


clearMenu :: IO ()
clearMenu = do
  cursorUp 5
  setCursorColumn 0
  clearLine


printMenuSelected :: Int -> MenuElement -> IO ()
printMenuSelected n (i, (s, _)) = do
      clearLine
      if i == n then
        putStrLn $ colorPrint Background Blue s
      else
        putStrLn s


runForm :: AppData -> Form -> IO ()
runForm appData form = do
      putStrLn ""
      e <- form appData
      putStrLn "\n"
      menuForm e 0 appData 

