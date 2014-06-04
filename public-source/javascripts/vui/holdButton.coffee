class App.VUI.HoldButton extends App.VUI.CanvasBase
  propertyType: 'holdButton'
  dataType: 'boolean'

  defaults:
    resetValue: false
    propertyValue: true
    hasOutlet: false

  setValue: ->
    if @controlData.state is 'start' or @controlData.state is 'end'
      @values.propertyValue = @controlData.touched
    super

  setDisplayValue: -> @displayValue = (@values.propertyValue or @controlData.touched)

  draw: new App.VUI.TriggerButton().draw

