# file: src/core.coffee

debug = require('debug')('core')
fs = require 'fs'
async = require 'async'

pluginPath = "#{__dirname}/../plugins"

Person = require "#{__dirname}/person"
Message = require "#{__dirname}/message"
Plugin = require "#{__dirname}/plugin"

readPlugin = (name, done) ->
  debug "#{name}"
  return done null unless name[-6..] is 'coffee' or name[-2..] is 'js'
  plugin = require "#{pluginPath}/#{name}"
  plugin.init Person, Message, (err, pluginInterface) ->
    debug "plugin #{plugin.name} initialized"
    Plugin.add plugin.name, pluginInterface
    done err, pluginInterface

loadPlugins = (done)->
  debug "try to read plugins in #{pluginPath}"
  fs.readdir pluginPath, (err, files) ->
    return done err if err
    async.each files, readPlugin, (err) ->
      return done err if err
      debug "all plugins loaded"
      done null

module.exports = (done) ->
  loadPlugins (err)->
    done err, {Plugin, Message, Person}
