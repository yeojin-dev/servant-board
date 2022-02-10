module ServantBoardData
  ( ServantBoardResult,
    sampleResult,
    User,
    users,
  )
where

data ServantBoardResult = ServantBoardResult
  { message :: String
  }
  deriving (Show)

sampleResult :: ServantBoardResult
sampleResult = ServantBoardResult "success"

data User = User
  { userId        :: Int,
    userFirstName :: String,
    userLastName  :: String
  }
  deriving (Eq, Show)

users :: [User]
users =
  [ User 1 "Isaac" "Newton",
    User 2 "Albert" "Einstein"
  ]
