class App.VO.Cylinder extends App.VO.Base3d

  defaults: -> $.extend super,
    type: 'cylinder'
    'geometry.radiusTop': 0.5
    'geometry.radiusBottom': 0.5
    'geometry.height': 1
    'geometry.radiusSegments': 8
    'geometry.heightSegments': 1
    'geometry.openEnded': false
    'material.doublesided': true

  attributeControls: -> $.extend super,
    'geometry.radiusTop': { type: 'slider', name: 'Rad. Top', pos: [0, 4, 4, 1] }
    'geometry.radiusBottom': { type: 'slider', name: 'Rad. Bottom', pos: [4, 4, 4, 1] }
    'geometry.height': { type: 'slider', name: 'Height', pos: [8, 4, 4, 1] }
    'geometry.radiusSegments': { type: 'integerSlider', name: 'Radius Seg.', max: 40, pos: [0, 5, 4, 1] }
    'geometry.heightSegments': { type: 'integerSlider', name: 'Height Seg.', max: 40, pos: [4, 5, 4, 1] }
    'geometry.openEnded': { type: 'toggle', name: 'Open', pos: [8, 5, 4, 1] }

  createGeometry: -> new THREE.CylinderGeometry @get('geometry.radiusTop'), @get('geometry.radiusBottom'), @get('geometry.height'), @get('geometry.radiusSegments'), @get('geometry.heightSegments'), @get('geometry.openEnded')
