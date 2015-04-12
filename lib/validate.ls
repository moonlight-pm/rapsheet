require! \moment

module.exports = validate = (data, definition, field, extra-validators = {}) ->*
  extra-validators = definition.validate if definition.validate
  invalid = {}
  for key of data
    continue if field and key != field
    if not definition[key]
      invalid[key] ?= {}
      invalid[key][\known] = 'unknown parameter'
      continue
  for key of definition
    continue if key == \validate
    continue if field and key != field
    def = { -optional } <<< definition[key]
    if def.optional
      continue if not data[key]
    else if !def.conditional and !data[key]?
      invalid[key] ?= {}
      invalid[key][\optional] = 'Required'
      continue
    if typeof! data[key] == \String
      data[key] = data[key].trim!
    for vkey, vval of def
      continue if vkey == \optional
      throw "Tried to validate unknown type: #vkey" if not (validate[vkey] or extra-validators[vkey])
      try
        if extra-validators[vkey]
          if /^function\*/.test extra-validators[vkey].to-string!
            @_validator = extra-validators[vkey]
            yield @_validator data, key, vval
          else
            extra-validators[vkey] data, key, vval
        else
          validate[vkey] data, key, vval
      catch e
        if typeof! e == \String
          invalid[key] ?= {}
          invalid[key][vkey] = e
        else
          throw e
  return invalid if not field
  return invalid[field]

validate.conditional = -> # Means the value isn't required, but must pass validations

validate.token = (data, key, option) ->
  throw 'Malformed token' if not /^[0-9a-z]{32}$/.test data[key]

validate.hint = (data, key, option) ->
  throw 'Malformed hint' if not /^[0-9a-z]{4}$/.test data[key]

validate.email = (data, key, option) ->
  data[key] = data[key].to-lower-case!
  throw 'Must be a valid email address' if not /^[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$/.test data[key]

validate.password-repeat = (data, key, option) ->
  throw "#option don't match" if data[key] != data[key.match /(.*)\Repeat$/ .1]

validate.form = ->

validate.future = (data, key, option) ->
  thence = moment!
  if option != true
    thence.add option
  throw thence.format! if not thence.is-before data[key]

validate.phone = (data, key, option) ->
  val = data[key].replace /[^\d]/g, ''
  throw 'must be ten digits' if not /^\d{10}$/.test val
  data[key] = val

validate.min-length = (data, key, option) ->
  throw "Must be at least #option characters" if data[key].length < option

validate.min-words = (data, key, option) ->
  throw "Must be at least #option word#{option > 1 and 's' or ''}" if not (new RegExp (["[^\\s]"] * option).join("\\s+")).test data[key]

validate.exact-length = (data, key, option) ->
  throw "must be #option characters" if data[key].length != option

validate.latitude  = (data, key, option) ->
  val = parse-float data[key]
  throw 'not a latitude coordinate' if val == NaN or val < -90 or val > 90
  data[key] = parse-float data[key]

validate.longitude = (data, key, option) ->
  val = parse-float data[key]
  throw 'not a longitude coordinate' if val == NaN or val < -180 or val > 180
  data[key] = parse-float data[key]

validate.float = (data, key, option) ->
  throw 'not a float' if parse-float(data[key]) == NaN

validate.lowercase = (data, key, option) ->
  throw 'must be lower case' if /[A-Z]/.test data[key]

validate.alpha = (data, key, option) ->
  throw 'must be alpha' if not /^[a-zA-Z]*$/.test data[key]

validate.boolean = (data, key, option) ->
  throw 'not a boolean' if typeof! data[key] != 'Boolean'

validate.integer = (data, key, option) ->
  throw 'not an integer' if not /^[0-9]+$/.test data[key]

validate.money = (data, key, option) ->
  throw 'Must be a monetary value' if not /^(?!\(.*[^)]$|[^(].*\)$)\(?\$?(0|[1-9]\d{0,2}(,?\d{3})?)(\.\d\d?)?\)?$/.test data[key]
  data[key] = parse-float data[key]

validate.min-value = (data, key, option) ->
  throw "not greater than #option" if parse-float(data[key]) < option

validate.max-value = (data, key, option) ->
  throw "not less than #option" if parse-float(data[key]) > option

validate.date = (data, key, option) ->
  throw 'malformed date' if new moment(data[key])._d.to-string! == 'Invalid Date'

validate.time = (data, key, option) ->
  throw 'malformed time' if not /^\d{2}\:\d{2}$/.test data[key]

validate.values = (data, key, option) ->
  throw 'not in values' if data[key] not in option
