class App.TrackFilters.BrightnessContrast extends App.TrackFilters.Base

  defaults: -> $.extend super,
    brightness: 0
    contrast: 0

  attributeControls: -> $.extend super,
    'brightness': { type: 'slider', name: 'Brightness', min: -1, pos: [2, 0, 5, 1] }
    'contrast': { type: 'slider', name: 'Contrast', min: -1, pos: [7, 0, 5, 1] }

  name: 'Brightness and Contrast'
  filterClass: WAGNER.CustomBrightnessContrastPass
