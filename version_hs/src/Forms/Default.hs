module Forms.Default (
  defFormClose, defFormErr, defFormClear
) where

import Config
import ScreenControl


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
