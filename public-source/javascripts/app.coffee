Backbone.View.prototype.close = ->
  @closing() if @closing
  if @childViews
    childView.close() for childView in @childViews
  @remove()

App.objectTypes =
  color: { name: 'Color', className: App.VO.Color }
  canvas: { name: 'Canvas', className: App.VO.Canvas }
  circle: { name: 'Circle', className: App.VO.Circle }
  cube: { name: 'Cube', className: App.VO.Cube }
  cylinder: { name: 'Cylinder', className: App.VO.Cylinder }
  drawing: { name: 'Drawing', className: App.VO.Drawing }
  gradient: { name: 'Gradient', className: App.VO.Gradient }
  icosahedron: { name: 'Icosahedron', className: App.VO.Icosahedron }
  image: { name: 'Image', className: App.VO.Image }
  noun: { name: 'Noun', className: App.VO.Noun }
  octahedron: { name: 'Octahedron', className: App.VO.Octahedron }
  # particlesystem: { name: 'Particle System', className: App.VO.ParticleSystem }
  plane: { name: 'Plane', className: App.VO.Plane }
  ring: { name: 'Ring', className: App.VO.Ring }
  shape: { name: 'Shape', className: App.VO.Shape }
  sphere: { name: 'Sphere', className: App.VO.Sphere }
  tetrahedron: { name: 'Tetrahedron', className: App.VO.Tetrahedron }
  text: { name: 'Text', className: App.VO.Text }
  torus: { name: 'Torus', className: App.VO.Torus }
  torusknot: { name: 'Torus Knot', className: App.VO.TorusKnot }
  video: { name: 'Video', className: App.VO.Video }
  webcam: { name: 'Webcam', className: App.VO.Webcam }

$ ->
  if localStorage['fonts']
    App.fonts = JSON.parse localStorage['fonts']
  else
    fontDetect = new FontDetect "font-detect", "/resources/FontList.swf", (fd) ->
      fonts = fd.fonts()
      App.fonts = ( font.fontName for font in fonts )
      localStorage['fonts'] = JSON.stringify App.fonts

  fabric.Object.prototype.originX = fabric.Object.prototype.originY = 'center'
  App.NounSearch = new Fuse App.data.terms, { keys: ['term'], threshold: 0.25 }
  # App.NounSearch.search(searchTerm)
  App.termIcons = (termId) -> App.data.termIcons[ id + '' ]
  App.ticker = new App.Ticker
  App.router = new App.VijualRouter

  App.userBehaviors = _.without _.keys(App.Behaviors), 'Base', 'Intro', 'Outro', 'Looping', 'Beat', 'Trigger', 'Operator', 'Generator', 'DirectionalIntro', 'DirectionalOutro'
  App.userBehaviorGroups = { intro: {}, outro: {}, looping: {}, beat: {}, trigger: {}, operator: {}, generator: {} }
  for key in App.userBehaviors
    App.userBehaviorGroups[ App.Behaviors[key].prototype.groupName ][ key ] = App.Behaviors[key].prototype.name

  App.userTrackFilters = _.without _.keys(App.TrackFilters), 'Base'

  Backbone.history.start()
