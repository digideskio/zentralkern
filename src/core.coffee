# file: src/core.coffee

pull = require 'pull-stream'

Person = require "#{__dirname}/Person"
savePerson = require "#{__dirname}/savePerson"
rss = require "#{__dirname}/../plugins/zentrale-rss"

p1 = new Person
  name: 'Krispin'

p2 = new Person
  name: 'Burkhard'

p3 = new Person
  name: 'Patrick'

# handle persons
# pull(
#   pull.values([p1, p2, p3])
#   pull.asyncMap (item, done)->
#     done null, item
#   savePerson()
# )

# handle rss items as messages
pull(
  rss('https://news.ycombinator.com/rss')
  pull.map (item)->
    if item.title?
      console.log item.title
  pull.drain()
  # pull.log()
)


module.exports =
  addPerson: (filter)->
  getPerson: (filter)->
  getAllPersons: ()->
  removePerson: (filter)->
  addMessage: (filter)->
  getMessage: (filter)->
  getAllMessages: ()->
  removeMessage: (filter)->
