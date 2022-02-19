# API 추가 가이드

1. Create Haskell Data

```haskell
-- {
--   "response": {
--     "total": 10
--   }
-- }
data GuardianResponse = GuardianResponse { total :: Int } deriving (Eq, Show)

instance FromJSON GuardianResponse where
  parseJSON = withObject "response" $ \o -> do
    r <- o .: "response"
    r <- r .: "total"
    return $ GuardianResponse t

type SearchTerm = String
type ApiKey = String
```

2. Describe API with servant-client DSL

```haskell
-- /search?q=haskell&api-key=test
type GuardianAPI = "search"
  :> QueryParam "q" SearchTerm
  :> QueryParam "api-key" ApiKey
  :> Get '[JSON] GuardianResponse
```

3. Generate Haskell Client Functions

```haskell
guardianAPI :: Proxy GuardianAPI
guardianAPI :: Proxy

search = client guardianAPI
```

4. Implement business logic

```haskell
queries :: SearchTerm -> ClientM GuardianResponse
queries q = do
  t <- search (Just q) (Just "test")
  return t 
```

### 출처

[haskell servant client in 5 min](https://youtu.be/TQB2JbxNEUI)
