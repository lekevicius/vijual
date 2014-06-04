class App.VO.Text extends App.VO.BaseCanvas

  defaults: -> $.extend super,
    type: 'text'
    'text.text': ''
    'text.color': '#000000'
    'text.align': 0
    'text.font': 157
    'text.lineheight': 1.2
    'text.bold': false
    'text.italic': false

  textAlignments: [ 'left', 'center', 'right' ]

  attributeControls: -> $.extend super,
    'text.text': { type: 'textarea', name: 'Text', pos: [8, 0, 4, 3] }
    'text.color': { type: 'color', name: 'Color', pos: [0, 3, 4, 3] }
    'text.font': { type: 'list', name: 'Font', options: App.fonts, pos: [8, 3, 4, 3] }
    'text.align': { type: 'switcher', name: 'Align', options: @textAlignments, pos: [4, 3, 4, 1] }
    'text.bold': { type: 'toggle', name: 'Bold', pos: [4, 4, 2, 1] }
    'text.italic': { type: 'toggle', name: 'Italic', pos: [6, 4, 2, 1] }
    'text.lineheight': { type: 'slider', name: 'Line Height', step: 0.1, min: 0.1, max: 3, pos: [4, 5, 4, 1] }

  initialize: (attributes, options) ->
    super
    @drawCanvas()
    @on 'change', @checkTextChanges, @

  checkTextChanges: (model, options) ->
    textNeedsUpdating = false
    for item, value of model.changed
      if item.substr(0,4) is 'text'
        textNeedsUpdating = true
        break
    @drawCanvas() if textNeedsUpdating

  drawCanvas: ->
    super

    @text = new fabric.Text @get('text.text'),
      lineHeight: @get('text.lineheight')
      left: 0
      top: 0
      fontFamily: App.fonts[ @get('text.font') ]
      fontWeight: if @get('text.bold') then 'bold' else 'normal'
      fontStyle: if @get('text.italic') then 'italic' else 'normal'
      textAlign: @textAlignments[ @get('text.align') ]
      fill: @get('text.color')

    width = @text.getWidth()
    height = @text.getHeight()
    biggerRenderSide = if App.config.renderer.width > App.config.renderer.height then App.config.renderer.width else App.config.renderer.height
    if height > width then @text.scaleToHeight biggerRenderSide else @text.scaleToWidth biggerRenderSide
    width = @text.getWidth()
    height = @text.getHeight()
    @updatePlaneSize width, height, { dontRedraw: true }

    @fabricCanvas = new fabric.StaticCanvas @canvas
    @fabricCanvas.add @text
    @text.center()
    @fabricCanvas.renderAll()
    @texture.needsUpdate = true
