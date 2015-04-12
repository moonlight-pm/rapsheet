require! \util

module.exports = (next) ->*
  for name, lib of olio.lib
    @[name] ?= {}
    @[name].error = @error
    for key, val of lib
      if typeof! val == \Function
        throw @error "Library function clobbers existing property: #name:#key" if @[name][key]
        @[name][key] = val.bind @[name]
      else
        @[name][key] = val
  yield next
