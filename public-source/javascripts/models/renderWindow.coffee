App.RenderWindow.create = ->
  newWindow = window.open( 'renderer.html', '', "width=#{ App.config.renderer.width },height=#{ App.config.renderer.height },resizable=no,scrollbars=no,location=no" )
  newWindow.App = App
  newWindow.windowId = App.utils.makeid()

  $(newWindow).on 'load', ->
    newWindowCanvasContext = $( "#renderer", newWindow.document ).get(0).getContext('2d')
    App.RenderWindow.all[newWindow.windowId] = { window: newWindow, context: newWindowCanvasContext }
    App.mainView.documentToolbar.updateButtonStates()

    newWindow.onunload = ->
      w = @windowId
      App.utils.delay 60, -> App.RenderWindow.destroy(w)
      App.utils.delay 150, -> App.RenderWindow.destroy(w)
      App.utils.delay 300, -> App.RenderWindow.destroy(w)
    _.bind newWindow.onunload, { windowId: newWindow.windowId }

App.RenderWindow.destroy = (id) ->
  if App.RenderWindow.all[id]?.window.closed is true
    console.log "Removing RenderWindow##{ id }"
    delete App.RenderWindow.all[id]
    App.mainView.documentToolbar.updateButtonStates()
