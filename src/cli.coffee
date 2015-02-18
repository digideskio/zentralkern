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
  line =
    name: name
  line.version = plugin.version() if plugin.version
  console.log line

execPlugin = (core)->
  {Plugin} = core
  # register options and commands of plugins
  plugins = Plugin.getAll()
  return (name, action, options)->
    debug "exec #{action} of plugin #{name}"
    p = Plugin.get(name)
    for c in p.commands
      if c.name() == action
        c.parent.emit action

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
      .alias 'p'
      .description 'execute action of plugin'
      .option '-p, --peppers', 'Add pepper'
      .action execPlugin core

    program.parse(process.argv)
