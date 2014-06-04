class App.VO.Tetrahedron extends App.VO.Base3d

  defaults: -> $.extend super,
    type: 'tetrahedron'
    'geometry.radius': 0.5

  createGeometry: -> new THREE.TetrahedronGeometry @get('geometry.radius')
