module Main where

import           Lib

main :: IO ()
main = do
  let dbFile = "test.sqlite"
  initDB dbFile
  startApp dbFile
