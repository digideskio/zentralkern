# file: plugins/hipchat.coffee

debug = require('debug')('zentralkern:plugin:hipchat')
hipchat = require 'node-hipchat'

getClient = (api_key)->
  return new hipchat api_key

plugin =
  name: 'hipchat'
  version: '0.0.1'

  attach: (service)->
    debug 'attach'

  init: (core, config, done)->
    debug 'init', config
    plugin.config = config
    plugin.core = core
    plugin.client = getClient config.api_key
    done null

  api:
    rooms: (params, done)->
      plugin.client.listRooms (res, err)->
        done err, res.rooms

    room: (params, done)->
      unless params?.room_id?
        done new Error('param room_id is required.')
      else
        plugin.client.getHistory params, (res, err)->
          if res?
            done null, res.messages
          else
            done err

    users: (params, done)->
      plugin.client.listUsers (res, err)->
        done err, res.users

module.exports = plugin
