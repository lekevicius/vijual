class App.Views.MainView extends Backbone.View

  template: JST.main

  events:
    'click .gridSlot': 'resetSelection'
    'dblclick .gridSlot': 'createNewObjectAt'

  initialize: ->
    @gridObjects = []
    @sidebarViews = []
    @trackViews = []
    @childViews = []
    @listenTo App.document, "change:selectedTrack", @renderGrid
    @listenTo App.document.get('selectedObjects'), "add remove reset", @renderSidebar

    @addingNewObject = false
    @addingNewBehavior = false
    @newBehaviorData = { model: null, type: 'intro' }

    Mousetrap.bind 'enter', (e) =>
      e.preventDefault()
      @showNewObjectSidebar()
      return false

    Mousetrap.bind 'backspace', (e) =>
      e.preventDefault()
      object.destroy() for object in App.document.get('selectedObjects').toArray()
      App.mainView.renderGrid()
      return false

    Mousetrap.bind 'space', (e) =>
      e.preventDefault()
      if App.document.get('selectedObjects').size()
        object.toggleActivation() for object in App.document.get('selectedObjects').toArray()
      else
        App.document.get('tracks').at( App.document.get('selectedTrack') ).toggleActivation()
      return false

    for trackNumber in [1..8]
      Mousetrap.bind trackNumber+'', (e) =>
        e.preventDefault()
        App.mainView.selectTrack parseInt(String.fromCharCode(e.keyCode)) - 1
        return false

    Mousetrap.bind 'command+a', (e) =>
      e.preventDefault()
      App.document.get('selectedObjects').reset App.document.get('tracks').at( App.document.get('selectedTrack') ).get('objects').toArray()
      return false

    Mousetrap.bind 'command+c', (e) =>
      e.preventDefault()
      clipboard = []
      for object in App.document.get('selectedObjects').toArray()
        objectCopy = object.toJSON()
        delete objectCopy['id']
        delete objectCopy['editor.gridPosition']
        objectCopy.attributeLinksIn = {}
        for behavior in objectCopy.behaviors
          delete behavior['id']
        clipboard.push objectCopy
      App.clipboard = clipboard
      return false

    Mousetrap.bind 'command+shift+l', (e) =>
      if (annyang)
        annyang.addCommands
          'show (me ) (a ) (an ) (the ) *term': (term) ->
            console.log "Showing #{ term }"
            object.setToFirstResult(term) for object in App.document.get('selectedObjects').toArray() when object.get('type') is 'noun'
          'create (a ) (an ) (new ) *term': (term) ->
            if term in _.keys(App.objectTypes)
              console.log "Creating #{ term }"
              App.mainView.newObjectWithType term
        annyang.start()

    charObjects =
      c: 'color'
      i: 'image'
      v: 'video'
      w: 'webcam'
      t: 'text'
      n: 'noun'
      g: 'gradient'
      d: 'drawing'
      s: 'shape'
      u: 'cube'
      p: 'plane'
      r: 'circle'
      k: 'torusknot'

    @bindCharacterToNewObject key, value for key, value of charObjects

    Mousetrap.bind 'command+v', (e) =>
      e.preventDefault()
      currentTrackObjects = App.document.get('tracks').at( App.document.get('selectedTrack') ).get('objects')
      for object in App.clipboard
        newObject = App.VO.Base.build object
        currentTrackObjects.add newObject
      App.mainView.renderGrid()
      return false

  bindCharacterToNewObject: (char, type) =>
    Mousetrap.bind char, (e) =>
      e.preventDefault()
      @newObjectWithType type
      return false

  newObjectWithType: (type, position) ->
    newObjectClass = App.objectTypes[type].className
    attributes = {}
    attributes['editor.gridPosition'] = position if position
    newObject = new newObjectClass attributes
    App.document.get('tracks').at( App.document.get('selectedTrack') ).get('objects').add newObject
    App.mainView.addGridObject(newObject)
    App.mainView.updateGridAvailability()
    @temp = newObject
    App.utils.delay 1, => App.document.get('selectedObjects').reset(@temp)

  selectTrack: (track) =>
    if App.document.get('selectedTrack') isnt track then App.document.set 'selectedTrack', track
    App.document.get('selectedObjects').reset()

  render: =>
    @$el.html @template()

    @$documentToolbar = @$( '#documentToolbar' )
    @$tracks = @$( '#tracks' )
    @$grid = @$( '#objectGrid' )
    @$objects = @$( '#objectHolder' )
    @$sidebar = @$( '#sidebar' )

    @documentToolbar = new App.Views.DocumentToolbar model: App.document
    @$documentToolbar.html @documentToolbar.render().el
    @childViews.push @documentToolbar

    @renderTracks()

    @$('.gridSlot').droppable
      hoverClass: "drop-hover"
      accept: ".gridObject, .object-type"
      drop: (e, ui) ->
        newPosition = [ $(@).data('x'), $(@).data('y') ]
        if $(ui.draggable[0]).hasClass 'gridObject'
          currentTrack = App.document.get('tracks').at( App.document.get('selectedTrack') )
          currentTrackObjects = currentTrack.get('objects')
          droppedObjectId = $(ui.draggable[0]).data('id')
          droppedObject = currentTrackObjects.get droppedObjectId
          oldPosition = droppedObject.get 'editor.gridPosition'
          currentTrack.gridMap[oldPosition[0]][oldPosition[1]] = false
          currentTrack.gridMap[newPosition[0]][newPosition[1]] = droppedObject
          droppedObject.set 'editor.gridPosition', newPosition
          App.mainView.updateGridAvailability()
        else if $(ui.draggable[0]).hasClass 'object-type'
          App.mainView.newObjectWithType $(ui.draggable[0]).data('type'), newPosition
    @renderGrid()
    @renderSidebar()
    @

  renderTracks: =>
    view.close() for view in @trackViews
    @childViews = _.difference @childViews, @trackView
    @trackViews = []

    for track in App.document.get('tracks').toArray()
      trackView = new App.Views.Track model: track
      @$tracks.append trackView.render().el
      @childViews.push trackView
      @trackViews.push trackView

    # App.document.get('tracks')
    @$tracks.sortable
      appendTo: document.body
      axis: 'x'
      cursorAt: { left: 50 }
      scroll: false
      distance: 10
      stop: (e, ui) ->
        sorter = 0
        previouslySelectedTrackNumber = App.document.get('selectedTrack')
        newTrackNumberOfPreviouslySelected = 0
        $( '.track', @ ).each (item) ->
          $(@).attr 'data-sorter', sorter
          if App.VO.GlobalLookup[ $(@).data('id') ].trackNumber is previouslySelectedTrackNumber
            newTrackNumberOfPreviouslySelected = sorter
          App.VO.GlobalLookup[ $(@).data('id') ].set('trackNumber', sorter)
          App.VO.GlobalLookup[ $(@).data('id') ].trackNumber = sorter
          sorter += 1
        App.document.get('tracks').sort()
        track.updateSort() for track in App.document.get('tracks').toArray()
        App.document.set('selectedTrack', newTrackNumberOfPreviouslySelected)
        App.mainView.renderTracks()



  updateGridAvailability: =>
    @$(".gridSlot").removeClass('unavailable').droppable('enable')
    currentTrack = App.document.get('tracks').at( App.document.get('selectedTrack') )
    x = 0
    y = 0
    for column in currentTrack.gridMap
      y = 0
      for row in column
        if currentTrack.gridMap[x][y]
          # console.log "Object exists at #{x},#{y}"
          @$("#gridSlot_#{ x }_#{ y }").addClass('unavailable').droppable('disable')
        y++
      x++

  renderGrid: =>
    view.close() for view in @gridObjects
    @childViews = _.difference @childViews, @gridObjects
    @gridObjects = []
    @addGridObject object for object in App.document.get('tracks').at( App.document.get('selectedTrack') ).get('objects').toArray()
    @updateGridAvailability()

  addGridObject: (model) ->
    objectView = new App.Views.VijualObject model: model
    @$objects.append objectView.render().el
    @gridObjects.push objectView
    @childViews.push objectView

  renderSidebar: ->
    view.close() for view in @sidebarViews
    @childViews = _.difference @childViews, @sidebarViews
    @sidebarViews = []
    @$sidebar.attr 'class', ''

    selectedObjects = App.document.get('selectedObjects')

    if @addingNewObject
      sidebarView = new App.Views.AddObjectSidebar newObjectLocation: @newObjectLocation
      @$sidebar.attr('class', 'add-object').append sidebarView.render().el
      @sidebarViews.push sidebarView
      @childViews.push sidebarView
    else if @addingNewBehavior
      sidebarView = new App.Views.AddBehaviorSidebar @newBehaviorData
      @$sidebar.attr('class', 'add-behavior').append sidebarView.render().el
      @sidebarViews.push sidebarView
      @childViews.push sidebarView
    else if selectedObjects.length
      for object in selectedObjects.models
        sidebarView = new App.Views.Sidebar model: object
        @$sidebar.append sidebarView.render().el
        @sidebarViews.push sidebarView
        @childViews.push sidebarView
    else
      selectedTrack =  App.document.get('tracks').at( App.document.get('selectedTrack') )
      sidebarView = new App.Views.Sidebar model: selectedTrack
      @$sidebar.append sidebarView.render().el
      @sidebarViews.push sidebarView
      @childViews.push sidebarView

    @addingNewObject = false
    @addingNewBehavior = false
    App.mainView.documentToolbar.updateButtonStates()

  resetSelection: ->
    App.document.get('selectedObjects').reset()

  showNewObjectSidebar: ->
    @addingNewObject = true
    @newObjectLocation = null
    @renderSidebar()

  createNewObjectAt: (e) ->
    @addingNewObject = true
    @newObjectLocation = [ $(e.target).data('x'), $(e.target).data('y') ]
    @renderSidebar()

  showNewBehaviorSidebar: (object, type) ->
    @addingNewBehavior = true
    @newBehaviorData = { model: object, type: type }
    @renderSidebar()


# function handleFileSelect(evt) {
#   evt.stopPropagation();
#   evt.preventDefault();

#   var files = evt.dataTransfer.files; // FileList object.

#   // files is a FileList of File objects. List some properties.
#   var output = [];
#   for (var i = 0, f; f = files[i]; i++) {
#     output.push('<li><strong>', escape(f.name), '</strong> (', f.type || 'n/a', ') - ',
#                 f.size, ' bytes, last modified: ',
#                 f.lastModifiedDate ? f.lastModifiedDate.toLocaleDateString() : 'n/a',
#                 '</li>');
#   }
#   document.getElementById('list').innerHTML = '<ul>' + output.join('') + '</ul>';
# }

# function handleDragOver(evt) {
#   evt.stopPropagation();
#   evt.preventDefault();
#   evt.dataTransfer.dropEffect = 'copy'; // Explicitly show this is a copy.
# }

# // Setup the dnd listeners.
# var dropZone = document.getElementById('drop_zone');
# dropZone.addEventListener('dragover', handleDragOver, false);
# dropZone.addEventListener('drop', handleFileSelect, false);
