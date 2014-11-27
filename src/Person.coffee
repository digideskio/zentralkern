# file: src/Person.coffee

StateMachine = require('javascript-state-machine').StateMachine

class Person

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

module.exports = Person
