module.exports =
  name: 'log'
  init: (Person, Message, done) ->
    Person.on 'add', (data) ->
      console.log 'person added', data

    Message.on 'add', (data) ->
      console.log 'message added', data

    done()
