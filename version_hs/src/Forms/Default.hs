module Forms.Default (
    MenuElement
  , AppData
  , Form
  , FormData
  , MenuForm
  , FormType(..)
  , printMenuSelected

  , defFormClose
  , defFormErr
  , defFormClear
) where

import ScreenControl
import System.Console.ANSI


import User


data FormType = FormNew | FormClear | FormErr String | FormClose
  deriving (Eq, Show)

type AppData = ([User], User, [String])

type FormData = (FormType, AppData)
type Form     = FormData -> IO FormData
type MenuForm = Int -> Form

type MenuElement = (Int, (String, IO FormData))

printMenuSelected :: Int -> MenuElement -> IO ()
printMenuSelected n (i, (s, _)) = do
  putStr . inMain True $
    if i == n then colorPrint Background Blue s
    else s


defFormClose :: IO FormData
defFormClose = pure (FormClose, ([], User 0 "" 0 "", []))

defFormErr :: Form -> AppData -> String -> IO FormData
defFormErr form appData msg = do
  size <- tSize
  mapM_ putStr $ clearAll size
  putStr $ inError msg
  form (FormNew, appData)

defFormClear :: Form -> AppData -> IO FormData
defFormClear form appData = do
  size <- tSize
  mapM_ putStr $ clearAll size
  form (FormNew, appData)
