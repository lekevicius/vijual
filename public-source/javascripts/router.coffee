class App.VijualRouter extends Backbone.Router
  routes:
    '': 'mainRoute'
    'props': 'propsRoute'
    'scene': 'sceneRoute'

  mainRoute:
    route: ->
      # Start up the System
      App.renderer = new App.Renderer()
      App.document = new App.VijualTree(JSON.parse(App.defaultDocument))
      App.renderer.animate new Date().getTime()

      App.mediaLibrary = new App.MediaLibrary
      App.controlSurfaceManager = new App.VUI.ControlSurfaceManager()
      App.sceneManager = new App.VUI.SceneManager()
      App.mainConnection = new App.Connections.Main()
      App.mainConnection.on 'open', ->
        App.mainConnection.getMediaLibrary()
        thing.connectLinks() for key, thing of App.VO.GlobalLookup

      @currentView = App.mainView || App.mainView = new App.Views.MainView
      # console.log 'Entering main view'
      $('#content').attr('class', 'main').html @currentView.render().el
      $('body').addClass 'unbounce'
      # $('#content').append(App.mainConnection.sceneLowResCanvas).css({ position: 'absolute', zIndex: '200' })
    leave: ->
      App.mainConnection.close()
      $('body').removeClass 'unbounce'
      # console.log 'Leaving main view.'

  propsRoute:
    route: ->
      @currentView = App.propsView || App.propsView = new App.Views.PropsView
      # console.log 'Entering properties view'
      $('#ipad-icon-link, #ipad-retina-icon-link').remove()
      $('head').append '<link id="ipad-icon-link" rel="apple-touch-icon" sizes="76x76" href="icons/props-apple-touch-icon-76x76.png"><link id="ipad-retina-icon-link" rel="apple-touch-icon" sizes="152x152" href="icons/props-apple-touch-icon-152x152.png">'
      $('#content').attr('class', 'props').html @currentView.render().el

      App.controlSurfaceController = new App.VUI.ControlSurfaceController()
      App.propsConnection = new App.Connections.Props()
    leave: ->
      # console.log 'Leaving properties view.'

  sceneRoute:
    route: ->
      @currentView = App.sceneView || App.sceneView = new App.Views.SceneView
      # console.log 'Entering scene view'
      $('#ipad-icon-link, #ipad-retina-icon-link').remove()
      $('head').append '<link id="ipad-icon-link" rel="apple-touch-icon" sizes="76x76" href="icons/scene-apple-touch-icon-76x76.png"><link id="ipad-retina-icon-link" rel="apple-touch-icon" sizes="152x152" href="icons/scene-apple-touch-icon-152x152.png">'
      $('#content').attr('class', 'scene').html @currentView.render().el
      App.sceneView.setupScene()
      $('html, body').addClass 'unbounce'

      App.sceneController = new App.VUI.SceneController()
      App.sceneConnection = new App.Connections.Scene()
    leave: ->
      $('html, body').removeClass 'unbounce'
      # console.log 'Leaving scene view.'
