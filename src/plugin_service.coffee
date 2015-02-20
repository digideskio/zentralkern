# file: src/plugin_service.coffee
debug = require('debug')('zentralkern:plugins')
EventEmitter = require('eventemitter2').EventEmitter2

class PluginService extends EventEmitter

  plugins: {}

  init: (@core, @opts, done)->
    done()

  readPlugin: (name, done) ->
    debug "#{name}"
    return done null unless name[-6..] is 'coffee' or name[-2..] is 'js'
    plugin = require("#{pluginPath}/#{name}")
    opts = config.plugins[plugin.name]
    plugin.init core, opts, (err, pluginInterface) ->
      debug "plugin #{plugin.name} initialized"
      core.Plugin.add plugin.name, pluginInterface
      done err, pluginInterface

  loadPlugins: (done)->
    debug "try to read plugins in #{pluginPath}"
    fs.readdir pluginPath, (err, files) ->
      return done err if err
      async.each files, readPlugin, (err) ->
        return done err if err
        debug "all plugins loaded"
        done null

  add: (plugin)->
    debug "add #{plugin.name}"
    @plugins[plugin.name] = pluginInterface || {}
    @emit 'add', pluginInterface
    return pluginInterface

  get: (name)->
    return @plugins[name]

  getAll: ->
    debug "get all plugins"
    #return clones?
    return @plugins

module.exports = new PluginService()
