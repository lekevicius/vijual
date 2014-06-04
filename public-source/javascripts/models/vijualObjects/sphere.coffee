class App.VO.Sphere extends App.VO.Base3d

  defaults: -> $.extend super,
    type: 'sphere'
    'geometry.radius': 0.5
    'geometry.widthSegments': 8
    'geometry.heightSegments': 6
    'geometry.phiStart': 0
    'geometry.phiLength': Math.PI * 2
    'geometry.thetaStart': 0
    'geometry.thetaLength': Math.PI

  attributeControls: -> $.extend super,
    'geometry.radius': { type: 'slider', name: 'Radius', pos: [0, 3, 4, 1] }
    'geometry.widthSegments': { type: 'integerSlider', name: 'Width Seg.', max: 40, pos: [0, 4, 4, 1] }
    'geometry.heightSegments': { type: 'integerSlider', name: 'Height Seg.', max: 40, pos: [0, 5, 4, 1] }
    'geometry.phiStart': { type: 'angle', name: 'Start', pos: [4, 3, 2, 3] }
    'geometry.phiLength': { type: 'angle', name: 'Length', pos: [6, 3, 2, 3] }
    'geometry.thetaStart': { type: 'angle', name: 'Start', pos: [8, 3, 2, 3] }
    'geometry.thetaLength': { type: 'angle', name: 'Length', pos: [10, 3, 2, 3] }

  initialize: (attributes, options) ->
    @geometry = new THREE.SphereGeometry @get('geometry.radius'), @get('geometry.widthSegments'), @get('geometry.heightSegments'), @get('geometry.phiStart'), @get('geometry.phiLength'), @get('geometry.thetaStart'), @get('geometry.thetaLength')
    super

  createGeometry: -> new THREE.SphereGeometry @get('geometry.radius'), @get('geometry.widthSegments'), @get('geometry.heightSegments'), @get('geometry.phiStart'), @get('geometry.phiLength'), @get('geometry.thetaStart'), @get('geometry.thetaLength')
