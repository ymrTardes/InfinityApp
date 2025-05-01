module User (
  User(..)
  )
where

data User = User {
    ulogin :: String
  , uage   :: Int
  , ubio   :: String
  }
  deriving (Show, Eq)