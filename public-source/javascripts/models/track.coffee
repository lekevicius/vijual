class App.Track extends Backbone.RelationalModel

  relations: [{
    type: Backbone.HasMany
    key: 'objects'
    relatedModel: 'App.VO.Base'
    reverseRelation: {
      type: Backbone.HasOne
      key: 'track'
      includeInJSON: false
    }
  },
  {
    type: Backbone.HasMany
    key: 'filters'
    relatedModel: 'App.TrackFilters.Base'
    collectionOptions: {
      comparator: 'sortOrder'
    }
    reverseRelation: {
      type: Backbone.HasOne
      key: 'track'
      includeInJSON: false
    }
  }]

  defaults: ->
    active: true
    opacity: 1
    blending: 0
    'editor.name': "Track #{ @trackNumber + 1 }"
    'editor.color': @trackNumber * 3

  attributeControls: ->
    'opacity': { type: 'slider', name: 'Opacity', pos: [0, 0, 6, 1] }
    'blending': { type: 'switcher', name: 'Blending', options: [ 'Normal', 'Add', 'Subtract', 'Multiply' ], pos: [0, 0, 6, 1] }
    'active': { type: 'toggle', name: 'Active', pos: [0, 0, 6, 1] }

  constructor: ->
    @scene = new THREE.Scene()
    @globalLight = new THREE.AmbientLight( '#000' )
    @scene.add @globalLight
    @frontLight = new THREE.PointLight( '#fff', 0.4 )
    @frontLight.position.set 0, 0, 23.2
    @scene.add @frontLight
    @topLight = new THREE.PointLight( '#fff', 0.6 )
    @topLight.position.set 0, 20, 0
    @scene.add @topLight

    @trackNumber = App.GlobalTrackCount
    @gridMap = ((false for j in [1..8]) for i in [1..8])

    @renderTarget = new THREE.WebGLRenderTarget App.config.renderer.width, App.config.renderer.height, { minFilter: THREE.LinearFilter, magFilter: THREE.NearestFilter, format: THREE.RGBAFormat, clearColor: 0x000000, clearAlpha: 0 }
    @capturePlane = new THREE.Mesh( new THREE.PlaneGeometry(App.config.renderer.width, App.config.renderer.height), new THREE.MeshBasicMaterial( { map: @renderTarget, transparent: true, opacity: 0.5 } ) )
    @capturePlane.position.z = 10 - App.GlobalTrackCount
    App.renderer.captureScene.add @capturePlane

    App.GlobalTrackCount += 1

    @on 'change:opacity', @updateOpacity, @
    @on 'change:blending', @updateBlending, @

    super

  initialize: (attributes = {}, options = {}) ->
    @id = attributes.id || App.utils.uuid()
    @set 'id', @id
    App.VO.GlobalLookup[@id] = @
    @set 'trackNumber', @trackNumber
    @setupLinkable()
    @toggleActivation @get('active')

  updateOpacity: (model, value, options) -> @capturePlane.material.opacity = value
  updateBlending: (model, value, options) -> @capturePlane.material.blending = App.BlendingModes[value]

  updateSort: -> @capturePlane.position.z = 10 - @get('trackNumber')

  toggleActivation: (setTo) =>
    if      setTo is undefined then currentlyActive = @get 'active'
    else if setTo              then currentlyActive = false
    else                            currentlyActive = true
    @set 'active', not currentlyActive, { fromActivation: true }
    @capturePlane.visible = not currentlyActive

  destroy: ->
    object.destroy() for object in @get('objects').toArray()
    filter.destroy() for filter in @get('filters').toArray()
    App.renderer.captureScene.remove @capturePlane
    @destroyLinkListeners()
    delete App.VO.GlobalLookup[@id]
    @trigger 'destroy', @, @collection

App.Track.setup()
_.extend App.Track.prototype, App.Mixins.Linkable
