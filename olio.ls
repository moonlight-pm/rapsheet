export do
  db:
    host: \localhost
    port: \8529
    name: \rapsheet
  api:
    port: 9002
    mid: <[ error docs resolve lib db validation invoke ]>
    log-ip: false
    resolve-session-id: (request) ->
      if token = (/token=([0-9a-z]{52})/.exec request.url)?1
        take (token.length / 2), token
      else
        '-' * 26
  mail:
    from:     \support@rapsheet.me
    fromname: \Rapsheet
    user:     \username
    pass:     \password
