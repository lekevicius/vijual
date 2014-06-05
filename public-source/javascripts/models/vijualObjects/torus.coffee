class App.VO.Torus extends App.VO.Base3d

  defaults: -> $.extend super,
    type: 'torus'
    'geometry.radius': 0.5
    'geometry.tube': 0.25
    'geometry.radialSegments': 8
    'geometry.tubularSegments': 6
    'geometry.arc': Math.PI * 2

  attributeControls: -> $.extend super,
    'geometry.radius': { type: 'slider', name: 'Radius', pos: [0, 4, 4, 1] }
    'geometry.tube': { type: 'slider', name: 'Tube', pos: [0, 5, 4, 1] }
    'geometry.radialSegments': { type: 'integerSlider', name: 'Radial Seg.', max: 40, pos: [4, 4, 4, 1] }
    'geometry.tubularSegments': { type: 'integerSlider', name: 'Tube Seg.', max: 40, pos: [4, 5, 4, 1] }
    'geometry.arc': { type: 'angle', name: 'Arc', pos: [8, 4, 4, 2] }

  createGeometry: -> new THREE.TorusGeometry @get('geometry.radius'), @get('geometry.tube'), @get('geometry.radialSegments'), @get('geometry.tubularSegments'), @get('geometry.arc')
