class App.VUI.Angle extends App.VUI.CanvasBase
  propertyType: 'angle'
  dataType: 'angle'

  defaults:
    resetValue: Math.PI * 2
    propertyMinValue: 0
    propertyMaxValue: 1
    rimDepth: 12
    rimWidth: 0.1

  setValue: ->
    vectorCenter = [ ( @values.width / 2 ), ( @values.height / 2 ) ]
    vector = [ ( @controlData.positionOutsideX - vectorCenter[0] ), ( @controlData.positionOutsideY - vectorCenter[1] ) ]
    value = Math.atan2( vector[1], vector[0] )
    value += Math.PI * 2 if value < 0
    @values.propertyValue = value
    super

  draw: ->
    super

    # Outline
    @context.strokeStyle = App.VUI.colorAlpha @drawColor, ( if @controlData.touched then 1 else 0.5 )
    @context.lineWidth = 2
    @context.strokeRect 0, 0, @values.width, @values.height

    # Draw a circle of the right size, at least.
    smallerSize = if @values.width < @values.height then @values.width else @values.height
    circleSize = smallerSize - 12

    # outer rim
    @context.strokeStyle = App.VUI.colorAlpha @drawColor, ( if @controlData.touched then 1 else 0.3 )
    @context.lineWidth = 2
    @context.beginPath()
    @context.arc ( @values.width / 2 ), ( @values.height / 2 ), ( circleSize / 2 - @context.lineWidth / 2 ), 0, Math.PI * 2, false
    @context.stroke()
    # inner rim
    # @context.beginPath()
    # @context.arc ( @values.width / 2 ), ( @values.height / 2 ), ( circleSize / 2 + @context.lineWidth / 2 - @values.rimDepth ), 0, Math.PI * 2, false
    # @context.stroke()

    # value rim
    @context.strokeStyle = @drawColor
    @context.lineWidth = circleSize / 2 - 1
    @context.beginPath()
    @context.arc ( @values.width / 2 ), ( @values.height / 2 ), ( circleSize / 2 - @context.lineWidth / 2 ), @displayValue - @values.rimWidth, @displayValue + @values.rimWidth, false
    @context.stroke()

    # # value decoration
    # @context.strokeStyle = App.VUI.colorAlpha @drawColor, 0.4
    # @context.lineWidth = circleSize / 4
    # @context.beginPath()
    # @context.arc ( @values.width / 2 ), ( @values.height / 2 ), ( circleSize / 2 - @context.lineWidth / 2 ), (Math.PI * 0.5) + @values.arcCut, (Math.PI * 0.5) + (@values.arcCut) + (Math.PI * 2 * @displayValue * ( ( Math.PI * 2 - ( @values.arcCut * 2 ) ) / ( Math.PI * 2 ) ) ), false
    # @context.stroke()
