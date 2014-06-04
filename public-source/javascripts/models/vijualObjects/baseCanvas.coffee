class App.VO.BaseCanvas extends App.VO.Base

  defaults: -> $.extend super,
    type: 'baseCanvas'
    'material.doublesided': true
    'canvas.width': ( if App.config.renderer.width > App.config.renderer.height then App.config.renderer.width else App.config.renderer.height )
    'canvas.height': ( if App.config.renderer.width > App.config.renderer.height then App.config.renderer.width else App.config.renderer.height )

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

    # @texture = THREE.ImageUtils.loadTexture "/library/play-store.png"

    planeWidth = 1
    planeHeight = 1
    if @get('canvas.width') > @get('canvas.height')
      planeHeight = @get('canvas.height') / @get('canvas.width')
    else
      planeWidth = @get('canvas.width') / @get('canvas.height')
    @geometry = new THREE.PlaneGeometry planeWidth, planeHeight

    @createCanvas()

    @renderObject = new THREE.Mesh @geometry, @material
    @renderObject.doubleSided = true

    @on 'change', @updateCanvas, @
    super

  createCanvas: ->
    @canvas = document.createElement "canvas"
    @context = @canvas.getContext "2d"
    # context.font = size + "pt Arial";
    # textWidth = context.measureText(text).width;
    @canvas.width = @get('canvas.width')
    @canvas.height = @get('canvas.height')

    @texture = new THREE.Texture @canvas
    @drawCanvas()

    @material = new THREE.MeshBasicMaterial
      map: @texture
      color: 0xffffff
      transparent: true

  drawCanvas: ->
    @texture.needsUpdate = true
    @context.clearRect 0, 0, @get('canvas.width'), @get('canvas.height')

  updateCanvas: (model, options) ->
    canvasNeedsUpdating = false
    for item, value of model.changed
      if item.substr(0,6) is 'canvas'
        canvasNeedsUpdating = true
        break
    @drawCanvas() if canvasNeedsUpdating and not options.dontRedraw

  updatePlaneSize: (width, height, options = {}) ->
    @set { 'canvas.width': width, 'canvas.height': height }, options
    @canvas.width = width
    @canvas.height = height
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
