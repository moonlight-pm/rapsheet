export authenticate = (token) ->*
  first(
    (yield @db.find \token, hint: take (token.length / 2), token)
    |> filter ~> (@hash.encrypt token, it.salt) == it.hash)
