module Forms.Default (
    MenuElement
  , FormType(..)
  , AppData(..)
  , FormData
  , Form
  , MenuForm

  , colorMenuSelected

  , defFormClose
  , defFormErr
  , defFormClear

  , makeForm

  , dd
) where

import ScreenControl
import System.Console.ANSI
import Language.Haskell.TH


import User


data FormType = FormNew | FormClear | FormErr String | FormClose
  deriving (Eq, Show)

data AppData = AppData {
    appUsersList :: [User]
  , appUser :: User
  , appChatHistory :: [String]
  }

type FormData = (FormType, AppData)
type Form     = FormData -> IO FormData
type MenuForm = Int -> Form

type MenuElement = (Int, (String, IO FormData))



colorMenuSelected :: Int -> MenuElement -> String
colorMenuSelected n (i, (s, _)) = inMain True $
  if i == n then
    colorPrint Background Blue s
  else s


defFormClose :: IO FormData
defFormClose = pure (FormClose, AppData [] defUser [])

defFormErr :: Form -> AppData -> String -> IO FormData
defFormErr form appData msg = do
  size <- tSize
  mapM_ putStr $ clearAll size
  putStr $ inError msg
  form (FormNew, appData)

defFormClear :: Form -> AppData -> IO FormData
defFormClear form appData = do
  size <- tSize
  mapM_ putStr $ clearAll size
  form (FormNew, appData)



-- TemplateHaskell
  -- loginForm :: Form
  -- loginForm (FormClose  ,       _) = defFormClose
  -- loginForm (FormErr msg, appData) = defFormErr   loginForm appData msg
  -- loginForm (FormClear  , appData) = defFormClear loginForm appData
  -- loginForm (FormNew    , appData) = loginForm' (FormNew, appData)

makeForm :: String -> Q [Dec]
makeForm nameS = do
  let
    name    = mkName nameS
    run     = mkName $ nameS <> "'"
    msg     = mkName "msg"
    appData = mkName "appData"

  sequence [
      sigD name $ conT ''Form
    , funD name [
          clause [tupP [conP 'FormClose [], wildP]]
                 (normalB $ varE 'defFormClose) []

        , clause [tupP [conP 'FormErr   [varP msg], varP appData]]
                 (normalB $ varE 'defFormErr `appE` varE name `appE` varE appData `appE` varE msg) []

        , clause [tupP [conP 'FormClose [], varP appData]]
                 (normalB $ varE 'defFormClear `appE` varE name `appE` varE appData) []

        , clause [tupP [conP 'FormNew [], varP appData]]
                 (normalB $ varE run `appE` tupE [conE 'FormNew, varE appData]) []
        ]
    ]


dd :: IO [String]
dd = do
  x <- runQ $ makeForm "loginForm"
  pure $ lines $ pprint x


-- >>> runQ [|defFormClose|]
-- VarE Forms.Default.defFormClose

-- >>> dd
-- ["loginForm :: Forms.Default.Form"
-- ,"loginForm (Forms.Default.FormClose, _) = Forms.Default.defFormClose"
-- ,"loginForm (Forms.Default.FormErr msg,","           appData) = Forms.Default.defFormErr loginForm appData msg"
-- ,"loginForm (Forms.Default.FormClose,","           appData) = Forms.Default.defFormClear loginForm appData"
-- ,"loginForm (Forms.Default.FormNew,","           appData) = loginForm' (Forms.Default.FormNew, appData)"]

-- [SigD loginForm_16 (ConT Forms.Default.Form),FunD loginForm_16 [Clause [TupP [ConP Forms.Default.FormClose [] [],WildP]] (NormalB (VarE Forms.Default.defFormClose)) [],Clause [TupP [ConP Forms.Default.FormErr [] [VarP msg_21],VarP appData_22]] (NormalB (AppE (AppE (AppE (VarE Forms.Default.defFormErr) (VarE loginForm_16)) (VarE appData)) (VarE msg))) [],b     Clause [TupP [ConP Forms.Default.FormClear [] [],VarP appData_23]] (NormalB (AppE (AppE (VarE Forms.Default.defFormClear) (VarE loginForm_16)) (VarE appData))) [],   Clause [TupP [ConP Forms.Default.FormNew [] [],VarP appData_24]] (NormalB (AppE (VarE run) (VarE appData))) []]]
