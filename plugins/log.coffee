debug = require('debug')('log')

module.exports =
  name: 'log'
  init: (Person, Message, done) ->
    Person.on 'add', (data) ->
      debug 'person added', data

    Message.on 'add', (data) ->
      debug 'message added', data

    done()
