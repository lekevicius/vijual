class App.VUI.Knob extends App.VUI.CanvasBase
  propertyType: 'knob'

  defaults:
    resetValue: 0
    propertyMinValue: 0
    propertyMaxValue: 1
    dragSpeed: 0.3
    arcCut: ( Math.PI * 0.25 )

  setValue: ->
    if @controlData.state is 'start'
      @setDisplayValue()
      @previousValue = @displayValue

    value = @previousValue + (@controlData.deltaX * (@values.dragSpeed / 100)) + (-@controlData.deltaY * (@values.dragSpeed / 100))
    value = Math.min( 1, Math.max( 0, value ) )

    @values.propertyValue = @values.propertyMinValue + (value * ( @values.propertyMaxValue - @values.propertyMinValue ))
    super

  setDisplayValue: -> @displayValue = ( @values.propertyValue - @values.propertyMinValue ) / ( @values.propertyMaxValue - @values.propertyMinValue )

  draw: ->
    super

    # Outline
    @context.strokeStyle = App.VUI.colorAlpha @drawColor, ( if @controlData.touched then 1 else 0.5 )
    @context.lineWidth = 2
    @context.strokeRect 0, 0, @values.width, @values.height

    # Draw a circle of the right size, at least.
    smallerSize = if @values.width < @values.height then @values.width else @values.height
    circleSize = smallerSize - 12

    # bound rim
    @context.strokeStyle = App.VUI.colorAlpha @drawColor, ( if @controlData.touched then 1 else 0.3 )
    @context.lineWidth = 2
    @context.beginPath()
    @context.arc ( @values.width / 2 ), ( @values.height / 2 ), ( circleSize / 2 - @context.lineWidth / 2 ), (Math.PI * 0.5) + @values.arcCut, (Math.PI * 0.5) + (@values.arcCut) + (Math.PI * 2 * 1) - (@values.arcCut * 2), false
    @context.stroke()

    # value rim
    @context.strokeStyle = @drawColor
    @context.lineWidth = 6
    @context.beginPath()
    @context.arc ( @values.width / 2 ), ( @values.height / 2 ), ( circleSize / 2 - @context.lineWidth / 2 ), (Math.PI * 0.5) + @values.arcCut, (Math.PI * 0.5) + (@values.arcCut) + (Math.PI * 2 * @displayValue * ( ( Math.PI * 2 - ( @values.arcCut * 2 ) ) / ( Math.PI * 2 ) ) ), false
    @context.stroke()

    # value decoration
    @context.strokeStyle = App.VUI.colorAlpha @drawColor, ( if @controlData.touched then 0.6 else 0.2 )
    @context.lineWidth = circleSize / 4
    @context.beginPath()
    @context.arc ( @values.width / 2 ), ( @values.height / 2 ), ( circleSize / 2 - @context.lineWidth / 2 ), (Math.PI * 0.5) + @values.arcCut, (Math.PI * 0.5) + (@values.arcCut) + (Math.PI * 2 * @displayValue * ( ( Math.PI * 2 - ( @values.arcCut * 2 ) ) / ( Math.PI * 2 ) ) ), false
    @context.stroke()
