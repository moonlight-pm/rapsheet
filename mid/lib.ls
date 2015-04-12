require! \util

module.exports = (next) ->*
  for name, lib of olio.lib
    if typeof! lib == 'Function'
      throw @error "Library function clobbers existing property: #name" if @[name]
      @[name] = lib.bind this
    @[name] ?= {}
    @[name].error = @error
    for key, val of lib
      throw @error "Library function clobbers existing property: #name:#key" if @[name][key]
      @[name][key] = val.bind @[name]
  yield next
