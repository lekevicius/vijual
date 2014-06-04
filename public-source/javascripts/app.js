/***** Javascript Support *****/
//= libs/jquery-2.1.0.js
//= libs/jquery-ui-1.10.4.js
//= libs/sugar-1.4.1.js
//= libs/polyfills/requestAnimationFrame.js

/***** Backbone *****/
//= libs/underscore-1.6.0.js
//= libs/backbone/backbone-1.1.2.js
//= libs/backbone/backbone.router-filter.js
//= libs/backbone/backbone.relational.js

/***** TweenMax Animations *****/
//= libs/greensock/TweenMax.min.js
//= libs/greensock/plugins/ColorPropsPlugin.min.js
//= libs/greensock/plugins/ThrowPropsPlugin.min.js

/***** Fabric *****/
//= libs/fabric-1.4.0.js

/***** Three *****/
//= libs/three/three-r66.js
//= libs/three/Tween.js
//= libs/three/Sparks.js
//= libs/three/CanvasShaders.js

//= libs/three/Wagner.js
//= libs/three/Wagner.base.js
//= libs/three/ShaderLoader.js

//= libs/three/stats.min.js

/***** Misc. Libraries *****/
//= libs/mousetrap-1.4.6.js
//= libs/leap-0.4.1.js
//= libs/fuse.js
//= libs/tinycolor-0.9.17.js
//= libs/filesaver.js
//= libs/fastclick-1.0.1.js
//= libs/hammer-1.1.2.js
//= libs/swfobject.js
//= libs/font-detect.js
//= libs/annyang.js

//= libs/jade-runtime-1.1.4.js


/***** Configuration *****/
//= config.coffee

/***** Application Data *****/
//= data/terms.js
//= data/termIcons.js
//= data/demoPanel.coffee

/***** Application Support *****/
//= utils.coffee
//= templates.js

//= models/linkable.coffee

/***** Models *****/
//= models/vijualTree.coffee
//= models/track.coffee
//= models/ticker.coffee
//= models/mediaLibrary.coffee
//= models/renderer.coffee

//= models/connections/base.coffee
//= models/connections/main.coffee
//= models/connections/props.coffee
//= models/connections/scene.coffee

//= models/vijualObjects/base.coffee
//= models/vijualObjects/group.coffee

//= models/vijualObjects/base3d.coffee
//= models/vijualObjects/plane.coffee
//= models/vijualObjects/circle.coffee
//= models/vijualObjects/ring.coffee
//= models/vijualObjects/cube.coffee
//= models/vijualObjects/sphere.coffee
//= models/vijualObjects/cylinder.coffee
//= models/vijualObjects/tetrahedron.coffee
//= models/vijualObjects/octahedron.coffee
//= models/vijualObjects/icosahedron.coffee
//= models/vijualObjects/torus.coffee
//= models/vijualObjects/torusknot.coffee
//..... models/vijualObjects/particlesystem.coffee

//= models/vijualObjects/baseCanvas.coffee
//= models/vijualObjects/canvas.coffee
//= models/vijualObjects/color.coffee
//= models/vijualObjects/gradient.coffee
//= models/vijualObjects/image.coffee
//= models/vijualObjects/shape.coffee
//= models/vijualObjects/text.coffee
//= models/vijualObjects/video.coffee
//= models/vijualObjects/webcam.coffee
//= models/vijualObjects/drawing.coffee
//= models/vijualObjects/noun.coffee

//= models/trackFilters/customShaders.coffee

//= models/trackFilters/base.coffee
//= models/trackFilters/invert.coffee
//...... models/trackFilters/chromaticAberration.coffee
//= models/trackFilters/dotScreen.coffee
//= models/trackFilters/grayscale.coffee
//= models/trackFilters/halftone.coffee
//= models/trackFilters/sepia.coffee
//= models/trackFilters/noise.coffee
//= models/trackFilters/boxBlur.coffee
//= models/trackFilters/pixelate.coffee
//= models/trackFilters/rgbSplit.coffee
//= models/trackFilters/led.coffee
//= models/trackFilters/colorCorrection.coffee
//= models/trackFilters/colorify.coffee
//= models/trackFilters/hueSaturation.coffee
//= models/trackFilters/brightnessContrast.coffee
//= models/trackFilters/kaleidoscope.coffee
//= models/trackFilters/mirror.coffee
//= models/trackFilters/sobelEdgeDetection.coffee
//= models/trackFilters/oldVideo.coffee

/***** Behaviors *****/
//= behaviors/base.coffee
//= behaviors/intro.coffee
//= behaviors/outro.coffee
//= behaviors/looping.coffee
//= behaviors/beat.coffee
//= behaviors/trigger.coffee
//= behaviors/operator.coffee
//= behaviors/generator.coffee

//= behaviors/intro/fadeIn.coffee
//= behaviors/intro/scaleIn.coffee
//= behaviors/intro/rotateIn.coffee
//= behaviors/intro/directionalIntros.coffee

//= behaviors/outro/fadeOut.coffee
//= behaviors/outro/scaleOut.coffee
//= behaviors/outro/rotateOut.coffee
//= behaviors/outro/directionalOutros.coffee

//= behaviors/looping/control3d.coffee
//= behaviors/looping/spin3d.coffee
//= behaviors/looping/spin.coffee
//= behaviors/looping/pulseOpacity.coffee
//= behaviors/looping/pulseScale.coffee

//= behaviors/beat/beatOpacity.coffee
//= behaviors/beat/beatRotation.coffee
//= behaviors/beat/beatScale.coffee

//= behaviors/trigger/place.coffee
//= behaviors/trigger/attentionTriggers.coffee

//= behaviors/operator/mathOperators.coffee
//= behaviors/operator/floatToAngle.coffee

//= behaviors/generator/random.coffee
//= behaviors/generator/walk.coffee
//= behaviors/generator/counter.coffee
//= behaviors/generator/lfo.coffee

//= models/renderWindow.coffee

/***** Views *****/
//= views/main.coffee
//= views/documentToolbar.coffee
//= views/track.coffee
//= views/vijualObject.coffee
//= views/sidebar.coffee
//= views/addObjectSidebar.coffee

//= views/props.coffee
//= views/propsRecordingsModal.coffee
//= views/scene.coffee

//= views/statsWidget.coffee

/***** VUI - Vijual User Interface *****/
//= vui/vui.coffee

//= vui/base.coffee
//= vui/canvasBase.coffee
//= vui/domBase.coffee

//= vui/input.coffee
//= vui/output.coffee

//= vui/triggerButton.coffee
//= vui/holdButton.coffee
//= vui/toggle.coffee
//= vui/switcher.coffee
//= vui/list.coffee
//= vui/media.coffee

//= vui/stepper.coffee
//= vui/slider.coffee
//= vui/integerSlider.coffee
//= vui/knob.coffee
//= vui/linearTracker.coffee
//= vui/exponentialTracker.coffee
//= vui/angle.coffee
//= vui/area.coffee
//= vui/text.coffee
//= vui/textarea.coffee

//= vui/color.coffee

//= vui/sceneManager.coffee
//= vui/sceneController.coffee
//= vui/controlSurfaceManager.coffee
//= vui/controlSurfaceController.coffee
//= vui/builder.coffee

/***** Application *****/
//= router.coffee
//= app.coffee

/***** Temporary *****/
//= windowManager.coffee
//= midi.coffee
