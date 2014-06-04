class App.Behaviors.Random extends App.Behaviors.Generator
  name: "Random"

  defaults: -> $.extend super,
    from: 0.001
    to: 1
    output1: 0

  attributeControls: -> $.extend super,
    'output1': { type: 'output', name: 'Result', pos: [2, 0, 1, 1] }
    'from': { type: 'exponentialTracker', name: 'From', pos: [3, 0, 3, 1] }
    'to': { type: 'exponentialTracker', name: 'To', pos: [6, 0, 3, 1] }

  run: () ->
    newValue = Math.random() * ( @get('to') - @get('from') ) + @get('from')
    @set 'output1', newValue


class App.Behaviors.BeatRandom extends App.Behaviors.Random
  name: "Beat Random"
  setupListeners: -> @listenTo App.ticker, 'beat', @runIfActive
