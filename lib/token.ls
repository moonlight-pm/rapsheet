require! \crypto
require! \base32

export generate = ->
  base32.encode crypto.random-bytes 16

export encrypt = (token, salt) ->
  base32.encode crypto.pbkdf2-sync token, salt, 10000, 16

export authenticate = (token) ->*
  first(
    (yield @db.find \token, hint: take (token.length / 2), token)
    |> filter ~> (@encrypt token, it.salt) == it.hash)
