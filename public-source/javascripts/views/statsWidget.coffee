class App.StatsWidget
  constructor: ->
    @statsObject = new Stats()
    @domElement = @statsObject.domElement
    @$domElement = $(@domElement)
    @$domElement.css({ position: 'absolute', right: '580px' }).hide()
    document.body.appendChild @domElement
  show: ->
    @$domElement.show()
    App.mainView.documentToolbar.updateButtonStates()
  hide: ->
    @$domElement.hide()
    App.mainView.documentToolbar.updateButtonStates()
  update: -> @statsObject.update()
