class App.VUI.LinearTracker extends App.VUI.CanvasBase
  propertyType: 'linearTracker'

  defaults:
    resetValue: 0
    propertyMinValue: null
    propertyMaxValue: null
    propertyStep: 1
    displayFixTo: 2
    cursorWidth: 2
    cursorSpace: 10

  setValue: ->
    if @controlData.state is 'start'
      @previousValue = @values.propertyValue

    delta = if @horizontal then @controlData.deltaX else -@controlData.deltaY
    value = @previousValue + (delta * @values.propertyStep)
    value = Math.max( @values.propertyMinValue, value ) if @values.propertyMinValue
    value = Math.min( @values.propertyMaxValue, value ) if @values.propertyMaxValue

    @values.propertyValue = value
    super

  setDisplayValue: ->
    valuePixelShift = Math.floor( 1 / @values.propertyStep )
    @displayValue = Math.round ( @values.propertyValue * valuePixelShift ) % ( @values.cursorWidth + @values.cursorSpace )

  draw: ->
    super

    # Outline
    @context.strokeStyle = App.VUI.colorAlpha @drawColor, ( if @controlData.touched then 1 else 0.5 )
    @context.lineWidth = 2
    @context.strokeRect 0, 0, @values.width, @values.height

    blockSize = @values.cursorWidth + @values.cursorSpace
    currentLocation = @displayValue - blockSize
    currentLocation -= @displayValue * 2 unless @horizontal

    fullSize = if @horizontal then @values.width else @values.height

    while currentLocation <= fullSize
      midpoint = fullSize / 2
      alphaMultiplicator = 0.1 + ( 0.9 * ( 1 - Math.abs( midpoint - currentLocation ) / midpoint ) )
      fillAlpha = ( if @controlData.touched then 1 else 0.5 ) * alphaMultiplicator
      @context.fillStyle = App.VUI.colorAlpha @drawColor, fillAlpha

      if @horizontal
        @context.fillRect currentLocation, 1, @values.cursorWidth, @values.height - 2
      else
        @context.fillRect 1, currentLocation, @values.width - 2, @values.cursorWidth
      currentLocation += blockSize
    return
