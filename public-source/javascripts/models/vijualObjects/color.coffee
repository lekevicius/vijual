class App.VO.Color extends App.VO.BaseCanvas

  defaults: -> $.extend super,
    type: 'color'
    'canvas.color': '#ff0000'

  attributeControls: -> $.extend super,
    'canvas.color': { type: 'color', name: 'Color', pos: [8, 0, 4, 3] }

  drawCanvas: ->
    super

    @context.fillStyle = @get('canvas.color')
    @context.fillRect 0, 0, @get('canvas.width'), @get('canvas.height')
