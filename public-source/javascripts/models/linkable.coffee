App.Mixins.Linkable =

  setupLinkable: ->
    @set 'attributeLinksIn', {} unless @get 'attributeLinksIn'
    @attributeLinksOut = {}

    unless @get 'attributeRecordings'
      @set 'attributeRecordings', {}
      for key in _.keys(@attributes)
        @get('attributeRecordings')[ key ] = { recordings: [], recording: false, currentRecording: 0, playing: false, currentRecordingPlaying: 0, currentPlayingIndex: 0, totalPlayingValues: 0 }

    _.bindAll @, 'connectLinks', 'addLinkIn', 'deleteLink', 'destroyLinkListeners', 'startRecording', 'startPlaying', 'stopPlaying', 'checkRecordingKeys'
    @listenTo App.ticker, 'frame', @checkRecordingKeys

  addLinkIn: (key) ->
    keyParts = key.split ' '
    fromId = App.LinkingData.id
    fromKey = App.LinkingData.key
    toId = keyParts[0]
    toKey = keyParts[1]
    linkData =
      from: { id: fromId, key: fromKey }
      to: { id: toId, key: toKey }
    App.VO.GlobalLookup[fromId].attributeLinksOut[ "#{ toId } #{ toKey }" ] = linkData
    @get('attributeLinksIn')["#{ toId } #{ toKey }"] = linkData
    App.LinkingData = null
    @connectLinks()

  updateLinkValue: (model, value, options) -> App.VO.GlobalLookup[ @to.id ].set @to.key, value

  deleteLink: (toData) ->
    key = "#{ toData.id } #{ toData.key }"
    link = @get('attributeLinksIn')[key]
    delete App.VO.GlobalLookup[link.from.id].attributeLinksOut[ key ]
    @stopListening App.VO.GlobalLookup[ link.from.id ], "change:#{ link.from.key }"
    App.mainConnection.setControlState key, 'default'
    delete @get('attributeLinksIn')[key]

  connectLinks: ->
    @stopListening()
    @listenTo App.ticker, 'frame', @checkRecordingKeys
    @setupListeners @collection if _.isFunction @setupListeners
    for key, link of @get('attributeLinksIn')
      toObject = App.VO.GlobalLookup[ link.to.id ]
      fromObject = App.VO.GlobalLookup[ link.from.id ]
      fromObject.attributeLinksOut[ key ] = link
      func = _.bind @updateLinkValue, link
      toObject.listenTo fromObject, "change:#{ link.from.key }", func
      toObject.set link.to.key, fromObject.get( link.from.key )
      App.mainConnection.setControlState key, 'linked'

  destroyLinkListeners: ->
    for key, link of @get('attributeLinksIn')
      @stopListening App.VO.GlobalLookup[ link.from.id ], "change:#{ link.from.key }"
      delete App.VO.GlobalLookup[link.from.id].attributeLinksOut[ key ]
    for key, link of @attributeLinksOut
      listeningObject = App.VO.GlobalLookup[ link.to.id ]
      delete listeningObject.get('attributeLinksIn')[ "#{ link.to.id } #{ link.to.key }" ]
      listeningObject.stopListening @, "change:#{ link.from.key }"
    @attributeLinksOut = undefined
    @set('attributeLinksIn', undefined)
    App.utils.delay 3, -> App.mainConnection.setLayout()

  checkRecordingKeys: ->
    for key, recordingObject of @get('attributeRecordings')
      if recordingObject.recording
        recordingObject.recordings[ recordingObject.currentRecording ].push @get(key)
      else if recordingObject.playing
        if recordingObject.currentPlayingIndex >= recordingObject.totalPlayingValues
          recordingObject.currentPlayingIndex = 0
        @set key, recordingObject.recordings[ recordingObject.currentRecordingPlaying ][ recordingObject.currentPlayingIndex ]
        recordingObject.currentPlayingIndex += 1

  startRecording: (key) ->
    @get('attributeRecordings')[ key ].recording = true
    @get('attributeRecordings')[ key ].currentRecording = @get('attributeRecordings')[ key ].recordings.length
    @get('attributeRecordings')[ key ].recordings.push []

  deleteRecording: (key, recordingNumber) -> @get('attributeRecordings')[ key ].recordings.splice recordingNumber, 1

  startPlaying: (key, recordingNumber) ->
    recordingNumber = @get('attributeRecordings')[ key ].recordings.length - 1 if recordingNumber is undefined
    @get('attributeRecordings')[ key ].recording = false
    @get('attributeRecordings')[ key ].playing = true
    @get('attributeRecordings')[ key ].currentPlayingIndex = 0
    @get('attributeRecordings')[ key ].currentRecordingPlaying = recordingNumber
    @get('attributeRecordings')[ key ].totalPlayingValues = @get('attributeRecordings')[ key ].recordings[ recordingNumber ].length

  stopPlaying: (key) ->
    @get('attributeRecordings')[ key ].playing = false
    @get('attributeRecordings')[ key ].currentPlayingIndex = 0
    @get('attributeRecordings')[ key ].currentRecordingPlaying = 0
    @get('attributeRecordings')[ key ].totalPlayingValues = 0
