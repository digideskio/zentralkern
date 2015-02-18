# file: src/core.coffee

debug = require('debug')('zentralkern:core')
fs = require 'fs'
async = require 'async'

pluginPath = "#{__dirname}/../plugins"

config = require "#{__dirname}/../config/dev.json"

core =
  Person: require "#{__dirname}/person"
  Message: require "#{__dirname}/message"
  Plugin: require "#{__dirname}/plugin"

readPlugin = (name, done) ->
  debug "#{name}"
  return done null unless name[-6..] is 'coffee' or name[-2..] is 'js'
  plugin = require("#{pluginPath}/#{name}")
  opts = config.plugins[plugin.name]
  plugin.init core, opts, (err, pluginInterface) ->
    debug "plugin #{plugin.name} initialized"
    core.Plugin.add plugin.name, pluginInterface
    done err, pluginInterface

loadPlugins = (done)->
  debug "try to read plugins in #{pluginPath}"
  fs.readdir pluginPath, (err, files) ->
    return done err if err
    async.each files, readPlugin, (err) ->
      return done err if err
      debug "all plugins loaded"
      done null

module.exports = (done)->
  loadPlugins (err)->
    done err, core
