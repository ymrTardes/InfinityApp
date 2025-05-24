module Forms.Default (
    MenuElement
  , AppData
  , Form
  , MenuForm
  , FormType(..)
  , printMenuSelected
  , runForm

  , defFormClose
  , defFormErr
  , defFormClear
) where

import ScreenControl
import System.Console.ANSI


import User


type Form = FormType -> AppData -> IO FormType
type MenuForm = Int -> Form

type AppData = ([User], User, [String])

data FormType = FormNew | FormClear | FormErr String | FormClose
  deriving (Eq, Show)

type MenuElement = (Int, (String, IO FormType))


runForm :: MenuForm -> AppData -> Form -> IO FormType
runForm mform appData form = do
  formType <- form FormClear appData
  mform 0 formType appData 

printMenuSelected :: Int -> MenuElement -> IO ()
printMenuSelected n (i, (s, _)) = do
  putStr . inMain True $
    if i == n then colorPrint Background Blue s
    else s


defFormClose :: IO FormType
defFormClose = pure FormClose

defFormErr :: Form -> AppData -> String -> IO FormType
defFormErr form appData msg = do
  size <- tSize
  mapM_ putStr $ clearAll size
  putStr $ inError msg
  form FormNew appData

defFormClear :: Form -> AppData -> IO FormType
defFormClear form appData = do
  size <- tSize
  mapM_ putStr $ clearAll size
  form FormNew appData
