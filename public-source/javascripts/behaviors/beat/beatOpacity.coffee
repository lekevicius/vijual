class App.Behaviors.BeatOpacity extends App.Behaviors.Beat
  name: "Beat Opacity"

  run: () ->
    @proxy.opacity = 1
    TweenLite.to @proxy, @beatDuration(),
      opacity: 0
      onUpdateParams: ["{self}"]
      onUpdate: (tween) =>
        @object.set 'material.opacity', tween.target.opacity
