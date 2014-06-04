Mousetrap.bind 'command+shift+/', (e) ->
  e.preventDefault()
  gui = require 'nw.gui'
  gui.Window.get().showDevTools() if isNodeWebkit
  return false

# gui.Window.get().showDevTools()
