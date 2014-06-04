class App.VO.Base extends Backbone.RelationalModel

  relations: [{
    type: Backbone.HasMany
    key: 'behaviors'
    relatedModel: 'App.Behaviors.Base'
    reverseRelation: {
      type: Backbone.HasOne
      key: 'object'
      includeInJSON: false
    }
  }]

  defaults: ->
    'active': App.config.defaultActivationState
    'screenPosition': [0.5, 0.5]
    'position.x': 0
    'position.y': 0
    'position.z': 0
    'rotation.x': 0
    'rotation.y': 0
    'rotation.z': 0
    'scale': 1
    'scale.x': 1
    'scale.y': 1
    'scale.z': 1
    'visible' : true
    'material.color': new THREE.Color('#ffffff')
    'material.opacity': 1
    'material.blending': 0
    'material.doublesided': false

  attributeControls: ->
    'screenPosition': { type: 'area', name: 'Screen Posistion', pos: [0, 0, 2, 3] }
    'rotation.x': { type: 'angle', name: 'Rot. X', pos: [2, 0, 1, 2] }
    'rotation.y': { type: 'angle', name: 'Rot. Y', pos: [3, 0, 1, 2] }
    'rotation.z': { type: 'angle', name: 'Rot. Z', pos: [4, 0, 1, 2] }
    'scale': { type: 'exponentialTracker', name: 'Scale', pos: [2, 2, 3, 1] }
    'material.blending' : { type: 'switcher', name: 'Blending', options: [ 'Normal', 'Add', 'Subtract', 'Multiply' ], pos: [10, 0, 1, 3] }
    'active' : { type: 'toggle', name: 'Active', color: '#ffffff', pos: [11, 0, 1, 3] }
    'material.color': { type: 'color', name: 'Color', pos: [5, 0, 4, 3] }
    'material.opacity': { type: 'slider', name: 'Opacity', pos: [9, 0, 1, 3] }

  subModelTypes:
    group: 'App.VO.Group'
    plane: 'App.VO.Plane'
    circle: 'App.VO.Circle'
    ring: 'App.VO.Ring'
    cube: 'App.VO.Cube'
    sphere: 'App.VO.Sphere'
    cylinder: 'App.VO.Cylinder'
    tetrahedron: 'App.VO.Tetrahedron'
    octahedron: 'App.VO.Octahedron'
    icosahedron: 'App.VO.Icosahedron'
    torus: 'App.VO.Torus'
    torusknot: 'App.VO.TorusKnot'
    color: 'App.VO.Color'
    gradient: 'App.VO.Gradient'
    image: 'App.VO.Image'
    shape: 'App.VO.Shape'
    text: 'App.VO.Text'
    video: 'App.VO.Video'
    webcam: 'App.VO.Webcam'
    drawing: 'App.VO.Drawing'
    canvas: 'App.VO.Canvas'
    noun: 'App.VO.Noun'
    # particlesystem: 'App.VO.ParticleSystem'

  constructor: ->

    @renderObject = null # Three Object in the scene

    @on 'add', @onAdd, @
    super

  initialize: (attributes = {}, options = {}) ->
    @initialActivation = true
    @id = attributes.id || App.utils.uuid()
    @set 'id', @id
    App.VO.GlobalLookup[@id] = @
    @set 'editor.name', App.objectTypes[@get('type')].name unless @has 'editor.name'

    @on 'change', @onChange, @
    @updateValue item, value for item, value of attributes
    @setupLinkable()
    @setupListeners()
    @toggleActivation @get('active')


  onAdd: (model, collection, options) ->
    if collection.track
      collection.track.scene.add @renderObject

      @renderObject.material.transparent = true

      App.utils.setScreenPosition @
      @set 'editor.color', collection.track.get('editor.color') unless @has('editor.color')
      @placeInGridMap model, collection.track

      gridPosition = @get('editor.gridPosition')
      model.set('position.z', (8 - gridPosition[0]) * 0.0001 + (8 - gridPosition[1]) * 0.001 )

  placeInGridMap: (model, track) ->
    if model.get('editor.gridPosition')
      position = model.get('editor.gridPosition')
      unless track.gridMap[ position[0] ][ position[1] ]
        track.gridMap[ position[0] ][ position[1] ] = model
      else
        console.log "Spot was taken"
        @findNewPositionInGridMap model, track
    else
      @findNewPositionInGridMap model, track

  findNewPositionInGridMap: (model, track) ->
    emptySpot = null
    currentRow = 0
    currentColumn = 0
    for column in track.gridMap
      currentRow = 0
      for row in column
        unless track.gridMap[currentRow][currentColumn]
          emptySpot = [currentRow, currentColumn]
          track.gridMap[currentRow][currentColumn] = model
          break
        currentRow++
      break if emptySpot
      currentColumn++
    model.set 'editor.gridPosition', emptySpot

  updateValue: (item, value, options = {}) =>
    switch item
      when 'active' then @toggleActivation value unless options.fromActivation
      when 'editor.gridPosition' then @set 'position.z', (8 - value[0]) * 0.0001 + (8 - value[1]) * 0.001
      when 'screenPosition' then @onChange @set({ 'position.x': App.utils.renderX(value[0]), 'position.y': App.utils.renderY(value[1]) })
      when 'position.x' then @renderObject.position.x = value
      when 'position.y' then @renderObject.position.y = value
      when 'position.z' then @renderObject.position.z = value
      when 'rotation.x' then @renderObject.rotation.x = value
      when 'rotation.y' then @renderObject.rotation.y = value
      when 'rotation.z' then @renderObject.rotation.z = value
      when 'scale' then @onChange @set({ 'scale.x': value, 'scale.y': value, 'scale.z': value })
      when 'scale.x' then @renderObject.scale.x = value
      when 'scale.y' then @renderObject.scale.y = value
      when 'scale.z' then @renderObject.scale.z = value
      when 'visible' then @renderObject.visible = value
      when 'material.color' then @renderObject.material.color.set value
      when 'material.blending' then @renderObject.material.blending = App.BlendingModes[value]
      when 'material.opacity'
        if value < 1
          @renderObject.material.opacity = value
        else
          @renderObject.material.opacity = 1
      when 'material.doublesided'
        if value
          @renderObject.material.side = THREE.DoubleSide
        else
          @renderObject.material.side = THREE.FrontSide

  onChange: (model, options) =>
    # console.log JSON.stringify(model.changed)
    @updateValue item, value, options for item, value of model.changedAttributes()

  keyIsUpdatable: (key) -> not @get('attributeRecordings')[key].playing and not @get('attributeLinksIn')[ "#{ @id } #{ key }" ]

  setupListeners: -> # noop

  updateSceneChanges: (change) ->
    if change.positionX and @keyIsUpdatable 'screenPosition'
      @set { 'screenPosition': [ change.positionX, change.positionY ] }, { fromScene: true }
    @set 'rotation.z', App.utils.radians(change.rotation), { fromScene: true } if change.rotation and @keyIsUpdatable 'rotation.z'
    @set 'scale', change.scale, { fromScene: true } if change.scale and @keyIsUpdatable 'scale'

  setScreenPositionX: (x) -> @set 'screenPosition', [ x, @get('screenPosition')[1] ]
  setScreenPositionY: (y) -> @set 'screenPosition', [ @get('screenPosition')[0], y ]

  toggleActivation: (setTo, immediate = false) =>
    if @initialActivation
      @initialActivation = false
      immediate = true

    if      setTo is undefined then currentlyActive = @get 'active'
    else if setTo              then currentlyActive = false
    else                            currentlyActive = true
    @set 'active', not currentlyActive, { fromActivation: true }
    hasCustom = false
    if currentlyActive
      hasCustom = true for behavior in @get('behaviors').toArray() when behavior instanceof App.Behaviors.Outro
      if hasCustom then @trigger 'deactivate'
      else @defaultOutro(immediate)
    else
      hasCustom = true for behavior in @get('behaviors').toArray() when behavior instanceof App.Behaviors.Intro
      if hasCustom then @trigger 'activate'
      else @defaultIntro(immediate)

  defaultIntro: (immediate = false) =>
    if immediate
      @onChange @set({ 'material.opacity': 1 })
    else
      @proxy = { prop: @get('material.opacity') }
      TweenLite.to @proxy, 0.4, { prop: 1, onUpdateParams: ["{self}"], onUpdate: (tween) => @set 'material.opacity', tween.target.prop }

  defaultOutro: (immediate = false) =>
    if immediate
      @onChange @set({ 'material.opacity': 0 })
    else
      @proxy = { prop: @get('material.opacity') }
      TweenLite.to @proxy, 0.4, { prop: 0, onUpdateParams: ["{self}"], onUpdate: (tween) => @set 'material.opacity', tween.target.prop }


  moveToTrack: (newTrackId) ->
    newTrack = App.VO.GlobalLookup[newTrackId]

    # Say goodbye
    @get('track').scene.remove @renderObject
    gridPosition = @get('editor.gridPosition')
    @get('track').gridMap[ gridPosition[0] ][ gridPosition[1] ] = false
    @get('track').get('objects').remove @

    # Say hello
    newTrack.get('objects').add @ # Should be all.
    # newTrack.scene.add @renderObject
    # currentTrack.gridMap[newPosition[0]][newPosition[1]] = droppedObject



  destroy: ->
    @get('track').scene.remove @renderObject
    @get('track').gridMap[ @get('editor.gridPosition')[0] ][ @get('editor.gridPosition')[1] ] = false
    behavior.destroy() for behavior in @get('behaviors').toArray()
    @destroyLinkListeners()
    delete App.VO.GlobalLookup[@id]
    @trigger 'destroy', @, @collection
    App.mainView.updateGridAvailability()

App.VO.Base.setup()
_.extend App.VO.Base.prototype, App.Mixins.Linkable
