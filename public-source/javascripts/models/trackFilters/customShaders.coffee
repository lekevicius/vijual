class WAGNER.CustomColorCorrectionPass extends WAGNER.Pass

  constructor: ->
    super
    WAGNER.log 'Custom Color correction constructor'
    @loadShader 'color-correction-fs.glsl'

    @params.powRGB = new THREE.Vector3 2, 2, 2
    @params.mulRGB = new THREE.Vector3 1, 1, 1

  run: (c) ->
    @shader.uniforms.powRGB.value.copy @params.powRGB
    @shader.uniforms.mulRGB.value.copy @params.mulRGB
    c.pass @shader



class WAGNER.CustomColorifyPass extends WAGNER.Pass

  constructor: ->
    super
    WAGNER.log 'Custom Colorify constructor'
    @loadShader 'colorify-fs.glsl'

    @params.color = new THREE.Color 0xffffff

  run: (c) ->
    @shader.uniforms.color.value = new THREE.Vector3 @params.color.r, @params.color.g, @params.color.b
    c.pass @shader



class WAGNER.CustomHueSaturationPass extends WAGNER.Pass

  constructor: ->
    super
    WAGNER.log 'Custom Hue Saturation constructor'
    @loadShader 'hue-saturation-fs.glsl'

    @params.hue = 0
    @params.saturation = 0

  run: (c) ->
    @shader.uniforms.hue.value = @params.hue
    @shader.uniforms.saturation.value = @params.saturation
    c.pass @shader



class WAGNER.CustomBrightnessContrastPass extends WAGNER.Pass

  constructor: ->
    super
    WAGNER.log 'Custom Brightness Contrast constructor'
    @loadShader 'brightness-contrast-fs.glsl'

    @params.brightness = 0
    @params.contrast = 0

  run: (c) ->
    @shader.uniforms.brightness.value = @params.brightness
    @shader.uniforms.contrast.value = @params.contrast
    c.pass @shader



class WAGNER.CustomKaleidoscopePass extends WAGNER.Pass

  constructor: ->
    super
    WAGNER.log 'Custom Kaleidoscope constructor'
    @loadShader 'kaleidoscope-fs.glsl'

    @params.sides = 6
    @params.angle = 0

  run: (c) ->
    @shader.uniforms.sides.value = @params.sides
    @shader.uniforms.angle.value = @params.angle
    c.pass @shader



class WAGNER.CustomMirrorPass extends WAGNER.Pass

  constructor: ->
    super
    WAGNER.log 'Custom Mirror constructor'
    @loadShader 'mirror-fs.glsl'
    @params.side = 1

  run: (c) ->
    @shader.uniforms.side.value = parseInt(@params.side)
    c.pass @shader

