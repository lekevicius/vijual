class App.Views.SceneView extends Backbone.View
  template: JST.scene
  events:
    'touchstart #scene-button': 'sceneMsg'
  render: ->
    @$el.html @template()
    @
  setupScene: ->
    @$sceneCanvas = @$('#sceneCanvas')
    @$sceneCanvas.css marginLeft: (App.config.renderer.lowDisplayWidth / -2) + 'px', marginTop: (App.config.renderer.lowDisplayHeight / -2) + 'px'
    @sceneCanvas = @$sceneCanvas.get(0)
    @sceneCanvasContext = @sceneCanvas.getContext '2d'

    gestureArea = document.getElementById('interaction-layer')

    @objectPropeties =
      height: 0.2
      width: 0.2
      scale: 1.5
      positionX: 0.1
      positionY: 0.3
      rotation: 34
    @objectLastProperties = _.clone @objectPropeties

    @$interactionObject = @$('.interaction-object')
    @canvasOffset = @$sceneCanvas.offset()
    @$interactionObject.css
      width: ( App.config.renderer.lowDisplayWidth ) + 'px'
      height: ( App.config.renderer.lowDisplayHeight ) + 'px'
      top: ( @canvasOffset.top ) + 'px'
      left: ( @canvasOffset.left ) + 'px'
      marginTop: ( App.config.renderer.lowDisplayHeight * -0.5 ) + 'px'
      marginLeft: ( App.config.renderer.lowDisplayWidth * -0.5 ) + 'px'
    @$interactionObject.hide()

    @allowDragging = true
    @startedDragging = false
    hammertime = Hammer gestureArea, preventDefault: true, gesture: true
    .on "dragstart transformstart", (e) =>
      return unless @allowDragging
      @startedDragging = true
      @objectLastProperties = _.clone @objectPropeties
      @objectLastProperties.positionX = (e.gesture.center.pageX - @canvasOffset.left) / App.config.renderer.lowDisplayWidth
      @objectLastProperties.positionY = (e.gesture.center.pageY - @canvasOffset.top) / App.config.renderer.lowDisplayHeight
      App.sceneController.recordChanges { controlStage: 'start' }
    .on "drag transform", (e) =>
      return unless @allowDragging
      touchesNow = e.gesture.touches.length

      @newProperties =
        positionX: (e.gesture.center.pageX - @canvasOffset.left) / App.config.renderer.lowDisplayWidth
        positionY: (e.gesture.center.pageY - @canvasOffset.top) / App.config.renderer.lowDisplayHeight
        controlStage: 'move'
      if touchesNow > 1
        @newProperties.scale = @objectLastProperties.scale * e.gesture.scale
        @newProperties.rotation = @objectLastProperties.rotation + e.gesture.rotation * (-1)
      App.sceneController.recordChanges @newProperties
      # @objectPropeties = _.extend {}, @objectPropeties, @newProperties
      # @updateInteractionObject()
    .on "tap", (e) =>
      @newProperties =
        positionX: (e.gesture.center.pageX - @canvasOffset.left) / App.config.renderer.lowDisplayWidth
        positionY: (e.gesture.center.pageY - @canvasOffset.top) / App.config.renderer.lowDisplayHeight
        controlStage: 'startend'
      App.sceneController.recordChanges @newProperties
      # @objectPropeties = _.extend {}, @objectPropeties, @newProperties
      # @updateInteractionObject()
    .on "release", (e) =>
      touchesNow = e.gesture.touches.length
      @allowDragging = false if e.gesture.pointerType is 'touch' and touchesNow is 2 and e.gesture.srcEvent.touches.length is 1
      @allowDragging = true if touchesNow is 1
      if @startedDragging
        @startedDragging = false
        @newProperties =
          positionX: (e.gesture.center.pageX - @canvasOffset.left) / App.config.renderer.lowDisplayWidth
          positionY: (e.gesture.center.pageY - @canvasOffset.top) / App.config.renderer.lowDisplayHeight
          controlStage: 'end'
        App.sceneController.recordChanges @newProperties
        # @objectPropeties = _.extend {}, @objectPropeties, @newProperties
        # @updateInteractionObject()

    document.ontouchmove = (event) -> event.preventDefault()

  updateInteractionObject: =>
    translateX = @objectPropeties.positionX * App.config.renderer.lowDisplayWidth
    translateY = @objectPropeties.positionY * App.config.renderer.lowDisplayHeight
    # scaleX = @objectPropeties.width * @objectPropeties.scale
    # scaleY = @objectPropeties.height * @objectPropeties.scale
    displayWidth = @objectPropeties.width * @objectPropeties.scale * App.config.renderer.lowDisplayWidth
    displayHeight = @objectPropeties.height * @objectPropeties.scale * App.config.renderer.lowDisplayHeight
    # scale(#{ scaleX }, #{ scaleY })
    @$interactionObject.css
      transform: "translate(#{ translateX }px, #{ translateY }px) rotate(#{ @objectPropeties.rotation * (-1) }deg)"
      width: displayWidth + 'px'
      height: displayHeight + 'px'
      marginTop: ( displayHeight * -0.5 ) + 'px'
      marginLeft: ( displayWidth * -0.5 ) + 'px'
      border: "3px solid #{ @objectPropeties.color }"
      backgroundColor: App.VUI.colorAlpha( @objectPropeties.color, 0.2 )
