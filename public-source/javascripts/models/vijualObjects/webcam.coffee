class App.VO.Webcam extends App.VO.Base

  defaults: -> $.extend super,
    type: 'webcam'
    'material.doublesided': true
    'video.width': App.config.renderer.width
    'video.height': App.config.renderer.height

  attributeControls: ->
    'screenPosition': { type: 'area', name: 'Screen Position', pos: [0, 0, 2, 3] }
    'scale.x': { type: 'exponentialTracker', name: 'Scale X', pos: [2, 0, 1, 2] }
    'scale.y': { type: 'exponentialTracker', name: 'Scale Y', pos: [3, 0, 1, 2] }
    'rotation.z': { type: 'angle', name: 'Rot. Z', pos: [4, 0, 1, 2] }
    'scale': { type: 'exponentialTracker', name: 'Scale', pos: [2, 2, 3, 1] }
    'material.opacity': { type: 'slider', name: 'Opacity', pos: [5, 0, 1, 3] }
    'material.blending' : { type: 'switcher', name: 'Blending', options: [ 'Normal', 'Add', 'Subtract', 'Multiply' ], pos: [6, 0, 1, 3] }
    'active' : { type: 'toggle', name: 'Active', color: '#ffffff', pos: [7, 0, 1, 3] }

  initialize: (attributes, options) ->

    @video = document.createElement "video"
    @video.autoplay = true

    @video.addEventListener "loadedmetadata", (e) =>
      @updatePlaneSize @video.videoWidth, @video.videoHeight
      @video.play()
    , false

    navigator.webkitGetUserMedia { video: true }, (stream) =>
      @video.src = window.URL.createObjectURL stream
      @localMediaStream = stream
    , -> alert 'error!'

    @texture = new THREE.Texture @video
    @texture.minFilter = THREE.LinearFilter
    @texture.magFilter = THREE.LinearFilter
    @texture.format = THREE.RGBFormat
    @texture.generateMipmaps = false

    @material = new THREE.MeshBasicMaterial
      map: @texture
      color: 0x000000

    planeWidth = 1
    planeHeight = 1
    if @get('video.width') > @get('video.height')
      planeHeight = @get('video.height') / @get('video.width')
    else
      planeWidth = @get('video.width') / @get('video.height')
    @geometry = new THREE.PlaneGeometry planeWidth, planeHeight

    @renderObject = new THREE.Mesh @geometry, @material
    @renderObject.doubleSided = true

    super

  setupListeners: ->
    @listenTo App.ticker, 'frame', @animateVideo

  animateVideo: -> @texture.needsUpdate = true if @texture and @get('active')

  drawVideo: -> @texture.needsUpdate = true

  updatePlaneSize: (width, height) ->
    @set { 'video.width': width, 'video.height': height }
    @video.width = width
    @video.height = height
    @texture.needsUpdate = true

    planeWidth = 1
    planeHeight = 1
    if width > height then planeHeight = height / width else planeWidth = width / height
    @geometry = new THREE.PlaneGeometry planeWidth, planeHeight

    @get('track').scene.remove @renderObject if @get('track')
    @renderObject = new THREE.Mesh @geometry, @material
    @renderObject.doubleSided = true
    @get('track').scene.add @renderObject if @get('track')

    @updateValue item, value for item, value of @attributes
