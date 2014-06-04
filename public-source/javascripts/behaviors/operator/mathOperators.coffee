class App.Behaviors.Sum extends App.Behaviors.Operator
  name: "Sum"

  defaults: -> $.extend super,
    input1: 1
    input2: 1
    value1: 1
    value2: 1
    output1: 2

  attributeControls: -> $.extend super,
    'input1': { type: 'input', name: 'Number', pos: [2, 0, 1, 1] }
    'input2': { type: 'input', name: 'Number', pos: [3, 0, 1, 1] }
    'output1': { type: 'output', name: 'Result', pos: [4, 0, 1, 1] }
    'value1': { type: 'exponentialTracker', name: 'Value 1', pos: [6, 0, 3, 1] }
    'value2': { type: 'exponentialTracker', name: 'Value 2', pos: [9, 0, 3, 1] }

  run: () ->
    value1 = if @hasLink('input1') then @get('input1') else @get('value1')
    value2 = if @hasLink('input2') then @get('input2') else @get('value2')
    @set 'output1', value1 + value2



class App.Behaviors.Subtract extends App.Behaviors.Operator
  name: "Subtract"

  defaults: -> $.extend super,
    input1: 1
    input2: 1
    value1: 1
    value2: 1
    output1: 2

  attributeControls: -> $.extend super,
    'input1': { type: 'input', name: 'Number', pos: [2, 0, 1, 1] }
    'input2': { type: 'input', name: 'Number', pos: [3, 0, 1, 1] }
    'output1': { type: 'output', name: 'Result', pos: [4, 0, 1, 1] }
    'value1': { type: 'exponentialTracker', name: 'Value 1', pos: [6, 0, 3, 1] }
    'value2': { type: 'exponentialTracker', name: 'Value 2', pos: [9, 0, 3, 1] }

  run: () ->
    value1 = if @hasLink('input1') then @get('input1') else @get('value1')
    value2 = if @hasLink('input2') then @get('input2') else @get('value2')
    @set 'output1', value1 - value2



class App.Behaviors.Multiply extends App.Behaviors.Operator
  name: "Multiply"

  defaults: -> $.extend super,
    input1: 1
    input2: 1
    value1: 1
    value2: 1
    output1: 2

  attributeControls: -> $.extend super,
    'input1': { type: 'input', name: 'Number', pos: [2, 0, 1, 1] }
    'input2': { type: 'input', name: 'Number', pos: [3, 0, 1, 1] }
    'output1': { type: 'output', name: 'Result', pos: [4, 0, 1, 1] }
    'value1': { type: 'exponentialTracker', name: 'Value 1', pos: [6, 0, 3, 1] }
    'value2': { type: 'exponentialTracker', name: 'Value 2', pos: [9, 0, 3, 1] }

  run: () ->
    value1 = if @hasLink('input1') then @get('input1') else @get('value1')
    value2 = if @hasLink('input2') then @get('input2') else @get('value2')
    @set 'output1', value1 * value2



class App.Behaviors.Divide extends App.Behaviors.Operator
  name: "Divide"

  defaults: -> $.extend super,
    input1: 1
    input2: 1
    value1: 1
    value2: 1
    output1: 2

  attributeControls: -> $.extend super,
    'input1': { type: 'input', name: 'Number', pos: [2, 0, 1, 1] }
    'input2': { type: 'input', name: 'Number', pos: [3, 0, 1, 1] }
    'output1': { type: 'output', name: 'Result', pos: [4, 0, 1, 1] }
    'value1': { type: 'exponentialTracker', name: 'Value 1', pos: [6, 0, 3, 1] }
    'value2': { type: 'exponentialTracker', name: 'Value 2', pos: [9, 0, 3, 1] }

  run: () ->
    value1 = if @hasLink('input1') then @get('input1') else @get('value1')
    value2 = if @hasLink('input2') then @get('input2') else @get('value2')
    @set 'output1', value1 / value2



class App.Behaviors.Modulus extends App.Behaviors.Operator
  name: "Modulus"

  defaults: -> $.extend super,
    input1: 1
    input2: 1
    value1: 1
    value2: 1
    output1: 2

  attributeControls: -> $.extend super,
    'input1': { type: 'input', name: 'Number', pos: [2, 0, 1, 1] }
    'input2': { type: 'input', name: 'Number', pos: [3, 0, 1, 1] }
    'output1': { type: 'output', name: 'Result', pos: [4, 0, 1, 1] }
    'value1': { type: 'exponentialTracker', name: 'Value 1', pos: [6, 0, 3, 1] }
    'value2': { type: 'exponentialTracker', name: 'Value 2', pos: [9, 0, 3, 1] }

  run: () ->
    value1 = if @hasLink('input1') then @get('input1') else @get('value1')
    value2 = if @hasLink('input2') then @get('input2') else @get('value2')
    @set 'output1', value1 % value2
