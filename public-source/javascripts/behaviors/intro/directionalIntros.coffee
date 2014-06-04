class App.Behaviors.DirectionalIntro extends App.Behaviors.Intro
  name: "Directional Intro"
  properties: [ 'setScreenPositionY', 'setScreenPositionY', 'setScreenPositionX', 'setScreenPositionX' ]
  valueChanges: [ '-=0.4', '+=0.4', '-=0.4', '+=0.4' ]
  currentValueIndex: [ 1, 1, 0, 0 ]
  easing: 'Quad.easeOut'

  defaults: -> $.extend super, { direction: 0 }
  attributeControls: -> $.extend super, { 'direction': { type: 'switcher', name: 'Direction', options: [ 'Top', 'Bottom', 'Left', 'Right' ], pos: [5, 0, 4, 1] } }

  run: () ->
    @proxy.property = @object.get('screenPosition')[ @currentValueIndex[ @get('direction') ] ]
    TweenLite.from @proxy, @get('time'),
      ease: @easing
      property: @valueChanges[ @get('direction') ]
      onUpdateParams: ["{self}"]
      onUpdate: (tween) => @object[ @properties[ @get('direction') ] ](tween.target.property)



class App.Behaviors.BounceInDirectionally extends App.Behaviors.DirectionalIntro
  name: "Bounce In Directionally"
  easing: 'Back.easeOut'

class App.Behaviors.BounceInFromSide extends App.Behaviors.DirectionalIntro
  name: "Bounce In From Side"
  easing: 'Back.easeOut'
  valueChanges: [ -0.5, 1.5, -0.5, 1.5 ]

class App.Behaviors.SlideInDirectionally extends App.Behaviors.DirectionalIntro
  name: "Slide In Directionally"

class App.Behaviors.SlideInFromSide extends App.Behaviors.DirectionalIntro
  name: "Slide In From Side"
  valueChanges: [ -0.5, 1.5, -0.5, 1.5 ]
