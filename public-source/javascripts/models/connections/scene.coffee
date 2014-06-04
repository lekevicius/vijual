class App.Connections.Scene extends App.Connections.Base
  protocol: 'scene'

  onOpen: (e) =>
    # @listenTo App.ticker, 'frame', @sendDataUpdates
    App.utils.every Math.round(1000 / @connectionRate), @sendDataUpdates
    super

  main_drawCanvas: (data) =>
    img = new Image
    img.src = data.dataURL
    img.onload = ->
      App.sceneView.sceneCanvasContext.drawImage @, 0, 0, App.config.renderer.lowWidth, App.config.renderer.lowHeight, 0, 0, App.config.renderer.lowDisplayWidth, App.config.renderer.lowDisplayHeight
    # console.log data.dataURL.length

  main_setObject: (data) =>
    if data
      App.sceneView.objectPropeties = data
      App.sceneView.updateInteractionObject()
      App.sceneView.$interactionObject.show()
    else
      App.sceneView.$interactionObject.hide()

  sendDataUpdates: =>
    if 'main' in @onlinePeers
      changes = App.sceneController.dumpChanges()
      @sendDocument 'main', 'updateSceneObject', changes if changes
