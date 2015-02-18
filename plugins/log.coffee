debug = require('debug')('log')

module.exports =
  name: 'log'
  init: (core, config, done) ->
    { Person, Message } = core
    Person.on 'add', (data) ->
      debug 'person added', data

    Message.on 'add', (data) ->
      debug 'message added', data

    done()
