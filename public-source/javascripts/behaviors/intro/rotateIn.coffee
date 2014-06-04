class App.Behaviors.RotateIn extends App.Behaviors.Intro
  name: "Rotate In"

  defaults: -> $.extend super, { clockwise: true, angle: 1 }
  attributeControls: -> $.extend super,
    'clockwise': { type: 'toggle', name: 'Clockwise', pos: [5, 0, 2, 1] }
    'angle': { type: 'angle', name: 'angle', pos: [7, 0, 3, 1] }

  run: () ->
    @proxy.rotation = @object.get('rotation.z')
    angle = @get('angle')
    if @get('clockwise') then angle = angle * -1
    TweenLite.from @proxy, @get('time'),
      rotation: '-=' + angle
      onUpdateParams: ["{self}"]
      onUpdate: (tween) => @object.set 'rotation.z', tween.target.rotation
