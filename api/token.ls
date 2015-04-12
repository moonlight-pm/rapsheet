export tokens =
  """
  Get a list of tokens.

  The user may want to clean out some old tokens, so lets give them a list.

  This only returns the 4 character hint, which may, however unlikely, occur more
  than once.  Further functions will take the hint, as to which token to effect.
  """
  token: { +token }
  ->*
    # Grab all claims with the hint, then hash against each to find the true claim.
    claim = yield @claim.with-token @in.token
    (yield @db.find \claim, email: claim.email)
    |> map -> it.hint

export destroy =
  """
  Destroy a token.
  """
  token: { +token }
  hint:  { +hint }
  ->*
