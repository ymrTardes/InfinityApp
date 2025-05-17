module User (
    User(..)
  , userToRow
  , defUser

  , splitOn
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

userToRow :: User -> (String, Int, String)
userToRow a = (ulogin a, uage a, ubio a)

splitOn :: Char -> String -> [String]
splitOn _  [] = [[]]
splitOn c arr = a : splitOn c (drop 1 $ b)
  where
    (a, b) = break (==c) arr