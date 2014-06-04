class App.Behaviors.PulseScale extends App.Behaviors.Looping
  name: "Pulse Scale"
  counter: 0

  defaults: -> $.extend super,
    period: 10
    fromScale: 0.1
    toScale: 0.2
  attributeControls: -> $.extend super,
    'period': { type: 'knob', name: 'Period', max: 20, pos: [3, 0, 3, 1] }
    'fromScale': { type: 'exponentialTracker', name: 'From', pos: [6, 0, 3, 1] }
    'toScale': { type: 'exponentialTracker', name: 'To', pos: [9, 0, 3, 1] }

  run: (delta) ->
    @counter += delta * (20 / @get('period'))
    position =  Math.sin( @counter ) / 2 + 0.5
    newScale = position * @get('toScale') + (1 - position) * @get('fromScale')

    @object.set 'scale', newScale
