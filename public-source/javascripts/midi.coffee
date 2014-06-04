class App.MIDIModels.Generic extends Backbone.Model
  processMessage: (t, a, b, c) ->
    str = "#{ @midiIn } #{a} #{b} #{c} "
    console.log str

class App.MIDIModels.NanoKontrol extends App.MIDIModels.Generic
  initialize: () ->
    @set { slider0: 0, slider1: 0, slider2: 0, slider3: 0, slider4: 0, slider5: 0, slider6: 0, slider7: 0, knob0: 0, knob1: 0, knob2: 0, knob3: 0, knob4: 0, knob5: 0, knob6: 0, knob7: 0 }
    _.bindAll @, 'processMessage'
  processMessage: (t, a, b, c) ->
    if b < 24
      # if b < 16
      # App.document.attributes.tracks.models[ b % 16 ].capturePlane.material.opacity = c / 127.0
      # App.document.get('tracks').at( b % 16 ).set('opacity', c / 127.0)
      # App.document.get('tracks').at(item.substr(6,1)).set('opacity', value) if item.startsWith 'slider'
      @set "#{ if b < 16 then 'slider' else 'knob' }#{ b % 16 }",  c / 127.0
    else
      console.log "#{a} #{b} #{c}"

class App.MIDIModels.NanoPad extends App.MIDIModels.Generic
  processMessage: (t, a, b, c) -> console.log "PAD #{a} #{b} #{c}"

class App.MIDIModels.Launchpad extends App.MIDIModels.Generic
  actionsMode: 'track'

  lightOff: 12
  lightLowRed: 13
  lightBrightRed: 15
  lightLowAmber: 29
  lightBrightAmber: 63
  lightLowGreen: 28
  lightBrightGreen: 60

  lightFlashRed: 11
  lightFlashAmber: 59
  lightFlashGreen: 56

  currentlyPressedObjects: []

  initialize: ->
    @setupListeners()

  setupListeners: =>
    @stopListening()
    @listenTo App.document, 'change:selectedTrack', (model, value) => @updateSelectedTrack value
    @listenTo App.document.get('tracks').at( App.document.get('selectedTrack') ), 'change:active', => @updateSelectedTrack()

    @listenTo App.document.get('selectedObjects'), 'add remove reset', => @updateObjectGrid()
    for object in App.document.get('tracks').at( App.document.get('selectedTrack') ).get('objects').toArray()
      @listenTo object, 'change:editor.gridPosition', => @updateObjectGrid()
      @listenTo object, 'change:active', => @updateObjectGrid() # optimize here

  parseMessage: (a, b, c) ->
    action = 'grid'
    x = 0
    y = 0
    pressed = c is 127
    if a is 144
      x = b % 16
      y = (b - x) / 16
      if x is 8
        action = 'action'
        x = y
        y = 0
    if a is 176
      action = 'track'
      x = (b % 16) - 8
    return [ action, x, y, pressed ]

  processMessage: (t, a, b, c) ->
    [ action, x, y, pressed ] = App.MIDIDevices.launchpad.parseMessage a, b, c

    if action is 'track' and pressed
      App.mainView.selectTrack x
    if action is 'grid'
      if App.MIDIDevices.launchpad.currentlyPressedObjects.length is 0 and pressed
        # First press
        currentTrackMap = App.document.get('tracks').at( App.document.get('selectedTrack') ).gridMap
        if currentTrackMap[x][y]
          App.MIDIDevices.launchpad.currentlyPressedObjects.push "#{x}:#{y}"
        else
          App.MIDIDevices.launchpad.newObjectMode(x, y)
      else
        if pressed
          App.MIDIDevices.launchpad.currentlyPressedObjects.push "#{x}:#{y}"
        else if App.MIDIDevices.launchpad.currentlyPressedObjects.length
          App.MIDIDevices.launchpad.selectObjects()
    if action is 'action' and pressed
      App.MIDIDevices.launchpad.handleAction x

  newObjectMode: (x, y) =>
    @newObjectCoordinates = [x, y]
    @actionsMode = 'new'
    @renderSide()

  handleAction: (x) =>
    if @actionsMode is 'track' and x is 0
      App.document.get('tracks').at( App.document.get('selectedTrack') ).toggleActivation()
      @renderSide()
    else if @actionsMode is 'object'
      if x is 0
        object.toggleActivation() for object in App.document.get('selectedObjects').toArray()
        @renderSide()
      else if x is 7
        object.destroy() for object in App.document.get('selectedObjects').toArray()
        App.mainView.renderGrid()
        # @updateObjectGrid()
    else if @actionsMode is 'new'
      objectTypes = [ 'image', 'video', 'text', 'drawing', 'shape', 'noun', 'color', 'gradient' ]
      App.mainView.newObjectWithType objectTypes[x], @newObjectCoordinates

  selectObjects: =>
    currentTrackMap = App.document.get('tracks').at( App.document.get('selectedTrack') ).gridMap
    addableObjects = []
    for coordinateString in @currentlyPressedObjects
      coordinate = coordinateString.split ':'
      coordinate = [ parseInt(coordinate[0]), parseInt(coordinate[1]) ]
      objectThere = currentTrackMap[ coordinate[0] ][ coordinate[1] ]
      if objectThere then addableObjects.push objectThere
    App.document.get('selectedObjects').reset addableObjects
    @currentlyPressedObjects = []

  setButtonColor: (action, x, y, color) =>
    if action is 'grid' then [ a, b, c ] = [ 144, ( x + y * 16 ), color ]
    else if action is 'action' then [ a, b, c ] = [ 144, ( 8 + x * 16 ), color ]
    else if action is 'track' then [ a, b, c ] = [ 176, 104 + x, color ]
    @sendMessage a, b, c

  renderSide: =>
    @setButtonColor 'action', i, 0, @lightOff for i in [0..7]
    if @actionsMode is 'track'
      @setButtonColor 'action', 0, 0, ( if App.document.get('tracks').at( App.document.get('selectedTrack') ).get('active') then @lightBrightRed else @lightBrightGreen )
    else if @actionsMode is 'object'
      state = null
      for obj in App.document.get('selectedObjects').toArray()
        if obj.get('active')
          if state is null then state = 'active'
          else if state is 'inactive' then state = 'mixed'
        else
          if state is null then state = 'inactive'
          else if state is 'active' then state = 'mixed'

      if state is 'inactive' then @setButtonColor 'action', 0, 0, @lightBrightGreen
      else if state is 'active' then @setButtonColor 'action', 0, 0, @lightBrightRed
      else @setButtonColor 'action', 0, 0, @lightBrightAmber

      @setButtonColor 'action', 7, 0, @lightBrightRed
    else if @actionsMode is 'new'
      @setButtonColor 'action', i, 0, @lightBrightGreen for i in [0..7]


  updateSelectedTrack: (track = undefined) =>
    if track is undefined then track = App.document.get('selectedTrack')
    for i in [0..7]
      @setButtonColor 'track', i, 0, ( if i is track then ( if App.document.get('tracks').at(i).get('active') then @lightBrightGreen else @lightBrightRed ) else @lightOff )
    @actionsMode = if App.document.get('selectedObjects').size() then 'object' else 'track'
    @renderSide()
    @updateObjectGrid()

  updateObjectGrid: =>
    @actionsMode = if App.document.get('selectedObjects').size() then 'object' else 'track'
    @renderSide()
    currentTrackMap = App.document.get('tracks').at( App.document.get('selectedTrack') ).gridMap
    for x in [0..7]
      for y in [0..7]
        if currentTrackMap[x][y]
          obj = currentTrackMap[x][y]
          if App.document.get('selectedObjects').contains(obj)
            setColor = if obj.get('active') then @lightBrightGreen else @lightBrightRed
          else
            setColor = if obj.get('active') then @lightLowGreen else @lightLowRed
        else
          setColor = @lightOff
        @setButtonColor 'grid', x, y, setColor
    @setupListeners()

  clearAllButtons: =>
    @sendMessage 176, 0, 0 # Clear all
    @sendMessage 176, 0, 40 # Setup blinking

  fillRandom: =>
    colors = [ @lightLowRed, @lightBrightRed, @lightLowAmber, @lightBrightAmber, @lightLowGreen, @lightBrightGreen ]
    for i in [0..7]
      for j in [0..7]
        @setButtonColor 'grid', i, j, _.sample(colors)
    return

  sendMessage: (a, b, c) => @get('midiOutPlugin').MidiOut a, b, c

