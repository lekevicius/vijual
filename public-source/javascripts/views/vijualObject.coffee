class App.Views.VijualObject extends Backbone.View

  template: JST.vijualObject
  id: -> "vo_#{ @model.id }"
  className: -> "gridObject#{ if App.document.get('selectedObjects').contains(@model) then ' selected' else '' }"

  initialize: ->
    @$el.attr 'data-id', @model.id
    @updatePosition()
    @listenTo App.document.get('selectedObjects'), "add remove reset", -> @$el.attr 'class', @className()
    @listenTo @model, "change:material.opacity change:editor.name change:editor.color change:active", @render
    @listenTo @model, "change:editor.gridPosition", @updatePosition
    @$el.draggable
      revert: 'invalid'
      revertDuration: 150
      appendTo: document.body
      scroll: false
      helper: 'clone'
      distance: 8
      start: -> $(@).css visibility: 'hidden'
      stop: -> $(@).css visibility: 'visible'

  updatePosition: ->
    position = @model.get('editor.gridPosition')
    @$el.css
      left: position[0] * 12.5 + '%'
      top: position[1] * 12.5 + '%'
      position: 'absolute'

  events:
    'click': 'selectObject'
    'click .object-activation-toggle': 'toggleActivation'

  toggleActivation: -> @model.toggleActivation()

  render: ->
    @$el.html @template({ object: @model, color: App.colors[ @model.get('editor.color') ] })
    @$el.css
      width: ((window.innerWidth - 300) / 8) + 'px'
      height: ((window.innerHeight - 88) / 8) + 'px'
    @

  selectObject: (e) ->
    if e.shiftKey or e.metaKey
      if App.document.get('selectedObjects').contains(@model)
        App.document.get('selectedObjects').remove @model
      else
        App.document.get('selectedObjects').add @model
    else
      App.document.get('selectedObjects').reset(@model)
