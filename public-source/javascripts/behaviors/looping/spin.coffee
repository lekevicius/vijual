class App.Behaviors.Spin extends App.Behaviors.Looping
  name: "Spin"

  defaults: -> $.extend super, { spin: 1 }
  attributeControls: -> $.extend super, { 'spin': { type: 'knob', name: 'Spin', max: 10, pos: [2, 0, 3, 1] } }

  run: (delta) ->
    newRotation = @object.get('rotation.z') + delta * @get('spin')
    @object.set 'rotation.z', newRotation
