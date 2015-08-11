
debug = require('debug')('zentralkern:plugin:persist')

Datastore = require 'nedb'
async = require 'async'

dbs = {}
initDB = (entity, cb) ->
  name = entity.constructor.name.toLowerCase()
  debug 'initDB', name

  dbs[name] = new Datastore filename: "#{__dirname}/../db/#{name}"
  dbs[name].loadDatabase (err) ->
    return cb err if err

    dbs[name].find {}, (err, items) ->
      return cb err if err
      entity.add item for item in items

      entity.on 'add', (data) ->
        dbs[name].insert data
      cb()

module.exports =
  name: 'persist'
  version: '0.0.1'
  attach: (service)->
    debug 'attach'

  init: (core, config, done) ->
    { persons, messages } = core
    debug "initialized"
    done null
    # async.each [persons, messages], initDB, (err) ->
    #   done err
