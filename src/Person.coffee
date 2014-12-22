# file: src/Person.coffee

StateMachine = require('javascript-state-machine').StateMachine

EventEmitter = require('eventemitter2').EventEmitter2

class Person extends EventEmitter

  persons = []

  add: (data)->
    persons.push data
    @emit 'add', data
    return data

  constructor: (data)->
    @[key] = value for key, value of data
    @startup()

  onpanic: (event, from, to)->
    console.log event

StateMachine.create
  target: Person.prototype
  events: [
    { name: 'startup', from: 'none', to: 'green' }
    { name: 'warn', from: 'green', to: 'yellow' }
    { name: 'panic', from: 'yellow', to: 'red' }
    { name: 'panic', from: 'green', to: 'red' }
    { name: 'calm', from: 'red', to: 'yellow' }
    { name: 'clear', from: 'yellow', to: 'green' }
  ]

module.exports = new Person
