# file: src/core.coffee

debug = require('debug')('core')
fs = require 'fs'
async = require 'async'

pluginPath = "#{__dirname}/../plugins"

Person = require "#{__dirname}/person"
Message = require "#{__dirname}/message"
Plugin = require "#{__dirname}/plugin"


readPlugin = (name, done) ->
  return done null unless name[-6..] is 'coffee' or name[-2..] is 'js'
  plugin = require "#{pluginPath}/#{name}"
  plugin.init Person, Message, (err) ->
    return done err if err
    debug "plugin #{plugin.name} initialized"
    Plugin.add plugin
    done()

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
