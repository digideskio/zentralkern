# file: src/savePerson.coffee

pull = require 'pull-stream'

module.exports = pull.Sink (read)->
  next = (end, data)->
    return if end
    console.log 'SAVE!'
    console.log data
    read null, next
  read null, next
