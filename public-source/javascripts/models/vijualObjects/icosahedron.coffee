class App.VO.Icosahedron extends App.VO.Base3d

  defaults: -> $.extend super,
    type: 'icosahedron'
    'geometry.radius': 0.5

  createGeometry: -> new THREE.IcosahedronGeometry @get('geometry.radius')
