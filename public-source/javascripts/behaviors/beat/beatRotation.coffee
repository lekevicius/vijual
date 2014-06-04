class App.Behaviors.BeatRotation extends App.Behaviors.Beat
  name: "Beat Rotation"

  defaults: -> $.extend super,
    angleX: 0
    angleY: 0
    angleZ: 1
    reverse: false
  attributeControls: -> $.extend super,
    'reverse': { type: 'toggle', name: 'Reverse', pos: [2, 0, 2, 1] }
    'angleX': { type: 'angle', name: 'Angle X', pos: [6, 0, 2, 1] }
    'angleY': { type: 'angle', name: 'Angle X', pos: [8, 0, 2, 1] }
    'angleZ': { type: 'angle', name: 'Angle X', pos: [10, 0, 2, 1] }

  run: () ->
    @proxy.rotationX = @object.get('rotation.x')
    @proxy.rotationY = @object.get('rotation.y')
    @proxy.rotationZ = @object.get('rotation.z')
    reverseMultiplier = if @get('reverse') then -1 else 1

    TweenLite.to @proxy, @beatDuration(),
      rotationX: @proxy.rotationX + @get('angleX') * reverseMultiplier
      rotationY: @proxy.rotationY + @get('angleY') * reverseMultiplier
      rotationZ: @proxy.rotationZ + @get('angleZ') * reverseMultiplier
      onUpdateParams: ["{self}"]
      onUpdate: (tween) =>
        @object.set 'rotation.x', tween.target.rotationX
        @object.set 'rotation.y', tween.target.rotationY
        @object.set 'rotation.z', tween.target.rotationZ
