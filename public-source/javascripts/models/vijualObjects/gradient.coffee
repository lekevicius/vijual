class App.VO.Gradient extends App.VO.BaseCanvas

  defaults: -> $.extend super,
    type: 'gradient'
    'canvas.startColor': '#ff0000'
    'canvas.startColorAlpha': 1
    'canvas.endColor': '#00ffff'
    'canvas.endColorAlpha': 1
    'canvas.gradientAngle': 0

  attributeControls: -> $.extend super,
    'canvas.startColor': { type: 'color', name: 'Start', pos: [0, 4, 4, 3] }
    'canvas.startColorAlpha': { type: 'slider', name: 'Alpha', pos: [4, 4, 2, 3] }
    'canvas.endColor': { type: 'color', name: 'End', pos: [6, 4, 4, 3] }
    'canvas.endColorAlpha': { type: 'slider', name: 'Alpha', pos: [10, 4, 2, 3] }
    'canvas.gradientAngle': { type: 'angle', name: 'Angle', pos: [8, 0, 4, 3] }


  gradientCoordinates: (angle) ->
    degreeAngle = App.utils.degrees(angle) % 360
    edge = if App.config.renderer.width > App.config.renderer.height then App.config.renderer.width else App.config.renderer.height

    line1StartX = edge / 2
    line1StartY = edge / 2
    line1EndX = line1StartX + Math.cos(angle) * 10
    line1EndY = line1StartY + Math.sin(angle) * 10

    endPoint = { x: 0, y: 0 }
    if degreeAngle < 45 or degreeAngle >= 315 # right
      endPoint =  App.utils.checkLineIntersection( line1StartX, line1StartY, line1EndX, line1EndY, edge, 0, edge, edge )
    else if 45 <= degreeAngle < 135 # bottom
      endPoint = App.utils.checkLineIntersection( line1StartX, line1StartY, line1EndX, line1EndY, 0, edge, edge, edge )
    else if 135 <= degreeAngle < 225 # left
      endPoint = App.utils.checkLineIntersection( line1StartX, line1StartY, line1EndX, line1EndY, 0, 0, 0, edge )
    else if 225 <= degreeAngle < 315 # top
      endPoint = App.utils.checkLineIntersection( line1StartX, line1StartY, line1EndX, line1EndY, 0, 0, edge, 0 )

    startPoint = { x: ( edge - endPoint.x ), y: ( edge - endPoint.y ) }
    [ startPoint.x, startPoint.y, endPoint.x, endPoint.y ]

  drawCanvas: ->
    super

    coordinates = @gradientCoordinates @get('canvas.gradientAngle')
    gradient = @context.createLinearGradient coordinates[0], coordinates[1], coordinates[2], coordinates[3]
    gradient.addColorStop 0, App.VUI.colorAlpha(@get('canvas.startColor'), @get('canvas.startColorAlpha'))
    gradient.addColorStop 1, App.VUI.colorAlpha(@get('canvas.endColor'), @get('canvas.endColorAlpha'))

    @context.fillStyle = gradient
    @context.fillRect 0, 0, @get('canvas.width'), @get('canvas.height')
