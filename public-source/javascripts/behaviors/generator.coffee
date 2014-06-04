class App.Behaviors.Generator extends App.Behaviors.Base

  # defaults: -> $.extend super, {}
  # attributeControls: -> $.extend super, {}

  groupName: 'generator'

  initialize: ->
    super
    @bind 'add', @onAdd, @

  onAdd: (model, collection, options) -> @setupListeners()

  runIfActive: () -> @run.apply(@, arguments) if @get('active')

  setupListeners: -> @listenTo App.ticker, 'frame', @runIfActive
