class App.VO.Cube extends App.VO.Base3d

  defaults: -> $.extend super,
    type: 'cube'
    'geometry.width': 1
    'geometry.height': 1
    'geometry.depth': 1

  attributeControls: -> $.extend super,
    'geometry.width': { type: 'linearTracker', step: 0.01, name: 'Geo.Width', pos: [0, 4, 4, 1] }
    'geometry.height': { type: 'linearTracker', step: 0.01, name: 'Geo.Height', pos: [4, 4, 4, 1] }
    'geometry.depth': { type: 'linearTracker', step: 0.01, name: 'Geo.Depth', pos: [8, 4, 4, 1] }

  createGeometry: -> new THREE.CubeGeometry @get('geometry.width'), @get('geometry.height'), @get('geometry.depth')
