class App.TrackFilters.Mirror extends App.TrackFilters.Base

  defaults: -> $.extend super,
    side: 1

  attributeControls: -> $.extend super,
    'side': { type: 'switcher', name: 'Side', options: [ 'Left', 'Right', 'Top', 'Bottom' ], pos: [2, 0, 10, 1] }

  name: 'Mirror'
  filterClass: WAGNER.CustomMirrorPass
