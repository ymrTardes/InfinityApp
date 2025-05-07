module Forms.ChatForm (chatForm) where

import System.Console.ANSI
import Data.Char

import User
import Config
import Control.Monad

chatForm :: ([User], User) -> IO MenuOption
chatForm appData@(accountList, _) = do
  putStr "Message (or :q): "
  messageData <- getLine

  -- Remove entereted maessage/command
  cursorUp 1
  clearLine

  if and (zipWith (==) ":q" messageData) && length messageData == 2 then do
    writeFile usersPath $ prepareUsers accountList
    pure MenuClose

  else do
    (accountList', user') <- commandRender (words messageData) appData
    chatForm (accountList', user')


commandRender :: [String] -> ([User], User) -> IO ([User], User)
commandRender [] appData = pure appData

commandRender (":b":args) (accountList, user) = do
  successText "Bio updated"
  let
    user' = user {ubio = unwords args}
    bacc  = break (==user) accountList
    accountList' = fst bacc <> [user'] <> (drop 1 $ snd bacc)

  pure (accountList', user')

commandRender (cmd:args) (accountList,user) = do
  case cmd of
    -- Info
    ":h" -> mapM_ putStrLn showHelp
    ":l" -> mapM_ (putStrLn . show) $ doList accountList args

    ":i" -> putStrLn $ show user

    -- Actions
    ":r" -> do
              putStr $ concat [ ulogin user, " [R]> "]
              case doReverse args of
                Nothing  -> errorText "Command error :r <str>"
                Just res -> putStrLn res
    ":c" -> do
              putStr $ concat [ ulogin user, " [C]> "]
              case doCalc args of
                Nothing  -> errorText "Command error :c <num> <num>"
                Just res -> putStrLn res

    -- Just message
    _    -> putStrLn $ ulogin user ++ "> " ++ unwords (cmd:args)

  pure (accountList, user)

showHelp :: [String]
showHelp =  [ " [HELP]         "
            , ":h for help"
            , ":a for show chat"
            , ":i for info user"
            , ":q for exit"
            , ":r <msg> to reverse"
            , ":c <a> <b> to a + b"
            , ":l <start letters login> to search"
            ]


prepareUsers :: [User] -> String
prepareUsers  = concat . map (\a -> concat [ulogin a, ";", show $ uage a, ";", ubio a, "\n"] )

doReverse :: [String] -> Maybe String
doReverse [] = Nothing
doReverse x  = pure $ (reverse . unwords) x


doCalc :: [String] -> Maybe String
doCalc []      = Nothing
doCalc (_:[])  = Nothing
doCalc (a:b:_) = do
  guard $ and $ map (isDigit) a
  guard $ and $ map (isDigit) b
  pure $ show @Int $ read a + read b


doList :: [User] -> [String] -> [User]
doList accountList [] = accountList
doList accountList (stName:_) = filter (and . zipWith (==) stName . ulogin) $ accountList
