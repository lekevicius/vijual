class App.Behaviors.FadeOut extends App.Behaviors.Outro
  name: "Fade Out"

  run: () ->
    @proxy.opacity = @object.get('material.opacity')
    TweenLite.to @proxy, @get('time'),
      opacity: 0
      onUpdateParams: ["{self}"]
      onUpdate: (tween) => @object.set 'material.opacity', tween.target.opacity
