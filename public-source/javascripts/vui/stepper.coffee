class App.VUI.Stepper extends App.VUI.CanvasBase
  propertyType: 'switcher'

  defaults:
    resetValue: 0
    propertyMinValue: null
    propertyMaxValue: null
    propertyStep: 1
    propertyValue: 1

  setValue: ->
    if @controlData.state is 'end'
      if @horizontal
        valueChange = ( if @controlData.positionInsideX < @values.width / 2 then -@values.propertyStep else @values.propertyStep )
      else
        valueChange = ( if @controlData.positionInsideY < @values.height / 2 then @values.propertyStep else -@values.propertyStep )
      @values.propertyValue += valueChange
      @values.propertyValue = Math.max( @values.propertyMinValue, @values.propertyValue ) if @values.propertyMinValue
      @values.propertyValue = Math.min( @values.propertyMaxValue, @values.propertyValue ) if @values.propertyMaxValue
    super

  draw: ->
    super
    # Outline
    @context.strokeStyle = App.VUI.colorAlpha @drawColor, ( if @controlData.touched then 1 else 0.5 )
    @context.lineWidth = 2
    @context.strokeRect 0, 0, @values.width, @values.height

    middleLine = Math.floor(if @horizontal then @values.width / 2 else @values.height / 2)
    @context.fillStyle = App.VUI.colorAlpha @drawColor, ( if @controlData.touched then 1 else 0.5 )
    if @horizontal
      @context.fillRect middleLine, 1, 1, @values.height - 2
    else
      @context.fillRect 1, middleLine, @values.width - 2, 1

    if @controlData.touched
      @context.fillStyle = App.VUI.colorAlpha @drawColor, 0.4
      if @horizontal
        valueChange = ( if @controlData.positionInsideX < @values.width / 2 then -1 else 1 )
        if valueChange > 0 then @context.fillRect middleLine+1, 1, @values.width - middleLine - 2, @values.height - 2
        else @context.fillRect 1, 1, middleLine - 1, @values.height - 2
      else
        valueChange = ( if @controlData.positionInsideY < @values.height / 2 then 1 else -1 )
        if valueChange > 0 then @context.fillRect 1, 1, @values.width - 2, middleLine - 1
        else @context.fillRect 1, middleLine+1, @values.width - 2, @values.height - middleLine - 2

    if @horizontal
      plusLocation = [ Math.round(middleLine * 1.5), Math.round(@values.height / 2) ]
      minusLocation = [ Math.round(middleLine * 0.5), Math.round(@values.height / 2) ]
    else
      plusLocation = [ Math.round(@values.width / 2), Math.round(middleLine * 0.5) ]
      minusLocation = [ Math.round(@values.width / 2), Math.round(middleLine * 1.5) ]

    @context.fillStyle = ( if valueChange > 0 then @whiteColor else App.VUI.colorAlpha @drawColor, 0.4 )
    @context.fillRect plusLocation[0] - 7, plusLocation[1] - 1, 15, 3 # Horizontal bar
    @context.fillRect plusLocation[0] - 1, plusLocation[1] - 7, 3, 6 # Vertical bar top
    @context.fillRect plusLocation[0] - 1, plusLocation[1] + 2, 3, 6 # Vertical bar bottom

    @context.fillStyle = ( if valueChange < 0 then @whiteColor else App.VUI.colorAlpha @drawColor, 0.4 )
    @context.fillRect minusLocation[0] - 7, minusLocation[1] - 1, 15, 3 # Horizontal bar

    # optionCount = @values.propertyOptions.length
    # sectorWidth = (@values.width - 2 - 4) / optionCount - 4
    # currentLocation = 1 + 4
    # for option in [0..optionCount-1]
    #   if option is @displayValue
    #     @context.fillStyle = App.VUI.colorAlpha @drawColor, ( if @controlData.touched then 0.8 else 0.6 )
    #     @context.fillRect currentLocation, 5, sectorWidth, @values.height - 10
    #     @context.fillStyle = @whiteColor
    #   else
    #     @context.fillStyle = App.VUI.colorAlpha @whiteColor, 0.6

    #   @context.font = '10pt sans-serif'
    #   @context.textAlign = 'center'
    #   @context.fillText "#{ @values.propertyOptions[option] }", currentLocation + sectorWidth / 2, @values.height / 2 + 4

    #   currentLocation += sectorWidth + 4
