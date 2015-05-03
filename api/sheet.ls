export sheet =
  """
  Update or retrieve your sheet.

  If you pass a sheet, it will update, otherwise it will return it.

  This will create your sheet if it doesn't exist, and deep merge the
  contents incoming sheet onto it.  Sheets are versioned.
  """
  token: { +token }
  sheet: { +object, +conditional }
  ->*
    @error 401 if not token = yield @token.authenticate @in.token
    if not sheet = first yield @db.find \sheet, token{identifier}
      sheet = yield @db.create \sheet, token{identifier}
    if @in.sheet
      @log "Updating sheet for #{token.identifier}"
      # Prevent overwriting fields that should be read-only by deleting them from the incoming sheet
      delete @in.sheet._id
      delete @in.sheet._key
      delete @in.sheet._rev
      delete @in.sheet.identifier
      # Merge the incoming sheet over the existing one, and update
      sheet = yield @db.update deepmerge sheet, @in.sheet
    sheet
