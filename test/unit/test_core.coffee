# file: test/unit/test_core.coffee

assert = require 'assert'
core_module = require "#{__dirname}/../../src/core"

describe 'Core module', ->

  it 'should export a function', ->
    assert typeof core_module is 'function'

  describe 'Module function', ->
    it 'should return a new instance of the Core class',
      core = core_module()
      # console.log core.plugins?
