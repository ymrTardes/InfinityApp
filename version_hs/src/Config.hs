module Config (
    usersPath
  , chatPath
  , showHelp
  , getKey

  , checkAge
  , mSplit
  , doReverse
  , doCalc
  , doList
  )
where


import System.IO
import User


usersPath :: FilePath
chatPath  :: FilePath
usersPath  = "data/users"
chatPath   = "data/chat"

showHelp :: [String]
showHelp =  [ "--HELP----------"
            , ":h for help"
            , ":a for show chat"
            , ":i for info user"
            , ":q for exit"
            , ":r <msg> to reverse"
            , ":c <a> <b> to a + b"
            , ":l <login> to search"
            ]


mSplit :: Eq a => a -> [a] -> [[a]]
mSplit _  [] = [[]]
mSplit c arr = takeWhile (/=c) arr : mSplit c (drop 1 $ dropWhile (/= c) arr)

getKey :: IO [Char]
getKey = reverse <$> getKey' ""
  where 
    getKey' chars = do
      char <- getChar
      more <- hReady stdin
      (if more then getKey' else return) (char:chars)


-- Usually
checkAge :: Int -> Bool
checkAge x = (x > 17) && (x < 80)


-- Chat Commands
doReverse :: [String] -> [Char]
doReverse = (reverse . unwords . drop 1)

doCalc :: [String] -> String
doCalc msgCom = show @Int $ read (msgCom !! 1) + read (msgCom !! 2)

doList :: [User] -> [[Char]] -> [User]
doList accountList msgCom = if (length msgCom /= 1) then
            filter (and . zipWith (==) (msgCom !! 1) . ulogin) $ accountList
          else
            accountList