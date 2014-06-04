class App.Behaviors.BeatScale extends App.Behaviors.Beat
  name: "Beat Scale"

  defaults: -> $.extend super,
    fromScale: 0.2
    toScale: 0.01
  attributeControls: -> $.extend super,
    'fromScale': { type: 'exponentialTracker', name: 'From', pos: [2, 0, 3, 1] }
    'toScale': { type: 'exponentialTracker', name: 'To', pos: [5, 0, 3, 1] }

  run: () ->
    @proxy.scale = @get('fromScale')
    TweenLite.to @proxy, @beatDuration(),
      scale: @get('toScale')
      onUpdateParams: ["{self}"]
      onUpdate: (tween) => @object.set 'scale', tween.target.scale
