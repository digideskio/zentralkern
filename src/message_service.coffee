# file: src/message_service.coffee
debug = require('debug')('zentralkern:messages')
EventEmitter = require('eventemitter2').EventEmitter2

class MessageService extends EventEmitter

  messages = []

  add: (data)->
    messages.push data
    @emit 'add', data
    return data

  getAll: ->
    #return clones
    return JSON.parse(JSON.stringify(messages))

module.exports = (opts, done)->
  done null, new MessageService opts
