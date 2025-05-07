module User (
    User(..)
  , prepareUsers
  )
where

import Database.SQLite.Simple.FromRow

data User = User {
    uid    :: Int
  , ulogin :: String
  , uage   :: Int
  , ubio   :: String
  }
  deriving (Show, Eq)


instance FromRow User where
  fromRow = User <$> field <*> field <*> field <*> field


prepareUsers :: [User] -> String
prepareUsers  = concat . map (\a -> concat [ulogin a, ";", show $ uage a, ";", ubio a, "\n"] )