class App.Behaviors.PlaceInCenter extends App.Behaviors.Trigger
  name: "Place in Center"
  run: () -> @object.set { 'screenPosition': [ 0.5, 0.5 ] }

class App.Behaviors.PlaceLeft extends App.Behaviors.Trigger
  name: "Place Left"
  run: () -> @object.setScreenPositionX -0.5

class App.Behaviors.PlaceRight extends App.Behaviors.Trigger
  name: "Place Right"
  run: () -> @object.setScreenPositionX 1.5

class App.Behaviors.PlaceTop extends App.Behaviors.Trigger
  name: "Place Top"
  run: () -> @object.setScreenPositionY -0.5

class App.Behaviors.PlaceBottom extends App.Behaviors.Trigger
  name: "Place Bottom"
  run: () -> @object.setScreenPositionY 1.5
