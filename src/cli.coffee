# file: src/cli.coffee

debug = require('debug')('cli')
program = require 'commander'
pkg = require "#{__dirname}/../package.json"

Plugin = null
Message = null
Person = null

loadCore = (done)->
  require("#{__dirname}/../src/core") done

showPlugin = (plugin)->
  console.log "#{plugin.name}"

getAllPlugins = (core)->
  { Plugin } = core
  return (program)->
    debug "get all installed plugins"
    plugins = Plugin.getAll()
    showPlugin plugin for name, plugin of plugins


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

    program.parse(process.argv)
