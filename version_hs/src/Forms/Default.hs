module Forms.Default (
    MenuElement
  , FormType(..)
  , AppData(..)
  , FormData
  , Form
  , MenuForm

  , colorMenuSelected

  , defFormClose
  , defFormErr
  , defFormClear
) where

import ScreenControl
import System.Console.ANSI


import User


data FormType = FormNew | FormClear | FormErr String | FormClose
  deriving (Eq, Show)

data AppData = AppData {
    appUsersList :: [User]
  , appUser :: User
  , appChatHistory :: [String]
  }

type FormData = (FormType, AppData)
type Form     = FormData -> IO FormData
type MenuForm = Int -> Form

type MenuElement = (Int, (String, IO FormData))

colorMenuSelected :: Int -> MenuElement -> String
colorMenuSelected n (i, (s, _)) = inMain True $
  if i == n then
    colorPrint Background Blue s
  else s


defFormClose :: IO FormData
defFormClose = pure (FormClose, AppData [] defUser [])

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
