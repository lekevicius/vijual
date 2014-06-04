class App.Views.Track extends Backbone.View

  template: JST.track
  id: -> @model.id
  className: -> "track#{ if App.document.get('selectedTrack') is @model.trackNumber then ' selected' else '' }#{ if @model.get('active') then ' active' else ' inactive' }"

  initialize: ->
    @listenTo @model, "change:opacity change:editor.name change:editor.color", @render
    @listenTo @model, "change:active", -> @$el.attr 'class', @className()
    @listenTo App.document, "change:selectedTrack", -> @$el.attr 'class', @className()

  events:
    'click': 'selectTrack'

  render: ->
    @$el.html @template({ track: @model, color: App.colors[ @model.get('editor.color') ] })
    @$el.attr 'data-id', @model.id

    @$el.droppable
      hoverClass: "drop-hover"
      accept: ".gridObject, .object-type"
      drop: (e, ui) ->
        trackId = $(@).data('id')
        if $(ui.draggable[0]).hasClass 'gridObject'
          droppedObjectId = $(ui.draggable[0]).data('id')
          droppedObject = App.VO.GlobalLookup[ droppedObjectId ]
          droppedObject.moveToTrack trackId
          App.mainView.renderGrid()
        else if $(ui.draggable[0]).hasClass 'object-type'
          newObjectType = $(ui.draggable[0]).data('type')
          newObjectClass = App.objectTypes[newObjectType].className
          newObjectAttributes = {}
          newObject = new newObjectClass newObjectAttributes
          newTrack = App.VO.GlobalLookup[ trackId ]
          newTrack.get('objects').add newObject
          @temp = newObject
          App.document.set 'selectedTrack', newTrack.trackNumber
          App.utils.delay 1, => App.document.get('selectedObjects').reset(@temp)

    @

  selectTrack: -> App.mainView.selectTrack @model.trackNumber

# var canvas = document.getElementById('myCanvas');
# var context = canvas.getContext('2d');
# var x = canvas.width / 2;
# var y = canvas.height / 2;
# var radius = 75;
# var startAngle = 1.1 * Math.PI;
# var endAngle = 1.9 * Math.PI;
# var counterClockwise = false;

# context.beginPath();
# context.arc(x, y, radius, startAngle, endAngle, counterClockwise);
# context.lineWidth = 15;

# // line color
# context.strokeStyle = 'black';
# context.stroke();


