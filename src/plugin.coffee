# file: src/plugin.coffee

EventEmitter = require('eventemitter2').EventEmitter2

class Plugin extends EventEmitter

  plugins = {}

  add: (plugin)->
    plugins[plugin.name] = plugin
    @emit 'add', plugin
    return plugin

  get: (name)->
    return plugins[name]

  getAll: ->
    #return clones
    return JSON.parse(JSON.stringify(plugins))

module.exports = new Plugin
