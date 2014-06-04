class App.Behaviors.Control3d extends App.Behaviors.Looping
  name: "3D Control"
  defaults: -> $.extend super,
    'position.x': 0
    'position.y': 0
    'position.z': 0
    'scale.x': 1
    'scale.y': 1
    'scale.z': 1
    'rotation.x': 0
    'rotation.y': 0
    'rotation.z': 0

  attributeControls: ->
    'position.x': { type: 'slider', name: 'Position.X', min: -1, max: 1, pos: [0, 0, 1, 3] }
    'scale.x': { type: 'exponentialTracker', name: 'Scale.X', pos: [1, 0, 1, 3] }
    'rotation.x': { type: 'angle', name: 'Rotation.X', pos: [2, 0, 2, 3] }
    'position.y': { type: 'slider', name: 'Position.Y', min: -1, max: 1, pos: [4, 0, 1, 3] }
    'scale.y': { type: 'exponentialTracker', name: 'Scale.Y', pos: [5, 0, 1, 3] }
    'rotation.y': { type: 'angle', name: 'Rotation.Y', pos: [6, 0, 2, 3] }
    'position.z': { type: 'slider', name: 'Position.Z', min: -1, max: 1, pos: [8, 0, 1, 3] }
    'scale.z': { type: 'exponentialTracker', name: 'Scale.Z', pos: [9, 0, 1, 3] }
    'rotation.z': { type: 'angle', name: 'Rotation.Z', pos: [10, 0, 2, 3] }

  initialize: ->
    super
    @on 'change', @updateObject, @

  updateObject: (model, options) ->
    if @object
      for item, value of model.changed
        @object.set item, value

  setupListeners: (collection) -> @listenTo collection.object, 'change', @runIfActive

  run: (model, options) ->
    watchedKeys = [ 'position.x', 'position.y', 'position.z', 'scale.x', 'scale.y', 'scale.z', 'rotation.x', 'rotation.y', 'rotation.z' ]
    for item, value of model.changed
      @set item, value if item in watchedKeys