createPlugin = ->
  element = $('<div/>').html('<object type="audio/x-jazz" class="visually-hidden"></object>').contents().get(0)
  $('body').append element
  return element if element.isJazz
  $('body').get(0).removeChild(0)
  console.log "Jazz is not supported"
  return false

connectPluginToMidiIn = (plugin, midiIn) ->
  switch midiIn
    when "SLIDER/KNOB"
      # nanoKONTROL2
      App.MIDIDevices.nanoKontrol = new App.MIDIModels.NanoKontrol
        midiInPlugin: plugin
      plugin.MidiInOpen midiIn, App.MIDIDevices.nanoKontrol.processMessage
    when "PAD"
      # nanoPAD2
      App.MIDIDevices.nanoPad = new App.MIDIModels.NanoPad
        midiInPlugin: plugin
      plugin.MidiInOpen midiIn, App.MIDIDevices.nanoPad.processMessage
    when "Launchpad Mini"
      # Launchpad
      outPlugin = createPlugin()
      App.MIDIDevices.launchpad = new App.MIDIModels.Launchpad
        midiInPlugin: plugin
        midiOutPlugin: outPlugin
      plugin.MidiInOpen midiIn, App.MIDIDevices.launchpad.processMessage
      outPlugin.MidiOutOpen midiIn
      App.MIDIDevices.launchpad.clearAllButtons()
      App.MIDIDevices.launchpad.updateSelectedTrack()
    else
      App.MIDIDevices[midiIn] = new App.MIDIModels.Generic
        midiInPlugin: plugin
      plugin.MidiInOpen midiIn, App.MIDIDevices[midiIn].processMessage

disconnectPluginFromMidiIn = (plugin) -> plugin.MidiInClose()

$ ->
  return if App.isTouch

  firstPlugin = createPlugin()
  if firstPlugin
    midiInList = firstPlugin.MidiInList()
    if midiInList.length
      firstName = midiInList.shift()
      connectPluginToMidiIn firstPlugin, firstName
      connectPluginToMidiIn createPlugin(), midiIn for midiIn in midiInList

  if App.MIDIDevices.nanoKontrol
    @setTrackOpacity = (track, opacity) -> App.document.get('tracks').at(track).set('opacity', opacity)
    @trackChangeFunctions = ( _.debounce @setTrackOpacity, 5 for number in [0..7] )

    App.document.listenTo App.MIDIDevices.nanoKontrol, 'change', (model, options) =>
      for item, value of model.changed
        trackNumber = parseInt(item.substr(6,1))
        @trackChangeFunctions[trackNumber]( trackNumber, value ) if item.substr(0,6) is 'slider'

  # $(window).on 'focus', -> plugin.MidiInOpen midiIn, midiProc for midiIn, plugin of plugins
  # $(window).on 'blur', -> disconnectPluginFromMidiIn plugin for midiIn, plugin of plugins
