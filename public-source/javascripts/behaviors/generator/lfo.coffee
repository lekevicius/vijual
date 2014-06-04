class App.Behaviors.LFO extends App.Behaviors.Generator
  name: "LFO"
  timeCount: 0

  defaults: -> $.extend super,
    output1: 0
    lowerLimit: 0.001
    upperLimit: 1
    period: 1
    inverted: false
    waveform: 0

  attributeControls: -> $.extend super,
    'output1': { type: 'output', name: 'Result', pos: [2, 0, 1, 1] }
    'lowerLimit': { type: 'exponentialTracker', name: 'From', pos: [3, 0, 3, 1] }
    'upperLimit': { type: 'exponentialTracker', name: 'To', pos: [6, 0, 3, 1] }
    'period': { type: 'exponentialTracker', name: 'Period', pos: [9, 0, 3, 1] }
    'inverted': { type: 'toggle', name: 'Inverted', pos: [0, 1, 4, 1] }
    'waveform': { type: 'switcher', name: 'Waveform', options: [ 'Sine', 'Triangle', 'Sawtooth', 'Square' ], pos: [4, 1, 8, 1] }

  run: (delta) ->
    @timeCount += delta
    # console.log @timeCount
    valueStep = (@timeCount % @get('period')) / @get('period')
    valueStep = 1 - valueStep if @get('inverted')
    scaledValue = valueStep
    switch @get('waveform')
      when 0 then scaledValue = Math.sin( valueStep * Math.PI * 2 ) / 2 + 0.5
      when 1 then scaledValue = (0.5 - Math.abs(valueStep - 0.5)) * 2
      when 2 then scaledValue = valueStep
      when 3 then scaledValue = if valueStep >= 0.5 then 1 else 0
    @set 'output1', @get('lowerLimit') + ( @get('upperLimit') - @get('lowerLimit') ) * scaledValue
