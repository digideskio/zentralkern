# file: src/Message.coffee

EventEmitter = require('eventemitter2').EventEmitter2

class Message extends EventEmitter

  messages = []

  add: (data)->
    messages.push data
    @emit 'add', data
    return data

  getAll: ->
    #return clones
    return JSON.parse(JSON.stringify(messages))

module.exports = new Message
