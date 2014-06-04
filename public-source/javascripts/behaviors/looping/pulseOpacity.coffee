class App.Behaviors.PulseOpacity extends App.Behaviors.Looping
  name: "Pulse Opacity"
  counter: 0

  defaults: -> $.extend super, { period: 10 }
  attributeControls: -> $.extend super, { 'period': { type: 'knob', name: 'Period', max: 20, pos: [2, 0, 3, 1] } }

  run: (delta) ->
    @counter += delta * (20 / @get('period'))
    newOpacity =  Math.sin( @counter ) / 2 + 0.5
    @object.set 'material.opacity', newOpacity
