App.utils = {}

$.fn.classList = () -> $(this).attr('class').split(/\s+/)

$.preload = (url, callback) -> $('<img/>').attr({ src: url }).load callback

App.utils.getObjectByString = (object, query) ->
  query = query.replace /\[(\w+)\]/g, '.$1' # convert indexes to properties
  query = query.replace /^\./, '' # strip a leading dot
  array = query.split('.')
  while array.length
    currentName = array.shift()
    if object[currentName] isnt undefined then object = object[currentName] else return undefined
  object

App.utils.setObjectByString = (object, query, value) ->
  query = query.replace /\[(\w+)\]/g, '.$1' # convert indexes to properties
  query = query.replace /^\./, '' # strip a leading dot
  array = query.split('.')
  while array.length
    currentName = array.shift()
    if object[currentName] isnt undefined then object = object[currentName] else return undefined
  object.setX(value)
  return object

App.utils.checkLineIntersection = (line1StartX, line1StartY, line1EndX, line1EndY, line2StartX, line2StartY, line2EndX, line2EndY) ->
  # if the lines intersect, the result contains the x and y of the intersection (treating the lines as infinite)
  # and booleans for whether line segment 1 or line segment 2 contain the point
  result =
    x: null
    y: null
    onLine1: false
    onLine2: false

  denominator = (line2EndY-line2StartY) * (line1EndX-line1StartX) - (line2EndX-line2StartX) * (line1EndY-line1StartY)
  return result if denominator is 0
  a = line1StartY - line2StartY
  b = line1StartX - line2StartX
  numerator1 = (line2EndX-line2StartX) * a - (line2EndY-line2StartY) * b
  numerator2 = (line1EndX-line1StartX) * a - (line1EndY-line1StartY) * b
  a = numerator1 / denominator
  b = numerator2 / denominator

  # if we cast these lines infinitely in both directions, they intersect here:
  result.x = line1StartX + a * ( line1EndX - line1StartX )
  result.y = line1StartY + a * ( line1EndY - line1StartY )
  result.onLine1 = true if a > 0 and a < 1 # if line1 is a segment and line2 is infinite, they intersect
  result.onLine2 = true if b > 0 and b < 1 # if line2 is a segment and line1 is infinite, they intersect
  # if line1 and line2 are segments, they intersect if both of the above are true
  result

App.utils.makeid = ->
  text = ""
  possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
  for i in [1..8]
    text += possible.charAt(Math.floor(Math.random() * possible.length))
  text

App.utils.delay = (time, func) -> setTimeout func, time
App.utils.every = (time, func) -> setInterval func, time

App.utils.touchByIdentifier = (touches, id) ->
  for touch in touches
    return touch if touch.identifier is id
  return -1

App.utils.uuid = ->
  'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) ->
    `r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8)`
    v.toString(16)

App.utils.radians = (degrees) -> degrees * Math.PI / 180
App.utils.degrees = (radians) -> radians * 180 / Math.PI

# Translate to render world
App.utils.renderX = (x) ->
  if App.config.renderer.aspect > 1 then return x - 0.5 # width > height, goes from -0.5 to 0.5
  else return (x - 0.5) * App.config.renderer.aspect # width < height, goes from (-0.5)/aspect to positive
App.utils.renderY = (y) ->
  if App.config.renderer.aspect <= 1 then return 0.5 - y # height > width, goes from -0.5 to 0.5
  else return (0.5 - y) / App.config.renderer.aspect # height < width, goes from (-0.5)/aspect to positive

# Translate from render world back to 0-1 in both sizes world
App.utils.screenX = (x) ->
  if App.config.renderer.aspect > 1 then return x + 0.5 # width > height, goes from -0.5 to 0.5
  else return x / App.config.renderer.aspect + 0.5  # width < height, goes from (-0.5)/aspect to positive
App.utils.screenY = (y) ->
  if App.config.renderer.aspect <= 1 then return 0.5 - y # height > width, goes from -0.5 to 0.5
  else return 0.5 - y * App.config.renderer.aspect # height < width, goes from (-0.5)/aspect to positive


App.utils.setScreenPosition = (object) ->
  object.set({ 'position.x': App.utils.renderX(object.get('screenPosition')[0]), 'position.y': App.utils.renderY(object.get('screenPosition')[1]), 'position.z': 0 })
