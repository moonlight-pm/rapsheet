require! \glob
require! \koa
require! \inflection
require! \util
require! \moment
require! \http

function ApiError @code, @message = null
  if not @message and typeof! @code != 'Number'
    @message = code
    @code = 500
  Error.call this, @message
  Error.capture-stack-trace this, this.constructor
util.inherits ApiError, Error

export watch = [ 'host.ls', 'olio.ls', 'api', 'mid', 'lib', 'task/api.ls' ]

export documentation = ->*
  content = []
  content.push "\n\# Rapsheet API"
  content.push "***\n"
  for mname, module of api
    content.push "\#\#\# #{mname.to-upper-case!}\n"
    for name, definition of module
      if name not in [ mname, inflection.pluralize(mname) ]
        name = "#mname/#name"
      content.push "\#\#\#\# /#name"
      content ++= definition.0.split('\n')
      content.push ''
      for pname, pvals of definition.1
        content.push "* #pname[#{keys pvals}]"
      content.push ''
  """
  <!DOCTYPE html>
  <html>
    <head>
      <title>Rapsheet</title>
    </head>
    <body>
      <xmp theme="cyborg" style="display:none">
        #{content.join '\n'}
      </xmp>
      <script src="http://strapdownjs.com/v/0.2/strapdown.js"></script>
    </body>
  </html>
  """

export api = ->*
  olio.api = api <<< require-dir "api"
  olio.config.api ?= {}
  olio.config.api.port ?= 9001
  mid = require-dir 'mid', "node_modules/olio/mid"
  app = koa!
  app.use require('koa-gzip')!
  app.use require('koa-bodyparser')!
  app.use (next) ->* # Main error handler
    try
      yield next
    catch e
      @response.status = (e.code and /^\d\d\d$/.test e.code and e.code) or 500
      if e.code and (e.code >= 400 and e.code < 500)
        e.message ?= http.STATUS_CODES[e.code.to-string!]
        @response.body = e.message
        message = (typeof! e.message == 'Object' and JSON.stringify(e.message)) or e.message
        if m = (/at Object\.out\$\.\w+.(\w+) \[as api\].*\/(\w+)\.ls/.exec (e.stack.split('\n') |> filter -> /\[as api\]/.test it))
          error "#{e.code} #{message} (#{m[2]}.#{m[1]})"
        else
          error "#{e.code} #{message}"
      else
        if e.stack
          error e.stack
        else if e.message
          error e.message
        else
          error JSON.stringify(e)
  app.use (next) ->*
    if typeof! @request.body == 'Array'
      @in = @request.body |> map ~> (pairs-to-obj (obj-to-pairs @query |> map ~> [(camelize it.0), it.1])) <<< it
    else
      @in = (pairs-to-obj (obj-to-pairs @query |> map -> [(camelize it.0), it.1])) <<< @request.body
    segments = filter id, @url.split('?').0.split('/')
    if empty segments
      @response.body = yield documentation!
      @response.status = 200
      return
    @api = (api[segments.0] and ((!segments.1 and api[segments.0][segments.0]) or api[segments.0][segments.1])) or (api[inflection.singularize segments.0] and api[inflection.singularize segments.0][segments.0])
    @error = (code, message) -> new ApiError code, message
    yield next
  if olio.config.api.mid
    olio.config.api.mid |> each (m) ->
      app.use mid[m]
  app.use (next) ->*
    return if not @api
    info "#{moment!format 'YYYY-MM-DD HH:mm:ss'} DISPATCH [#{@header['x-forwarded-for'] or '0.0.0.0'}] #{@url}".blue
    if typeof! @in == 'Array'
      data = @in
      result = []
      for item in data
        @in = item
        result.push(yield @api!)
    else
      result = yield @api!
    result = 200 if result == undefined
    if typeof! result == 'Number'
      @response.status = result
    else
      @body = result
  app.listen olio.config.api.port
  info "Started api server on port #{olio.config.api.port}".green
