module User (
    User(..)
  , usersToStr
  , strToUsers
  , defUser
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

usersToStr :: [User] -> [String]
usersToStr  = map (\a -> concat [ulogin a, ";", show $ uage a, ";", ubio a] )

strToUsers :: [String] -> [User]
strToUsers = map (\usr -> User 0 (uSplit usr !! 0) (read $ uSplit usr !! 1) (uSplit usr !! 2))
  where
    uSplit = mSplit ';'

mSplit :: Eq a => a -> [a] -> [[a]]
mSplit _  [] = [[]]
mSplit c arr = takeWhile (/=c) arr : mSplit c (drop 1 $ dropWhile (/= c) arr)