class App.Behaviors.FadeIn extends App.Behaviors.Intro
  name: "Fade In"

  run: () ->
    @proxy.opacity = @object.get('material.opacity')
    TweenLite.to @proxy, @get('time'),
      opacity: 1
      onUpdateParams: ["{self}"]
      onUpdate: (tween) => @object.set 'material.opacity', tween.target.opacity
