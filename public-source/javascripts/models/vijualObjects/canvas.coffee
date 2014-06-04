class App.VO.Canvas extends App.VO.BaseCanvas

  defaults: -> $.extend super,
    type: 'canvas'
    'canvas.width': App.config.renderer.width
    'canvas.height': App.config.renderer.height
