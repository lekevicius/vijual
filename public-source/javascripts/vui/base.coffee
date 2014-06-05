class App.VUI.Base extends Backbone.View

  propertyType: 'base'
  dataType: 'float'

  baseDefaults:
    propertyObjectUUID: ''
    propertyKey: ''
    propertyValue: 0.5
    propertyLabel: "Values"
    color: App.VUI.defaultControlColor
    gridWidth: 1
    gridHeight: 1
    gridLeft: 0
    gridTop: 0
    gridSize: 80
    hasOutlet: true
    onlyOutlet: false
    outletOrientation: 'auto'
    outletLabelOverride: ''
    outletValueOverride: ''
    outletIconOverride: ''
    allowLinkOut: true
    allowLinkIn: true
    allowRecord: true
    outletWidth: 0 # 0 = auto, and width is ignored if rotated
    recordings: [ { frames: 1059 }, { frames: 323 }, { frames: 29 } ]

  initialize: (options = {}) ->
    @defaults ?= {}
    @defaults = _.extend _.clone(@baseDefaults), @defaults
    @values = _.extend @defaults, options

    @className = "vui-#{ @propertyType }"

    if @values.hasOutlet
      shortSide = 48
      if @values.onlyOutlet then shortSide = @values.gridSize - 8 - (App.VUI.globalPadding * 3)
      if @values.gridHeight > 1 or @values.outletOrientation is 'horizontal'
        @outletCanvasWidth = ( ( if @values.outletWidth > 0 then @values.outletWidth else @values.gridWidth ) * @values.gridSize) - (App.VUI.globalPadding * 2)
        @outletCanvasHeight = shortSide
        @outletCanvasRotated = false
      else
        @outletCanvasWidth = shortSide
        @outletCanvasHeight = @values.gridSize - (App.VUI.globalPadding * 2)
        @outletCanvasRotated = true

      @outletCanvas = $('<div/>').html("<canvas width='#{ @outletCanvasWidth }' height='#{ @outletCanvasHeight }'></canvas>").contents().get(0)
      @outletContext = @outletCanvas.getContext "2d"
      @outletContext.font = '9pt sans-serif'
      @outletContext.textAlign = 'center'
    else
      @outletCanvasWidth = 0
      @outletCanvasHeight = 0
      @outletCanvasRotated = false

    @controlState = 'default' # 0 = default, 1 = disabled, 2 = recording, 3 = linked in.
    @outletDrawState = @controlState
    @controlDisabled = false
    @outletLastClick = (+ new Date)

    @outletControlData =
      touched: false
      moved: false
      startPageX: 0
      startPageY: 0
      currentPageX: 0
      currentPageY: 0
      deltaX: 0
      deltaY: 0

    @outletHandler =
      moveHandler: (startData, currentTouch) =>
        @outletControlData =
          touched: true
          moved: true
          startPageX: startData.startX
          startPageY: startData.startY
          currentPageX: currentTouch.pageX
          currentPageY: currentTouch.pageY
        @setOutletControlDataPositions()

        # @setValue()
        @drawOutletCanvas()

      endHandler: (startData, lastTouch) =>
        lastDrawState = @outletDrawState

        if @controlState is 'default'
          if lastDrawState is 'linkHover'
            @controlState = 'linkOpen'
            App.propsConnection.askForLinks @
          if lastDrawState is 'recordingHover'
            if @outletIconOverride is 'play'
              recordingsView = new  App.Views.PropsRecordingsModalView @
              App.propsView.showModal recordingsView
            else
              @controlState = 'recording'
              App.propsConnection.startRecording @
        if @controlState is 'recording' and lastDrawState is 'recordingHighlighted'
          @controlState = 'playing'
          App.propsConnection.startPlaying @, @values.recordings.length
        if @controlState is 'playing' and lastDrawState is 'playingHighlighted'
          @controlState = 'default'
          App.propsConnection.stopPlaying @
        if @controlState is 'linkOpen' and lastDrawState is 'linkOpenHighlighted'
          @controlState = 'default'
          App.propsConnection.cancelLinking()
        if @controlState is 'linked' and lastDrawState is 'linkedHighlighted'
          @setControlState 'default'
          App.propsConnection.deleteLink @
        if @controlState is 'linking' and lastDrawState is 'linkingHighlighted'
          @controlState = 'default'
          App.propsConnection.createLink @

        @outletControlData =
          touched: false
          moved: @outletControlData.moved
          startPageX: startData.startX
          startPageY: startData.startY
          currentPageX: lastTouch.pageX
          currentPageY: lastTouch.pageY
        @setOutletControlDataPositions()

        # @setValue() # unless @moved
        @drawOutletCanvas()

    @events = _.extend {}, @events, { 'touchstart .vui-outlet-canvas': 'outletStartHandler', 'mousedown .vui-outlet-canvas': 'outletStartHandler' }
    @delegateEvents()

    @values.width = @values.gridWidth * @values.gridSize
    @values.height = @values.gridHeight * @values.gridSize

    if @outletCanvasRotated
      @values.width -= @outletCanvasWidth + ( App.VUI.globalPadding * 3 )
      @values.height -= ( App.VUI.globalPadding * 2 )
    else
      @values.height -= @outletCanvasHeight + ( App.VUI.globalPadding * 2 )
      @values.height -= App.VUI.globalPadding if @values.hasOutlet
      @values.width -= ( App.VUI.globalPadding * 2 )

    @horizontal = ( @values.width > @values.height )

  setValue: ->
    # console.log @values.propertyValue
    App.controlSurfaceController.recordChange @values.propertyObjectUUID, @values.propertyKey, @values.propertyValue

  getValue: -> @values.propertyValue

  updateValue: (value) ->
    @values.propertyValue = value
    @draw()

  doResetValue: () ->
    @values.propertyValue = @defaults.resetValue
    App.controlSurfaceController.recordChange @values.propertyObjectUUID, @values.propertyKey, @values.propertyValue
    @draw()

  setControlState: (state) ->
    if state is 'linked'
      @controlState = 'linked'
      @controlDisabled = true
    if state is 'default'
      @controlState = 'default'
      @controlDisabled = false
    if state is 'recording'
      @controlState = 'recording'
      @controlDisabled = false
    if state is 'playing'
      @controlState = 'playing'
      @controlDisabled = true

    @draw()

  setOutletControlDataPositions: ->
    deltaX = @outletControlData.currentPageX - @outletControlData.startPageX
    deltaY = @outletControlData.currentPageY - @outletControlData.startPageY
    @outletControlData = _.extend @outletControlData, { deltaX: deltaX, deltaY: deltaY }

  outletStartHandler: (e) ->
    unless @controlState is 'disabled'
      e.preventDefault()

      if e.type is 'touchstart'
        originalTouch = e.originalEvent.targetTouches[0]
        startX = originalTouch.pageX
        startY = originalTouch.pageY
        identifier = originalTouch.identifier
      else
        startX = e.pageX
        startY = e.pageY
        identifier = e.timeStamp+""

      currentTime = (+ new Date)
      if currentTime - @outletLastClick < 200 then @doResetValue()
      @outletLastClick = currentTime

      touch = { startX: startX, startY: startY, identifier: identifier, handler: @outletHandler }
      App.VUI.ongoingTouches.push touch

      @outletControlData =
        touched: true
        moved: false
        startPageX: startX
        startPageY: startY
        currentPageX: startX
        currentPageY: startY
      @setOutletControlDataPositions()

      # @setValue()
      @drawOutletCanvas()

  propertyValueLabel: ->
    switch @dataType
      when 'float'
        return "#{ @values.propertyValue[0].toFixed(2) } : #{ @values.propertyValue[1].toFixed(2) }" if _.isArray(@values.propertyValue)
        @values.propertyValue.toFixed(2)
      when 'integer' then parseInt(@values.propertyValue)
      when 'angle' then App.utils.degrees(@values.propertyValue).toFixed() + "°"
      when 'coordinates' then "#{ @values.propertyValue[0].toFixed(2) } : #{ @values.propertyValue[1].toFixed(2) }"
      when 'color' then @values.propertyValue
      when 'option' then @values.propertyOptions[ @values.propertyValue ]
      when 'boolean'
        if @values.propertyValue then 'On' else 'Off'
      when 'string'
        return @values.propertyValue.substr(0,6) + '...' if @values.propertyValue.length > 6
        @values.propertyValue

  disable: ->
    @controlState = 'disabled'
    @controlDisabled = true
    # delete link, stop recording maybe.
    @draw()

  enable: ->
    @controlState = 'default'
    @controlDisabled = false
    @draw()

  setOutletDrawState: ->
    @outletIconOverride = ''
    if @outletControlData.touched
      if @controlState is 'default'
        if -App.VUI.activationDragDistance <= @outletControlData.deltaY <= App.VUI.activationDragDistance
          @outletDrawState = 'defaultHighlighted'
        else if @outletControlData.deltaY < App.VUI.activationDragDistance and @values.allowRecord
          @outletDrawState = 'recordingHover'
          if @outletControlData.deltaX < 0 and @values.recordings.length
            @outletIconOverride = 'play'
          else
            @outletIconOverride = 'record'
        else if @outletControlData.deltaY > App.VUI.activationDragDistance and @values.allowLinkOut
          @outletDrawState = 'linkHover'

      else if @controlState is 'disabled'
        @outletDrawState = 'disabled'

      else if @controlState is 'recording'
        @outletDrawState = 'recordingHighlighted'
      else if @controlState is 'playing'
        @outletDrawState = 'playingHighlighted'

      else if @controlState is 'linkOpen'
        @outletDrawState = 'linkOpenHighlighted'
      else if @controlState is 'linked'
        @outletDrawState = 'linkedHighlighted'
      else if @controlState is 'linking'
        @outletDrawState = 'linkingHighlighted'
    else
      @outletDrawState = @controlState

  drawOutletCanvas: ->
    if @values.hasOutlet
      @outletContext.clearRect 0, 0, @outletCanvasWidth, @outletCanvasHeight

      textStyle = App.VUI.colorAlpha '#fff', 0.5

      @setOutletDrawState()

      switch @outletDrawState
        when 'disabled'
          @outletContext.fillStyle = App.VUI.colorAlpha App.VUI.defaultColor, 0
          @outletContext.strokeStyle = App.VUI.colorAlpha App.VUI.defaultColor, 0.2
          textStyle = App.VUI.colorAlpha App.VUI.defaultColor, 0.2

        when 'default'
          @outletContext.fillStyle = App.VUI.colorAlpha App.VUI.defaultColor, 0
          @outletContext.strokeStyle = App.VUI.colorAlpha App.VUI.defaultColor, 0.5
        when 'defaultHighlighted'
          @outletContext.fillStyle = App.VUI.colorAlpha App.VUI.defaultColor, 0.3
          @outletContext.strokeStyle = App.VUI.colorAlpha App.VUI.defaultColor, 0.8

        when 'recordingHover'
          @outletContext.fillStyle = App.VUI.colorAlpha App.VUI.recordingColor, 0.3
          @outletContext.strokeStyle = App.VUI.colorAlpha App.VUI.recordingColor, 0.8
        when 'recording'
          @outletContext.fillStyle = App.VUI.colorAlpha App.VUI.recordingColor, 0.6
          @outletContext.strokeStyle = App.VUI.colorAlpha App.VUI.recordingColor, 1
          textStyle = App.VUI.colorAlpha App.VUI.recordingColor, 1
        when 'recordingHighlighted'
          @outletContext.fillStyle = App.VUI.colorAlpha App.VUI.recordingColor, 0.3
          @outletContext.strokeStyle = App.VUI.colorAlpha App.VUI.recordingColor, 1
          textStyle = App.VUI.colorAlpha App.VUI.recordingColor, 0.8
        when 'playing'
          @outletContext.fillStyle = App.VUI.colorAlpha App.VUI.recordingColor, 0.1
          @outletContext.strokeStyle = App.VUI.colorAlpha App.VUI.recordingColor, 0.25
          textStyle = App.VUI.colorAlpha App.VUI.recordingColor, 1
        when 'playingHighlighted'
          @outletContext.fillStyle = App.VUI.colorAlpha App.VUI.recordingColor, 0.6
          @outletContext.strokeStyle = App.VUI.colorAlpha App.VUI.recordingColor, 1
          textStyle = App.VUI.colorAlpha App.VUI.recordingColor, 0.8

        when 'linkHover'
          @outletContext.fillStyle = App.VUI.colorAlpha App.VUI.linkColor, 0.3
          @outletContext.strokeStyle = App.VUI.colorAlpha App.VUI.linkColor, 0.8
        when 'linking'
          @outletContext.fillStyle = App.VUI.colorAlpha App.VUI.linkColor, 0.3
          @outletContext.strokeStyle = App.VUI.colorAlpha App.VUI.linkColor, 0.8
        when 'linkingHighlighted'
          @outletContext.fillStyle = App.VUI.colorAlpha App.VUI.linkColor, 0.8
          @outletContext.strokeStyle = App.VUI.colorAlpha App.VUI.linkColor, 1
        when 'linked'
          @outletContext.fillStyle = App.VUI.colorAlpha App.VUI.linkColor, 0.1
          @outletContext.strokeStyle = App.VUI.colorAlpha App.VUI.linkColor, 0.25
        when 'linkedHighlighted'
          @outletContext.fillStyle = App.VUI.colorAlpha App.VUI.linkColor, 0.3
          @outletContext.strokeStyle = App.VUI.colorAlpha App.VUI.linkColor, 0.8
        when 'linkOpen'
          @outletContext.fillStyle = App.VUI.colorAlpha App.VUI.linkColor, 0.1
          @outletContext.strokeStyle = App.VUI.colorAlpha App.VUI.linkColor, 1
        when 'linkOpenHighlighted'
          @outletContext.fillStyle = App.VUI.colorAlpha App.VUI.linkColor, 0.8
          @outletContext.strokeStyle = App.VUI.colorAlpha App.VUI.linkColor, 1


      radii = if @outletCanvasRotated then [6, 0, 0, 6] else [0, 0, 6, 6]
      # if @values.onlyOutlet then radii = [6, 6, 6, 6]
      @outletContext.lineWidth = 1
      App.VUI.roundRect @outletContext, 0.5, 0.5, @outletCanvasWidth - 1, @outletCanvasHeight - 1, radii, true

      @outletContext.fillStyle = textStyle

      if @outletCanvasRotated
         @outletContext.save()
         @outletContext.translate 0, 60
         @outletContext.rotate -Math.PI / 2


      if @outletIconOverride
        @outletContext.fillStyle = App.VUI.colorAlpha App.VUI.recordingColor, 1
        if @outletIconOverride is 'play'
          @outletContext.beginPath()
          @outletContext.moveTo @outletCanvasWidth / 2 - 7, @outletCanvasHeight / 2 - 10
          @outletContext.lineTo @outletCanvasWidth / 2 + 11, @outletCanvasHeight / 2
          @outletContext.lineTo @outletCanvasWidth / 2 - 7, @outletCanvasHeight / 2 + 10
          @outletContext.closePath()
          @outletContext.fill()
        if @outletIconOverride is 'record'
          @outletContext.beginPath()
          @outletContext.arc @outletCanvasWidth / 2, @outletCanvasHeight / 2, 10, 0, 2 * Math.PI
          @outletContext.fill()
      else
        textSpace = if @outletCanvasRotated then @outletCanvasWidth else @outletCanvasHeight
        labelShift = textSpace / 2 - 2
        valueShift = textSpace / 2 + 13
        labelText = if @outletLabelOverride then @outletLabelOverride else @values.propertyLabel
        valueText = if @outletValueOverride then @outletValueOverride else @propertyValueLabel()
        @outletContext.fillText labelText, @outletCanvasWidth / 2, labelShift
        @outletContext.fillText valueText, @outletCanvasWidth / 2, valueShift

      if @outletCanvasRotated
        @outletContext.restore() # Now tell me code is not poetry.

  draw: ->
    @drawOutletCanvas()

  render: ->
    @$el.empty().addClass('vui-element').addClass(@className)
    @$el.append $('<div/>').addClass 'vui-control-holder'
    @$vuiHolder = @$('.vui-control-holder')
    @$vuiHolder.addClass 'rotated-outlet' if @outletCanvasRotated
    @$vuiHolder.append $(@outletCanvas).addClass 'vui-outlet-canvas'
    @$el.css
      left: ( @values.gridLeft * @values.gridSize ) + 'px'
      top: ( @values.gridTop * @values.gridSize ) + 'px'
      width: ( @values.gridWidth * @values.gridSize ) + 'px'
      height: ( @values.gridHeight * @values.gridSize ) + 'px'
    @el.vui = @
