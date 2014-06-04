class App.Connections.Props extends App.Connections.Base
  protocol: 'props'

  onOpen: (e) =>
    # @listenTo App.ticker, 'frame', @sendDataUpdates
    App.utils.every Math.round(1000 / @connectionRate), @sendDataUpdates
    super

  main_setLayout: (doc) =>
    # console.log doc
    $('#propertiesModalBackground').hide()
    $('#properties-grid').empty().html App.VUI.Builder(doc)

  main_updateValues: (doc) =>
    for change in doc
      key = "#{ change.id } #{ change.key }"
      if change.key is 'editor.name'
        $("div[data-id='#{ change.id }']").find('h3').html change.value
      else if change.key is 'editor.color'
        newColor = App.colors[change.value]
        $("div[data-id='#{ change.id }']").css { backgroundColor: App.VUI.colorAlpha(newColor, 0.3) }
        $("div[data-id='#{ change.id }']").find('h3').css { backgroundColor: App.VUI.colorAlpha(newColor, 0.4) }
      else if App.VUI.controls[key]
        value = JSON.parse change.value
        value = (JSON.parse item for item in value) if _.isArray(value)
        App.VUI.controls[key].updateValue( value )

  askForLinks: (fromVUI) =>
    for key, control of App.VUI.controls
      if control.controlState in [ 'linking', 'linkOpen' ]
        control.controlState = 'default'
        control.drawOutletCanvas()

    fromVUI.controlState = 'linkOpen'
    fromVUI.drawOutletCanvas()

    @sendDocument 'main', 'lookForLinks',
      dataType: fromVUI.dataType
      id: fromVUI.values.propertyObjectUUID
      key: fromVUI.values.propertyKey

  cancelLinking: =>
    for key, control of App.VUI.controls
      if control.controlState in [ 'linking', 'linkOpen' ]
        control.controlState = 'default'
        control.drawOutletCanvas()
    @sendDocument 'main', 'stopLookingForLinks'

  createLink: (toVUI) =>
    for key, control of App.VUI.controls
      if control.controlState in [ 'linking', 'linkOpen' ]
        control.controlState = 'default'
        control.drawOutletCanvas()

    @sendDocument 'main', 'setupLink',
      id: toVUI.values.propertyObjectUUID
      key: toVUI.values.propertyKey

  deleteLink: (toVUI) =>
    @sendDocument 'main', 'deleteLink',
      id: toVUI.values.propertyObjectUUID
      key: toVUI.values.propertyKey

  main_showAvailableLinks: (linkingData) =>
    if linkingData is null
      for key, control of App.VUI.controls
        if control.controlState in [ 'linking', 'linkOpen' ]
          control.controlState = 'default'
          control.drawOutletCanvas()
      return

    originalKey = "#{ linkingData.id } #{ linkingData.key }"
    openDataType = linkingData.dataType
    if App.VUI.controls[originalKey]
      App.VUI.controls[originalKey].controlState = 'linkOpen'
      App.VUI.controls[originalKey].drawOutletCanvas()

    for key, control of App.VUI.controls
      if key isnt originalKey and control.dataType is openDataType and control.controlState is 'default' and control.values.allowLinkIn
        control.controlState = 'linking'
        control.drawOutletCanvas()

  main_setControlState: (controlData) => App.VUI.controls[controlData.key].setControlState controlData.state

  main_updateRecordings: (recordingsData) =>
    App.VUI.controls[recordingsData.key].values.recordings = recordingsData.recordings
    App.propsView.currentModalView.render()

  startRecording: (vui) ->
    @sendDocument 'main', 'startRecording',
      id: vui.values.propertyObjectUUID
      key: vui.values.propertyKey

  startPlaying: (vui, recordingNumber) ->
    @sendDocument 'main', 'startPlaying',
      id: vui.values.propertyObjectUUID
      key: vui.values.propertyKey
      recordingNumber: recordingNumber

  deleteRecording: (vui, recordingNumber) ->
    @sendDocument 'main', 'deleteRecording',
      id: vui.values.propertyObjectUUID
      key: vui.values.propertyKey
      recordingNumber: recordingNumber

  stopPlaying: (vui) ->
    @sendDocument 'main', 'stopPlaying',
      id: vui.values.propertyObjectUUID
      key: vui.values.propertyKey

  main_updateOptions: (controlData) =>
    control = App.VUI.controls[controlData.key]
    control.values.propertyOptions = controlData.options
    control.updateOptions()

  sendDataUpdates: =>
    if 'main' in @onlinePeers
      changes = App.controlSurfaceController.dumpChanges()
      @sendDocument 'main', 'updateValues', changes if changes.length
