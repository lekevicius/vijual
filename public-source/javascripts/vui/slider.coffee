class App.VUI.Slider extends App.VUI.CanvasBase
  propertyType: 'slider'

  defaults:
    resetValue: 0.5
    propertyMinValue: 0
    propertyMaxValue: 1
    propertyStep: null
    cursorWidth: 4

  setValue: ->
    if @horizontal
      value = @controlData.relativePositionInsideX
    else
      value = 1 - @controlData.relativePositionInsideY

    @values.propertyValue = @values.propertyMinValue + (value * ( @values.propertyMaxValue - @values.propertyMinValue ))

    if @values.propertyStep
      multipliedValue = @values.propertyValue / @values.propertyStep
      multipliedValue = Math.round(multipliedValue)
      steppedValue = multipliedValue * @values.propertyStep
      @values.propertyValue = Math.max( @values.propertyMinValue, Math.min( @values.propertyMaxValue, steppedValue ) )

    super

  setDisplayValue: -> @displayValue = ( @values.propertyValue - @values.propertyMinValue ) / ( @values.propertyMaxValue - @values.propertyMinValue )

  draw: ->
    super

    # Outline
    @context.strokeStyle = App.VUI.colorAlpha @drawColor, ( if @controlData.touched then 1 else 0.5 )
    @context.lineWidth = 2
    @context.strokeRect 0, 0, @values.width, @values.height

    # Cursor
    @context.fillStyle = @drawColor
    if @horizontal
      startX = Math.floor(@displayValue * (@values.width - 2 - @values.cursorWidth)) + 1
      startY = 1
      @context.fillRect startX, startY, @values.cursorWidth, @values.height - 2
    else
      startX = 1
      startY = @values.height - Math.floor( @displayValue * (@values.height - 2 - @values.cursorWidth)) - 1 - @values.cursorWidth
      @context.fillRect startX, startY, @values.width - 2, @values.cursorWidth

    # Fill
    @context.fillStyle = App.VUI.colorAlpha @drawColor, 0.5
    if @horizontal
      @context.fillRect 1, 1, startX - 1, @values.height - 2
    else
      @context.fillRect 1, startY + @values.cursorWidth, @values.width - 2, @values.height - startY - 1 - @values.cursorWidth
