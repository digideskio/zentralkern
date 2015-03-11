# file: src/core.coffee

debug = require('debug')('zentralkern:core')
fs = require 'fs'
async = require 'async'
EventEmitter = require('eventemitter2').EventEmitter2

class Core extends EventEmitter

  constructor: (opts)->
    debug 'new Core()'
    @plugins = require("#{__dirname}/plugin_service")()
    # @persons:  require("#{__dirname}/person_service")()
    # @messages: require("#{__dirname}/message_service")()
    super
      wildcard: true
      delimiter: '::'

  init: (@config, done)->
    debug 'init'
    async.parallel
      plugins:  (cb)=>
        @plugins.init
          core: @
          plugins_path: "#{__dirname}/../plugins" # plugins path
        , (err)->
          debug err if err
          cb err

    ,(err)=>
      debug 'initialized'
      done err, @

module.exports = (opts)->
  debug 'exports'
  new Core opts
