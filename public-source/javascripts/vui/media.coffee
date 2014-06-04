class App.VUI.Media extends App.VUI.DOMBase
  propertyType: 'media'
  dataType: 'string'
  mediaType: 'images'

  defaults:
    resetValue: 'Default.png'
    propertyOptions: [ 'One', 'Two', 'Three', 'Four', 'Five' ]
    propertyValue: 'One'

  setValue: (e) =>
    return if @controlDisabled or @controlState is 'disabled'
    @values.propertyValue = @values.propertyOptions[ parseInt($(e.target).closest('li').attr('data-value')) ]
    @draw()
    super

  propertyValueLabel: -> @values.propertyValue

  setup: ->
    optionList = $("<ul class='mediaList optionList' />")
    @$control.append optionList
    for index in [0..@values.propertyOptions.length-1]
      optionList.append $("<li data-value='#{ index }'><div class='thumbnail'><img src='/library/_vijualThumbnails/#{ @values.propertyOptions[index] }.png' /></div><span>#{ @values.propertyOptions[index] }</span></li>")
    @$el.on 'click', 'li', @setValue
    FastClick.attach @el

    super

  draw: ->
    super
    @$control.find('li').removeClass('selected').find("span:contains(#{ @values.propertyValue })").closest('li').addClass('selected')
    return
