class App.VUI.SceneController extends Backbone.Model
  # For scene

  outQueue: []
  needsSending: false

  recordChanges: (properties) ->
    @outQueue.push properties
    @needsSending = true

  dumpChanges: () ->
    if @needsSending
      @needsSending = false
      returning = JSON.parse(JSON.stringify(@outQueue))
      @outQueue = []
      return returning
    else return false
