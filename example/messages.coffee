# file: example/messages.coffee

rss = require "#{__dirname}/../plugins/zentrale-rss"
pull = require 'pull-stream'
{Message} = require "#{__dirname}/../src/core"

i = 1
Message.on 'add', (msg)->
  console.log "#{i++}. #{msg.title}"

# handle rss items as new messages
pull(
  rss('https://news.ycombinator.com/rss')
  pull.map (item)->
    if item.title?
      Message.add item
  pull.drain()
)
