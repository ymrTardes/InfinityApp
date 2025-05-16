module Forms.Chat (chatForm) where

import System.Console.ANSI
import Data.Char

import User
import Config
import Control.Monad

chatForm :: Form
chatForm FormClose _ = pure FormClose
chatForm (FormErr msg) appData  = do
                                    formError msg
                                    chatForm FormNew appData
chatForm FormClear appData  = do
                                formClear
                                chatForm FormNew appData

chatForm FormNew appData@(accountList, _, chatBuf) = do
  setCursorPosition 3 0
  printMain $ titleText "[CHAT]"
  printMain $ successText "Online : 1"

  setCursorPosition 3 0
  mapM_ printSecond chatBuf

  printSecondDown "Message (or :q): "

  messageData <- getLine

  -- Remove entereted maessage/command
  (_,x) <- tSize
  printSecondDown $ concat [replicate (x - 37) ' ', "|"]

  if messageData == ":q" then do
    writeFile usersPath $ unlines $ map userToStr accountList
    pure FormClose
  else do
    chatForm FormNew $ commandRender (words messageData) appData



commandRender :: [String] -> AppData -> AppData

commandRender [] appData = appData

commandRender (":b":args) (accountList, user, chatBuf) = (accountList', user', chatBuf')
  where
    user' = user {ubio = unwords args}
    bacc  = break (==user) accountList
    accountList' = fst bacc <> [user'] <> (drop 1 $ snd bacc)
    chatBuf' = chatBuf <> [successText "Bio updated"]

commandRender (cmd:args) (accountList, user, chatBuf) = (accountList, user, chatBuf')
  where
    res = doList accountList args
    res' = map show res
    chatBuf' = case cmd of
      -- Info
      ":h" -> chatBuf <> showHelp
      ":l" -> chatBuf <> [successText ("Complited search: " <> show (length res))] <> res'
      ":i" -> chatBuf <> [show user]

      -- Actions
      ":r" -> chatBuf <> [runAction user (doReverse args) "R" "Command error :r <str>"]
      ":c" -> chatBuf <> [runAction user (doCalc args)    "C" "Command error :c <num> <num>"]

      -- Just message
      _    -> chatBuf <> [ulogin user ++ "> " ++ unwords (cmd:args)]


showHelp :: [String]
showHelp =  [ successText "[HELP]"
            , ":h for help"
            , ":a for show chat"
            , ":i for info user"
            , ":q for exit"
            , ":r <msg> to reverse"
            , ":c <a> <b> to a + b"
            , ":l <start letters login> to search"
            ]


runAction :: User -> Maybe String -> String -> String -> String
runAction user fRes logo errMsg = 
              concat [ ulogin user, " [", logo, "]> "]
              <> case fRes of
                  Nothing  -> errorText errMsg
                  Just res -> res


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
