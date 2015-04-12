require! \util

module.exports = (next) ->*
  if typeof! @api == 'Array'
    # info "VALIDATI [#{@header['x-forwarded-for'] or '0.0.0.0'}] #{@url}".cyan
    throw @error 500, "Api has malformed construction" if @api.length % 3 != 0
    if @api.length != 3 or typeof! @api.0 != 'String' or typeof! @api.1 != 'Object' or typeof! @api.2 != 'Function'
      throw @error 500, "Api has malformed construction"
    @valid = false
    @_validate = olio.validate
    if !(keys (invalid = yield @_validate @in, @api.1)).length
      @valid = true
      @api = @api.2
    throw @error 403, invalid if !@valid
  else
    @nonvalidatable = true
    @valid = true
  yield next
