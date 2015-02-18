# file: src/plugin.coffee

EventEmitter = require('eventemitter2').EventEmitter2
debug = require('debug')('Plugin')

class Plugin extends EventEmitter

  plugins: {}

  add: (name, pluginInterface)->
    debug "add #{name}"
    @plugins[name] = pluginInterface || {}
    @emit 'add', pluginInterface
    return pluginInterface

  get: (name)->
    return @plugins[name]

  getAll: ->
    debug "get all plugins"
    #return clones?
    return @plugins

module.exports = new Plugin
