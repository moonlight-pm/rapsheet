require! \crypto
require! \arangojs
require! \aqb

olio.config.db      ?= {}
olio.config.db.host ?= \localhost
olio.config.db.port ?= \8529

arango = new arangojs "http://#{olio.config.db.host}:#{olio.config.db.port}"

db = null
collections = null

export initialize = ->*
  if not db := first((yield arango.databases!) |> filter -> it.name == \rapsheet)
    db := yield arango.create-database \rapsheet
  collections := (yield db.collections!)
  |> map -> [ it.name, it ]
  |> pairs-to-obj

export generate-id = ->
  do
    id = crypto.random-bytes(4).to-string(\base64).substr(0, 6)
  while !/^[a-zA-Z0-9]{6}/.test id
  id

export query = ->*
  yield (yield db.query ...&).all!

export create = (name, properties = {}) ->*
  if not collections[name]
    collections[name] = yield db.create-collection name
  first(yield query(aqb.insert(\@o).into(name).return-new(\o), o: { _key: generate-id! } <<< properties))

aqb-simple-filter = (q, properties) ->
  for key, val of properties
    val = switch typeof! val
    | \Boolean  => aqb.bool val
    | \Number   => aqb.num val
    | \String   => aqb.str val
    | \List     => aqb.list val
    | \Object   => aqb.obj val
    | otherwise => throw 'Unrecognized type'
    q = q.filter(aqb.eq(aqb.ref("o.#key"), val))
  q

export find = (name, properties = {}) ->*
  if not collections[name]
    return []
  q = aqb.for(\o).in(name)
  q = aqb-simple-filter q, properties
  yield query(q.return(\o))

export destroy = (name, properties = {}) ->*
  if not collections[name]
    return []
  q = aqb.for(\o).in(name)
  q = aqb-simple-filter q, properties
  yield query(q.remove(\o).in(name))
