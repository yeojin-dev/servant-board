module ServantBoardData
  ( User,
    users,
  )
where

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
