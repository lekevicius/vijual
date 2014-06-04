class App.Behaviors.Spin3d extends App.Behaviors.Looping
  name: "Spin 3D"
  defaults: -> $.extend super,
    xSpin: 1
    ySpin: 1
    zSpin: 1

  attributeControls: -> $.extend super,
    'xSpin': { type: 'knob', name: 'Spin X', max: 10, pos: [2, 0, 3, 1] }
    'ySpin': { type: 'knob', name: 'Spin Y', max: 10, pos: [5, 0, 3, 1] }
    'zSpin': { type: 'knob', name: 'Spin Z', max: 10, pos: [8, 0, 3, 1] }

  run: (delta) ->
    newX = @object.get('rotation.x') + delta * @get('xSpin')
    newY = @object.get('rotation.y') + delta * @get('ySpin')
    newZ = @object.get('rotation.z') + delta * @get('zSpin')
    @object.set { 'rotation.x': newX, 'rotation.y': newY, 'rotation.z': newZ }
    # console.log @defaults()
