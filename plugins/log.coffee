debug = require('debug')('zentralkern:plugin:log')

module.exports =
  name: 'log'
  version: '0.0.1'
  attach: (service)->
    debug 'attach'
    # service.on 'error::*::*::*', (data)->
    #   debug 'Event', data
  init: (core, config, done) ->
    debug "initialized"
    done()
  detach: (core)->
    debug 'detach'
