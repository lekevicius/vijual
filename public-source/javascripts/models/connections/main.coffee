class App.Connections.Main extends App.Connections.Base
  protocol: 'main'
  streamCanvas: true

  initialize: (attributes, options) ->
    super
    @sceneLowResCanvas = $('<div/>').html("<canvas width='#{ App.config.renderer.lowWidth }' height='#{ App.config.renderer.lowHeight }'></canvas>").contents().get(0)
    @sceneLowResCanvasContext = @sceneLowResCanvas.getContext '2d'
    @updateListeners()
    @listenTo App.document.get('selectedObjects'), "add remove reset", @setLayout

  onOpen: (e) =>
    @setLayout()
    # @listenTo App.ticker, 'frame', @sendDataUpdates
    App.utils.every Math.round(1000 / @connectionRate), @sendDataUpdates
    super

  updateListeners: ->
    @stopListening()
    @listenTo App.document.get('selectedObjects'), "add remove reset", @setLayout
    if App.document.get('selectedObjects').length
      @listenTo object.get('behaviors'), "add remove reset", @setLayout for object in App.document.get('selectedObjects').toArray()
    else
      @listenTo App.document.get('tracks').at( App.document.get('selectedTrack') ).get('filters'), "add remove reset", @setLayout

  props_updateValues: (doc) =>
    for change in doc
      if App.VO.GlobalLookup[change.id]
        if _.isString(change.value) and change.value.substr(0,1) is '#'
          value = change.value
        else
          if _.isString(change.value) and ( change.value.substr(0,1) is '{' or change.value.substr(0,1) is '[' )
            value = JSON.parse change.value
          else
            value = change.value
          value = (JSON.parse item for item in value) if _.isArray(value)
        App.VO.GlobalLookup[change.id].set change.key, value, { fromVUI: true }

  scene_updateSceneObject: (doc) =>
    return unless App.sceneManager.listenedObjectUUID
    sceneObject = App.VO.GlobalLookup[ App.sceneManager.listenedObjectUUID ]
    sceneObject.updateSceneChanges change for change in doc


  setLayout: =>
    @sendDocument 'props', 'setLayout', App.controlSurfaceManager.updateLayout() if 'props' in @onlinePeers
    @sendDocument 'scene', 'setObject', App.sceneManager.updateObject() if ('scene' in @onlinePeers)
    @sendDocument 'props', 'showAvailableLinks', App.LinkingData if App.LinkingData
    @updateListeners()

  updateOptions: (key, newOptions) =>
    @sendDocument 'props', 'updateOptions', { key: key, options: newOptions } if 'props' in @onlinePeers

  sendDataUpdates: =>
    if 'props' in @onlinePeers

      changes = App.controlSurfaceManager.dumpChanges()
      @sendDocument 'props', 'updateValues', changes if changes.length

    if 'scene' in @onlinePeers

      if App.renderer.rendering and @streamCanvas
        @sceneLowResCanvasContext.drawImage App.projections[0].canvas, 0, 0, App.config.renderer.width, App.config.renderer.height, 0, 0, App.config.renderer.lowWidth, App.config.renderer.lowHeight
        data = @sceneLowResCanvas.toDataURL()
        @sendDocument 'scene', 'drawCanvas', { dataURL: data }

      changes = App.sceneManager.dumpChanges()
      @sendDocument 'scene', 'setObject', changes if changes

  props_lookForLinks: (linkingData) =>
    App.LinkingData = linkingData
    @sendDocument 'props', 'showAvailableLinks', App.LinkingData if App.LinkingData

  props_stopLookingForLinks: =>
    App.LinkingData = null
    @sendDocument 'props', 'showAvailableLinks', null

  props_setupLink: (toData) =>
    App.VO.GlobalLookup[ toData.id ].addLinkIn "#{ toData.id } #{ toData.key }"

  setControlState: (key, state) =>
    @sendDocument 'props', 'setControlState',
      key: key
      state: state

  updateRecordings: (keyData) =>
    @sendDocument 'props', 'updateRecordings',
      key: "#{ keyData.id } #{ keyData.key }"
      recordings: ( { frames: recording.length } for recording in App.VO.GlobalLookup[ keyData.id ].get('attributeRecordings')[keyData.key].recordings )

  props_deleteLink: (toData) =>
    App.VO.GlobalLookup[ toData.id ].deleteLink toData

  props_startRecording: (keyData) =>
    App.VO.GlobalLookup[ keyData.id ].startRecording keyData.key
    App.mainConnection.setControlState "#{ keyData.id } #{ keyData.key }", 'recording'
  props_startPlaying: (keyData) =>
    App.VO.GlobalLookup[ keyData.id ].startPlaying keyData.key, keyData.recordingNumber
    App.mainConnection.setControlState "#{ keyData.id } #{ keyData.key }", 'playing'
    App.mainConnection.updateRecordings keyData
  props_stopPlaying: (keyData) =>
    App.VO.GlobalLookup[ keyData.id ].stopPlaying keyData.key
    App.mainConnection.setControlState "#{ keyData.id } #{ keyData.key }", 'default'
  props_deleteRecording: (keyData) =>
    App.VO.GlobalLookup[ keyData.id ].deleteRecording keyData.key, keyData.recordingNumber
    App.mainConnection.updateRecordings keyData

  server_cameOnline: (who) =>
    super
    @setLayout()
    App.mainView.documentToolbar.updateButtonStates()
  server_currentlyOnline: =>
    super
    App.mainView.documentToolbar.updateButtonStates()
  server_wentOffline: =>
    super
    App.mainView.documentToolbar.updateButtonStates()

  getMediaLibrary: => @sendDocument 'server', 'getLibraryIndex'
  server_libraryIndex: (index) => App.mediaLibrary.setMediaLibrary index
