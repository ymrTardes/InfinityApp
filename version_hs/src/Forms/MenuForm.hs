module Forms.MenuForm (menuForm) where

import System.IO
import System.Console.ANSI
import Data.Char

import User
import Config

import Forms.RegisterForm
import Forms.LoginForm

type MenuElement = (Int, (String, IO ()))

menuForm :: MenuOption -> Int -> [User] -> IO ()
menuForm cls (-1) u = menuForm cls 0 u
menuForm cls 3    u = menuForm cls 2 u
menuForm MenuClose _ _ = pure ()
menuForm (MenuErr msg) n users  = do
                                    clearMenu
                                    putStr "Error: "
                                    errorText msg
                                    menuForm MenuNew n users
menuForm MenuClear n users      = do
                                    clearMenu
                                    putStrLn ""
                                    menuForm MenuNew n users
menuForm MenuNew n users = do
  hSetBuffering stdin NoBuffering
  titleText " [APP]          "

  let
    runFormR = runForm users registerForm
    runFormL = runForm users loginForm

    menu_list = zip [0..] [
        ("> (R)egister    ", runFormR)
      , ("> (L)ogin       ", runFormL)
      , ("> (Q)ite        ", pure ())
      ]

  -- Show Menu:
  mapM_ (printMenuSelected n) menu_list
  clearLine
  putStr "> "

  controlKey <- getKey

  case map toUpper controlKey of
    -- Menu control
    "\ESC[A" -> menuForm MenuClear (n - 1) users
    "\ESC[B" -> menuForm MenuClear (n + 1) users
    "\n"     -> snd $ (snd $ unzip menu_list) !! n

    -- Hotkeys
    "R"      -> runFormR
    "L"      -> runFormL
    "Q"      -> putStrLn ""

    _        -> menuForm (MenuErr "No command") n users



printMenuSelected :: Int -> MenuElement -> IO ()
printMenuSelected n (i, (s, _)) = do
      clearLine
      if i == n then
        colorPrint Background Blue s
      else
        putStrLn s


runForm :: [User] -> ([User] -> IO MenuOption) -> IO ()
runForm users form = do
      hSetBuffering stdin LineBuffering
      putStrLn ""
      e <- form users
      putStrLn "\n"
      menuForm e 0 users 


clearMenu :: IO ()
clearMenu = do
  cursorUp 5
  setCursorColumn 0
  clearLine