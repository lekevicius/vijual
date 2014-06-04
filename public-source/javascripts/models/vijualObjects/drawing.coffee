class App.VO.Drawing extends App.VO.BaseCanvas

  defaults: -> $.extend super,
    type: 'drawing'
    'canvas.width': App.config.renderer.width
    'canvas.height': App.config.renderer.height
    'drawing.color': '#ffffff'
    'drawing.opacity': 1
    'drawing.linewidth': 5
    'drawing.mode': 0
    'drawing.clear': false

  attributeControls: -> $.extend super,
    'drawing.color': { type: 'color', name: 'Color', pos: [8, 0, 4, 3] }
    'drawing.mode': { type: 'switcher', name: 'Draw / Move', options: [ 'Draw', 'Move' ], pos: [0, 3, 3, 1] }
    'drawing.clear': { type: 'triggerButton', name: 'Clear', pos: [3, 3, 1, 1] }
    'drawing.opacity': { type: 'slider', name: 'Line Opacity', pos: [4, 3, 4, 1] }
    'drawing.linewidth': { type: 'integerSlider', name: 'Line width', min: 1, max: 30, pos: [8, 3, 4, 1] }

  initialize: (attributes, options) ->
    super

    @holder = $('<div class="visually-hidden"><canvas width="800" height="600"></div>').get(0)
    $('#content').append @holder
    @fabricCanvasElement = $(@holder).find('canvas').get(0)
    @fabricCanvas = new fabric.Canvas @fabricCanvasElement, { isDrawingMode: true }

    # @fabricCanvas.freeDrawingBrush.onMouseDown({ x: 400, y: 300 })
    # @fabricCanvas.freeDrawingBrush.onMouseMove({ x: 100, y: 200 })
    # @fabricCanvas.freeDrawingBrush.onMouseMove({ x: 700, y: 100 })
    # @fabricCanvas.freeDrawingBrush.onMouseUp()

    @fabricCanvas.loadFromJSON attributes.drawingData if attributes.drawingData
    @fabricCanvas.renderAll()
    @drawCanvas()

    @fabricCanvas.freeDrawingBrush = new fabric.PencilBrush @fabricCanvas
    @fabricCanvas.freeDrawingBrush.color = @drawingColor()
    @fabricCanvas.freeDrawingColor = @drawingColor()
    @fabricCanvas.freeDrawingBrush.width = @get('drawing.linewidth')
    @fabricCanvas.freeDrawingLineWidth = @get('drawing.linewidth')

    @on 'change', @checkDrawingChanges, @

  drawingColor: -> App.VUI.colorAlpha @get('drawing.color'), @get('drawing.opacity')

  toJSON: ->
    @set 'drawingData', @fabricCanvas.toJSON()
    super

  updateSceneChanges: (change) ->
    if @get('drawing.mode') is 0
      if change.controlStage and change.controlStage isnt 'end'
        canvasX = change.positionX * App.config.renderer.width
        canvasY = change.positionY * App.config.renderer.height
      if change.controlStage is 'start' or change.controlStage is 'startend'
        @fabricCanvas.freeDrawingBrush.onMouseDown({ x: canvasX, y: canvasY })
      if change.controlStage is 'move'
        @fabricCanvas.freeDrawingBrush.onMouseMove({ x: canvasX, y: canvasY })
      if change.controlStage is 'end' or change.controlStage is 'startend'
        @fabricCanvas.freeDrawingBrush.onMouseUp()
      @drawCanvas()
    else
      super

  checkDrawingChanges: (model, options) ->
    for item, value of model.changed
      if item is 'drawing.color' or item is 'drawing.opacity'
        @fabricCanvas.freeDrawingBrush.color = @drawingColor()
        @fabricCanvas.freeDrawingColor = @drawingColor()
      else if item is 'drawing.linewidth'
        @fabricCanvas.freeDrawingBrush.width = value
        @fabricCanvas.freeDrawingLineWidth = value
      else if item is 'drawing.clear' and value
        @fabricCanvas.clear()
        @fabricCanvas.renderAll()
        @drawCanvas()

  drawCanvas: ->
    return unless @fabricCanvas
    super
    # @fabricCanvas.renderAll()
    @context.drawImage @fabricCanvas.lowerCanvasEl, 0, 0
    @context.drawImage @fabricCanvas.upperCanvasEl, 0, 0


    # @fabricCanvas.add new fabric.Rect top: 300, left: 400, width: 400, height: 300, fill: '#ff5555'


