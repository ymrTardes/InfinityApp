module Forms.ChatForm (chatForm) where

import System.Console.ANSI
import Data.Char

import User
import Config
import Control.Monad

chatForm :: [User] -> User -> IO ()
chatForm accountList user = do
  putStr "Message (or :q): "
  messageData <- getLine

  let
    msgCom = words messageData

  -- Remove entereted maessage/command
  cursorUp 1
  clearLine

  if length msgCom == 0 then
    chatForm accountList user

  else do
    case map toLower (msgCom !! 0) of
      ":q" -> pure ()
      ":b" -> pure ()

      -- Info
      ":h" -> mapM_ putStrLn showHelp
      ":l" -> mapM_ (putStrLn . show) $ doList accountList msgCom

      ":i" -> putStrLn $ show user

      -- Actions
      ":r" -> do
                putStr $ concat [ ulogin user, " [C]> "]
                case doReverse msgCom of
                  Nothing  -> errorText "Command error :r <str>"
                  Just res -> putStrLn res
      ":c" -> do
                putStr $ concat [ ulogin user, " [C]> "]
                case doCalc msgCom of
                  Nothing  -> errorText "Command error :c <num> <num>"
                  Just res -> putStrLn res

      _    -> do
        putStrLn $ ulogin user ++ "> " ++ messageData

    case map toLower (msgCom !! 0) of
      ":q" -> do
                writeFile usersPath $ prepareUsers accountList
      ":b" -> do
                putStrLn "Bio updated"
                let
                  user' = user {ubio = (msgCom !! 1)}
                  bacc  = break (==user) accountList
                  accountList' = fst bacc <> [user'] <> (drop 1 $ snd bacc)

                chatForm accountList' $ user'

      _    -> chatForm accountList user


prepareUsers :: [User] -> String
prepareUsers u = concat $ map (\a -> concat [ulogin a, ";", show $ uage a, ";", ubio a, "\n"] ) u

doReverse :: [String] -> Maybe String
doReverse (_:[]) = Nothing
doReverse x = pure $ (reverse . unwords . drop 1) x


doCalc :: [String] -> Maybe String
doCalc []        = Nothing
doCalc (_:[])    = Nothing
doCalc (_:_:[])  = Nothing
doCalc (_:a:b:_) = do
  guard $ and $ map (isDigit) a
  guard $ and $ map (isDigit) b
  pure $ show @Int $ read a + read b


doList :: [User] -> [[Char]] -> [User]
doList accountList msgCom | length msgCom /= 1 =
                              filter (and . zipWith (==) (msgCom !! 1) . ulogin) $ accountList
                          | otherwise = accountList
