class App.Behaviors.DirectionalOutro extends App.Behaviors.Outro
  name: "Directional Outro"
  properties: [ 'setScreenPositionY', 'setScreenPositionY', 'setScreenPositionX', 'setScreenPositionX' ]
  valueChanges: [ '-=0.4', '+=0.4', '-=0.4', '+=0.4' ]
  currentValueIndex: [ 1, 1, 0, 0 ]
  easing: 'Quad.easeIn'

  defaults: -> $.extend super, { direction: 0 }
  attributeControls: -> $.extend super, { 'direction': { type: 'switcher', name: 'Direction', options: [ 'Top', 'Bottom', 'Left', 'Right' ], pos: [5, 0, 4, 1] } }

  run: () ->
    @startingValue = @object.get('screenPosition')[ @currentValueIndex[ @get('direction') ] ]
    @proxy.property = _.clone @startingValue

    TweenLite.to @proxy, @get('time'),
      ease: @easing
      property: @valueChanges[ @get('direction') ]
      onUpdateParams: ["{self}"]
      onUpdate: (tween) => @object[ @properties[ @get('direction') ] ](tween.target.property)
      onComplete: (tween) => @object[ @properties[ @get('direction') ] ]( @startingValue )



class App.Behaviors.BounceOutDirectionally extends App.Behaviors.DirectionalOutro
  name: "Bounce Out Directionally"
  easing: 'Back.easeIn'

class App.Behaviors.BounceOutToSide extends App.Behaviors.DirectionalOutro
  name: "Bounce Out To Side"
  easing: 'Back.easeIn'
  valueChanges: [ -0.5, 1.5, -0.5, 1.5 ]

class App.Behaviors.SlideOutDirectionally extends App.Behaviors.DirectionalOutro
  name: "Slide Out Directionally"

class App.Behaviors.SlideOutToSide extends App.Behaviors.DirectionalOutro
  name: "Slide Out To Side"
  valueChanges: [ -0.5, 1.5, -0.5, 1.5 ]
