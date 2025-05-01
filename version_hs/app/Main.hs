{-# LANGUAGE TypeApplications #-}

module Main where

import System.IO

import System.Console.ANSI

data User = User {
    ulogin :: String
  , uage   :: Int
  , ubio   :: String
  }
  deriving (Show, Eq)
-- ? -------------------------------------
-- ? Entry point
-- ? -------------------------------------


main :: IO ()
main = do
  putStrLn "World"
  putStrLn "World"

  hSetBuffering stdout NoBuffering
  hSetBuffering stdin NoBuffering

  usersS <- readFile usersPath
  let
    usersL = lines usersS
    uSplit = mSplit ';'
    users  = map (\usr -> User (uSplit usr !! 0) (read $ uSplit usr !! 1) (uSplit usr !! 2)) usersL

  menu False 1 users

menu :: Bool -> Int -> [User] -> IO ()
menu cls (-1) u = menu cls 0 u
menu cls 3    u = menu cls 2 u
menu cls n users = do
  if cls then do
    cursorUp 4
    setCursorColumn 0
  else
    pure ()

  putStrLn "--APP-----------"

  let 
    m = [
        (0, "> (R)egister    ")
      , (1, "> (L)ogin       ")
      , (2, "> (Q)ite        ")
      ]

  mapM_ (\x ->  if fst x == n then do
                  setSGR [SetColor Background Vivid Blue]
                  putStr $ snd x
                  setSGR [Reset]
                  putStrLn ""
                else
                  putStrLn $ snd x
        ) m

  clearLine
  putStr "> "
  typeApp <- getKey

  let
    rF = putStrLn "" >> hSetBuffering stdin LineBuffering >> registerForm users
    lF = putStrLn "" >> hSetBuffering stdin LineBuffering >> loginForm users

  case typeApp of
    "\ESC[A" -> menu True (n - 1) users
    "\ESC[B" -> menu True (n + 1) users
    "\n"     -> case n of
                  0 -> rF
                  1 -> lF
                  _ -> pure ()
    "R"      -> rF
    "L"      -> lF
    "Q"      -> pure ()
    _        -> do
                  clearScreen
                  putStrLn "Err"
                  menu True 1 users


getKey :: IO [Char]
getKey = reverse <$> getKey' ""
  where 
    getKey' chars = do
      char <- getChar
      more <- hReady stdin
      (if more then getKey' else return) (char:chars)


-- ? -------------------------------------
-- ? Forms
-- ? -------------------------------------


registerForm :: [User] -> IO ()
registerForm accountList = do
  putStrLn "--REGISTRATION--"
  putStr "Login (or :q): "
  login <- getLine

  let
    findUser = filter (\x -> login == ulogin x) accountList

  if login == ":q" then
    main
  else if length findUser /= 0 then do
    putStrLn $ "Login is used"
    registerForm accountList
  else do
    putStr "Enter age: "
    age <- getLine

    if not $ checkAge $ read age then do
      putStrLn $ "Age incorrect"
      registerForm accountList
    else do
      putStrLn $ "Register success"
      appendFile usersPath $ concat ["\n", login, ";", age, ";"]

      putStrLn "---CHAT---"
      chatForm accountList (User login (read age) "")


loginForm :: [User] -> IO ()
loginForm accountList = do
  putStrLn "--LOGIN---------"
  putStr "Login: "
  login <- getLine

  let
    findUser = filter (\x -> login == ulogin x) accountList

  if length findUser /= 0 then do
    putStrLn $ "Login success"
    putStrLn "--CHAT----------"
    chatForm accountList (findUser !! 0)
  else do
    putStrLn $ "No account"
    main


chatForm :: [User] -> User -> IO ()
chatForm accountList user = do
  putStr "Message (or :q): "
  messageData <- getLine

  chatS <- readFile chatPath

  let
    msgCom = words messageData
    chat = lines chatS

  case msgCom !! 0 of
    ":q" -> pure ()
    ":h" -> mapM_ putStrLn showHelp
    ":a" -> mapM_ putStrLn chat
    ":b" -> do
      putStrLn "Bio updated"
      let
        user' = user {ubio = (msgCom !! 1)}
        bacc  = break (==user) accountList
        accountList' = fst bacc <> [user'] <> (drop 1 $ snd bacc)
      chatForm accountList' $ user'
    ":i" -> putStrLn $ show user
    ":r" -> putStrLn $ concat [ ulogin user, " [R]> ", (reverse . unwords . drop 1) msgCom]
    ":c" -> putStrLn $ concat [ ulogin user, " [C]> "
                              , show @Int $ read (msgCom !! 1) + read (msgCom !! 2)]
    ":l" -> putStrLn $ show $
              if (length msgCom /= 1) then
                filter (and . zipWith (==) (msgCom !! 1) . ulogin) $ accountList
              else
                accountList
    _    -> do
      cursorUp 1
      clearLine
      putStrLn $ ulogin user ++ "> " ++ messageData

  if msgCom !! 0 == ":q" then
    pure ()
  else
    chatForm accountList user


-- ? -------------------------------------
-- ? Config
-- ? -------------------------------------


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

checkAge :: Int -> Bool
checkAge x = (x > 17) && (x < 80)

mSplit :: Eq a => a -> [a] -> [[a]]
mSplit _  [] = [[]]
mSplit c arr = takeWhile (/=c) arr : mSplit c (drop 1 $ dropWhile (/= c) arr)
