class App.VO.ParticleSystem extends App.VO.Base

  defaults: -> $.extend super,
    type: 'particlesystem'
    'geometry.radius': 0.5
    'geometry.segments': 8
    'geometry.thetaStart': 0
    'geometry.thetaLength': Math.PI * 2

  createGeometry: -> new THREE.CircleGeometry @get('geometry.radius'), @get('geometry.segments'), @get('geometry.thetaStart'), @get('geometry.thetaLength')


  initialize: (attributes, options) ->

    @renderObject = new THREE.Object3D()

    @sparksEmitter = new SPARKS.Emitter(new SPARKS.SteadyCounter(200))

    @sparksEmitter.addInitializer new SPARKS.Lifetime(3,3)
    @sparksEmitter.addInitializer new SPARKS.Position( new SPARKS.PointZone( new THREE.Vector3( 0, 0, 0 ) ) )
    @sparksEmitter.addInitializer new SPARKS.Velocity( new SPARKS.PointZone( new THREE.Vector3( 0.0001, 0, 0 ) ) )

    @sparksEmitter.addAction new SPARKS.Age()
    @sparksEmitter.addAction new SPARKS.Move()

    @sparksEmitter.addCallback "created", @onParticleCreated
    @sparksEmitter.addCallback "dead", @onParticleDead

    @sparksEmitter.start()

    @on 'change', @updateSystem, @
    super

  onParticleCreated: (p) =>
    # create a three.js particle
    material = new THREE.ParticleCanvasMaterial
      program: SPARKS.CanvasShadersUtils.circles
      blending: THREE.AdditiveBlending
      color: '#ff0000'

    particle = new THREE.Particle material
    particle.scale.x = particle.scale.y = 0.2
    @renderObject.add particle
    # assign three.js particle to sparks.js position
    particle.position = p.position
    # assign sparks.js target particle to three.js particle
    p.target = particle

  onParticleDead: (p) =>
    p.target.visible = false # is this a work around?
    @renderObject.remove p.target

  updateSystem: (model, options) ->
    # geometryChanged = false
    # for item, value of model.changed
    #   if item.substr(0,8) is 'geometry'
    #     geometryChanged = true
    #     break
    # if geometryChanged
    #   @get('track').scene.remove @renderObject
    #   @geometry = @createGeometry()
    #   @renderObject = new THREE.Mesh( @geometry, new THREE.MeshLambertMaterial() )
    #   @get('track').scene.add @renderObject

    #   @updateValue item, value for item, value of @attributes


# PointZone in the center
# Group in the center

# Lifetime
# Velocity
# RandomDrift
# Color range
# Shape
