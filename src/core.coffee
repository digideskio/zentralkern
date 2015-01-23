# file: src/core.coffee
fs = require 'fs'
async = require 'async'

Person = require "#{__dirname}/person"
Message = require "#{__dirname}/message"

plugins = {}
path = "#{__dirname}/../plugins"
done = {}

# get in the plugins
fs.readdir path, (err, files) ->
  return console.log 'err', err if err

  readPlugin = (name, cb) ->
    return cb() unless name[-6..] is 'coffee' or name[-2..] is 'js'

    plugin = require "#{path}/#{name}"
    plugin.init Person, Message, (err, pluginInterface) ->
      return cb err if err

      console.log "plugin #{plugin.name} initialized"
      plugins[plugin.name] = pluginInterface || {}
      cb()

  async.each files, readPlugin, (err) ->
    return done err if err

    console.log 'plugins loaded'
    done null, Person, Message, (name) -> return plugins[name]

module.exports = (cb) ->
  done = cb
