module Animations(
    menuAnim
  , gamesAnim
  )
where

import Data.Time
import ScreenControl (toSide, successText)
import Data.Time.Clock.System

fps :: SystemTime -> Int
fps time =  fps100 `div` 5
  where
    fps100 = fromIntegral $ 100 * systemSeconds time + (fromIntegral (systemNanoseconds time) `div` (10  * 1000 * 1000))

menuAnim :: SystemTime -> [String]
menuAnim time = [
      toSide <> 
      successText"Main menu side:"
    , formatTime defaultTimeLocale "%a %b %e %H:%M:%S" (systemToUTCTime time)
    , successText $ "Tick 1/20: " ++ (show $ fps time)
    , concat $ replicate 20 $ (arr !! step1)
    , (arr2 !! step2)
  ]

  where 
    arr = ["|", "/", "-", "\\"]
    arr2 = [
        "H|     H"
      , "H |    H"
      , "H  |   H"
      , "H   |  H"
      , "H    | H"
      , "H     |H"
      , "H    | H"
      , "H   |  H"
      , "H  |   H"
      , "H |    H"
      ]
    step = fps time
    step1 = step `mod` 4
    step2 = step `mod` 9

gamesAnim :: SystemTime -> [String]
gamesAnim time = [toSide <> "SIN:"] <>
      map (\y -> map (\x -> (arr !! y) !! ((step + x) `mod` 20)) [0..50]) [0..7]


  where
    arr = [ "    XXX             "
          , "  XX   XX           "
          , " X       X          "
          , "X         X         "
          , "X         X         "
          , "           X       X"
          , "            XX   XX "
          , "              XXX   " ]

    step = fps time
