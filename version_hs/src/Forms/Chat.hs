module Forms.Chat (chatForm) where

import Data.Char
import Control.Monad
import Database.SQLite.Simple
import System.Console.ANSI (ConsoleLayer(Foreground), Color (Blue))


import User
import Config
import ScreenControl

import Forms.Default


chatForm :: Form
chatForm (FormClose  ,       _) = defFormClose
chatForm (FormErr msg, appData) = defFormErr   chatForm appData msg
chatForm (FormClear  , appData) = defFormClear chatForm appData

chatForm (FormNew, appData) = do
  (y,x) <- tSize

  putStr toMain
  printUserInfo $ appUser appData

  mapM_ putStr $ clearSide (y,x)
  putStr toSide

  let
    winChatBuf = (reverse . take (y - 6) . reverse) $ appChatHistory appData
  mapM_ (putStr . inSide True) winChatBuf

  putStr . inSideDown (y,x) $ "Message (or :q): "

  messageData <- getLine

  -- Remove entereted maessage/command
  putStr . inSideDown (y,x) $ replicate (x - 36) ' '

  if messageData == ":q" then pure (FormClose, appData)
  else do
    let
      appData' = commandRender (words messageData) appData

    if (appUser appData) /= (appUser appData') then do
      withConnection dbPath $ \conn -> do
        execute conn "update users set bio = ? where id = ?"
          (ubio (appUser appData'), uid (appUser appData))

      mapM_ putStr $ clearMain (y,x)
    else
      pure ()

    chatForm (FormNew, appData')


commandRender :: [String] -> AppData -> AppData
commandRender [] appData = appData
commandRender (":b":args) (AppData accountList user chatBuf) =
    AppData accountList' user' chatBuf'
  where
    user' = user {ubio = unwords args}
    bacc  = break (==user) accountList
    accountList' = fst bacc <> [user'] <> (drop 1 $ snd bacc)
    chatBuf' = chatBuf <> [successText "Bio updated"]
commandRender (cmd:args)  (AppData accountList user chatBuf) =
    AppData accountList user chatBuf'
  where
    listRes = doList accountList args
    chatBuf' = case cmd of
      -- Info
      ":h" -> chatBuf <> showHelp
      ":l" -> chatBuf <> [successText ("Complited search: " <> show (length listRes))] <> (map show listRes)
      ":i" -> chatBuf <> [show user]

      -- Actions
      ":r" -> chatBuf <> [runAction user (doReverse args) "R" "Command error :r <str>"]
      ":c" -> chatBuf <> [runAction user (doCalc args)    "C" "Command error :c <num> <num>"]

      -- Just message
      _    -> chatBuf <> [colorPrint Foreground Blue (ulogin user ++ "> ") ++ unwords (cmd:args)]


printUserInfo :: User -> IO ()
printUserInfo user = do
  putStr . inMain True $ titleText "[CHAT]"
  putStr . inMain True $ successText "Online : 1"
  putStr . inMain True $ ""
  putStr . inMain True $ "Info:"
  putStr . inMain True $ "Id:   "   <> (show $ uid user)
  putStr . inMain True $ "User: " <> ulogin user
  putStr . inMain True $ "Age:  "  <> (show $ uage user)
  putStr . inMain True $ "Bio:  "  <> ubio user


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
