
require("#{__dirname}/../src/core") (err, Person, Message, Plugin) ->
  return console.log 'err', err if err
  p1 = Person.add
    name: 'Krispin'

  p2 = Person.add
    name: 'Burkhard'

  p3 = Person.add
    name: 'Patrick'

# Person.on 'add', (p)->
#   console.log 'Add person:'
#   console.log p
  #

# pull = require 'pull-stream'
#
# savePerson = require "#{__dirname}/../src/savePerson"

# handle persons
# pull(
#   pull.values([p1, p2, p3])
#   pull.asyncMap (item, done)->
#     done null, item
#   savePerson()
# )
