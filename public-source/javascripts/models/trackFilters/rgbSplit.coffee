class App.TrackFilters.RGBSplit extends App.TrackFilters.Base

  defaults: -> $.extend super,
    deltaX: 0
    deltaY: 0

  attributeControls: -> $.extend super,
    'deltaX': { type: 'slider', name: 'Blur X', max: 20, pos: [2, 0, 5, 1] }
    'deltaY': { type: 'slider', name: 'Blur Y', max: 20, pos: [7, 0, 5, 1] }

  updateValue: (item, value, options = {}) ->
    if item is 'deltaX'
      @filter.params.delta.x = value
      return
    else if item is 'deltaY'
      @filter.params.delta.y = value
      return
    super

  name: 'RGB Split'
  filterClass: WAGNER.RGBSplitPass
