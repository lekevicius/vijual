class App.TrackFilters.Pixelate extends App.TrackFilters.Base

  defaults: -> $.extend super,
    amount: 320

  attributeControls: -> $.extend super,
    'amount': { type: 'slider', name: 'Amount', max: 800, step: 1, pos: [2, 0, 10, 1] }

  name: 'Pixelate'
  filterClass: WAGNER.PixelatePass
