class App.VUI.ExponentialTracker extends App.VUI.CanvasBase
  propertyType: 'exponentialTracker'

  defaults:
    resetValue: 1
    propertyMinValue: null
    propertyMaxValue: null
    dragSpeed: 0.001
    exponentBase: 10
    displayFixTo: 2
    cursorWidth: 2
    cursorSpace: 10

  setValue: ->
    if @controlData.state is 'start'
      @setDisplayValue()
      @previousValue = @exponent

    delta = if @horizontal then @controlData.deltaX else -@controlData.deltaY
    exponentValue = @previousValue + (delta * @values.dragSpeed)

    value = Math.pow( @values.exponentBase, exponentValue )
    value = Math.max( @values.propertyMinValue, value ) if @values.propertyMinValue
    value = Math.min( @values.propertyMaxValue, value ) if @values.propertyMaxValue

    @values.propertyValue = value
    super

  setDisplayValue: ->
    @exponent = Math.log(@values.propertyValue) / Math.log(@values.exponentBase)
    valuePixelShift = Math.floor( 1 / @values.dragSpeed )
    @displayValue = Math.round ( @exponent * valuePixelShift ) % ( @values.cursorWidth + @values.cursorSpace )

  draw: new App.VUI.LinearTracker().draw
