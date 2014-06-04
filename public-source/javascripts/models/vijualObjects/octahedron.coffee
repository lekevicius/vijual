class App.VO.Octahedron extends App.VO.Base3d

  defaults: -> $.extend super,
    type: 'octahedron'
    'geometry.radius': 0.5

  createGeometry: -> new THREE.OctahedronGeometry @get('geometry.radius')
