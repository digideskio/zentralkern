# file: src/core.coffee
debug = require('debug')('zentralkern:core')
fs = require 'fs'
async = require 'async'
EventEmitter = require('eventemitter2').EventEmitter2

class Core extends EventEmitter

  constructor: ->
    # config = require "#{__dirname}/../config/dev.json"
    super
      wildcard: true
      delimiter: '::'

    @plugin_opts =
      path: "#{__dirname}/../plugins"

    @persons = require "#{__dirname}/person_service"
    @messages = require "#{__dirname}/message_service"
    @plugins = require "#{__dirname}/plugin_service"

  init: (opts, done)->
    @plugins.init @, @plugin_opts, (err)=>
      done err, @

module.exports = (done)->
  opts = {}
  core = new Core()
  core.init opts, done
