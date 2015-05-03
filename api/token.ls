export token =
  """
  Retrieve a new token for the given identifier.

  An identifier, such as an email address, positively identifies a person by their ability
  to receive a private message.  A token is sent to the identifier and can then be used to
  initiate other API actions against it.
  """
  email: { +email }
  ->*
    token    = @token.generate!
    info token, token.length
    @in.hint = take (token.length / 2), token
    @in.salt = @token.generate!
    @in.hash = @token.encrypt token, @in.salt
    yield @db.create \token, @in{identifier:email, hint, salt, hash}
    yield @mail to: @in.email, subject: 'Your token resides within.', text: """
      Someone has requested a token for identifier '#{@in.email}' on rapsheet.me.
      If you have not made this request, you may safely ignore this email.

      Your token: #token

      You may use this token to manipulate the sheet for the related identifier.
    """
    200

export hints =
  """
  Get a list of token hints.

  The user may want to clean out some old tokens, so lets give them a list.

  Each token is 52 bytes long, each hint is the first half of a token.
  """
  token: { +token }
  ->*
    @error 401 if not token = yield @token.authenticate @in.token
    (yield @db.find \token, token{identifier}) |> map -> it.hint

export destroy =
  """
  Destroy a token.
  """
  token: { +token }
  hint:  { +hint }
  ->*
    @error 401 if not token = yield @token.authenticate @in.token
    yield @db.destroy \token, token{identifier} <<< hint: @in.hint
    200