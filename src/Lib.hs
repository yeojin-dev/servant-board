{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}

module Lib
  ( startApp,
    app,
  )
where

import           Data.Aeson
import           Data.Aeson.TH
import           Network.Wai
import           Network.Wai.Handler.Warp
import           Servant
import           ServantBoardData

$(deriveJSON defaultOptions ''User)
$(deriveJSON defaultOptions ''ServantBoardResult)

type API =
  "users" :> Get '[JSON] [User]
    :<|> "users" :> Post '[JSON] ServantBoardResult

startApp :: IO ()
startApp = run 8080 app

app :: Application
app = serve api server

api :: Proxy API
api = Proxy

server :: Server API
server =
  return users
    :<|> return sampleResult
