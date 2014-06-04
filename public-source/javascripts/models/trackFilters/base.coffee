class App.TrackFilters.Base extends Backbone.RelationalModel

  subModelTypes:
    invert: 'App.TrackFilters.Invert'
    # chromaticAberration: 'App.TrackFilters.ChromaticAberration'
    dotScreen: 'App.TrackFilters.DotScreen'
    grayscale: 'App.TrackFilters.Grayscale'
    halftone: 'App.TrackFilters.Halftone'
    sepia: 'App.TrackFilters.Sepia'
    noise: 'App.TrackFilters.Noise'
    boxBlur: 'App.TrackFilters.BoxBlur'
    pixelate: 'App.TrackFilters.Pixelate'
    rgbSplit: 'App.TrackFilters.RGBSplit'
    led: 'App.TrackFilters.LED'
    colorCorrection: 'App.TrackFilters.ColorCorrection'
    colorify: 'App.TrackFilters.Colorify'
    hueSaturation: 'App.TrackFilters.HueSaturation'
    brightnessContrast: 'App.TrackFilters.BrightnessContrast'
    kaleidoscope: 'App.TrackFilters.Kaleidoscope'
    mirror: 'App.TrackFilters.Mirror'
    sobelEdgeDetection: 'App.TrackFilters.SobelEdgeDetection'
    oldVideo: 'App.TrackFilters.OldVideo'


  filterClass: WAGNER.Pass

  defaults: ->
    active: true

  attributeControls: ->
    'active' : { type: 'toggle', name: 'Active', pos: [0, 0, 2, 1] }

  initialize: (attributes = {}, options = {}) ->
    @id = attributes.id || App.utils.uuid()
    @set 'id', @id
    App.VO.GlobalLookup[@id] = @
    @setupFilter()
    @updateValue item, value for item, value of attributes
    @on 'change', @onChange, @
    super
    @setupLinkable()

  setupFilter: -> @filter = new @filterClass

  updateValue: (item, value, options = {}) -> @filter.params[item] = value unless item in ['active', 'sortOrder']

  onChange: (model, options) -> @updateValue item, value, options for item, value of model.changed

  destroy: ->
    @destroyLinkListeners()
    delete App.VO.GlobalLookup[@id]
    @trigger 'destroy', @, @collection

App.TrackFilters.Base.setup()
_.extend App.TrackFilters.Base.prototype, App.Mixins.Linkable



#++ (params) fullBoxBlurPass = new WAGNER.FullBoxBlurPass();
#++ (params) zoomBlurPass = new WAGNER.ZoomBlurPass();
#++ (params) multiPassBloomPass = new WAGNER.MultiPassBloomPass();
# denoisePass = new WAGNER.DenoisePass();
# vignettePass = new WAGNER.VignettePass();
# vignette2Pass = new WAGNER.Vignette2Pass();
# CGAPass = new WAGNER.CGAPass();
# sobelEdgeDetectionPass = new WAGNER.SobelEdgeDetectionPass();
#-----? dirtPass = new WAGNER.DirtPass();
# blendPass = new WAGNER.BlendPass();
# guidedBoxPass = new WAGNER.GuidedBoxBlurPass();
# guidedFullBoxBlurPass = new WAGNER.GuidedFullBoxBlurPass();



#++ barrelBlurPass = new WAGNER.BarrelBlurPass();
# oldVideoPass = new WAGNER.OldVideoPass();

#++ circularBlur = new WAGNER.CircularBlurPass();
# poissonDiscBlur = new WAGNER.PoissonDiscBlurPass();
# freiChenEdgeDetectionPass = new WAGNER.FreiChenEdgeDetectionPass();
#++ toonPass = new WAGNER.ToonPass();
# fxaaPass = new WAGNER.FXAAPass();
#++ highPassPass = new WAGNER.HighPassPass();
# asciiPass = new WAGNER.ASCIIPass();
