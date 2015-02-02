# file: src/cli.coffee

debug = require('debug')('zentralkern:cli')
program = require 'commander'
pkg = require "#{__dirname}/../package.json"

Plugin = null
Message = null
Person = null

loadCore = (done)->
  require("#{__dirname}/../src/core") done

showPlugin = (name, plugin)->
  console.log "#{name}"

execPlugin = (core)->
  {Plugin} = core
  return (name, action)->
    debug "exec #{action} of plugin #{name}"
    Plugin.get(name)[action]()

getAllPlugins = (core)->
  { Plugin } = core
  return (program)->
    debug "get all installed plugins"
    plugins = Plugin.getAll()
    showPlugin name, pluginInterface for name, pluginInterface of plugins


module.exports = (opts)->

  loadCore (err, core)->
    debug err if err
    process.exit(1) if err

    program
      .version(pkg.version)

    program
      .command 'plugins'
      .description 'get all installed plugins'
      .action getAllPlugins core

    program
      .command 'plugin <name> <action>'
      .option '-p, --peppers', 'Add pepper'
      .description 'execute action of plugin'
      .action execPlugin core

    program.parse(process.argv)
