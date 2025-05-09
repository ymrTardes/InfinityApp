module User (
    User(..)
  , userToStr
  , strToUser
  , defUser

  , splitOn
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


defUser :: User
defUser = User 0 "" 0 ""

userToStr :: User -> String
userToStr a = concat [ulogin a, ";", show $ uage a, ";", ubio a]

strToUser :: String -> User
strToUser str = User 0 (usr !! 0) (read $ usr !! 1) (usr !! 2)
  where
      usr = splitOn ';' str

splitOn :: Char -> String -> [String]
splitOn _  [] = [[]]
splitOn c arr = a : splitOn c (drop 1 $ b)
  where
    (a, b) = break (==c) arr