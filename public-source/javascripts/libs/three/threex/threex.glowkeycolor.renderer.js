var THREEx	= THREEx || {};

THREEx.GlowKeyColor	= THREEx.GlowKeyColor	|| {}

THREEx.GlowKeyColor.Renderer	= function(renderer, camera, scene, keyColor, glowColor){
	// init argument
	keyColor	= keyColor	|| new THREE.Color('hotpink')
	this.keyColor	= keyColor
	glowColor	= glowColor	|| new THREE.Color('red')
	this.glowColor	= glowColor
	
	//////////////////////////////////////////////////////////////////////////////////
	//		update loop							//
	//////////////////////////////////////////////////////////////////////////////////
	
	var updateFcts	= []
	this.update	= function(delta, now){
		updateFcts.forEach(function(updateFct){
			updateFct(delta, now)
		})
	}
	
	//////////////////////////////////////////////////////////////////////////////////
	//		render the scene						//
	//////////////////////////////////////////////////////////////////////////////////

	var colorRenderTarget	= new THREE.WebGLRenderTarget(window.innerWidth, window.innerHeight, {
		minFilter	: THREE.LinearFilter,
		magFilter	: THREE.LinearFilter,
		format		: THREE.RGBFormat,
	});
	updateFcts.push(function(){
		renderer.render( scene, camera, colorRenderTarget );		
	})

	//////////////////////////////////////////////////////////////////////////////////
	//		do the glow rendering=						//
	//////////////////////////////////////////////////////////////////////////////////
	
	var glowPostProc  = new THREEx.GlowKeyColor.PostProc(renderer, camera, colorRenderTarget, undefined);
	this.glowPostProc = glowPostProc
	glowPostProc.filterEffect.uniforms.keyColor.value	= keyColor
	glowPostProc.filterEffect.uniforms.glowColor.value	= glowColor
	// actually render it
	updateFcts.push(function(delta, now){
		glowPostProc.update(delta, now);
	})

	//////////////////////////////////////////////////////////////////////////////////
	//		blend initial rendering with glow				//
	//////////////////////////////////////////////////////////////////////////////////
	
	var composer	= new THREE.EffectComposer(renderer);

	// add Texture Pass
	var effect	= new THREE.TexturePass(colorRenderTarget);
	composer.addPass( effect );
	
	// add Blend Pass - to blend with glow.renderTarget
	var effect	= new THREE.ShaderPass( THREEx.GlowKeyColor.BlendShader, 'tDiffuse1');
	this.blendEffect= effect
	effect.uniforms.tDiffuse2.value	= glowPostProc.dstRenderTarget;
	effect.uniforms.keyColor.value	= keyColor;
	effect.uniforms.glowColor.value	= glowColor;
	composer.addPass( effect );	

	// mark the last pass as ```renderToScreen```
	composer.passes[composer.passes.length-1].renderToScreen	= true;
	// actually render it
	updateFcts.push(function(delta, now){
		composer.render(delta);
	})
}