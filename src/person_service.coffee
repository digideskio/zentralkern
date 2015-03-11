# file: src/person_service.coffee
debug = require('debug')('zentralkern:persons')
EventEmitter = require('eventemitter2').EventEmitter2

class PersonService extends EventEmitter

  persons = []

  add: (data)->
    persons.push data
    @emit 'add', data
    return data

module.exports = (opts, done)->
  debug 'exports', opts
  done null, new PersonService opts
