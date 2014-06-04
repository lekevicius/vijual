class App.TrackFilters.Colorify extends App.TrackFilters.Base

  defaults: -> $.extend super,
    color: new THREE.Color('#ffffff')

  attributeControls: -> $.extend super,
    'color': { type: 'color', name: 'Color', pos: [2, 0, 4, 3] }

  updateValue: (item, value, options = {}) ->
    if item is 'color'
      @filter.params.color.set value
      return
    super

  name: 'Colorify'
  filterClass: WAGNER.CustomColorifyPass
