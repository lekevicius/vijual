class App.Behaviors.ScaleIn extends App.Behaviors.Intro
  name: "Scale In"

  run: () ->
    @proxy.scale = @object.get('scale')
    TweenLite.from @proxy, @get('time'),
      scale: 0
      onUpdateParams: ["{self}"]
      onUpdate: (tween) => @object.set 'scale', tween.target.scale

class App.Behaviors.PopIn extends App.Behaviors.Intro
  name: "Pop In"

  run: () ->
    @proxy.scale = @object.get('scale')
    TweenLite.from @proxy, @get('time'),
      ease: 'Elastic.easeOut'
      scale: 0
      onUpdateParams: ["{self}"]
      onUpdate: (tween) => @object.set 'scale', tween.target.scale
