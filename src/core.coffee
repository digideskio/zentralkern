# file: src/core.coffee


Person = require("#{__dirname}/Person")

p = new Person
  name: 'Krispin'

p.panic()
console.log p.name
