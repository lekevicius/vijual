class App.Behaviors.Operator extends App.Behaviors.Base

  # defaults: -> $.extend super, {}
  # attributeControls: -> $.extend super, {}

  groupName: 'operator'

  initialize: ->
    super
    @bind 'add', @onAdd, @
    @setupListeners()

  onAdd: (model, collection, options) -> @setupListeners()

  hasLink: (attribute) -> !! @get('attributeLinksIn')[ "#{ @id } #{ attribute }" ]

  setupListeners: -> @listenTo @, 'change', @runIfActive
