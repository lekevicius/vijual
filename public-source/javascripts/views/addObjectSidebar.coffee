class App.Views.AddObjectSidebar extends Backbone.View

  template: JST.addObjectSidebar

  initialize: (attributes) ->
    Mousetrap.bind 'esc', (e) =>
      e.preventDefault()
      Mousetrap.unbind 'esc'
      App.mainView.renderSidebar()
      return false
    @newObjectLocation = attributes.newObjectLocation if attributes.newObjectLocation

  events:
    'dblclick .object-type': 'newObject'

  render: ->
    @$el.html @template()
    @$('.object-type').draggable
      revert: 'invalid'
      revertDuration: 150
      helper: 'clone'
      appendTo: document.body
      scroll: false
    @

  newObject: (e) -> App.mainView.newObjectWithType $(e.currentTarget).data('type'), @newObjectLocation
