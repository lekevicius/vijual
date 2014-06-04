class App.VO.Image extends App.VO.BaseCanvas

  defaults: -> $.extend super,
    type: 'image'
    'image.image': 'DefaultImage.png'

  attributeControls: -> $.extend super,
    'image.image': { type: 'media', mediaType: 'images', name: 'Image', pos: [8, 0, 4, 3] }

  initialize: (attributes, options) ->
    super
    @on 'change', @checkImageChanges, @

  checkImageChanges: (model, options) -> @drawCanvas() for item, value of model.changed when item is 'image.image'

  drawCanvas: ->
    super

    @imageObj = document.createElement 'img'
    @imageObj.onload = =>
      @updatePlaneSize @imageObj.width, @imageObj.height
      @context.drawImage @imageObj, 0, 0
      @texture.needsUpdate = true
    @imageObj.src = "/library/#{ @get('image.image') }"
