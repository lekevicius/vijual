class App.VUI.ControlSurfaceController extends Backbone.Model
  # For props

  outQueue: []

  recordChange: (id, key, value) -> @outQueue.push { id: id, key: key, value: value }

  dumpChanges: () ->
    queue = JSON.stringify @outQueue
    @outQueue = []
    return JSON.parse queue
