App.WindowManager.create = (type, url, width, height) ->
  newWindow = window.open( url, '', "width=#{ width },height=#{ height },resizable=no,scrollbars=no,location=no" )
  # newWindow.App = App
  newWindow.windowId = App.utils.makeid()

  $(newWindow).on 'load', ->
    App.WindowManager.all[newWindow.windowId] = { window: newWindow, type: type }
    newWindow.onunload = ->
      w = @windowId
      App.utils.delay 60, -> App.WindowManager.destroy(w)
      App.utils.delay 150, -> App.WindowManager.destroy(w)
      App.utils.delay 300, -> App.WindowManager.destroy(w)
    _.bind newWindow.onunload, { windowId: newWindow.windowId }

App.WindowManager.destroy = (id) ->
  if App.WindowManager.all[id]?.window.closed is true
    console.log "Removing Window##{ id }"
    delete App.WindowManager.all[id]

App.WindowManager.props = -> unless 'props' in App.mainConnection.onlinePeers then App.WindowManager.create 'props', 'index.html#props', 1024, 768
App.WindowManager.scene = -> unless 'scene' in App.mainConnection.onlinePeers then App.WindowManager.create 'scene', 'index.html#scene', 1024, 748
