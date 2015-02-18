# file example/plugins.coffee

EventEmitter = require('eventemitter2').EventEmitter2


class PluginService extends EventEmitter

  constructor: ->
    super
      wildcard: true
      delimiter: '::'

  add: (plugin)->
    plugin.attach @
    @emit "add::#{plugin.name}", plugin

  init: (plugin, opts)->
    plugin.init opts, (err, plugin)=>
      console.log err if err
      unless err?
        @emit "init::#{plugin.name}", plugin, opts

  remove: (plugin)->
    plugin.detach @
    @emit "remove::#{plugin.name}", plugin


class Plugin extends EventEmitter

  constructor: (@name)->

  attach: (service)->
    console.log "setup #{@name}"

    if @name == 'plugin 3'
      service.on 'init::plugin 1', (plugin, opts)=>
        console.log "#{@name} listens on init #{plugin.name} with #{JSON.stringify opts}"

  init: (opts, done)->
    console.log "init #{@name} with #{JSON.stringify opts}"
    if @name == 'plugin 1'
      setTimeout (=> done null, @), 2000
    else
      done null, @

  detach: ->
    console.log "teardown #{@name}"

# plugins
p1 = new Plugin 'plugin 1'
p2 = new Plugin 'plugin 2'
p3 = new Plugin 'plugin 3'
plugins = [p1, p2, p3]

# opts
o1 = a: 1
o2 = b: 2
o3 = c: 3
opts = [o1, o2, o3]

ps = new PluginService

# ps.onAny (x)->
#   console.log "x"

ps.add plugin for plugin in plugins
ps.init plugin, opts[i] for plugin, i in plugins
ps.remove plugin for plugin in plugins
