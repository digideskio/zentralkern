# file: src/plugin_service.coffee

debug = require('debug')('zentralkern:plugins')
EventEmitter = require('eventemitter2').EventEmitter2
fs = require 'fs'
async = require 'async'

module.exports = (opts)->
  debug 'exports'
  return new PluginService opts

class PluginService extends EventEmitter

  constructor: (opts)->
    debug 'new PluginService'
    @plugins = {}
    @initialized = false
    super
      wildcard: true
      delimiter: '::'

  init: (opts, done)->
    debug 'init'
    { @core, @plugins_path } = opts
    @loadPlugins (err, result)=>
      @initialized = true
      @emit 'error::plugins::load', err if err
      @emit 'init::plugins'
      done err, result

  loadPluginFromFile: (name, done) ->
    return done null unless name[-6..] is 'coffee' or name[-2..] is 'js'
    debug "load plugin from #{name}"
    plugin = require("#{@plugins_path}/#{name}")
    done null, plugin

  loadPluginsFromPath: (path, done)->
    debug "load plugins from #{path}"
    fs.readdir path, (err, files) =>
      return done err if err
      async.map files, @loadPluginFromFile.bind(@), (err, result)=>
        # check if item in array is plugin obj
        async.filter result, (x, cb)=>
          cb x?
        , (plugins)=>
          done null, plugins

  loadPlugins: (done)->
    debug 'loadPlugins'
    if @plugins_path?
      @loadPluginsFromPath @plugins_path, (err, plugins)=>
        return done err if err
        async.waterfall [
          (callback)=>
            @addPlugin plugin for plugin in plugins
            callback()
          (callback)=>
            async.each plugins, @initPlugin.bind(@), callback
        ], (err)=>
          done err, @
    else
      done null, @

  addPlugin: (plugin)->
    debug "add #{plugin.name}"
    plugin.attach @
    @plugins[plugin.name] = plugin
    @emit "add::#{plugin.name}", plugin
    return plugin

  # init each plugin
  initPlugin: (plugin, done)->
    debug "init #{plugin.name}"
    opts = @core.config?.plugins?[plugin.name] or {}
    plugin.init @core, opts, (err)=>
      unless err
        @emit "init::#{plugin.name}", plugin, opts
      else
        @emit "error::init::plugin::#{plugin.name}", err
      done err

  getPlugin: (name)->
    return @plugins[name]

  getAllPlugins: (done)->
    debug "get all plugins"
    done null, @plugins
