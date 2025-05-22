module Forms (
  defFormClose, defFormErr, defFormClear
) where

import Config
import ScreenControl

defFormClose :: IO FormType
defFormClose = pure FormClose

defFormErr :: Form -> FormType -> AppData -> IO FormType
defFormErr form (FormErr msg) appData = do
  size <- tSize
  mapM_ putStr $ clearAll size
  putStr $ inError msg
  form FormNew appData
defFormErr _ _ _ = error "defFormError"

defFormClear :: Form -> AppData -> IO FormType
defFormClear form appData = do
  size <- tSize
  mapM_ putStr $ clearAll size
  form FormNew appData
