class App.VUI.Color extends App.VUI.CanvasBase
  propertyType: 'color'
  dataType: 'color'

  defaults:
    resetValue: '#ffffff'
    cursorWidth: 4
    propertyValue: '#ff0000'
    hsv: [ 0, 1, 1 ]
    outletWidth: 1

  initialize: (options = {}) ->
    super

    valueHsv = tinycolor(@values.propertyValue).toHsv()
    @values.hsv = [ valueHsv.h, valueHsv.s, valueHsv.v ]

    @values.colorCanvasWidth = (@values.gridWidth - 1) * @values.gridSize - App.VUI.globalPadding
    @values.colorCanvasHeight = @values.gridHeight * @values.gridSize - ( App.VUI.globalPadding * 2 )
    @colorCanvas = $('<div/>').html("<canvas width='#{ @values.colorCanvasWidth }' height='#{ @values.colorCanvasHeight }'></canvas>").contents().get(0)
    $(@colorCanvas).css
      position: 'absolute'
      top: '4px'
      right: '4px'
    @colorContext = @colorCanvas.getContext "2d"

    @hueFadedGradient = @context.createLinearGradient 0, 0, 0, @values.height - 2
    @hueGradient = @context.createLinearGradient 0, 0, 0, @values.height - 2
    for hue in [0..360]
      step = 1 - hue / 360
      @hueFadedGradient.addColorStop step, "hsla(#{ hue }, 100%, 50%, 0.5)"
      @hueGradient.addColorStop step, "hsl(#{ hue }, 100%, 50%)"

    @saturationFadedGradient = @colorContext.createLinearGradient 0, 0, @values.colorCanvasWidth - 2, 0
    @saturationGradient = @colorContext.createLinearGradient 0, 0, @values.colorCanvasWidth - 2, 0
    for alpha in [0..255]
      step = alpha / 255
      @saturationFadedGradient.addColorStop step, "rgba(255, 255, 255, #{ (1 - alpha / 255) * 0.5 })"
      @saturationGradient.addColorStop step, "rgba(255, 255, 255, #{ (1 - alpha / 255) })"

    @valueFadedGradient = @colorContext.createLinearGradient 0, 0, 0, @values.colorCanvasHeight - 2
    @valueGradient = @colorContext.createLinearGradient 0, 0, 0, @values.colorCanvasHeight - 2
    for alpha in [0..255]
      step = alpha / 255
      @valueFadedGradient.addColorStop step, "rgba(0, 0, 0, #{ (alpha / 255) * 0.5 })"
      @valueGradient.addColorStop step, "rgba(0, 0, 0, #{ (alpha / 255) })"

    @colorControlData =
      state: 'none'
      touched: false
      moved: false
      relativePositionInsideX: 0
      relativePositionInsideY: 0

    @controlData.relativePositionInsideY = 1 - @values.hsv[0] / 359
    @colorControlData.relativePositionInsideX = @values.hsv[1]
    @colorControlData.relativePositionInsideY = 1 - @values.hsv[2]

    @colorHandler =
      moveHandler: (startData, currentTouch) =>
        @colorControlData =
          touched: true
          moved: true
          currentPageX: currentTouch.pageX
          currentPageY: currentTouch.pageY
        @setColorControlDataPositions()
        @setValue()
        @draw()

      endHandler: (startData, lastTouch) =>
        @colorControlData =
          touched: false
          moved: @colorControlData.moved
          currentPageX: lastTouch.pageX
          currentPageY: lastTouch.pageY
        @setColorControlDataPositions()
        @setValue()
        @draw()

    @events = _.extend @events, { 'touchstart .vui-color-canvas': 'colorStartHandler', 'mousedown .vui-color-canvas': 'colorStartHandler' }
    @delegateEvents()

    @values.width = 1 * @values.gridSize - ( App.VUI.globalPadding * 2 )
    @context.canvas.width = @values.width
    @draw()

  colorStartHandler: (e) ->
    unless @controlState is 'disabled'
      e.preventDefault()
      @colorOffset = $(@colorCanvas).offset()

      if e.type is 'touchstart'
        originalTouch = e.originalEvent.targetTouches[0]
        startX = originalTouch.pageX
        startY = originalTouch.pageY
        identifier = originalTouch.identifier
      else
        startX = e.pageX
        startY = e.pageY
        identifier = e.timeStamp+""

      touch = { startX: startX, startY: startY, identifier: identifier, handler: @colorHandler }
      App.VUI.ongoingTouches.push touch

      @colorControlData =
        touched: true
        moved: false
        currentPageX: startX
        currentPageY: startY
      @setColorControlDataPositions()

      @setValue()
      @draw()

  setColorControlDataPositions: ->
    controlPageX = @colorOffset.left
    controlPageY = @colorOffset.top
    positionOutsideX = @colorControlData.currentPageX - controlPageX
    positionOutsideY = @colorControlData.currentPageY - controlPageY
    positionInsideX = Math.max( 0, Math.min( @values.colorCanvasWidth, positionOutsideX ) )
    positionInsideY = Math.max( 0, Math.min( @values.colorCanvasHeight, positionOutsideY ) )
    relativePositionInsideX = positionInsideX / @values.colorCanvasWidth
    relativePositionInsideY = positionInsideY / @values.colorCanvasHeight

    @colorControlData = _.extend @colorControlData,
      relativePositionInsideX: relativePositionInsideX
      relativePositionInsideY: relativePositionInsideY

  setValue: ->
    newHue = (1 - @controlData.relativePositionInsideY) * 359
    @values.hsv[0] = newHue

    newSaturation = @colorControlData.relativePositionInsideX
    @values.hsv[1] = newSaturation

    newValue = 1 - @colorControlData.relativePositionInsideY
    @values.hsv[2] = newValue

    @values.propertyValue = tinycolor({ h: @values.hsv[0], s: @values.hsv[1], v: @values.hsv[2] }).toHexString()
    super

  updateValue: (value) ->
    valueHsv = tinycolor(value).toHsv()
    @values.hsv = [ valueHsv.h, valueHsv.s, valueHsv.v ]
    super

  doResetValue: () ->
    @updateValue '#ffffff'
    @setValue()

  setDisplayValue: -> @displayValue = { h: @values.hsv[0], s: @values.hsv[1], v: @values.hsv[2] }

  render: ->
    super
    @$vuiHolder.append $(@colorCanvas).addClass 'vui-color-canvas'
    @

  draw: ->
    return unless @context and @colorContext
    super
    viewDisabled = @controlDisabled or @controlState is 'disabled'
    @colorContext.clearRect 0, 0, @values.colorCanvasWidth, @values.colorCanvasHeight

    hueRatio = @displayValue.h / 359
    anyTouched = @controlData.touched or @colorControlData.touched

    # Outline
    @context.strokeStyle = App.VUI.colorAlpha @whiteColor, ( if anyTouched then 1 else 0.5 )
    @context.lineWidth = 2
    @context.strokeRect 0, 0, @values.width, @values.height

    @colorContext.strokeStyle = App.VUI.colorAlpha @whiteColor, ( if anyTouched then 1 else 0.5 )
    @colorContext.lineWidth = 2
    @colorContext.strokeRect 0, 0, @values.colorCanvasWidth, @values.colorCanvasHeight

    @context.fillStyle = ( if anyTouched then @hueGradient else @hueFadedGradient )
    @context.fillStyle = App.VUI.colorAlpha @drawColor, 0.5 if viewDisabled
    @context.fillRect 1, 1, @values.width - 2, @values.height - 2

    # Cursor
    @context.fillStyle = App.VUI.colorAlpha @whiteColor, ( if anyTouched then 1 else 0.5 )
    startY = @values.height - Math.floor( hueRatio * (@values.height - 2 - @values.cursorWidth)) - 1 - @values.cursorWidth
    @context.fillRect 1, startY, @values.width - 2, @values.cursorWidth

    fillColor = tinycolor({ h: @displayValue.h, s: 1, v: 1 })
    fillColor.setAlpha 0.3 unless anyTouched
    @colorContext.fillStyle = fillColor.toRgbString()
    @colorContext.fillStyle = App.VUI.colorAlpha @drawColor, 0.3 if viewDisabled
    @colorContext.fillRect 1, 1, @values.colorCanvasWidth - 2, @values.colorCanvasHeight - 2

    @colorContext.fillStyle = ( if anyTouched then @saturationGradient else @saturationFadedGradient )
    @colorContext.fillRect 1, 1, @values.colorCanvasWidth - 2, @values.colorCanvasHeight - 2
    @colorContext.fillStyle = ( if anyTouched then @valueGradient else @valueFadedGradient )
    @colorContext.fillRect 1, 1, @values.colorCanvasWidth - 2, @values.colorCanvasHeight - 2

    @colorContext.fillStyle = App.VUI.colorAlpha @whiteColor, ( if anyTouched then 1 else 0.5 )
    @colorContext.beginPath()
    @colorContext.arc ( @displayValue.s * @values.colorCanvasWidth ), ( (1 - @displayValue.v) * @values.colorCanvasHeight ), 24, 0, Math.PI * 2, false
    @colorContext.fill()

    @colorContext.fillStyle = @values.propertyValue
    @colorContext.fillStyle = App.VUI.colorAlpha @drawColor, 0.5 if viewDisabled
    @colorContext.beginPath()
    @colorContext.arc ( @displayValue.s * @values.colorCanvasWidth ), ( (1 - @displayValue.v) * @values.colorCanvasHeight ), 22, 0, Math.PI * 2, false
    @colorContext.fill()
