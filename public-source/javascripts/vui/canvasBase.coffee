class App.VUI.CanvasBase extends App.VUI.Base

  propertyType: 'canvasBase'

  events:
    'touchstart .vui-control-canvas': 'startHandler'
    'mousedown .vui-control-canvas': 'startHandler'

  initialize: (options = {}) ->
    super

    @canvas = $('<div/>').html("<canvas width='#{ @values.width }' height='#{ @values.height }'></canvas>").contents().get(0)
    @context = @canvas.getContext "2d"

    @controlData =
      state: 'none'
      touched: false # +outlet
      moved: false # +outlet
      startPageX: 0 # +outlet
      startPageY: 0 # +outlet
      currentPageX: 0 # +outlet
      currentPageY: 0 # +outlet
      controlPageX: 0
      controlPageY: 0
      deltaX: 0 # +outlet
      deltaY: 0 # +outlet
      positionInsideX: 0
      positionInsideY: 0
      relativePositionInsideX: 0
      relativePositionInsideY: 0
      positionOutsideX: 0
      positionOutsideY: 0

    @setDisplayValue()
    @draw()

  setDisplayValue: -> @displayValue = @values.propertyValue

  render: ->
    super
    @$vuiHolder.append $(@canvas).addClass 'vui-control-canvas'
    @

  setcontrolDataPositions: ->
    controlPageX = @offset.left
    controlPageY = @offset.top
    deltaX = @controlData.currentPageX - @controlData.startPageX
    deltaY = @controlData.currentPageY - @controlData.startPageY
    positionOutsideX = @controlData.currentPageX - controlPageX
    positionOutsideY = @controlData.currentPageY - controlPageY
    positionInsideX = Math.max( 0, Math.min( @values.width, positionOutsideX ) )
    positionInsideY = Math.max( 0, Math.min( @values.height, positionOutsideY ) )
    relativePositionInsideX = positionInsideX / @values.width
    relativePositionInsideY = positionInsideY / @values.height

    @controlData = _.extend @controlData,
      controlPageX: controlPageX
      controlPageY: controlPageY
      deltaX: deltaX
      deltaY: deltaY
      positionOutsideX: positionOutsideX
      positionOutsideY: positionOutsideY
      positionInsideX: positionInsideX
      positionInsideY: positionInsideY
      relativePositionInsideX: relativePositionInsideX
      relativePositionInsideY: relativePositionInsideY

  startHandler: (e) ->
    unless @controlDisabled or @controlState is 'disabled'
      e.preventDefault()
      @offset = $(@canvas).offset()

      if e.type is 'touchstart'
        originalTouch = e.originalEvent.targetTouches[0]
        startX = originalTouch.pageX
        startY = originalTouch.pageY
        identifier = originalTouch.identifier
      else
        startX = e.pageX
        startY = e.pageY
        identifier = e.timeStamp+""

      touch = { startX: startX, startY: startY, identifier: identifier, handler: @ }
      App.VUI.ongoingTouches.push touch

      @controlData =
        state: 'start'
        touched: true
        moved: false
        startPageX: startX
        startPageY: startY
        currentPageX: startX
        currentPageY: startY
      @setcontrolDataPositions()

      @setValue()
      @draw()

  moveHandler: (startData, currentTouch) ->
    @controlData =
      state: 'moved'
      touched: true
      moved: true
      startPageX: startData.startX
      startPageY: startData.startY
      currentPageX: currentTouch.pageX
      currentPageY: currentTouch.pageY
    @setcontrolDataPositions()

    @setValue()
    @draw()

  endHandler: (startData, lastTouch) ->
    @controlData =
      state: 'end'
      touched: false
      moved: @controlData.moved
      startPageX: startData.startX
      startPageY: startData.startY
      currentPageX: lastTouch.pageX
      currentPageY: lastTouch.pageY
    @setcontrolDataPositions()

    @setValue() # unless @moved
    @draw()

  draw: ->
    super
    @setDisplayValue()
    @context.clearRect 0, 0, @values.width, @values.height
    @drawColor = unless @controlDisabled or @controlState is 'disabled' then @values.color else App.VUI.disabledColor
    @whiteColor = unless @controlDisabled or @controlState is 'disabled' then '#fff' else App.VUI.disabledColor
