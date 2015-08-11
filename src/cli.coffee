# file: src/cli.coffee

debug = require('debug')('zentralkern:cli')
program = require 'commander'
pkg = require "#{__dirname}/../package.json"
fs = require 'fs'

zk_config = "#{process.env['HOME']}/.zk"

showPlugin = (plugin)->
  line =
    name: plugin.name
  line.version = plugin.version if plugin.version
  console.log line

showItem = (item)->
  console.log JSON.stringify item

execPlugin = (core)->
  return (name, action, params)->
    debug "exec #{action} with #{params} from plugin #{name}"
    plugin = core.plugins.getPlugin name
    unless action?
      line =
        name: plugin.name
        version: plugin.version
        api: plugin.api
      console.log line
    else
      if params?
        params = JSON.parse params
      plugin.api[action] params, (err, list)->
        if err
          console.log err
        else
          showItem item for item in list

getAllPlugins = (core)->
  return (program)->
    debug "get all installed plugins"
    core.plugins.getAllPlugins (err, plugins)=>
      showPlugin plugin for name, plugin of plugins

module.exports = (opts)->
  debug 'exports', opts

  # process.exit(1) if err
  core = require("#{__dirname}/../src/core")()

  program
    .version pkg.version

  program
    .option '-c, --config [file]', 'path to config file'

  program.parse process.argv

  if fs.existsSync(zk_config)
    opts = JSON.parse fs.readFileSync(zk_config)
  opts or= require program.config

  core.init opts, (err, core)->

    program
      .command 'plugins'
      .description 'get all installed plugins'
      .action getAllPlugins core

    program
      .command 'plugin <name> [action] [params]'
      .alias 'p'
      .description 'run plugin action with params'
      .action execPlugin core

    program.parse process.argv

    debug 'done'
