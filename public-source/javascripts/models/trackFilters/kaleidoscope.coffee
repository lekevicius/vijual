class App.TrackFilters.Kaleidoscope extends App.TrackFilters.Base

  defaults: -> $.extend super,
    sides: 6
    angle: 0

  attributeControls: -> $.extend super,
    'sides': { type: 'integerSlider', name: 'Sides', max: 24, pos: [2, 0, 5, 1] }
    'angle': { type: 'angle', name: 'angle', pos: [7, 0, 5, 1] }

  name: 'Kaleidoscope'
  filterClass: WAGNER.CustomKaleidoscopePass
