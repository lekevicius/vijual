class App.VO.Noun extends App.VO.BaseCanvas

  defaults: ->
    @search = 'person'
    @results = App.NounSearch.search @search
    @termId = _.toArray(@results)[0].id
    @resultNames = ( result.term for result in @results )
    @resultTermIds = ( result.id for result in @results )
    @iconIds = ( item + '' for item in App.data.termIcons[ @termId + '' ] ).reverse()
    $.extend super,
      type: 'noun'
      'shape.search': @search
      'shape.term': 0
      'shape.id': 0
      'shape.color': '#000000'

  attributeControls: -> $.extend super,
    'shape.search': { type: 'text', name: 'Search', pos: [0, 4, 4, 1] }
    'shape.term': { type: 'list', name: 'Term', options: @resultNames, pos: [4, 4, 4, 3] }
    'shape.id': { type: 'list', name: 'Icon', options: @iconIds, pos: [8, 4, 4, 3] }
    'shape.color': { type: 'color', name: 'Color', pos: [8, 0, 4, 3] }

  initialize: (attributes, options) ->
    super
    @drawCanvas()
    @on 'change', @checkImageChanges, @

  checkImageChanges: (model, options) ->
    return if options.innerSet
    for item, value of model.changed
      if item is 'shape.id'
        @drawCanvas() if value > -1
      else if item is 'shape.term'
        if value > -1
          @termId = @resultTermIds[ @get('shape.term') ]
          @iconIds = ( item + '' for item in App.data.termIcons[ @termId + '' ] ).reverse()
          @set 'shape.id', -1
          App.mainConnection.updateOptions "#{ @id } shape.id", @iconIds
          # @drawCanvas()
      else if item is 'shape.search'
        @search = value
        @results = App.NounSearch.search @search
        if _.size(@results)
          @termId = _.toArray(@results)[0].id
          @resultNames = ( result.term for result in @results )
          @resultTermIds = ( result.id for result in @results )
          @iconIds = ( item + '' for item in App.data.termIcons[ @termId + '' ] ).reverse()
          @set { 'shape.id': -1, 'shape.term': -1 }
          App.mainConnection.updateOptions "#{ @id } shape.term", @resultNames
          App.mainConnection.updateOptions "#{ @id } shape.id", @iconIds
          # @drawCanvas()
      else if item is 'shape.color' then @recolorShape()

  setToFirstResult: (term) ->
    console.log term
    @search = term
    @results = App.NounSearch.search @search
    if _.size(@results)
      @termId = _.toArray(@results)[0].id
      @resultNames = ( result.term for result in @results )
      @resultTermIds = ( result.id for result in @results )
      @termId = @resultTermIds[ 0 ]
      @iconIds = ( item + '' for item in App.data.termIcons[ @termId + '' ] ).reverse()
      @set { 'shape.term': term, 'shape.id': 0, 'shape.term': 0 }, { innerSet: true }
      App.mainConnection.updateOptions "#{ @id } shape.term", @resultNames
      App.mainConnection.updateOptions "#{ @id } shape.id", @iconIds
      @drawCanvas()
    else
      console.log "Not found!"


  recolorShape: ->
    if @loadedSVG
      @loadedSVG.setFill @get('shape.color')
      @loadedSVG.setStroke @get('shape.color')
      @fabricCanvas.renderAll()
      @texture.needsUpdate = true

  drawCanvas: ->
    super

    @fabricCanvas = new fabric.StaticCanvas @canvas
    @loadedSVG = null
    # console.log @fabricCanvas
    # console.log "/library/" + @get('shape.shape')
    fabric.loadSVGFromURL "/library/nouns/icon_" + @iconIds[ @get('shape.id') ] + '.svg', (objects, options) =>

      @loadedSVG = fabric.util.groupSVGElements(objects, options)
      # @loadedSVG.scaleToHeight 800
      width = @loadedSVG.getWidth()
      height = @loadedSVG.getHeight()
      biggerRenderSide = if App.config.renderer.width > App.config.renderer.height then App.config.renderer.width else App.config.renderer.height
      if height > width then @loadedSVG.scaleToHeight biggerRenderSide else @loadedSVG.scaleToWidth biggerRenderSide
      width = @loadedSVG.getWidth()
      height = @loadedSVG.getHeight()
      @updatePlaneSize width, height, { dontRedraw: true }

      @fabricCanvas = new fabric.StaticCanvas @canvas
      @fabricCanvas.add @loadedSVG
      @loadedSVG.center()
      @loadedSVG.setFill @get('shape.color')
      @loadedSVG.setStroke @get('shape.color')
      @fabricCanvas.renderAll()
      @texture.needsUpdate = true
