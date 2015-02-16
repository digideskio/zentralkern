# file: plugins/hipchat.coffee

hipchat = require 'node-hipchat'
Table = require 'cli-table'
charm = require('charm')()
moment = require 'moment'
colors = require 'colors'

charm.pipe process.stdout
# charm.reset()

client = null

program = require 'commander'
program.name = 'hipchat'
program
  .version '0.0.1'
  .option '-a, --api-key <api_key>', 'Required. The HipChat admin API key'

getClient = (api_key)->
  unless client?
    client = new hipchat api_key
  return client

getHistory = (params, watch)->
  client = getClient program.apiKey
  client.getHistory params, (data)->
    if data?
      table = new Table
        head: ['From', 'Message', 'When', 'Date']
      for msg, i in data.messages
        table.push [ msg.from.name, msg.message, moment(msg.date).fromNow(), msg.date]
      charm.reset() if watch
      console.log table.toString()

program.init = (core, config, done)->
  client = getClient config.api_key
  done null, program

program.command 'rooms'
  .description 'list all available rooms'
  .action ->
    client = getClient program.apiKey
    client.listRooms (data)->
      table = new Table
        head: ['Room ID', 'Name', 'Topic']
      for room in data.rooms
        table.push [ room.room_id, room.name, room.topic ]
      console.log table.toString()

program.command 'history <room_id>'
  .description 'show history of specific room'
  .alias 'room'
  .option '-d, --date [date]', 'Optional. The date to fetch history for in YYYY-MM-DD format.'
  .option '-w, --watch', 'Optional. Show the history but watch for changes and refresh.'
  .action (room_id, opts)->
    client = getClient program.apiKey
    params =
      room_id: room_id
    params.date = opts.date if opts.date?
    getHistory params, opts.watch
    if opts.watch
      charm.cursor false
      setInterval ->
        getHistory params, true
      , 5000

if module.parent
  module.exports = program
else
  process.on 'SIGINT', ->
    charm.cursor true
    process.exit 0

  program.parse process.argv
  unless program.apiKey?
    program.help()
