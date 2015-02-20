debug = require('debug')('zentralkern:plugins:log')

module.exports =
  name: 'log'
  attach: (core)->
    debug 'attach'
    core.on '*', (data)->
      debug 'Event', data
  init: (core, config, done) ->
    done()
  detach: (core)->
    debug 'detach'
