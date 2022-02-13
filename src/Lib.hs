{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeOperators     #-}

module Lib
  ( startApp,
    app,
  )
where

import           Data.Aeson
import           Data.Aeson.TH
import           Database.SQLite.Simple
import           Network.Wai
import           Network.Wai.Handler.Warp
import           Servant
import           ServantBoardData

$(deriveJSON defaultOptions ''User)
$(deriveJSON defaultOptions ''ServantBoardResult)

initQuery :: Query
initQuery = "CREATE TABLE IF NOT EXISTS post (id PRIMARY KEY, content text not null);"

initDB :: FilePath -> IO ()
initDB dbFileName = withConnection dbFileName $ \conn ->
  execute_
    conn
    initQuery

--dbFileName :: FilePath
--dbFileName = "test.sqlite"

type API =
  "users" :> Get '[JSON] [User]
    :<|> "users" :> Post '[JSON] ServantBoardResult

startApp :: FilePath -> IO ()
startApp dbFileName = run 8080 (app dbFileName)

app :: FilePath -> Application
app dbFileName = serve api $ server dbFileName

api :: Proxy API
api = Proxy

server :: FilePath -> Server API
server dbFileName =
  return users
    :<|> return sampleResult
