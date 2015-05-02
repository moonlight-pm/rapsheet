export tokens =
  """
  Get a list of tokens.

  The user may want to clean out some old tokens, so lets give them a list.

  This only returns the 4 character hint, which may, however unlikely, occur more
  than once.  Further functions will take the hint, as to which token to effect.
  """
  token: { +token }
  ->*
    @error 401 if not claim = yield @claim.with-token @in.token
    (yield @db.find \claim, email: claim.email) |> map -> it.hint

export destroy =
  """
  Destroy a token.
  """
  token: { +token }
  hint:  { +hint }
  ->*
    @error 401 if not claim = yield @claim.with-token @in.token
    yield @db.destroy \claim, email: claim.email, hint: @in.hint
    200
