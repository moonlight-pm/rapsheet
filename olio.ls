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
      if request.in.token
        take (request.in.token.length / 2), request.in.token
      else
        '-' * 13
  mail:
    from:     \support@rapsheet.me
    fromname: \Rapsheet
    user:     \username
    pass:     \password
