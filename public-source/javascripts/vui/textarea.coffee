class App.VUI.TextArea extends App.VUI.DOMBase
  propertyType: 'textarea'
  dataType: 'string'

  defaults:
    resetValue: ''
    propertyValue: ''

  setValue: (e) =>
    return if @controlDisabled or @controlState is 'disabled'
    @values.propertyValue = e.target.value
    @draw()
    super

  setup: ->
    @$control.append $("<textarea class='vui-text-field'>#{ @values.propertyValue }</textarea>")
    @$el.on 'keyup', 'textarea', @setValue
    FastClick.attach @el
    super

  draw: ->
    super
    @$('textarea').val @values.propertyValue
    return
