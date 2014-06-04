class App.TrackFilters.Noise extends App.TrackFilters.Base

  defaults: -> $.extend super,
    amount: 0.1
    speed: 0

  attributeControls: -> $.extend super,
    'amount': { type: 'slider', name: 'Amount', max: 2, pos: [2, 0, 5, 1] }
    'speed': { type: 'slider', name: 'Speed', pos: [7, 0, 5, 1] }

  name: 'Noise'
  filterClass: WAGNER.NoisePass
