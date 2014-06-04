class App.VUI.Output extends App.VUI.Base
  propertyType: 'output'
  defaults:
    outletOrientation: 'horizontal'
    onlyOutlet: true
    allowRecord: false
    allowLinkIn: false

  initialize: (options = {}) ->
    super
    @draw()

  doResetValue: () ->

  render: ->
    super
    @$vuiHolder.append "<div class='outlet-tag'></div>"
    @
