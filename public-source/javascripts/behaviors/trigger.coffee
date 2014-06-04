class App.Behaviors.Trigger extends App.Behaviors.Base

  groupName: 'trigger'
  attributeControls: -> {}

  initialize: ->
    super
    @bind 'add', @onAdd, @

  onAdd: (model, collection, options) ->
    @setupListeners(collection)
    @object = collection.object

  hit: =>  @run() if @get 'active' and @object and @object.get('active')

  run: -> console.log "Yeah, run little", @get('object')
