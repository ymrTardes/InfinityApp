module Forms (
    menuForm
  , registerForm
  , loginForm
  , chatForm
  )
where

import System.IO
import System.Console.ANSI
import Data.Char

import User
import Config

menuForm :: RenderOpt -> Int -> [User] -> IO ()
menuForm cls (-1) u = menuForm cls 0 u
menuForm cls 3    u = menuForm cls 2 u
menuForm cls n users = do
  hSetBuffering stdin NoBuffering

  case cls of
    RNew -> pure ()
    RCls -> do
              cursorUp 4
              setCursorColumn 0
    RErr msg -> do
                  cursorUp 6
                  setCursorColumn 0
                  clearLine
                  putStrLn ""
                  clearLine
                  putStrLn msg

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
    rF = do
      putStrLn ""
      hSetBuffering stdin LineBuffering
      e <- registerForm users
      if e then menuForm RNew n users else pure ()
    lF = do
      putStrLn ""
      hSetBuffering stdin LineBuffering
      e <- loginForm users
      if e then menuForm RNew n users else pure ()

  case map toUpper typeApp of
    "\ESC[A" -> menuForm RCls (n - 1) users
    "\ESC[B" -> menuForm RCls (n + 1) users
    "\n"     -> case n of
                  0 -> rF
                  1 -> lF
                  _ -> pure ()
    "R"      -> rF
    "L"      -> lF
    "Q"      -> pure ()
    _        -> do
                  menuForm (RErr "!!! No command !!!") 1 users



registerForm :: [User] -> IO Bool
registerForm accountList = do
  putStrLn "--REGISTRATION--"
  putStr "Login (or :q): "
  login <- getLine

  let
    findUser = filter (\x -> login == ulogin x) accountList

  if login == ":q" then
    pure True
  else if length findUser /= 0 then do
    putStrLn $ "Login is used"
    registerForm accountList
  else do
    putStr "Enter age: "
    age <- getLine

    if not . and $ map isDigit age then do
      putStrLn $ "Age incorrect"
      registerForm accountList
    else if not . checkAge $ read age then do
      putStrLn $ "Age us not in range 18-80"
      registerForm accountList
    else do
      putStrLn $ "Register success"
      appendFile usersPath $ concat ["\n", login, ";", age, ";"]
  
      putStrLn "--CHAT----------"
      chatForm accountList (User login (read age) "")
      pure False


loginForm :: [User] -> IO Bool
loginForm accountList = do
  putStrLn "--LOGIN---------"
  putStr "Login (or :q): "
  login <- getLine

  let
    findUser = filter (\x -> login == ulogin x) accountList

  if login == ":q" then
    pure True
  else if length findUser /= 0 then do
    putStrLn $ "Login success"

    putStrLn "--CHAT----------"
    chatForm accountList (findUser !! 0)
    pure False
  else do
    putStrLn $ "No account"
    pure True


chatForm :: [User] -> User -> IO ()
chatForm accountList user = do
  putStr "Message (or :q): "
  messageData <- getLine

  chatS <- readFile chatPath

  let
    msgCom = words messageData
    chat = lines chatS

  cursorUp 1
  clearLine

  case map toLower (msgCom !! 0) of
    ":q" -> pure ()
    ":b" -> pure ()

    -- Info
    ":h" -> mapM_ putStrLn showHelp
    ":a" -> mapM_ putStrLn chat
    ":l" -> mapM_ (putStrLn . show) $ doList accountList msgCom

    ":i" -> putStrLn $ show user

    -- Actions
    ":r" -> putStrLn $ concat [ ulogin user, " [R]> ", doReverse msgCom]
    ":c" -> putStrLn $ concat [ ulogin user, " [C]> ", doCalc msgCom]

    _    -> do
      putStrLn $ ulogin user ++ "> " ++ messageData

  case msgCom !! 0 of
    ":q" -> pure ()
    ":b" -> do
              putStrLn "Bio updated"
              let
                user' = user {ubio = (msgCom !! 1)}
                bacc  = break (==user) accountList
                accountList' = fst bacc <> [user'] <> (drop 1 $ snd bacc)

              chatForm accountList' $ user'

    _    -> chatForm accountList user
    