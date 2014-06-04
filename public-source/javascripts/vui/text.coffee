class App.VUI.Text extends App.VUI.DOMBase
  propertyType: 'text'
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
    @$control.append $("<input type='text' class='vui-text-field' value='#{ @values.propertyValue }' />")
    @$el.on 'keyup', 'input', @setValue
    FastClick.attach @el
    super

  draw: ->
    super
    @$('input').val @values.propertyValue
    return
