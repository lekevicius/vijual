class App.TrackFilters.HueSaturation extends App.TrackFilters.Base

  defaults: -> $.extend super,
    hue: 0
    saturation: 0

  attributeControls: -> $.extend super,
    'hue': { type: 'slider', name: 'Hue', min: -1, pos: [2, 0, 5, 1] }
    'saturation': { type: 'slider', name: 'Saturation', min: -1, pos: [7, 0, 5, 1] }

  name: 'Hue and Saturation'
  filterClass: WAGNER.CustomHueSaturationPass
