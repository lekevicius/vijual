App.VUI.colorAlpha = (hex, alpha) ->
  color = tinycolor hex
  color.setAlpha alpha
  color.toRgbString()

App.VUI.roundRect = (ctx, x, y, width, height, radius = 5, fill = false, stroke = true) ->
  radii = [ radius, radius, radius, radius ] if typeof radius is 'number'
  radii = radius if typeof radius is 'object'
  ctx.beginPath()
  ctx.moveTo(x + radii[0], y)
  ctx.lineTo(x + width - radii[1], y)
  ctx.quadraticCurveTo(x + width, y, x + width, y + radii[1])
  ctx.lineTo(x + width, y + height - radii[2])
  ctx.quadraticCurveTo(x + width, y + height, x + width - radii[2], y + height)
  ctx.lineTo(x + radii[3], y + height)
  ctx.quadraticCurveTo(x, y + height, x, y + height - radii[3])
  ctx.lineTo(x, y + radii[0])
  ctx.quadraticCurveTo(x, y, x + radii[0], y)
  ctx.closePath()
  if (stroke) then ctx.stroke()
  if (fill) then ctx.fill()

App.VUI.GlobalTouchHandler =
  moveHandler: (e) ->
    if App.VUI.ongoingTouches.length
      e.preventDefault()
      if e.type is 'touchmove'
        trackableTouchIds = (touch.identifier for touch in App.VUI.ongoingTouches)
        trackedTouches = ( touch for touch in e.originalEvent.changedTouches when _.contains(trackableTouchIds, touch.identifier) )
        for currentTouch in trackedTouches
          touchData = _.findWhere( App.VUI.ongoingTouches, { identifier: currentTouch.identifier } )
          touchData.handler.moveHandler touchData, currentTouch
      else
        touchData = App.VUI.ongoingTouches[0]
        currentTouch = e
        touchData.handler.moveHandler touchData, currentTouch

  endHandler: (e) ->
    if App.VUI.ongoingTouches.length
      e.preventDefault()
      if e.type is 'touchend'
        removeTouchIds = ( touch.identifier for touch in e.originalEvent.changedTouches )
        trackableTouchIds = (touch.identifier for touch in App.VUI.ongoingTouches)
        removeTouches = ( touch for touch in e.originalEvent.changedTouches when _.contains(trackableTouchIds, touch.identifier) )
        for removingTouch in removeTouches
          touchData = _.findWhere( App.VUI.ongoingTouches, { identifier: removingTouch.identifier } )
          touchData.handler.endHandler(touchData, removingTouch)
        App.VUI.ongoingTouches = ( touch for touch in App.VUI.ongoingTouches when !(touch.identifier in removeTouchIds) )
      else
        touchData = App.VUI.ongoingTouches[0]
        removingTouch = e
        touchData.handler.endHandler touchData, removingTouch
        App.VUI.ongoingTouches = []


$(document).on 'touchmove mousemove', App.VUI.GlobalTouchHandler.moveHandler
$(document).on 'touchend mouseup', App.VUI.GlobalTouchHandler.endHandler
