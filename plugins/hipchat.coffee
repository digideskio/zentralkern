# file: plugins/hipchat.coffee

debug = require('debug')('zentralkern:plugin:hipchat')
hipchat = require 'node-hipchat'

plugin =
  name: 'hipchat'
  version: '0.0.1'

  attach: (service)->
    debug 'attach'

  init: (core, opts, done)->
    debug 'init', opts
    plugin.client = new hipchat opts.api_key
    plugin.core = core
    plugin.client.listRooms (res, err)->
      unless err
        debug "initialized"
        plugin.rooms = res.rooms
      done err

  connected: ->
    return plugin.client.apikey?

  api:
    rooms: (params, done)->
      unless plugin.connected()
        done new Error('Hipchat not connected.')
      else
        plugin.client.listRooms (res, err)->
          done err, res.rooms

    room: (params, done)->
      unless params?
        done new Error('No params')
      else
        plugin.client.getHistory params, (res, err)->
          if res?
            done null, res.messages
          else
            done err

module.exports = plugin
