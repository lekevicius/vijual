class App.VUI.ControlSurfaceManager extends Backbone.Model

  outQueue: []
  listenedKeys: []
  listenedObjects: []

  getControlState: (object, key) ->
    state = 'default'
    if object.get('attributeLinksIn')[ "#{ object.id } #{ key }" ] then state = 'linked'
    if object.get('attributeRecordings')[key].recording then state = 'recording'
    if object.get('attributeRecordings')[key].playing then state = 'playing'
    state

  getControlRecordings: (object, key) -> ( { frames: recording.length } for recording in object.get('attributeRecordings')[key].recordings )

  buildLayoutControls: (object) ->
    controls = []
    _.each object.attributeControls(), (value, key) =>
      value.uuid = object.id
      value.key = key
      value.value = object.get key
      value.state = @getControlState(object, key)
      value.recordings = @getControlRecordings(object, key)

      if value.type is 'media'
        value.options = App.mediaLibrary.getByType value.mediaType

      controls.push value
    controls

  buildTrackMixer: ->
    controls = []
    for track in App.document.get('tracks').toArray()
      trackOpacityControl = track.attributeControls()['opacity']
      trackOpacityControl.uuid = track.id
      trackOpacityControl.key = 'opacity'
      trackOpacityControl.value = track.get 'opacity'
      trackOpacityControl.name = track.get 'editor.name'
      trackOpacityControl.color = App.colors[ track.get('editor.color') ]
      trackOpacityControl.state = @getControlState(track, 'opacity')
      trackOpacityControl.pos = [ 0, track.get('trackNumber'), 6, 1 ]
      controls.push trackOpacityControl

      trackBlendingModeControl = track.attributeControls()['blending']
      trackBlendingModeControl.uuid = track.id
      trackBlendingModeControl.key = 'blending'
      trackBlendingModeControl.value = track.get 'blending'
      trackBlendingModeControl.color = App.colors[ track.get('editor.color') ]
      trackBlendingModeControl.state = @getControlState(track, 'blending')
      trackBlendingModeControl.pos = [ 6, track.get('trackNumber'), 4, 1 ]
      controls.push trackBlendingModeControl

      trackActivationControl = track.attributeControls()['active']
      trackActivationControl.uuid = track.id
      trackActivationControl.key = 'active'
      trackActivationControl.value = track.get 'active'
      trackActivationControl.color = App.colors[ track.get('editor.color') ]
      trackActivationControl.state = @getControlState(track, 'active')
      trackActivationControl.pos = [ 10, track.get('trackNumber'), 2, 1 ]
      controls.push trackActivationControl

    controls

  updateLayout: ->
    @layout = []
    selectedObjects = App.document.get('selectedObjects')
    if selectedObjects.length
      for object in selectedObjects.toArray()
        @layout.push
          name: object.get('editor.name')
          color: object.get('editor.color')
          uuid: object.id
          controls: @buildLayoutControls object

        for behavior in object.get('behaviors').toArray()
          @layout.push
            name: behavior.name
            color: object.get('editor.color')
            uuid: object.id
            controls: @buildLayoutControls behavior
    else
      # selectedTrack =  App.document.get('tracks').at( App.document.get('selectedTrack') )
      @layout.push
        color: 24
        name: 'Track Opacity Mixer'
        uuid: 'null'
        controls: @buildTrackMixer()
      for track in App.document.get('tracks').toArray()
        for filter in track.get('filters').toArray()
          @layout.push
            name: track.get('editor.name') + ' ' + filter.name
            color: track.get('editor.color')
            uuid: track.id
            controls: @buildLayoutControls filter

    @updateWatcher @layout
    @layout

  updateWatcher: (layout) ->
    @stopListening()
    @listenedKeys = []
    @listenedObjects = []
    @outQueue = []
    for group in layout
      for control in group.controls
        unless control.uuid in @listenedObjects
          @listenTo App.VO.GlobalLookup[ control.uuid ], "change", @recordChanges
          @listenedObjects.push control.uuid
        @listenedKeys.push "#{ control.uuid } #{ control.key }"
      @listenedKeys.push "#{ group.uuid } editor.name"
      @listenedKeys.push "#{ group.uuid } editor.color"

  recordChanges: (model, options) ->
    uuid = model.id
    return if options.fromVUI
    for key, value of model.changed
      @outQueue.push { id: uuid, key: key, value: value } if "#{ uuid } #{ key }" in @listenedKeys

  dumpChanges: () ->
    queue = JSON.stringify @outQueue
    @outQueue = []
    return JSON.parse queue
