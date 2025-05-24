module User (
    User(..)
  , defUser
  )
where

import Database.SQLite.Simple


data User = User {
    uid    :: Int
  , ulogin :: String
  , uage   :: Int
  , ubio   :: String
  }
  deriving (Show, Eq)

instance FromRow User where
  fromRow = User <$> field <*> field <*> field <*> field

instance ToRow User where
  toRow (User _ name' age' bio') = toRow (name', age', bio')

defUser :: User
defUser = User 0 "" 0 ""