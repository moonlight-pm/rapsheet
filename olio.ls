export do
  db:
    host: \localhost
    port: \8529
    name: \rapsheet
  api:
    name: \Rapsheet
    port: 9002
    mid: <[ log docs web resolve lib db error validation invoke ]>
    docs: \/api
    log-ip: false
    resolve-session-id: (request) ->
      if request.in?token
        take (request.in.token.length / 2), request.in.token
      else
        '-' * 13
  mail:
    from:     \support@rapsheet.me
    fromname: \Rapsheet
    user:     \username
    pass:     \password
  web:
    app: \rapsheet
    modules: [
    ]
    imports: [
      'semantic-ui-css/semantic.css'
    ]
    require: [
      'semantic-ui-css/semantic'
    ]
    require-global: {
      $: \jquery
      jQuery: \jquery
    }
