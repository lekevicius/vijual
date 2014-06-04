class App.VUI.IntegerSlider extends App.VUI.Slider
  propertyType: 'integerSlider'
  dataType: 'integer'

  defaults:
    resetValue: 1
    propertyMinValue: 0
    propertyMaxValue: 10
    propertyStep: 1
    cursorWidth: 4

  setValue: ->
    if @horizontal
      value = @controlData.relativePositionInsideX
    else
      value = 1 - @controlData.relativePositionInsideY

    @values.propertyValue = @values.propertyMinValue + (value * ( @values.propertyMaxValue - @values.propertyMinValue ))

    multipliedValue = @values.propertyValue / @values.propertyStep
    multipliedValue = Math.round(multipliedValue)
    steppedValue = multipliedValue * @values.propertyStep
    @values.propertyValue = Math.max( @values.propertyMinValue, Math.min( @values.propertyMaxValue, steppedValue ) )
    @values.propertyValue = Math.round @values.propertyValue

    super
