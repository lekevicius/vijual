class App.Behaviors.Swing extends App.Behaviors.Trigger
  name: "Swing"
  run: () ->
    @proxy.rotation = 0
    tl = new TimelineMax
      onUpdateParams: ["{self}", @proxy]
      onUpdate: (tween, proxy) => @object.set 'rotation.z', App.utils.radians(proxy.rotation)
    tl
      .from @proxy, 0, { rotation: '0' }
      .to @proxy, 0.1, { rotation:'15' }
      .to @proxy, 0.2, { rotation: '-10' }
      .to @proxy, 0.3, { rotation: '5' }
      .to @proxy, 0.4, { rotation: '-5' }
      .to @proxy, 0.5, { rotation: '0' }



class App.Behaviors.Wobble extends App.Behaviors.Trigger
  name: "Wobble"
  run: () ->
    @proxy.rotation = 0
    @proxy.left = @object.get('screenPosition')[0]
    @proxy.width = 0.6
    tl = new TimelineMax
      onUpdateParams: ["{self}", @proxy]
      onUpdate: (tween, proxy) =>
        @object.set 'rotation.z', App.utils.radians(proxy.rotation)
        @object.setScreenPositionX proxy.left
    tl
      .from @proxy, 0.15, { rotation: '0', left: '+=' + ( @proxy.width * 0 ) }
      .to @proxy, 0.15, { rotation: '-7', left: '-=' + ( @proxy.width * 0.30 ) }
      .to @proxy, 0.15, { rotation: '5', left: '+=' + ( @proxy.width * 0.30 ) }
      .to @proxy, 0.15, { rotation: '-5', left: '-=' + ( @proxy.width * 0.25 ) }
      .to @proxy, 0.15, { rotation: '3', left: '+=' + ( @proxy.width * 0.25 ) }
      .to @proxy, 0.15, { rotation: '-3', left: '-=' + ( @proxy.width * 0.15 ) }
      .to @proxy, 0.15, { rotation: '0', left: '+=' + ( @proxy.width * 0.15 ) }



class App.Behaviors.Shake extends App.Behaviors.Trigger
  name: "Shake"
  run: () ->
    @proxy.left = @object.get('screenPosition')[0]
    @proxy.width = 0.6
    tl = new TimelineMax
      onUpdateParams: ["{self}", @proxy]
      onUpdate: (tween, proxy) => @object.setScreenPositionX proxy.left

    tl
      .from @proxy, 0, { left: '+=' + ( @proxy.width * 0 ) }
      .to @proxy, 0.1, { left: '-=' + ( @proxy.width * 0.20 ) }
      .to @proxy, 0.1, { left: '+=' + ( @proxy.width * 0.20 ) }
      .to @proxy, 0.1, { left: '-=' + ( @proxy.width * 0.15 ) }
      .to @proxy, 0.1, { left: '+=' + ( @proxy.width * 0.15 ) }
      .to @proxy, 0.1, { left: '-=' + ( @proxy.width * 0.10 ) }
      .to @proxy, 0.1, { left: '+=' + ( @proxy.width * 0.10 ) }
      .to @proxy, 0.1, { left: '-=' + ( @proxy.width * 0.10 ) }
      .to @proxy, 0.1, { left: '+=' + ( @proxy.width * 0.10 ) }



class App.Behaviors.Bounce extends App.Behaviors.Trigger
  name: "Bounce"
  run: () ->
    @proxy.top = @object.get('screenPosition')[1]
    @proxy.width = 0.6
    tl = new TimelineMax
      onUpdateParams: ["{self}", @proxy]
      onUpdate: (tween, proxy) => @object.setScreenPositionY proxy.top

    tl
      .from @proxy, 0.2, { top: '+=' + ( @proxy.width * 0 ), ease: Quad.easeInOut }
      .to @proxy, 0.2, { top: '-=' + ( @proxy.width * 0.30 ), ease: Quad.easeInOut }
      .to @proxy, 0.15, { top: '+=' + ( @proxy.width * 0.30 ) }
      .to @proxy, 0.1, { top: '-=' + ( @proxy.width * 0.10 ) }
      .to @proxy, 0.1, { top: '+=' + ( @proxy.width * 0.10 ) }



