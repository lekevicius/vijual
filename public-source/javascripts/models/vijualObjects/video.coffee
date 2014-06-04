class App.VO.Video extends App.VO.Base

  defaults: -> $.extend super,
    type: 'video'
    'material.doublesided': true
    'video.width': App.config.renderer.width
    'video.height': App.config.renderer.height
    'video.video': 'DefaultVideo.mp4'
    'video.playing': false
    'video.looping': true
    'video.volume': 0

  attributeControls: ->
    'screenPosition': { type: 'area', name: 'Screen Position', pos: [0, 0, 2, 3] }
    'scale.x': { type: 'exponentialTracker', name: 'Scale X', pos: [2, 0, 1, 2] }
    'scale.y': { type: 'exponentialTracker', name: 'Scale Y', pos: [3, 0, 1, 2] }
    'rotation.z': { type: 'angle', name: 'Rot. Z', pos: [4, 0, 1, 2] }
    'scale': { type: 'exponentialTracker', name: 'Scale', pos: [2, 2, 3, 1] }
    'material.opacity': { type: 'slider', name: 'Opacity', pos: [5, 0, 1, 3] }
    'material.blending' : { type: 'switcher', name: 'Blending', options: [ 'Normal', 'Add', 'Subtract', 'Multiply' ], pos: [6, 0, 1, 3] }
    'active' : { type: 'toggle', name: 'Active', color: '#ffffff', pos: [7, 0, 1, 3] }
    'video.video': { type: 'media', mediaType: 'videos', name: 'Video', pos: [8, 0, 4, 4] }
    'video.playing': { type: 'toggle', name: 'Play', pos: [0, 3, 2, 1] }
    'video.looping': { type: 'toggle', name: 'Loop', pos: [2, 3, 2, 1] }
    'video.volume': { type: 'slider', name: 'Volume', pos: [4, 3, 4, 1] }

  initialize: (attributes, options) ->

    @createVideo()
    @renderObject = new THREE.Mesh @geometry, new THREE.MeshBasicMaterial({ color: 0x000000 })

    @on 'change', @updateVideo, @
    super

  setupListeners: -> @listenTo App.ticker, 'frame', @animateVideo

  animateVideo: ->
    @texture.needsUpdate = true if @texture and @get('active')
    if @video and @get('video.looping') and @video.currentTime is @video.duration and @get('active')
      @video.src = ''
      @video.src = '/library/' + @get('video.video')
      @renderObject.material = new THREE.MeshBasicMaterial({ color: 0x000000 })
      @video.load()
      @video.addEventListener "loadedmetadata", (e) =>
        @renderObject.material = @material
        @video.play() if @get('video.playing')

  createVideo: ->
    @video = document.createElement "video"
    @video.volume = @get('video.volume')

    @video.addEventListener "loadedmetadata", (e) =>
      @updatePlaneSize @video.videoWidth, @video.videoHeight
      @video.play() if @get('video.playing')
    , false

    @video.src = '/library/' + @get('video.video')
    @video.load()

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

  drawVideo: ->
    @texture.needsUpdate = true

  updateVideo: (model, options) ->
    for item, value of model.changed
      if item is 'video.video'
        @video.src = ''
        @video.src = '/library/' + value
        @renderObject.material = new THREE.MeshBasicMaterial({ color: 0x000000 })
        @video.load()
        @video.addEventListener "loadedmetadata", (e) =>
          @renderObject.material = @material
          @updatePlaneSize @video.videoWidth, @video.videoHeight
          @video.play()
      if item is 'video.playing'
        if value then @video.play()
        else @video.pause()
      if item is 'video.volume'
        @video.volume = value
    # canvasNeedsUpdating = false
    # for item, value of model.changed
    #   if item.substr(0,5) is 'video'
    #     canvasNeedsUpdating = true
    #     break
    # @drawVideo() if canvasNeedsUpdating

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
