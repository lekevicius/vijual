App.data.demoPanel = [
  {
    name: 'Gradient Color From'
    uuid: 'fake'
    color: 3
    controls: [
      {
        type: 'slider'
        color: '#d31f1f'
        name: 'Red'
        value: 0.31
        pos: [0, 0, 1, 3]
        uuid: 'fakeUUID'
        key: 'red'
      }
      {
        type: 'slider'
        color: '#30c429'
        name: 'Green'
        value: 0.61
        pos: [1, 0, 1, 3]
        uuid: 'fakeUUID'
        key: 'green'
      }
      {
        type: 'slider'
        color: '#1f71cd'
        name: 'Blue'
        value: 0.92
        pos: [2, 0, 1, 3]
        uuid: 'fakeUUID'
        key: 'blue'
      }
      {
        type: 'integerSlider'
        color: '#cc8700'
        name: 'Hue'
        value: 230
        max: 360
        pos: [3, 0, 3, 1]
        uuid: 'fakeUUID'
        key: 'hue'
      }
      {
        type: 'slider'
        color: '#aaa'
        name: 'Satur'
        value: 0.5
        pos: [3, 1, 3, 1]
        uuid: 'fakeUUID'
        key: 'saturation'
      }
      {
        type: 'slider'
        color: '#aaa'
        name: 'Bright'
        value: 0.5
        pos: [3, 2, 3, 1]
        uuid: 'fakeUUID'
        key: 'brightness'
      }
      {
        type: 'color'
        name: 'Color'
        value: '#8abd28'
        pos: [6, 0, 4, 3]
        uuid: 'fakeUUID'
        key: 'color'
      }
      {
        type: 'switcher'
        name: 'PickerType'
        options: [ 'Picker', 'Swatch' ]
        value: 0
        pos: [10, 0, 2, 1]
        uuid: 'fakeUUID'
        key: 'swatcher'
      }
      {
        type: 'toggle'
        name: 'Invert'
        value: true
        pos: [10, 1, 1, 2]
        uuid: 'fakeUUID'
        key: 'inversion'
      }
      {
        type: 'triggerButton'
        name: 'Save'
        pos: [11, 1, 1, 1]
        uuid: 'fakeUUID'
        key: 'save'
      }
      {
        type: 'holdButton'
        name: 'Pulse'
        pos: [11, 2, 1, 1]
        uuid: 'fakeUUID'
        key: 'pulse'
      }
    ]
  }

  {
    name: 'Behavior Properties'
    uuid: 'faker'
    color: 16
    controls: [
      {
        type: 'knob'
        name: 'Activity'
        value: 0.6
        pos: [0, 0, 2, 3]
        uuid: 'fakeUUID'
        key: 'activity'
      }
      {
        type: 'angle'
        name: 'Angle'
        value: 2.1
        pos: [2, 0, 2, 3]
        uuid: 'fakeUUID'
        key: 'angle'
      }
      {
        type: 'knob'
        name: 'Fun'
        value: 0.8
        pos: [4, 0, 1, 2]
        uuid: 'fakeUUID'
        key: 'fun'
      }
      {
        type: 'angle'
        name: 'Sad'
        value: 1.2
        pos: [5, 0, 1, 2]
        uuid: 'fakeUUID'
        key: 'sadness'
      }
      {
        type: 'linearTracker'
        name: 'Pos.Z'
        value: 110
        pos: [6, 0, 1, 2]
        uuid: 'fakeUUID'
        key: 'position.z'
      }
      {
        type: 'linearTracker'
        name: 'Pos.X'
        value: 0.3
        pos: [4, 2, 3, 1]
        uuid: 'fakeUUID'
        key: 'position.x'
      }
      {
        type: 'exponentialTracker'
        name: 'Pos.Y'
        value: 12
        pos: [7, 0, 1, 3]
        uuid: 'fakeUUID'
        key: 'position.y'
      }
      {
        type: 'list'
        name: 'Wave Function'
        options: [ 'Sine', 'Sawtooth', 'Square', 'Triangle', 'Noise' ]
        value: 1
        pos: [8, 0, 4, 3]
        uuid: 'fakeUUID'
        key: 'wave'
      }
      {
        type: 'area'
        name: 'Head'
        value: [0.2, 0.3]
        pos: [0, 3, 4, 3]
        uuid: 'fakeUUID'
        key: 'head'
      }
      {
        type: 'stepper'
        name: 'Corners'
        value: 2
        pos: [4, 3, 2, 1]
        uuid: 'fakeUUID'
        key: 'corners'
      }
      {
        type: 'stepper'
        name: 'Points'
        value: 10
        step: 10
        pos: [4, 4, 1, 2]
        uuid: 'fakeUUID'
        key: 'hogwarts'
      }
      {
        type: 'switcher'
        name: 'Move'
        options: [ 'Forward', 'Stop', 'Backward' ]
        value: 0
        pos: [5, 4, 1, 2]
        uuid: 'fakeUUID'
        key: 'movetype'
      }
      {
        type: 'integerSlider'
        name: 'Right Arm'
        value: 13
        min: 10
        max: 30
        pos: [6, 3, 1, 3]
        uuid: 'fakeUUID'
        key: 'rightarm'
      }
      {
        type: 'slider'
        name: 'Left Arm'
        step: 0.2
        value: 0.6
        pos: [7, 3, 1, 3]
        uuid: 'fakeUUID'
        key: 'leftarm'
      }
      {
        type: 'area'
        name: 'Torso'
        value: [1, 0.23]
        pos: [8, 3, 4, 2]
        uuid: 'fakeUUID'
        key: 'torso'
      }
      {
        type: 'text'
        name: 'Hello'
        value: "Boom"
        pos: [8, 5, 4, 1]
        uuid: 'fakeUUID'
        key: 'hello'
      }
    ]
  }







  {
    name: 'Media Things'
    uuid: 'faker'
    color: 20
    controls: [
      {
        type: 'media'
        name: 'Image'
        options: ["European-Union.png", "IMG_3381.JPG", "IMG_3392.JPG", "IMG_3393.JPG", "IMG_3402.JPG", "colors-gather.jpg", "ic_action_call.png", "play-store.png"]
        value: 'play-store.png'
        pos: [0, 0, 4, 3]
        uuid: 'fakeUUID'
        key: 'wave'
      }
      {
        type: 'knob'
        name: 'Activity'
        value: 0.6
        pos: [8, 0, 2, 2]
        uuid: 'fakeUUID'
        key: 'activity'
      }
      {
        type: 'knob'
        name: 'Angle'
        value: 0.1
        pos: [10, 0, 2, 2]
        uuid: 'fakeUUID'
        key: 'angle'
      }
      {
        type: 'area'
        name: 'Head'
        value: [0.2, 0.3]
        pos: [4, 0, 4, 3]
        uuid: 'fakeUUID'
        key: 'head'
      }
      {
        type: 'input'
        name: 'Input 1'
        value: 0.4
        dataType: 'float'
        pos: [8, 2, 1, 1]
        uuid: 'fakeUUID'
        key: 'input1'
      }
      {
        type: 'input'
        name: 'Input 2'
        value: 21
        dataType: 'integer'
        pos: [9, 2, 1, 1]
        uuid: 'fakeUUID'
        key: 'input2'
      }
      {
        type: 'output'
        name: 'Output 1'
        value: 21.1
        dataType: 'float'
        pos: [10, 2, 1, 1]
        uuid: 'fakeUUID'
        key: 'output1'
      }
      {
        type: 'output'
        name: 'Output 2'
        value: 12
        dataType: 'integer'
        pos: [11, 2, 1, 1]
        uuid: 'fakeUUID'
        key: 'output2'
      }
    ]
  }
]
