class App.TrackFilters.ColorCorrection extends App.TrackFilters.Base

  defaults: -> $.extend super,
    redPower: 1
    greenPower: 1
    bluePower: 1
    redMultiply: 1
    greenMultiply: 1
    blueMultiply: 1

  attributeControls: -> $.extend super,
    'redPower': { type: 'exponentialTracker', name: 'Red', pos: [3, 0, 3, 1] }
    'greenPower': { type: 'exponentialTracker', name: 'Green', pos: [6, 0, 3, 1] }
    'bluePower': { type: 'exponentialTracker', name: 'Blue', pos: [9, 0, 3, 1] }
    'redMultiply': { type: 'exponentialTracker', name: 'Red', pos: [3, 1, 3, 1] }
    'greenMultiply': { type: 'exponentialTracker', name: 'Green', pos: [6, 1, 3, 1] }
    'blueMultiply': { type: 'exponentialTracker', name: 'Blue', pos: [9, 1, 3, 1] }

  updateValue: (item, value, options = {}) ->

    if item is 'redPower'
      @filter.params.powRGB.x = value
      return
    else if item is 'greenPower'
      @filter.params.powRGB.y = value
      return
    else if item is 'bluePower'
      @filter.params.powRGB.z = value
      return

    if item is 'redMultiply'
      @filter.params.mulRGB.x = value
      return
    else if item is 'greenMultiply'
      @filter.params.mulRGB.y = value
      return
    else if item is 'blueMultiply'
      @filter.params.mulRGB.z = value
      return

    super

  name: 'Color Correction'
  filterClass: WAGNER.CustomColorCorrectionPass
