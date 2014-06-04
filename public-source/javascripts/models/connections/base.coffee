class App.Connections.Base extends Backbone.Model

  onlinePeers: []
  connectionRate: 30

  initialize: (attributes, options) ->
    @protocol ?= 'base'
    @connection = new WebSocket("ws://#{ App.MasterHostname }:9495/", @protocol)
    @connection.onopen = @onOpen
    @connection.onclose = @onClose
    @connection.onmessage = @onMessage
    @connection.onerror = @onError

  send: (message) =>
    @connection.send message
  sendDocument: (to, type, doc='') =>
    @connection.send JSON.stringify({
      from: @protocol
      to: to
      type: type
      doc: doc
    })
  close: =>
    @connection.close()

  onMessage: (e) =>
    message = JSON.parse e.data
    fromType = "#{ message.from }_#{ message.type }"
    @[fromType](message.doc) if _.isFunction @[fromType]
    @trigger 'message', message
    # console.log 'Message received', e.data
  onOpen: (e) =>
    @trigger 'open', e
    @sendDocument 'server', 'whosOnline'
    # console.log 'Connection opened', @protocol
  onClose: (e) =>
    @trigger 'close', e
    console.log 'Connection closed', @protocol
  onError: (e) =>
    @trigger 'error', e.data
    console.log "Error!", e.data, @protocol

  server_currentlyOnline: (peers) =>
    # console.log "Currently online:", peers
    @onlinePeers = peers
  server_cameOnline: (who) =>
    # console.log "#{ who } came online."
    @onlinePeers.push who
  server_wentOffline: (who) =>
    # console.log "#{ who } went offline."
    @onlinePeers = _.without @onlinePeers, who
  isOnline: (peer) => ( peer in @onlinePeers )
