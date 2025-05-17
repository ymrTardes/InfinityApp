module Animations(
    menuAnim
  , gamesAnim
  )
where

import Data.Time
import ScreenControl (toSide, successText)

menuAnim :: UTCTime -> [String]
menuAnim time = [
      toSide <> 
      successText"Main menu side:"
    , formatTime defaultTimeLocale "%a %b %e %H:%M:%S" time
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
    d = diffTimeToPicoseconds $ utctDayTime time
    step = fromInteger $ d `div` (80 * 1000 * 1000 * 1000)
    step1 = step `mod` 4
    step2 = step `mod` 9

gamesAnim :: UTCTime -> [String]
gamesAnim time = [
    toSide <>
    map (\x -> arr1 !! ((step + x) `mod` 18)) [0..50]
    , map (\x -> arr2 !! ((step + x) `mod` 18)) [0..50]
    , map (\x -> arr3 !! ((step + x) `mod` 18)) [0..50]
    , map (\x -> arr4 !! ((step + x) `mod` 18)) [0..50]
    , map (\x -> arr5 !! ((step + x) `mod` 18)) [0..50]
    , map (\x -> arr6 !! ((step + x) `mod` 18)) [0..50]
  ]

  where
    arr1 = "   XXX            "
    arr2 = " XX   XX          "
    arr3 = "X       X         "
    arr4 = "         X       X"
    arr5 = "          XX   XX "
    arr6 = "            XXX   "
    d = diffTimeToPicoseconds $ utctDayTime time
    step = fromInteger $ d `div` (80 * 1000 * 1000 * 1000) `mod` 18
