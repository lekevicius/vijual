class App.VUI.SceneManager extends Backbone.Model

  outObject: {}
  watchedKeys: []

  buildMetricsObject: (object) ->
    renderObject = object.renderObject
    renderObject.geometry.computeBoundingBox()
    boundingBox = renderObject.geometry.boundingBox
    pixelWidth = (boundingBox.max.x - boundingBox.min.x) * @largerSide
    pixelHeight = (boundingBox.max.y - boundingBox.min.y) * @largerSide
    screenWidth = pixelWidth / App.config.renderer.width
    screenHeight = pixelHeight / App.config.renderer.height
    metrics =
      positionX: App.utils.screenX renderObject.position.x
      positionY: App.utils.screenY renderObject.position.y
      width: screenWidth
      height: screenHeight
      rotation: App.utils.degrees(renderObject.rotation.z)
      scale: renderObject.scale.z
      color: App.colors[object.get('editor.color')]
    metrics

  initialize: ->
    @largerSide = Math.max( App.config.renderer.width, App.config.renderer.height )

  updateObject: ->
    if App.document.get('selectedObjects').length
      firstSelectedObject = App.document.get('selectedObjects').at(0)
      @objectMetrics = @buildMetricsObject firstSelectedObject if firstSelectedObject
      @updateWatcher firstSelectedObject
      @needsSending = false
      return @objectMetrics
    else
      @listenedObjectUUID = null
      return false

  updateWatcher: (object) ->
    @stopListening()
    @listenedObjectUUID = object.id
    @listenTo object, "change", @recordChanges

  recordChanges: (model, options) ->
    return if options.fromScene
    changedKeys = _.keys model.changed
    # Ideally we would check if any keys are interesting.
    @outObject = @buildMetricsObject App.VO.GlobalLookup[@listenedObjectUUID]
    @needsSending = true

  dumpChanges: () ->
    if @needsSending
      @needsSending = false
      return @outObject
    else return false
