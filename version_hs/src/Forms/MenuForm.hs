module Forms.MenuForm (menuForm) where

import System.IO
import System.Console.ANSI
import Data.Char

import User
import Config

import Forms.RegisterForm
import Forms.LoginForm

menuForm :: RenderOpt -> Int -> [User] -> IO ()
menuForm cls (-1) u = menuForm cls 0 u
menuForm cls 3    u = menuForm cls 2 u
menuForm cls n users = do
  hSetBuffering stdin NoBuffering

  case cls of
    RNew -> pure ()
    RCls -> do
              cursorUp 4
              setCursorColumn 0
    RErr msg -> do
                  cursorUp 6
                  setCursorColumn 0
                  clearLine
                  putStrLn ""
                  clearLine
                  errorText msg

  titleText " [APP]          "

  let 
    m = [
        (0, "> (R)egister    ")
      , (1, "> (L)ogin       ")
      , (2, "> (Q)ite        ")
      ]
  mapM_ (\(i, s) ->  if i == n then do colorPrint Background Blue s else putStrLn s) m

  clearLine
  putStr "> "
  typeApp <- getKey

  let
    rF = do
      putStrLn ""
      hSetBuffering stdin LineBuffering
      e <- registerForm users
      if e then menuForm RNew n users else pure ()
    lF = do
      putStrLn ""
      hSetBuffering stdin LineBuffering
      e <- loginForm users
      if e then menuForm RNew n users else pure ()

  case map toUpper typeApp of
    "\ESC[A" -> menuForm RCls (n - 1) users
    "\ESC[B" -> menuForm RCls (n + 1) users
    "\n"     -> case n of
                  0 -> rF
                  1 -> lF
                  _ -> pure ()
    "R"      -> rF
    "L"      -> lF
    "Q"      -> putStrLn ""
    _        -> do
                  menuForm (RErr "!!! No command !!!") 1 users