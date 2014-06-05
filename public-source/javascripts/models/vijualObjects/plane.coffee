class App.VO.Plane extends App.VO.Base3d

  defaults: -> $.extend super,
    type: 'plane'
    'geometry.width': 1
    'geometry.height': 1

  attributeControls: -> $.extend super,
    'geometry.width': { type: 'linearTracker', step: 0.01, name: 'Geo.Width', pos: [0, 4, 6, 1] }
    'geometry.height': { type: 'linearTracker', step: 0.01, name: 'Geo.Height', pos: [6, 4, 6, 1] }

  createGeometry: -> new THREE.PlaneGeometry @get('geometry.width'), @get('geometry.height')
