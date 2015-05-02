export do
  token: (data, key, option) ->
    throw 'Malformed token' if not /^[0-9a-z]{52}$/.test data[key]

  hint: (data, key, option) ->
    throw 'Malformed hint' if not /^[0-9a-z]{26}$/.test data[key]

