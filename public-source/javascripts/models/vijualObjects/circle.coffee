class App.VO.Circle extends App.VO.Base3d

  defaults: -> $.extend super,
    type: 'circle'
    'geometry.radius': 0.5
    'geometry.segments': 8
    'geometry.thetaStart': 0
    'geometry.thetaLength': Math.PI * 2

  attributeControls: -> $.extend super,
    'geometry.radius': { type: 'slider', name: 'Radius', pos: [0, 3, 4, 1] }
    'geometry.segments': { type: 'integerSlider', name: 'Theta Seg.', max: 40, pos: [4, 3, 4, 1] }
    'geometry.thetaStart': { type: 'angle', name: 'Start', pos: [8, 3, 2, 1] }
    'geometry.thetaLength': { type: 'angle', name: 'Length', pos: [10, 3, 2, 1] }

  createGeometry: -> new THREE.CircleGeometry @get('geometry.radius'), @get('geometry.segments'), @get('geometry.thetaStart'), @get('geometry.thetaLength')
