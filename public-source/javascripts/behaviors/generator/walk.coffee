class App.Behaviors.Walk extends App.Behaviors.Generator
  name: "Walk"

  defaults: -> $.extend super,
    from: 0.001
    to: 1
    step: 0.1
    output1: 0

  attributeControls: -> $.extend super,
    'output1': { type: 'output', name: 'Result', pos: [2, 0, 1, 1] }
    'from': { type: 'exponentialTracker', name: 'From', pos: [3, 0, 3, 1] }
    'to': { type: 'exponentialTracker', name: 'To', pos: [6, 0, 3, 1] }
    'step': { type: 'exponentialTracker', name: 'Step', pos: [9, 0, 3, 1] }

  run: () ->
    stepTaken = (Math.random() * 2 * @get('step') - @get('step'))
    oldValue = @get('output1')
    if oldValue <= @get('from') then stepTaken = Math.abs(stepTaken)
    if oldValue >= @get('to') then stepTaken = Math.abs(stepTaken) * -1
    newValue = Math.min( Math.max( oldValue + stepTaken, @get('from') ), @get('to') )
    @set 'output1', newValue


class App.Behaviors.BeatWalk extends App.Behaviors.Walk
  name: "Beat Walk"
  setupListeners: -> @listenTo App.ticker, 'beat', @runIfActive
