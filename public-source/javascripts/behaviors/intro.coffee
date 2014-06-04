class App.Behaviors.Intro extends App.Behaviors.Base

  defaults: -> $.extend super, { time: 1 }
  attributeControls: -> $.extend super, { 'time': { type: 'slider', name: 'Duration', max: 5, pos: [2, 0, 3, 1] } }

  groupName: 'intro'

  initialize: ->
    super
    @bind 'add', @onAdd, @

  onAdd: (model, collection, options) ->
    @setupListeners(collection)
    @object = collection.object

  setupListeners: (collection) ->
    @listenTo collection.object, 'activate', @runIfActive

