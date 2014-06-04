class App.Behaviors.ScaleOut extends App.Behaviors.Outro
  name: "Scale Out"

  run: () ->
    @proxy.scale = @object.get('scale')
    @startingValue = @proxy.scale
    TweenLite.to @proxy, @get('time'),
      scale: 0
      onUpdateParams: ["{self}"]
      onUpdate: (tween) => @object.set 'scale', tween.target.scale
      onComplete: (tween) => @object.set 'scale', @startingValue

class App.Behaviors.PopOut extends App.Behaviors.Outro
  name: "Pop Out"

  run: () ->
    @proxy.scale = @object.get('scale')
    @startingValue = @proxy.scale
    TweenLite.to @proxy, @get('time'),
      ease: 'Back.easeIn'
      scale: 0
      onUpdateParams: ["{self}"]
      onUpdate: (tween) => @object.set 'scale', tween.target.scale
      onComplete: (tween) => @object.set 'scale', @startingValue
