# file: src/cli.coffee

program = require 'commander'
pkg = require "#{__dirname}/../package.json"

getAllPlugins = (x)->
  console.log 'installed plugins'

module.exports = (opts)->
  program
    .version(pkg.version)

  program
    .command 'plugins' 
    .description 'get all installed plugins'
    .action getAllPlugins

  program.parse(process.argv)

