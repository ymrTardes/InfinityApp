module Config (
    FormType (..)
  , AppData
  , Form

  , dbPath
  )
where

import User

type Form = FormType -> AppData -> IO FormType

type AppData = ([User], User, [String])

data FormType = FormNew | FormClear | FormErr String | FormClose
  deriving (Eq, Show)

dbPath :: FilePath
dbPath  = "../infinityApp.db"
