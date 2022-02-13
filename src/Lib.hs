{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeOperators     #-}

module Lib
  ( startApp,
    app,
  )
where

import           Control.Monad.IO.Class
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
    :<|> "users" :> Post '[JSON] NoContent

startApp :: FilePath -> IO ()
startApp dbFileName = run 8080 (app dbFileName)

app :: FilePath -> Application
app dbFileName = serve api $ server dbFileName

api :: Proxy API
api = Proxy

sampleQuery = "INSERT INTO post (content) VALUES ('test content');" :: Query

server :: FilePath -> Server API
server dbFileName =
  return users
    :<|> samplePost
  where
    samplePost :: Handler NoContent
    samplePost = do
      liftIO . withConnection dbFileName $ \conn -> execute_ conn sampleQuery
      return NoContent
