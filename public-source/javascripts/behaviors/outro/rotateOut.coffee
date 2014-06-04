class App.Behaviors.RotateOut extends App.Behaviors.Outro
  name: "Rotate Out"

  defaults: -> $.extend super, { clockwise: true, angle: 1 }
  attributeControls: -> $.extend super,
    'clockwise': { type: 'toggle', name: 'Clockwise', pos: [5, 0, 2, 1] }
    'angle': { type: 'angle', name: 'angle', pos: [7, 0, 3, 1] }

  run: () ->
    @proxy.rotation = @object.get('rotation.z')
    @startingValue = @proxy.rotation
    angle = @get('angle')
    unless @get('clockwise') then angle = angle * -1
    TweenLite.to @proxy, @get('time'),
      rotation: '-=' + angle
      onUpdateParams: ["{self}"]
      onUpdate: (tween) => @object.set 'rotation.z', tween.target.rotation
      onComplete: (tween) => @object.set 'rotation.z', @startingValue
