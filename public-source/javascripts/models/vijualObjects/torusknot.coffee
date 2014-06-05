class App.VO.TorusKnot extends App.VO.Base3d

  defaults: -> $.extend super,
    type: 'torusknot'
    'geometry.radius': 0.5
    'geometry.tube': 0.2
    'geometry.radialSegments': 64
    'geometry.tubularSegments': 8
    'geometry.p': 2
    'geometry.q': 3
    'geometry.heightScale': 1

  attributeControls: -> $.extend super,
    'geometry.radius': { type: 'slider', name: 'Radius', pos: [0, 4, 4, 1] }
    'geometry.tube': { type: 'slider', name: 'Tube', pos: [0, 5, 4, 1] }
    'geometry.radialSegments': { type: 'integerSlider', name: 'Radial Seg.', max: 200, pos: [4, 4, 4, 1] }
    'geometry.tubularSegments': { type: 'integerSlider', name: 'Tube Seg.', max: 16, pos: [4, 5, 4, 1] }
    'geometry.p': { type: 'integerSlider', name: 'P', max: 20, pos: [8, 4, 4, 1] }
    'geometry.q': { type: 'integerSlider', name: 'Q', max: 20, pos: [8, 5, 4, 1] }

  createGeometry: -> new THREE.TorusKnotGeometry @get('geometry.radius'), @get('geometry.tube'), @get('geometry.radialSegments'), @get('geometry.tubularSegments'), @get('geometry.p'), @get('geometry.q'), @get('geometry.heightScale')


