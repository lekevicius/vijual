class App.VO.Base3d extends App.VO.Base

  defaults: -> $.extend super, { type: 'base3d' }
  # attributeControls: -> $.extend super, {}

  initialize: (attributes, options) ->
    @geometry = @createGeometry()
    @renderObject = new THREE.Mesh( @geometry, new THREE.MeshLambertMaterial() )
    @on 'change', @updateGeometry, @
    super

  createGeometry: -> #noop

  updateGeometry: (model, options) ->
    geometryChanged = false
    for item, value of model.changed
      if item.substr(0,8) is 'geometry'
        geometryChanged = true
        break
    if geometryChanged
      @get('track').scene.remove @renderObject
      @geometry = @createGeometry()
      @renderObject = new THREE.Mesh( @geometry, new THREE.MeshLambertMaterial() )
      @get('track').scene.add @renderObject

      @updateValue item, value for item, value of @attributes
