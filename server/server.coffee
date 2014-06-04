WebSocketServer = require('websocket').server
http = require('http')
_ = require('underscore')

LibraryIndexer = require './libraryIndexer'
console.log LibraryIndexer
libraryIndexer = new LibraryIndexer(__dirname + '/../../library/')
libraryIndex = libraryIndexer.read()

class ServerConnectionManager
  socketConnections: {}

  constructor: (port) ->
    @server = http.createServer()
    @server.listen 9495
    @webSocketServer = new WebSocketServer
      httpServer: @server
      autoAcceptConnections: true
    @webSocketServer.on 'connect', @addConnection

  addConnection: (connection) =>
    console.log "+++ [ #{ (new Date()) } ] #{ connection.protocol } at #{ connection.remoteAddress } connected."
    @sendDocument protocol, 'cameOnline', connection.protocol for protocol of @socketConnections
    @socketConnections[connection.protocol].close() if @socketConnections[connection.protocol]
    @socketConnections[connection.protocol] = connection
    connection.on 'message', @handleMessage
    connection.on 'close', @closeConnection

  sendDocument: (to, type, doc='') =>
    @socketConnections[to].sendUTF JSON.stringify({
      from: 'server'
      to: to
      type: type
      doc: doc
    })
    console.log "Server sent #{ type } to #{ to }"

  handleMessage: (message) =>
    if message.type is 'utf8'
      # console.log 'Received Message: ' + message.utf8Data
      messageDocument = JSON.parse(message.utf8Data)
      to = messageDocument.to
      if to is 'server'
        fromType = "#{ messageDocument.type }"
        @[fromType](messageDocument.from, messageDocument.doc) if _.isFunction @[fromType]
      else if @socketConnections[to]
        # console.log message.utf8Data
        @socketConnections[to].sendUTF message.utf8Data
        # console.log "Sent message from #{ messageDocument['from'] } to #{ messageDocument['to'] }"
      else
        console.log "Sorry, no #{ messageDocument['to'] } connection yet."
    # else if message.type is 'binary' then connection.sendBytes message.binaryData

  whosOnline: (backTo, doc) => @sendDocument backTo, 'currentlyOnline', _.keys(@socketConnections)

  getLibraryIndex: (backTo, doc) => @sendDocument backTo, 'libraryIndex', libraryIndex

  closeConnection: (reasonCode, description) ->
    socketConnections = global.serverConnectionManager.socketConnections
    delete socketConnections[@protocol]
    global.serverConnectionManager.sendDocument p, 'wentOffline', @protocol for p of socketConnections
    console.log "--- [ #{ (new Date()) } ] #{ @protocol } at #{ @remoteAddress } disconnected"

global.serverConnectionManager = new ServerConnectionManager 9495
module.exports = global.serverConnectionManager

# WebSocketClient = require('websocket').client
# client = new WebSocketClient()
# client.on 'connectFailed', (error) -> console.log 'Connect Error: ' + error.toString()
# client.on 'connect', (connection) ->
#     console.log 'WebSocket client connected'
#     connection.on 'error', (error) -> console.log "Connection Error: " + error.toString()
#     connection.on 'close', -> console.log 'echo-protocol Connection Closed'
#     connection.on 'message', (message) ->
#       if message.type is 'utf8'
#         console.log "Received: '" + message.utf8Data + "'"

#     sendNumber = () ->
#       if connection.connected
#         number = Math.round Math.random() * 0xFFFFFF
#         console.log "Generated: #{ number.toString() }"
#         connection.sendUTF number.toString()
#         # setTimeout sendNumber, 1000
#     sendNumber()
# client.connect 'ws://localhost:9495/', 'echo-protocol'
