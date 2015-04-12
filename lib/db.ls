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

export find = (label, properties = {}) ->*
  return (yield db.read-nodes-with-labels-and-properties-async label, properties)
