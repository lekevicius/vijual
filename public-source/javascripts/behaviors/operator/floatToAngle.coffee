class App.Behaviors.FloatToAngle extends App.Behaviors.Operator
  name: "Float to Angle"

  defaults: -> $.extend super,
    input1: 0
    output1: 0

  attributeControls: -> $.extend super,
    'input1': { type: 'input', name: 'Number', pos: [2, 0, 1, 1] }
    'output1': { type: 'output', name: 'Result', dataType: 'angle', pos: [3, 0, 1, 1] }

  run: () -> @set 'output1', App.utils.radians @get('input1')
