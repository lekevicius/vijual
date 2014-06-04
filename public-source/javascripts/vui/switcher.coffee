class App.VUI.Switcher extends App.VUI.CanvasBase
  propertyType: 'switcher'
  dataType: 'option'

  defaults:
    resetValue: 0
    propertyOptions: [ 'Yes', 'No' ]
    propertyValue: 1
    hasOutlet: false

  setValue: ->
    if @controlData.state is 'start'

      optionCount = @values.propertyOptions.length
      fullSize = if @horizontal then @values.width else @values.height
      sectorSize = (fullSize - 2 - 4) / optionCount - 4
      currentLocation = 1 + 4 / 2
      pressedLocation = if @horizontal then @controlData.positionInsideX else @controlData.positionInsideY
      newValue = null

      for option in [0..optionCount-1]
        upperBound = currentLocation + sectorSize + 4
        if currentLocation <= pressedLocation < upperBound
          newValue = option
          break
        currentLocation = upperBound

      newValue = ( if pressedLocation < fullSize / 2 then 0 else optionCount - 1 ) unless newValue

      @values.propertyValue = newValue
    super

  draw: ->
    super
    # Outline
    @context.strokeStyle = App.VUI.colorAlpha @drawColor, ( if @controlData.touched then 1 else 0.5 )
    @context.lineWidth = 2
    @context.strokeRect 0, 0, @values.width, @values.height

    optionCount = @values.propertyOptions.length
    fullSize = if @horizontal then @values.width else @values.height
    sectorSize = (fullSize - 2 - 4) / optionCount - 4
    currentLocation = 1 + 4
    for option in [0..optionCount-1]
      if option is @displayValue
        @context.fillStyle = App.VUI.colorAlpha @drawColor, ( if @controlData.touched then 0.8 else 0.6 )
        if @horizontal
          @context.fillRect currentLocation, 5, sectorSize, @values.height - 10
        else
          @context.fillRect 5, currentLocation, @values.width - 10, sectorSize
        @context.fillStyle = @whiteColor
      else
        @context.fillStyle = App.VUI.colorAlpha @whiteColor, 0.6

      @context.font = '10pt sans-serif'
      @context.textAlign = 'center'
      if @horizontal
        @context.fillText "#{ @values.propertyOptions[option] }", currentLocation + sectorSize / 2, @values.height / 2 + 4
      else
        @context.fillText "#{ @values.propertyOptions[option] }", @values.width / 2, currentLocation + sectorSize / 2  + 4

      currentLocation += sectorSize + 4
    return
