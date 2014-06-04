class App.VO.Shape extends App.VO.BaseCanvas

  defaults: -> $.extend super,
    type: 'shape'
    'shape.shape': 'DefaultShape.svg'
    'shape.color': '#000000'

  attributeControls: -> $.extend super,
    'shape.shape': { type: 'media', mediaType: 'shapes', name: 'Shape', pos: [8, 0, 4, 6] }
    'shape.color': { type: 'color', name: 'Color', pos: [0, 3, 4, 3] }

  initialize: (attributes, options) ->
    super
    @drawCanvas()
    @on 'change', @checkImageChanges, @

  checkImageChanges: (model, options) ->
    for item, value of model.changed
      if item is 'shape.shape' then @drawCanvas()
      else if item is 'shape.color' then @recolorShape()

  recolorShape: ->
    if @loadedSVG
      @loadedSVG.setFill @get('shape.color')
      @fabricCanvas.renderAll()
      @texture.needsUpdate = true

  drawCanvas: ->
    super

    @fabricCanvas = new fabric.StaticCanvas @canvas
    @loadedSVG = null
    # console.log @fabricCanvas
    # console.log "/library/" + @get('shape.shape')
    fabric.loadSVGFromURL "/library/" + @get('shape.shape'), (objects, options) =>

      @loadedSVG = fabric.util.groupSVGElements(objects, options)
      # @loadedSVG.scaleToHeight 800
      width = @loadedSVG.getWidth()
      height = @loadedSVG.getHeight()
      biggerRenderSide = if App.config.renderer.width > App.config.renderer.height then App.config.renderer.width else App.config.renderer.height
      if height > width then @loadedSVG.scaleToHeight biggerRenderSide else @loadedSVG.scaleToWidth biggerRenderSide
      width = @loadedSVG.getWidth()
      height = @loadedSVG.getHeight()
      @updatePlaneSize width, height, { dontRedraw: true }

      @fabricCanvas = new fabric.StaticCanvas @canvas
      @fabricCanvas.add @loadedSVG
      @loadedSVG.center()
      @loadedSVG.setFill @get('shape.color')
      @fabricCanvas.renderAll()
      @texture.needsUpdate = true
