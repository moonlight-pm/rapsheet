export with-token = (token) ->*
  first(
    (yield @db.find \claim, hint: take 4 token)
    |> filter ~> (@hash.encrypt token, it.salt) == it.hash)
