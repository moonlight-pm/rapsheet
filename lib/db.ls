require! \node-neo4j

olio.config.db      ?= {}
olio.config.db.host ?= \localhost
olio.config.db.port ?= \7474
olio.config.db.user ?= \neo4j
olio.config.db.pass ?= \secret

db = new node-neo4j "http://#{olio.config.db.user}:#{olio.config.db.pass}@#{olio.config.db.host}:#{olio.config.db.port}"
promisify-all db

export create = (label, properties = {}) ->*
 return (yield db.insert-node-async properties, label)
  # return yield db.insert!into(name).set(properties).one!


# require! \oriento

# db = null

# export initialize = ->*
#   orient = oriento olio.config.orient
#   try
#     db := yield orient.create name: olio.config.orient.db
#   catch
#     db := orient.use olio.config.orient.db

# export create = (name, properties) ->*
#   return yield db.insert!into(name).set(properties).one!


# if not db = first ((yield orient.list!) |> filter -> it.name == olio.config.orient.db)
#   info "Database '#{olio.config.orient.db}' already exists."
# else
#   db = yield orient.create name: olio.config.orient.db
# orient.close!

