class App.VUI.Toggle extends App.VUI.CanvasBase
  propertyType: 'toggle'
  dataType: 'boolean'

  defaults:
    resetValue: false
    propertyValue: false

  setValue: ->
    if @controlData.state is 'end'
      @values.propertyValue = not @values.propertyValue
    super

  draw: ->
    super
    # Outline
    @context.strokeStyle = App.VUI.colorAlpha @drawColor, ( if @controlData.touched then 1 else 0.5 )
    @context.lineWidth = 2
    @context.strokeRect 0, 0, @values.width, @values.height
    # Fill
    if @values.propertyValue
      @context.fillStyle = App.VUI.colorAlpha @drawColor, ( if @controlData.touched then 1 else 0.6 )
      @context.fillRect 5, 5, @values.width - 10, @values.height - 10
