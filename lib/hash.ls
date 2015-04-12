require! \crypto

export random = (length) ->
  crypto.random-bytes length .to-string \hex

export encrypt = (secret, salt) ->
  return crypto.pbkdf2-sync secret, salt, 10000, 32 .to-string \hex
