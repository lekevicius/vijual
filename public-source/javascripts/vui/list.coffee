class App.VUI.List extends App.VUI.DOMBase
  propertyType: 'list'
  dataType: 'option'

  defaults:
    resetValue: 0
    propertyOptions: [ 'One', 'Two', 'Three', 'Four', 'Five' ]
    propertyValue: 1

  setValue: (e) =>
    return if @controlDisabled or @controlState is 'disabled'
    @values.propertyValue = parseInt e.target.dataset.value
    @draw()
    super

  setup: ->
    optionList = $("<ul class='optionList' />")
    @$control.append optionList
    for index in [0..@values.propertyOptions.length-1]
      optionList.append $("<li data-value='#{ index }'>#{ @values.propertyOptions[index] }</li>")
    @$el.on 'click', 'li', @setValue
    FastClick.attach @el

    super

  updateOptions: ->
    optionList = @$control.find('ul')
    optionList.empty()
    for index in [0..@values.propertyOptions.length-1]
      optionList.append $("<li data-value='#{ index }'>#{ @values.propertyOptions[index] }</li>")
    @draw()

  draw: ->
    super
    @$control.find('li').removeClass('selected').eq( @values.propertyValue ).addClass('selected')
    return
