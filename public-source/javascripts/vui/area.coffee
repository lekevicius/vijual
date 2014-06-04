class App.VUI.Area extends App.VUI.CanvasBase
  propertyType: 'area'
  dataType: 'coordinates'

  defaults:
    resetValue: [0.5, 0.5]
    propertyValue: [0,0]
    propertyMinXValue: 0
    propertyMaxXValue: 1
    propertyMinYValue: 0
    propertyMaxYValue: 1
    cursorSizeShort: 3
    cursorSizeLong: 15

  setValue: ->
    @values.propertyValue = [0, 0]
    @values.propertyValue[0] = @values.propertyMinXValue + (@controlData.relativePositionInsideX * ( @values.propertyMaxXValue - @values.propertyMinXValue ))
    @values.propertyValue[1] = @values.propertyMinYValue + ( @controlData.relativePositionInsideY * ( @values.propertyMaxYValue - @values.propertyMinYValue ))
    super

  setDisplayValue: ->
    displayXValue = ( @values.propertyValue[0] - @values.propertyMinXValue ) / ( @values.propertyMaxXValue - @values.propertyMinXValue )
    displayYValue = ( @values.propertyValue[1] - @values.propertyMinYValue ) / ( @values.propertyMaxYValue - @values.propertyMinYValue )
    @displayValue = [ displayXValue, displayYValue ]

  draw: ->
    super

    # Outline
    @context.strokeStyle = App.VUI.colorAlpha @drawColor, ( if @controlData.touched then 1 else 0.5 )
    @context.lineWidth = 2
    @context.strokeRect 0, 0, @values.width, @values.height

    # Gridlines
    @context.fillStyle = App.VUI.colorAlpha @drawColor, ( if @controlData.touched then 1 else 0.5 )
    gridlinePositionX = Math.floor( @displayValue[0] * ( @values.width - 3 )) + 1
    gridlinePositionY = Math.floor( @displayValue[1] * ( @values.height - 3 )) + 1
    @context.fillRect gridlinePositionX, 1, 1, @values.height - 2
    @context.fillRect 1, gridlinePositionY, @values.width - 2, 1

    # Cursor
    @context.fillStyle = @drawColor
    cursorShiftShort = (@values.cursorSizeShort - 1) / 2
    cursorShiftLong = (@values.cursorSizeLong - 1) / 2

    @context.fillRect gridlinePositionX - cursorShiftLong, gridlinePositionY - cursorShiftShort, @values.cursorSizeLong, @values.cursorSizeShort # Horizontal bar
    @context.fillRect gridlinePositionX - cursorShiftShort, gridlinePositionY - cursorShiftLong, @values.cursorSizeShort, @values.cursorSizeLong # Vertical bar
