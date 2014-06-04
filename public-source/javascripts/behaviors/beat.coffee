class App.Behaviors.Beat extends App.Behaviors.Base

  # defaults: -> $.extend super, {}
  # attributeControls: -> $.extend super, {}

  groupName: 'beat'

  initialize: ->
    super
    @bind 'add', @onAdd, @

  onAdd: (model, collection, options) ->
    @setupListeners(collection)
    @object = collection.object

  runIfActive: () -> @run.apply(@, arguments) if @get('active') and @object and @object.get('active')

  beatDuration: -> (App.ticker.bpmDuration) / 1000 - 0.02
  setupListeners: -> @listenTo App.ticker, 'beat', @runIfActive
