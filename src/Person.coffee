# file: src/Person.coffee
EventEmitter = require('eventemitter2').EventEmitter2

class Person extends EventEmitter
  persons = []

  add: (data)->
    persons.push data
    @emit 'add', data
    return data
    
module.exports = new Person
