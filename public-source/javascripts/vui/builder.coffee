App.VUI.typeClasses =
  'slider': App.VUI.Slider
  'integerSlider': App.VUI.IntegerSlider
  'toggle': App.VUI.Toggle
  'holdButton': App.VUI.HoldButton
  'triggerButton': App.VUI.TriggerButton
  'area': App.VUI.Area
  'knob': App.VUI.Knob
  'angle': App.VUI.Angle
  'linearTracker': App.VUI.LinearTracker
  'exponentialTracker': App.VUI.ExponentialTracker
  'switcher': App.VUI.Switcher
  'list': App.VUI.List
  'media': App.VUI.Media
  'color': App.VUI.Color
  'stepper': App.VUI.Stepper
  'text': App.VUI.Text
  'textarea': App.VUI.TextArea
  'input': App.VUI.Input
  'output': App.VUI.Output

App.VUI.Builder = (layout) ->
  App.VUI.controls = {}
  @$el = $('<div />')

  for group in layout
    continue unless group.controls.length
    groupHeight = _.max _.map(group.controls, (control) -> control.pos[1] + control.pos[3])
    groupColor = App.colors[group.color]
    $group = $("<div class='properties-group' data-id='#{ group.uuid }' style='background-color: #{ App.VUI.colorAlpha groupColor, 0.3 }'><header><h3 style='background-color: #{ App.VUI.colorAlpha groupColor, 0.4 }'>#{ group.name }</h3><div class='toggler collapse'></div></header></div>")
    $controls = $("<div class='controls'></div>").css({ height: (groupHeight * 80) + 'px' })

    for control in group.controls
      if control.type in _.keys(App.VUI.typeClasses)
        typeClass = App.VUI.typeClasses[ control.type ]
        controlAttributes =
          gridLeft: control.pos[0]
          gridTop: control.pos[1]
          gridWidth: control.pos[2]
          gridHeight: control.pos[3]
          propertyObjectUUID: control.uuid
          propertyKey: control.key
          propertyValue: control.value
          propertyLabel: control.name
        controlAttributes[ 'propertyOptions' ] = control.options if control.options
        controlAttributes[ 'propertyMinValue' ] = control.min if control.min
        controlAttributes[ 'propertyMaxValue' ] = control.max if control.max
        controlAttributes[ 'propertyStep' ] = control.step if control.step

        otherKeys = _.difference _.keys(control), [ 'pos', 'uuid', 'key', 'value', 'name', 'options', 'min', 'max', 'step', 'state', 'dataType' ]
        controlAttributes[ otherKey ] = control[ otherKey ] for otherKey in otherKeys

        controller = new typeClass(controlAttributes)
        App.VUI.controls[ "#{ control.uuid } #{ control.key }" ] = controller
        # controller.disable()
        $controls.append controller.render().el
        controller.dataType = control.dataType if control.dataType
        controller.setControlState control.state if control.state
      else
        $controls.append $("<div class='control #{ control.type }'></div>").css
          left: control.pos[0] * 80 + 'px'
          top: control.pos[1] * 80 + 'px'
          width: control.pos[2] * 80 + 'px'
          height: control.pos[3] * 80 + 'px'

    $group.append $controls

    $group.on 'click', '.toggler', (e) ->
      e.preventDefault()
      if $(@).hasClass 'collapse'
        $(@).removeClass('collapse').addClass('expand').closest('.properties-group').find('.controls').slideUp('fast')
      else
        $(@).removeClass('expand').addClass('collapse').closest('.properties-group').find('.controls').slideDown('fast')
    FastClick.attach $group.get(0)


    @$el.append $group

  return @$el.contents()
