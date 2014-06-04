class App.VO.Ring extends App.VO.Base3d

  defaults: -> $.extend super,
    type: 'ring'
    'geometry.innerRadius': 0.25
    'geometry.outerRadius': 0.5
    'geometry.thetaSegments': 8
    'geometry.phiSegments': 8
    'geometry.thetaStart': 0
    'geometry.thetaLength': Math.PI * 2

  attributeControls: -> $.extend super,
    'geometry.innerRadius': { type: 'slider', name: 'Inner Rad.', pos: [0, 3, 4, 1] }
    'geometry.outerRadius': { type: 'slider', name: 'Outer Rad.', pos: [0, 4, 4, 1] }
    'geometry.thetaSegments': { type: 'integerSlider', name: 'Theta Seg.', max: 40, pos: [4, 3, 4, 1] }
    'geometry.phiSegments': { type: 'integerSlider', name: 'Phi Seg.', pos: [4, 4, 4, 1] }
    'geometry.thetaStart': { type: 'angle', name: 'Start', pos: [8, 3, 2, 2] }
    'geometry.thetaLength': { type: 'angle', name: 'Length', pos: [10, 3, 2, 2] }

  createGeometry: -> new THREE.RingGeometry @get('geometry.innerRadius'), @get('geometry.outerRadius'), @get('geometry.thetaSegments'), @get('geometry.phiSegments'), @get('geometry.thetaStart'), @get('geometry.thetaLength')
