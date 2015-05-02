require! \crypto
require! \base32

export random = (length) ->
  base32.encode crypto.random-bytes length

export encrypt = (secret, salt) ->
  return crypto.pbkdf2-sync secret, salt, 10000, 32 .to-string \hex
