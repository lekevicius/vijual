class App.TrackFilters.LED extends App.TrackFilters.Base

  defaults: -> $.extend super,
    pixelSize: 10
    tolerance: 0.25
    pixelRadius: 0.25
    luminanceSteps: 100
    luminanceBoost: 0.2
    colorBoost: 0.01
    burntOutPercent: 50

  attributeControls: -> $.extend super,
    'pixelSize': { type: 'slider', name: 'Pixel Size', max: 320, step: 1, pos: [2, 0, 1, 4] }
    'tolerance': { type: 'slider', name: 'Tolerance', pos: [3, 0, 1, 4] }
    'pixelRadius': { type: 'slider', name: 'Pixel Radius', pos: [4, 0, 1, 4] }
    'luminanceSteps': { type: 'slider', name: 'Steps', max: 320, step: 1, pos: [5, 0, 1, 4] }
    'luminanceBoost': { type: 'slider', name: 'Boost', pos: [6, 0, 1, 4] }
    'colorBoost': { type: 'slider', name: 'Color Boost', max: 0.1, pos: [7, 0, 1, 4] }
    'burntOutPercent': { type: 'slider', name: 'Burnout', max: 100, step: 1, pos: [8, 0, 1, 4] }

  name: 'LED'
  filterClass: WAGNER.LEDPass
