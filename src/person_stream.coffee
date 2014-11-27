# file: src/person_stream.coffee

es = require 'event-stream'

persons = ({ id: i, name: "person #{i}" } for i in [1..3])

reader = es.readArray persons

r = reader.pipe es.stringify()
r.pipe process.stdout

r
  .pipe(es.parse())
  .pipe(es.map (data, cb)->
    cb null, "Hello #{data.name}!"
  )
  .pipe process.stdout
