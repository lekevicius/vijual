App.projections = []
App.createProjection = ->
  projection = {}
  canvasEl = $('<div/>').html("<canvas id='mainCanvas' class='' width='#{ App.config.renderer.width }' height='#{ App.config.renderer.height }'></canvas>").contents().get(0)
  # $('body').append canvasEl
  projection.canvas = canvasEl


  projection.renderer = new THREE.WebGLRenderer antialias: true, canvas: projection.canvas, clearColor: 0x000000, clearAlpha: 0
  projection.renderer.context.getProgramInfoLog = -> '' # Can't hear you!
  projection.renderer.clear()
  App.projections.push projection

class App.Renderer extends Backbone.Model
  rendering: false
  initialize: (attributes) ->

    renderWidth = App.config.renderer.width
    renderHeight = App.config.renderer.height
    App.config.renderer.aspect = renderWidth / renderHeight
    App.config.renderer.reverseAspect = 1 / App.config.renderer.aspect

    @sceneCamera = new THREE.PerspectiveCamera 10, App.config.renderer.aspect, 0.001, 1000
    if App.config.renderer.aspect > 1 then @sceneCamera.position.z = 5.725 / App.config.renderer.aspect
    else @sceneCamera.position.z = 5.725

    App.createProjection()

    App.stats = new App.StatsWidget

    @captureScene = new THREE.Scene
    @captureCamera = new THREE.OrthographicCamera App.config.renderer.width / - 2, App.config.renderer.width / 2, App.config.renderer.height / 2, App.config.renderer.height / - 2, -10000, 10000
    @captureCamera.position.z = 100

    @composer = new WAGNER.Composer App.projections[0].renderer, { useRGBA: true }
    @composer.setSize App.config.renderer.width, App.config.renderer.height

  animate: (t) =>
    if _.size App.RenderWindow.all
      @rendering = true
      projection = App.projections[0]
      projection.renderer.clear()
      # projection.renderer.autoClearColor = true

      for track in App.document.get('tracks').toArray()
        if track.get('active')
          @sceneCamera.lookAt track.scene.position
          @composer.reset()
          @composer.render track.scene, @sceneCamera
          @composer.pass filter.filter for filter in track.get('filters').toArray() when filter.get('active')
          @composer.toTexture track.renderTarget

      projection.renderer.render @captureScene, @captureCamera

      for id, item of App.RenderWindow.all
        item.context.drawImage projection.canvas, 0, 0

      App.stats.update()
    else
      @rendering = false
    requestAnimationFrame @animate
