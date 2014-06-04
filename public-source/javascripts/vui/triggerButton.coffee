class App.VUI.TriggerButton extends App.VUI.CanvasBase
  propertyType: 'triggerButton'
  dataType: 'boolean'

  defaults:
    resetValue: false
    propertyValue: true
    hasOutlet: false

  setValue: (forceValue) =>
    if forceValue isnt undefined then @values.propertyValue = forceValue
    else if @controlData.state is 'end'
      @values.propertyValue = true
      App.utils.delay 16, => @setValue false
    super

  setDisplayValue: -> @displayValue = @controlData.touched

  draw: ->
    super
    # Outline
    @context.strokeStyle = App.VUI.colorAlpha @drawColor, ( if @displayValue then 1 else 0.5 )
    @context.lineWidth = 2
    @context.strokeRect 0, 0, @values.width, @values.height
    # Fill
    if @displayValue
      @context.fillStyle = App.VUI.colorAlpha @drawColor, 0.8
      @context.fillRect 5, 5, @values.width - 10, @values.height - 10
    # Label on the button
    if @displayValue
      @context.fillStyle = @whiteColor
    else
      @context.fillStyle = App.VUI.colorAlpha @whiteColor, 0.6
    @context.font = '10pt sans-serif'
    @context.textAlign = 'center'
    @context.fillText "#{ @values.propertyLabel }", @values.width / 2, @values.height / 2 + 4
