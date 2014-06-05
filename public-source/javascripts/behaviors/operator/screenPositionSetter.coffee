class App.Behaviors.ScreenPositionSetter extends App.Behaviors.Operator
  name: "Screen Position Setter"

  defaults: -> $.extend super,
    input1: 0.5
    input2: 0.5
    value1: 0.5
    value2: 0.5
    output1: [0.5, 0.5]

  attributeControls: -> $.extend super,
    'input1': { type: 'input', name: 'X', pos: [2, 0, 1, 1] }
    'input2': { type: 'input', name: 'Y', pos: [3, 0, 1, 1] }
    'output1': { type: 'output', name: 'Coordinates', dataType: 'coordinates', pos: [4, 0, 1, 1] }
    'value1': { type: 'linearTracker', name: 'X', step: 0.01, pos: [6, 0, 3, 1] }
    'value2': { type: 'linearTracker', name: 'Y', step: 0.01, pos: [9, 0, 3, 1] }

  run: () ->
    value1 = if @hasLink('input1') then @get('input1') else @get('value1')
    value2 = if @hasLink('input2') then @get('input2') else @get('value2')
    @set 'output1', [ value1, value2 ]
