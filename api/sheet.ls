export claim =
  """
  Claim a sheet by providing the email address attached to it.

  Sheets exists one-to-one per email address.  When claimed, a secret token will be generated
  and sent to the requestor.  This token can then be used to cause further actions against the
  sheet.
  """
  email: { +email }
  ->*
    token    = @hash.random 16
    @in.hint = take 4 token
    @in.salt = @hash.random 32
    @in.hash = @hash.encrypt token, @in.salt
    yield @db.create \claim, @in
    yield @mail.send @in.email, 'Your claim token resides within.', """
      Someone has made a claim for the email address #{@in.email} on rapsheet.me.  If you have not made this claim, you may safely ignore this email.

      Your token: #token

      You may use this token to make adjustments to your sheet.
    """
    200
