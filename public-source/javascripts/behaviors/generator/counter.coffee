class App.Behaviors.Counter extends App.Behaviors.Generator
  name: "Counter"

  defaults: -> $.extend super,
    step: 1
    output1: 0

  attributeControls: -> $.extend super,
    'output1': { type: 'output', name: 'Result', pos: [2, 0, 1, 1] }
    'step': { type: 'exponentialTracker', name: 'Step', pos: [3, 0, 3, 1] }

  run: () -> @set 'output1', @get('output1') + @get('step')



class App.Behaviors.AngleRotator extends App.Behaviors.Generator
  name: "Angle Rotator"

  defaults: -> $.extend super,
    step: 0.03
    output1: 0

  attributeControls: -> $.extend super,
    'output1': { type: 'output', name: 'Result', dataType: 'angle', pos: [2, 0, 1, 1] }
    'step': { type: 'angle', name: 'Step', pos: [3, 0, 3, 1] }

  run: () -> @set 'output1', @get('output1') + @get('step')



class App.Behaviors.BeatCounter extends App.Behaviors.Counter
  name: "Beat Counter"
  setupListeners: -> @listenTo App.ticker, 'beat', @runIfActive
