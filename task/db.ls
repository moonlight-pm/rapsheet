require! \oriento

export create = ->*
  orient = oriento olio.config.orient
  if db = first ((yield orient.list!) |> filter -> it.name == olio.config.orient.db)
    info "Database '#{olio.config.orient.db}' already exists."
  else
    db = yield orient.create name: olio.config.orient.db
  orient.close!
