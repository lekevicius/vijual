class App.Behaviors.Base extends Backbone.RelationalModel

  subModelTypes:

    fadeIn: 'App.Behaviors.FadeIn'
    rotateIn: 'App.Behaviors.RotateIn'
    scaleIn: 'App.Behaviors.ScaleIn'
    slideInFromSide: 'App.Behaviors.SlideInFromSide'
    slideInDirectionally: 'App.Behaviors.SlideInDirectionally'
    bounceInFromSide: 'App.Behaviors.BounceInFromSide'
    bounceInDirectionally: 'App.Behaviors.BounceInDirectionally'

    fadeOut: 'App.Behaviors.FadeOut'
    rotateOut: 'App.Behaviors.RotateOut'
    scaleOut: 'App.Behaviors.ScaleOut'
    slideOutToSide: 'App.Behaviors.SlideOutToSide'
    slideOutDirectionally: 'App.Behaviors.SlideOutDirectionally'
    bounceOutToSide: 'App.Behaviors.BounceOutToSide'
    bounceOutDirectionally: 'App.Behaviors.BounceOutDirectionally'

    spin3d: 'App.Behaviors.Spin3d'
    spin: 'App.Behaviors.Spin'
    control3d: 'App.Behaviors.Control3d'
    pulseScale: 'App.Behaviors.PulseScale'
    pulseOpacity: 'App.Behaviors.PulseOpacity'

    beatScale: 'App.Behaviors.BeatScale'
    beatRotation: 'App.Behaviors.BeatRotation'
    beatOpacity: 'App.Behaviors.BeatOpacity'
    beatRandom: 'App.Behaviors.BeatRandom'
    beatWalk: 'App.Behaviors.BeatWalk'
    beatCounter: 'App.Behaviors.BeatCounter'

    placeInCenter: 'App.Behaviors.PlaceInCenter'
    placeLeft: 'App.Behaviors.PlaceLeft'
    placeRight: 'App.Behaviors.PlaceRight'
    placeTop: 'App.Behaviors.PlaceTop'
    placeBottom: 'App.Behaviors.PlaceBottom'
    wobble: 'App.Behaviors.Wobble'
    swing: 'App.Behaviors.Swing'
    shake: 'App.Behaviors.Shake'
    flash: 'App.Behaviors.Flash'
    bounce: 'App.Behaviors.Bounce'
    tada: 'App.Behaviors.Tada'
    pulse: 'App.Behaviors.Pulse'
    rubberband: 'App.Behaviors.Rubberband'

    floatToAngle: 'App.Behaviors.FloatToAngle'
    sum: 'App.Behaviors.Sum'
    subtract: 'App.Behaviors.Subtract'
    multiply: 'App.Behaviors.Multiply'
    divide: 'App.Behaviors.Divide'
    modulus: 'App.Behaviors.Modulus'

    random: 'App.Behaviors.Random'
    walk: 'App.Behaviors.Walk'
    counter: 'App.Behaviors.Counter'
    angleRotator: 'App.Behaviors.AngleRotator'
    LFO: 'App.Behaviors.LFO'

  defaults: ->
    active: true

  attributeControls: ->
    'active' : { type: 'toggle', name: 'Active', pos: [0, 0, 2, 1] }

  initialize: (attributes = {}, options = {}) ->
    @id = attributes.id || App.utils.uuid()
    @set 'id', @id
    App.VO.GlobalLookup[@id] = @
    @proxy = {}
    _.bindAll @, 'run', 'runIfActive'
    @setupLinkable()

  runIfActive: () -> @run.apply(@, arguments) if @get('active')

  toggleActivation: => @set 'active', not @get 'active'

  run: -> # noop

  setupListeners: (collection) -> # noop

  destroy: ->
    @stopListening()
    @destroyLinkListeners()
    delete App.VO.GlobalLookup[@id]
    @trigger 'destroy', @, @collection

App.Behaviors.Base.setup()
_.extend App.Behaviors.Base.prototype, App.Mixins.Linkable
