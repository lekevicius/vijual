class App.Ticker extends Backbone.Model
  defaults:
    bpm: 110

  initialize: (attributes = {}, options = {}) ->
    _.bindAll @, 'everyFrame'
    @last = null
    @bpmDuration = 60000 / @get('bpm')
    @bpmInterval = App.utils.every @bpmDuration, @onBPM
    @on 'change:bpm', @updateBPM, @
    @on 'beat', @flashButton, @
    @button = $('.sync-button').get(0)
    window.requestAnimationFrame @everyFrame

  updateBPM: (model, value) =>
    clearInterval @bpmInterval
    @bpmDuration = 60000 / @get('bpm')
    @bpmInterval = App.utils.every @bpmDuration, @onBPM

  onBPM: => @trigger 'beat'

  flashButton: =>
    unless @button
      @button = $('.sync-button').get(0)
      return
    TweenMax.fromTo @button, Math.max(@bpmDuration / 1000, 0.01), { backgroundColor: '#333' }, { backgroundColor: '#000000' }

  syncBPM: =>
    clearInterval @bpmInterval
    @bpmInterval = App.utils.every @bpmDuration, @onBPM
    @trigger 'beat'

  everyFrame: (timestamp) ->
    if @last
      delta = (timestamp - @last) / 1000
      @trigger 'frame', delta
    @last = timestamp
    window.requestAnimationFrame @everyFrame
