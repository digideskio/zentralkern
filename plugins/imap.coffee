debug = require('debug')('zentralkern:plugin:imap')

Imap = require 'imap'
Q = require 'q'

plugin =
  name: 'imap'
  version: '0.0.1'
  attach: (service)->
    debug 'attach'
  init: (core, config, done) ->
    debug 'init', config
    con = plugin.api.connect config
    con.catch (err)->
      console.log err
    con.then (inbox)->
      debug "initialized"
      plugin.api.unread = ->
        inbox.unread().then (messages) ->
          console.log messages
          plugin.imap.end()
      done null
  api:
    connect: (data) ->
      debug "try to connect..."
      plugin.imap = imap = new Imap data
      deferred = Q.defer()

      imap.once 'ready', ->
        imap.openBox 'INBOX', true, (err, box) ->
          return deferred.reject err if err
          deferred.resolve
            unread: unread.bind(@, imap)
            get: get.bind(@, imap)
            messages: box.messages

      imap.once 'error', deferred.reject

      imap.connect()
      return deferred.promise

    readMessage: (msg, number) ->
      deferred = Q.defer()
      message = {}

      msg.on 'body', (stream, info) ->
        buffer = ''

        stream.on 'data', (chunk) ->
          buffer += chunk.toString 'utf8'

        stream.once 'end', ->
          if info.which is 'TEXT'
            message['body'] = buffer
          else
            message['header'] = Imap.parseHeader buffer

      msg.once 'attributes', (attrs) ->
        message['attributes'] = attrs

      msg.once 'end', ->
        deferred.resolve message

      return deferred.promise

getMessages = (imap, deferred, selector) ->
  messages = []

  fetch = imap.seq.fetch selector, bodies: ['HEADER.FIELDS (FROM TO SUBJECT DATE)', 'TEXT']
  fetch.on 'message', (msg, seqno) ->
    messages.push readMessage(msg, seqno)

  fetch.once 'error', deferred.reject

  fetch.once 'end', ->
    Q.all(messages).then deferred.resolve, deferred.reject

unread = (imap, since = new Date()) ->
  deferred = Q.defer()
  imap.seq.search ['UNSEEN', ['SINCE', since] ], (err, results) ->
    return deferred.reject err if err
    getMessages imap, deferred, results

  return deferred.promise

get = (imap, offset = 0, length = 1) ->
  deferred = Q.defer()
  getMessages imap, deferred, "#{offset + 1}:#{length}"

  return deferred.promise



module.exports = plugin
