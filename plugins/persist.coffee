
debug = require('debug')('persist')

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
  init: (Person, Message, done) ->
    async.each [Person, Message], initDB, (err) ->
      return done err if err
      done()