class App.Behaviors.Flash extends App.Behaviors.Trigger
  name: "Flash"
  run: () ->
    @proxy.opacity = @object.get('material.opacity')
    tl = new TimelineMax
      onUpdateParams: ["{self}", @proxy]
      onUpdate: (tween, proxy) => @object.set 'material.opacity', proxy.opacity

    tl
      .to @proxy, 0.2, { opacity: 0 }
      .to @proxy, 0.2, { opacity: 1 }
      .to @proxy, 0.2, { opacity: 0 }
      .to @proxy, 0.5, { opacity: 1 }



class App.Behaviors.Tada extends App.Behaviors.Trigger
  name: "Tada"
  run: () ->
    @proxy.rotation = 0
    @proxy.startScale = @object.get('scale')
    @proxy.scale = @proxy.startScale

    tl = new TimelineMax
      onUpdateParams: ["{self}", @proxy]
      onUpdate: (tween, proxy) =>
        @object.set 'rotation.z', App.utils.radians(proxy.rotation)
        @object.set 'scale', proxy.scale

    tl
      .to @proxy, 0.2, { scale: @proxy.startScale * 0.9, rotation: 3 }
      .to @proxy, 0.1, { scale: @proxy.startScale * 1.1, rotation: -3 }
      .to @proxy, 0.1, { scale: @proxy.startScale * 1.1, rotation: 3 }
      .to @proxy, 0.1, { scale: @proxy.startScale * 1.1, rotation: -3 }
      .to @proxy, 0.1, { scale: @proxy.startScale * 1.1, rotation: 3 }
      .to @proxy, 0.1, { scale: @proxy.startScale * 1.1, rotation: -3 }
      .to @proxy, 0.1, { scale: @proxy.startScale * 1.1, rotation: 3 }
      .to @proxy, 0.1, { scale: @proxy.startScale * 1, rotation: 0 }



class App.Behaviors.Pulse extends App.Behaviors.Trigger
  name: "Pulse"
  run: () ->
    @proxy.startScale = @object.get('scale')
    @proxy.scale = @proxy.startScale

    tl = new TimelineMax
      onUpdateParams: ["{self}", @proxy]
      onUpdate: (tween, proxy) => @object.set 'scale', proxy.scale
    tl
      .to @proxy, 0.2, { scale: @proxy.startScale * 1.2 }
      .to @proxy, 0.2, { scale: @proxy.startScale }


class App.Behaviors.Rubberband extends App.Behaviors.Trigger
  name: "Rubberband"
  run: () ->
    @proxy.startScaleX = @object.get('scale.x')
    @proxy.startScaleY = @object.get('scale.y')
    @proxy.scaleX = @proxy.startScaleX
    @proxy.scaleY = @proxy.startScaleY

    tl = new TimelineMax
      onUpdateParams: ["{self}", @proxy]
      onUpdate: (tween, proxy) => @object.set { 'scale.x': proxy.scaleX, 'scale.y': proxy.scaleY }
    tl
      .from @proxy, 0, { scaleX: @proxy.startScaleX * 1, scaleY: @proxy.startScaleY * 1 }
      .to @proxy, 0.3, { scaleX: @proxy.startScaleX * 1.25, scaleY: @proxy.startScaleY * 0.75 }
      .to @proxy, 0.1, { scaleX: @proxy.startScaleX * 0.75, scaleY: @proxy.startScaleY * 1.25 }
      .to @proxy, 0.2, { scaleX: @proxy.startScaleX * 1.15, scaleY: @proxy.startScaleY * 0.85 }
      .to @proxy, 0.4, { scaleX: @proxy.startScaleX * 1, scaleY: @proxy.startScaleY * 1 }
