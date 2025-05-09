module Forms.Chat (chatForm) where

import System.Console.ANSI
import Data.Char

import User
import Config
import Control.Monad

chatForm :: Form
chatForm appData@(accountList, _) = do
  putStr "Message (or :q): "
  messageData <- getLine

  -- Remove entereted maessage/command
  cursorUp 1
  clearLine

  if messageData == ":q" then do
    writeFile usersPath $ unlines $ map userToStr accountList
    pure MenuClose
  else do
    appData' <- commandRender (words messageData) appData
    chatForm appData'


commandRender :: [String] -> AppData -> IO AppData
commandRender [] appData = pure appData

commandRender (":b":args) (accountList, user) = do
  putStrLn $ successText "Bio updated"
  let
    user' = user {ubio = unwords args}
    bacc  = break (==user) accountList
    accountList' = fst bacc <> [user'] <> (drop 1 $ snd bacc)
  pure (accountList', user')

-- No changed data
commandRender (cmd:args) (accountList, user) = do
  case cmd of
    -- Info
    ":h" -> mapM_ putStrLn showHelp
    ":l" -> do
      let res = doList accountList args
      putStrLn . successText $ "Complited search: " <> show (length res)
      mapM_ (putStrLn . show) $ res
    ":i" -> putStrLn $ show user

    -- Actions
    ":r" -> runAction user (doReverse args) "R" "Command error :r <str>"
    ":c" -> runAction user (doCalc args)    "C" "Command error :c <num> <num>"

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


runAction :: User -> Maybe String -> String -> String -> IO ()
runAction user fRes logo errMsg = do
              putStr $ concat [ ulogin user, " [", logo, "]> "]
              case fRes of
                Nothing  -> putStrLn $ errorText errMsg
                Just res -> putStrLn res


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
