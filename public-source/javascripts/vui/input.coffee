class App.VUI.Input extends App.VUI.Base
  propertyType: 'input'
  defaults:
    outletOrientation: 'horizontal'
    onlyOutlet: true
    allowLinkOut: false
    allowRecord: false

  initialize: (options = {}) ->
    super
    @draw()

  doResetValue: () ->

  render: ->
    super
    @$vuiHolder.append "<div class='outlet-tag'></div>"
    @
