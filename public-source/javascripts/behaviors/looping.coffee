class App.Behaviors.Looping extends App.Behaviors.Base

  # defaults: -> $.extend super, {}
  # attributeControls: -> $.extend super, {}

  groupName: 'looping'

  initialize: ->
    super
    @bind 'add', @onAdd, @

  onAdd: (model, collection, options) ->
    @setupListeners(collection)
    @object = collection.object

  runIfActive: () -> @run.apply(@, arguments) if @get('active') and @object and @object.get('active')

  setupListeners: -> @listenTo App.ticker, 'frame', @runIfActive
