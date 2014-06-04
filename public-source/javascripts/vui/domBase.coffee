class App.VUI.DOMBase extends App.VUI.Base

  propertyType: 'domBase'

  events: {}

  initialize: (options = {}) ->
    super

    @control = $('<div/>').css { width: @values.width, height: @values.height }
    @$control = $(@control)

    @setup()

  setDisplayValue: -> @displayValue = @values.propertyValue

  render: ->
    super
    @$vuiHolder.append $(@control).addClass 'vui-control-element'
    @

  setup: ->
    @setDisplayValue()
    @draw()

  draw: ->
    super
    @setDisplayValue()
    if @controlDisabled or @controlState is 'disabled' then @$el.addClass 'disabled' else @$el.removeClass 'disabled'
    # set attr.style here, and use classes, .color-border, .color-background, .color-text
